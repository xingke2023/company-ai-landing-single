<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Customer;
use App\Models\CustomerFollowUp;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CustomerController extends Controller
{
    /**
     * GET /api/customers — 当前门店顾客列表（支持姓名/手机搜索 + 状态/等级/标签过滤）。
     */
    public function index(Request $request): JsonResponse
    {
        $storeId = $request->user()->resolveStoreId();
        if (! $storeId) {
            return response()->json(['message' => '该账号未关联任何门店'], 403);
        }

        $query = Customer::with('createdBy:id,name')
            ->where('store_id', $storeId);

        if ($request->filled('q')) {
            $q = $request->string('q')->toString();
            $query->where(function ($sub) use ($q): void {
                $sub->where('name', 'like', "%{$q}%")
                    ->orWhere('phone', 'like', "%{$q}%");
            });
        }

        if ($request->filled('status')) {
            $query->where('status', $request->integer('status'));
        }

        if ($request->filled('level')) {
            $query->where('level', $request->integer('level'));
        }

        if ($request->filled('tag')) {
            $query->whereJsonContains('tags', $request->string('tag')->toString());
        }

        $customers = $query->orderByDesc('created_at')->paginate(20);

        return response()->json($customers);
    }

    /**
     * POST /api/customers — 新建顾客（同店手机号查重）。
     */
    public function store(Request $request): JsonResponse
    {
        $storeId = $request->user()->resolveStoreId();
        if (! $storeId) {
            return response()->json(['message' => '该账号未关联任何门店'], 403);
        }

        $data = $request->validate([
            'name' => 'required|string|max:50',
            'phone' => 'nullable|string|max:20',
            'gender' => 'nullable|integer|in:0,1,2',
            'birthday' => 'nullable|date',
            'level' => 'nullable|integer|in:1,2,3',
            'tags' => 'nullable|array',
            'tags.*' => 'string|max:20',
            'address' => 'nullable|string|max:255',
            'status' => 'nullable|integer|in:0,1,2',
            'notes' => 'nullable|string|max:1000',
            'source' => 'nullable|integer|in:1,2,3',
        ]);

        if (! empty($data['phone'])) {
            $existing = Customer::where('store_id', $storeId)
                ->where('phone', $data['phone'])
                ->first();
            if ($existing) {
                return response()->json([
                    'message' => '该手机号顾客已存在',
                    'data' => $existing,
                ], 409);
            }
        }

        $customer = Customer::create(array_merge($data, [
            'store_id' => $storeId,
            'source' => $data['source'] ?? 1,
            'created_by' => $request->user()->id,
        ]));

        return response()->json([
            'message' => '顾客已创建',
            'data' => $customer,
        ], 201);
    }

    /**
     * GET /api/customers/{id} — 顾客详情（含跟进记录与订单）。
     */
    public function show(Request $request, int $id): JsonResponse
    {
        $customer = $this->findScoped($request, $id);
        if (! $customer) {
            return response()->json(['message' => '顾客不存在'], 404);
        }

        $customer->load([
            'followUps' => fn ($q) => $q->with('operator:id,name')->orderByDesc('follow_up_at'),
            'orders' => fn ($q) => $q->orderByDesc('created_at'),
        ]);

        return response()->json(['data' => $customer]);
    }

    /**
     * PUT/PATCH /api/customers/{id} — 更新顾客。
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $customer = $this->findScoped($request, $id);
        if (! $customer) {
            return response()->json(['message' => '顾客不存在'], 404);
        }

        $data = $request->validate([
            'name' => 'sometimes|string|max:50',
            'phone' => 'nullable|string|max:20',
            'gender' => 'nullable|integer|in:0,1,2',
            'birthday' => 'nullable|date',
            'level' => 'nullable|integer|in:1,2,3',
            'tags' => 'nullable|array',
            'tags.*' => 'string|max:20',
            'address' => 'nullable|string|max:255',
            'status' => 'nullable|integer|in:0,1,2',
            'notes' => 'nullable|string|max:1000',
        ]);

        $customer->update($data);

        return response()->json([
            'message' => '顾客已更新',
            'data' => $customer,
        ]);
    }

    /**
     * DELETE /api/customers/{id} — 软删除顾客。
     */
    public function destroy(Request $request, int $id): JsonResponse
    {
        $customer = $this->findScoped($request, $id);
        if (! $customer) {
            return response()->json(['message' => '顾客不存在'], 404);
        }

        $customer->delete();

        return response()->json(['message' => '顾客已删除']);
    }

    /**
     * GET /api/customers/{id}/follow-ups — 顾客跟进记录列表。
     */
    public function followUps(Request $request, int $id): JsonResponse
    {
        $customer = $this->findScoped($request, $id);
        if (! $customer) {
            return response()->json(['message' => '顾客不存在'], 404);
        }

        $followUps = $customer->followUps()
            ->with('operator:id,name')
            ->orderByDesc('follow_up_at')
            ->get();

        return response()->json(['data' => $followUps]);
    }

    /**
     * POST /api/customers/{id}/follow-ups — 新增一条跟进记录。
     */
    public function addFollowUp(Request $request, int $id): JsonResponse
    {
        $customer = $this->findScoped($request, $id);
        if (! $customer) {
            return response()->json(['message' => '顾客不存在'], 404);
        }

        $data = $request->validate([
            'type' => 'nullable|integer|in:1,2,3,4,5',
            'content' => 'required|string|max:1000',
            'follow_up_at' => 'nullable|date',
            'next_follow_up_at' => 'nullable|date',
        ]);

        $followUp = CustomerFollowUp::create([
            'customer_id' => $customer->id,
            'store_id' => $customer->store_id,
            'type' => $data['type'] ?? 1,
            'content' => $data['content'],
            'follow_up_at' => $data['follow_up_at'] ?? now(),
            'next_follow_up_at' => $data['next_follow_up_at'] ?? null,
            'operator_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => '跟进记录已保存',
            'data' => $followUp,
        ], 201);
    }

    /**
     * 按当前用户门店查找顾客，越权/不存在返回 null。
     */
    private function findScoped(Request $request, int $id): ?Customer
    {
        $storeId = $request->user()->resolveStoreId();
        if (! $storeId) {
            return null;
        }

        return Customer::where('store_id', $storeId)->find($id);
    }
}
