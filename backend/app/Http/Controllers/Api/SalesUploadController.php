<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SalesUpload;
use App\Services\SalesUploadService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class SalesUploadController extends Controller
{
    public function __construct(private SalesUploadService $service) {}

    /**
     * 第一步：上传销售记录（拍照/相册图片 或 Excel/CSV 文件）→ AI 识别 → 只返回明细供核对，不写库。
     *
     * POST /api/sales/upload/recognize  (multipart: file, sale_date?)
     */
    public function recognize(Request $request): JsonResponse
    {
        $request->validate([
            'file' => 'required|file|max:10240|mimes:jpg,jpeg,png,webp,xlsx,xls,csv',
            'sale_date' => 'nullable|date',
        ], [
            'file.mimes' => '只支持图片(jpg/png/webp)或表格(xlsx/xls/csv)',
            'file.max' => '文件大小不能超过 10MB',
        ]);

        $storeId = $request->user()->resolveStoreId();
        if (! $storeId) {
            return response()->json(['message' => '该账号未关联任何门店'], 403);
        }

        $file = $request->file('file');
        $ext = strtolower($file->getClientOriginalExtension());
        $isImage = in_array($ext, ['jpg', 'jpeg', 'png', 'webp'], true);
        $saleDate = $request->input('sale_date', today()->toDateString());

        $path = $file->storeAs(
            'sales_uploads/'.$storeId,
            now()->format('Ymd_His').'_'.$file->getClientOriginalName(),
            'local',
        );

        $upload = SalesUpload::create([
            'store_id' => $storeId,
            'uploaded_by' => $request->user()->id,
            'original_filename' => $file->getClientOriginalName(),
            'file_path' => $path,
            'sale_date' => $saleDate,
            'status' => SalesUpload::STATUS_PENDING,
        ]);

        // 识别（不写库）
        if ($isImage) {
            $base64 = base64_encode(Storage::disk('local')->get($path));
            $result = $this->service->recognizeFromImage($base64);
        } else {
            $result = $this->service->recognizeFromExcel($path);
            $upload->update(['raw_rows' => $result['raw_rows'] ?? null, 'total_items' => count($result['raw_rows'] ?? [])]);
        }

        $items = $result['items'] ?? [];
        $upload->update(['ai_result' => ['items' => $items, 'summary' => $result['summary'] ?? '']]);

        return response()->json([
            'upload_id' => $upload->id,
            'sale_date' => $saleDate,
            'items' => $items,
            'summary' => $result['summary'] ?? '',
        ]);
    }

    /**
     * 第二步：店长核对（可改/删）后确认 → 写入今日销售补录。
     *
     * POST /api/sales/upload/{id}/commit  (json: items[])
     */
    public function commit(Request $request, int $id): JsonResponse
    {
        $data = $request->validate([
            'items' => 'required|array|min:1|max:200',
            'items.*.product_name' => 'required|string|max:100',
            'items.*.qty' => 'required|numeric|min:0.001',
            'items.*.amount' => 'nullable|numeric|min:0',
            'items.*.unit' => 'nullable|string|max:10',
        ]);

        $storeId = $request->user()->resolveStoreId();
        if (! $storeId) {
            return response()->json(['message' => '该账号未关联任何门店'], 403);
        }

        $upload = SalesUpload::where('store_id', $storeId)->findOrFail($id);
        if ($upload->status === SalesUpload::STATUS_COMPLETED) {
            return response()->json(['message' => '该上传已入库，请勿重复提交'], 422);
        }

        $result = $this->service->writeRecognizedItems($upload, $data['items'], $request->user()->id);

        return response()->json([
            'message' => "已补录 {$result['processed']} 条销售".($result['failed'] > 0 ? "，{$result['failed']} 条未能处理" : ''),
            'processed' => $result['processed'],
            'failed' => $result['failed'],
        ]);
    }
}
