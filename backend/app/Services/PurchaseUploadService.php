<?php

namespace App\Services;

use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class PurchaseUploadService
{
    public function __construct(private SalesUploadService $spreadsheet) {}

    /**
     * 从图片识别进货明细 —— 用视觉模型（ai.vision_*，deepseek 不支持图片）。
     *
     * @return array{items: array, summary: string}
     */
    public function recognizeFromImage(string $imageBase64): array
    {
        try {
            $response = Http::baseUrl(config('ai.vision_base_url'))
                ->withToken(config('ai.vision_api_key'))
                ->timeout(60)
                ->post('/chat/completions', [
                    'model' => config('ai.vision_model'),
                    'messages' => [
                        ['role' => 'system', 'content' => $this->systemPrompt()],
                        ['role' => 'user', 'content' => [
                            ['type' => 'text', 'text' => '这是一张进货单/送货单/磅码单或手写进货清单的照片，请识别每个商品的进货数量和单价。'],
                            ['type' => 'image_url', 'image_url' => ['url' => 'data:image/jpeg;base64,'.$imageBase64]],
                        ]],
                    ],
                    'max_tokens' => 4000,
                ]);
        } catch (\Throwable $e) {
            Log::error('PurchaseUpload image AI exception', ['error' => $e->getMessage()]);

            return ['items' => [], 'summary' => 'AI 识别超时，请重试，或换一张更清晰/更小的图片'];
        }

        return $this->parseResponse($response, '无法从图片中识别有效进货数据');
    }

    /**
     * 从 Excel 识别进货明细（解析 + 文字 AI）。
     *
     * @return array{items: array, summary: string, raw_rows: array}
     */
    public function recognizeFromExcel(string $storagePath, ?string $disk = null): array
    {
        $rows = $this->spreadsheet->parseExcel($storagePath, $disk);
        if (empty($rows)) {
            return ['items' => [], 'summary' => 'Excel文件为空或格式不正确', 'raw_rows' => []];
        }

        $rowsText = json_encode(array_slice($rows, 0, 50), JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);

        try {
            $response = Http::baseUrl(config('ai.base_url'))
                ->withToken(config('ai.api_key'))
                ->timeout(60)
                ->post('/chat/completions', [
                    'model' => config('ai.model'),
                    'messages' => [
                        ['role' => 'system', 'content' => $this->systemPrompt()],
                        ['role' => 'user', 'content' => "以下是Excel导出的进货明细数据（JSON），请解析：\n\n{$rowsText}"],
                    ],
                    'max_tokens' => 4000,
                ]);
        } catch (\Throwable $e) {
            Log::error('PurchaseUpload excel AI exception', ['error' => $e->getMessage()]);

            return ['items' => [], 'summary' => 'AI 识别超时，请重试', 'raw_rows' => $rows];
        }

        $parsed = $this->parseResponse($response, '无法从Excel中识别有效进货数据');
        $parsed['raw_rows'] = $rows;

        return $parsed;
    }

    /** 统一的进货识别 system prompt（图片/Excel 共用，输出契约一致）。 */
    private function systemPrompt(): string
    {
        return <<<'PROMPT'
你是生鲜门店AI数据识别助手（舌尖香港）。
用户会提供一张进货单据（进货单/送货单/磅码单/手写进货清单的图片或Excel导出数据）。
请逐项识别每个进货商品的：品名/商品名、进货数量、进货单价（每单位价格）。

要求：
1. 只识别真实的进货商品行；忽略表头、合计/小计/总计行、供应商名、日期、单号等非商品信息。
2. ordered_qty（数量）必须为正数。unit_price（单价）若单据只有总价则用 总价/数量 估算；无法判断则填 0。
3. 单位 unit 若单据有则填写（如"斤/件/箱/个"），否则默认"斤"。
4. 模糊不清、无法确定品名或数量的行，跳过，不要臆造。

严格只返回以下JSON，不要输出任何额外文字：
{
  "items": [
    { "product_name": "商品名称", "ordered_qty": 数字, "unit_price": 数字, "unit": "单位" }
  ],
  "summary": "简短说明：共识别X个商品，单据类型/字段映射情况"
}
PROMPT;
    }

    /**
     * @return array{items: array, summary: string}
     */
    private function parseResponse(Response $response, string $emptyMsg): array
    {
        if ($response->failed()) {
            Log::error('PurchaseUpload AI failed', ['status' => $response->status(), 'body' => $response->body()]);

            return ['items' => [], 'summary' => 'AI识别失败（'.$response->status().'）'];
        }

        $content = $response->json('choices.0.message.content', '{}');
        $parsed = json_decode($content, true);

        if (! is_array($parsed) || empty($parsed['items'])) {
            return ['items' => [], 'summary' => (is_array($parsed) ? ($parsed['summary'] ?? '') : '') ?: $emptyMsg];
        }

        return $parsed;
    }
}
