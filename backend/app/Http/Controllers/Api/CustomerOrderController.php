<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use App\Models\CustomerOrder;
use App\Models\DailyOperationLog;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CustomerOrderController extends Controller
{
    /**
     * GET /api/customer-orders — 当前门店顾客订单列表。
     */
    public function index(Request $request): JsonResponse
    {
        $storeId = $request->user()->resolveStoreId();
        if (! $storeId) {
            return response()->json(['message' => '该账号未关联任何门店'], 403);
        }

        $query = CustomerOrder::with(['customer:id,name,phone', 'items'])
            ->where('store_id', $storeId);

        if ($request->filled('status')) {
            $query->where('status', $request->integer('status'));
        }

        if ($request->filled('type')) {
            $query->where('type', $request->integer('type'));
        }

        if ($request->filled('customer_id')) {
            $query->where('customer_id', $request->integer('customer_id'));
        }

        if ($request->filled('date')) {
            $query->whereDate('created_at', $request->string('date')->toString());
        }

        $orders = $query->orderByDesc('created_at')->paginate(20);

        return response()->json($orders);
    }

    /**
     * POST /api/customer-orders — 创建顾客订单（含明细，金额由明细汇总）。
     */
    public function store(Request $request): JsonResponse
    {
        $storeId = $request->user()->resolveStoreId();
        if (! $storeId) {
            return response()->json(['message' => '该账号未关联任何门店'], 403);
        }

        $data = $request->validate([
            'customer_id' => 'nullable|integer',
            'customer_name' => 'nullable|string|max:50',
            'customer_phone' => 'nullable|string|max:20',
            'type' => 'nullable|integer|in:1,2,3,4',
            'discount_amount' => 'nullable|numeric|min:0',
            'paid_amount' => 'nullable|numeric|min:0',
            'payment_method' => 'nullable|integer|in:1,2,3,4',
            'delivery_address' => 'nullable|string|max:255',
            'delivery_at' => 'nullable|date',
            'remark' => 'nullable|string|max:1000',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'nullable|integer',
            'items.*.product_name' => 'required|string|max:100',
            'items.*.qty' => 'required|numeric|min:0.001',
            'items.*.unit' => 'nullable|string|max:20',
            'items.*.unit_price' => 'required|numeric|min:0',
        ]);

        // 校验关联顾客属于本店
        $customer = null;
        if (! empty($data['customer_id'])) {
            $customer = Customer::where('store_id', $storeId)->find($data['customer_id']);
            if (! $customer) {
                return response()->json(['message' => '顾客不存在或不属于本门店'], 422);
            }
        }

        $order = DB::transaction(function () use ($data, $storeId, $customer, $request): CustomerOrder {
            $order = CustomerOrder::create([
                'store_id' => $storeId,
                'order_no' => CustomerOrder::generateOrderNo(),
                'customer_id' => $customer?->id,
                'customer_name' => $data['customer_name'] ?? $customer?->name,
                'customer_phone' => $data['customer_phone'] ?? $customer?->phone,
                'type' => $data['type'] ?? 1,
                'status' => 1,
                'discount_amount' => $data['discount_amount'] ?? 0,
                'paid_amount' => $data['paid_amount'] ?? 0,
                'payment_method' => $data['payment_method'] ?? null,
                'delivery_address' => $data['delivery_address'] ?? null,
                'delivery_at' => $data['delivery_at'] ?? null,
                'remark' => $data['remark'] ?? null,
                'operator_id' => $request->user()->id,
            ]);

            $total = 0;
            foreach ($data['items'] as $item) {
                $subtotal = round($item['qty'] * $item['unit_price'], 2);
                $total += $subtotal;
                $order->items()->create([
                    'product_id' => $item['product_id'] ?? null,
                    'product_name' => $item['product_name'],
                    'qty' => $item['qty'],
                    'unit' => $item['unit'] ?? null,
                    'unit_price' => $item['unit_price'],
                    'subtotal' => $subtotal,
                ]);
            }

            $order->total_amount = max(0, $total - ($data['discount_amount'] ?? 0));
            $order->save();

            DailyOperationLog::write(
                storeId: $storeId,
                content: "创建顾客订单 {$order->order_no}，{$order->items()->count()} 项，合计 {$order->total_amount}",
                intent: 'customer_order_create',
                source: 2,
                referenceType: 'customer_order',
                referenceId: $order->id,
                operatorId: $request->user()->id,
            );

            return $order;
        });

        return response()->json([
            'message' => '订单已创建',
            'data' => $order->load(['customer:id,name,phone', 'items']),
        ], 201);
    }

    /**
     * GET /api/customer-orders/{id} — 订单详情。
     */
    public function show(Request $request, int $id): JsonResponse
    {
        $order = $this->findScoped($request, $id);
        if (! $order) {
            return response()->json(['message' => '订单不存在'], 404);
        }

        return response()->json([
            'data' => $order->load(['customer:id,name,phone', 'items', 'operator:id,name']),
        ]);
    }

    /**
     * PUT /api/customer-orders/{id}/status — 订单状态流转。
     * 流转到「已完成」(4) 时累计顾客消费；「已取消」(5) 仅置状态。
     * 注意：不在此处扣库存——真正出货走现有 POS /api/sales，避免双重扣减。
     */
    public function updateStatus(Request $request, int $id): JsonResponse
    {
        $order = $this->findScoped($request, $id);
        if (! $order) {
            return response()->json(['message' => '订单不存在'], 404);
        }

        $data = $request->validate([
            'status' => 'required|integer|in:1,2,3,4,5',
        ]);

        $newStatus = $data['status'];

        DB::transaction(function () use ($order, $newStatus, $request): void {
            $wasCompleted = $order->status === 4;
            $order->status = $newStatus;
            $order->save();

            // 首次流转到「已完成」时累计顾客消费（避免重复完成重复计入）
            if ($newStatus === 4 && ! $wasCompleted && $order->customer_id) {
                $order->customer?->recordConsumption((float) $order->total_amount);
            }

            DailyOperationLog::write(
                storeId: $order->store_id,
                content: "订单 {$order->order_no} 状态变更为「{$order->statusLabel()}」",
                intent: 'customer_order_status',
                source: 2,
                referenceType: 'customer_order',
                referenceId: $order->id,
                operatorId: $request->user()->id,
            );
        });

        return response()->json([
            'message' => '订单状态已更新',
            'data' => $order->fresh()->load(['customer:id,name,phone', 'items']),
        ]);
    }

    /**
     * 按当前用户门店查找订单，越权/不存在返回 null。
     */
    private function findScoped(Request $request, int $id): ?CustomerOrder
    {
        $storeId = $request->user()->resolveStoreId();
        if (! $storeId) {
            return null;
        }

        return CustomerOrder::where('store_id', $storeId)->find($id);
    }
}
