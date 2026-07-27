<?php

use App\Http\Controllers\Api\AiAssistantController;
use App\Http\Controllers\Api\AppConfigController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ChatLogController;
use App\Http\Controllers\Api\CustomerController;
use App\Http\Controllers\Api\CustomerOrderController;
use App\Http\Controllers\Api\DamageController;
use App\Http\Controllers\Api\IndustryController;
use App\Http\Controllers\Api\InventoryController;
use App\Http\Controllers\Api\PostController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\PurchaseOrderController;
use App\Http\Controllers\Api\QuickActionController;
use App\Http\Controllers\Api\ResumeController;
use App\Http\Controllers\Api\SalesOrderController;
use App\Http\Controllers\Api\SalesUploadController;
use App\Http\Controllers\Api\SsoAuthController;
use App\Http\Controllers\Api\SuggestionController;
use App\Http\Controllers\Api\SupplierRefundClaimController;
use App\Http\Controllers\Api\WeatherController;
use App\Http\Controllers\Api\WeworkCallbackController;
use Illuminate\Support\Facades\Route;

// Public routes
Route::post('/login', [AuthController::class, 'login']);
// 公开应用配置（小程序标题等，登录前也要能拿到）
Route::get('/app-config', [AppConfigController::class, 'index']);
// 公开行业列表（小程序启动「选择行业」页，先于登录）
Route::get('/industries', [IndustryController::class, 'index']);

// SSO 单点登录（外部 Auth Center，桥接换本地 JWT）— 小程序登录入口
Route::post('/auth/sso/login', [SsoAuthController::class, 'login']);
Route::post('/auth/sso/register', [SsoAuthController::class, 'register']);
Route::post('/auth/sso/exchange', [SsoAuthController::class, 'exchange']);
Route::post('/auth/sso/refresh', [SsoAuthController::class, 'refresh']);

// Protected routes
Route::middleware('auth.hybrid')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    // 小程序聊天页底部快捷按钮（后台可配）
    Route::get('/quick-actions', [QuickActionController::class, 'index']);

    // AI 助手
    Route::post('/ai/message', [AiAssistantController::class, 'message']);
    Route::post('/ai/voice', [AiAssistantController::class, 'voice']);
    Route::get('/ai/sessions', [AiAssistantController::class, 'sessions']);
    Route::get('/ai/sessions/{id}/messages', [AiAssistantController::class, 'sessionMessages']);

    // 库存
    Route::get('/inventory', [InventoryController::class, 'index']);
    Route::get('/inventory/transactions', [InventoryController::class, 'transactions']);
    Route::get('/inventory/daily-overview', [InventoryController::class, 'dailyOverview']);
    Route::post('/inventory/adjust', [InventoryController::class, 'adjust']);
    Route::post('/inventory/sales-summary', [InventoryController::class, 'updateSalesSummary']);

    // 今日操作日志
    Route::get('/daily-logs', [InventoryController::class, 'dailyLogs']);

    // 零售流水
    Route::get('/sales/today', [SalesOrderController::class, 'todaySummary']);
    Route::get('/sales/summary', [SalesOrderController::class, 'summary']);
    Route::get('/sales/report', [SalesOrderController::class, 'dailyReport']);
    Route::post('/sales/supplement', [SalesOrderController::class, 'supplement']);
    // 销售报表上传（拍照/相册/文件 → AI 识别 → 预览 → 确认入库）
    Route::post('/sales/upload/recognize', [SalesUploadController::class, 'recognize']);
    Route::post('/sales/upload/{id}/commit', [SalesUploadController::class, 'commit']);
    Route::apiResource('/sales', SalesOrderController::class)->only(['index', 'store', 'show']);

    // 商品
    Route::get('/products', [ProductController::class, 'index']);

    // 进货单
    Route::get('/purchase-orders', [PurchaseOrderController::class, 'index']);
    Route::post('/purchase-orders/recognize', [PurchaseOrderController::class, 'recognize']);
    Route::get('/purchase-orders/{id}', [PurchaseOrderController::class, 'show']);
    Route::post('/purchase-orders', [PurchaseOrderController::class, 'store']);

    // 天气查询
    Route::get('/weather', [WeatherController::class, 'query']);

    // 经营建议
    Route::get('/suggestions', [SuggestionController::class, 'suggestions']);

    // 损耗记录
    Route::get('/damage/stats', [DamageController::class, 'stats']);
    Route::post('/damage/batch', [DamageController::class, 'storeBatch']);
    Route::post('/damage/{id}/images', [DamageController::class, 'uploadImages']);
    Route::apiResource('/damage', DamageController::class)->only(['index', 'store']);

    // 供应商退款申请
    Route::put('/refund-claims/{id}/status', [SupplierRefundClaimController::class, 'updateStatus']);
    Route::apiResource('/refund-claims', SupplierRefundClaimController::class)->only(['index', 'store', 'show']);

    // CRM 顾客管理
    Route::get('/customers/search', [CustomerController::class, 'index']);
    Route::get('/customers/{id}/follow-ups', [CustomerController::class, 'followUps']);
    Route::post('/customers/{id}/follow-ups', [CustomerController::class, 'addFollowUp']);
    Route::apiResource('/customers', CustomerController::class)
        ->only(['index', 'store', 'show', 'update', 'destroy'])
        ->parameters(['customers' => 'id']);

    // 顾客订单 / 预订单
    Route::put('/customer-orders/{id}/status', [CustomerOrderController::class, 'updateStatus']);
    Route::apiResource('/customer-orders', CustomerOrderController::class)
        ->only(['index', 'store', 'show'])
        ->parameters(['customer-orders' => 'id']);

    // 人才简历库
    Route::post('/resumes/parse', [ResumeController::class, 'parse']);
    Route::post('/resumes/batch', [ResumeController::class, 'batch']);
    Route::get('/resumes/search', [ResumeController::class, 'search']);
    Route::apiResource('/resumes', ResumeController::class)->only(['index', 'store', 'show', 'update', 'destroy']);
});

// Chat Logs — OpenClaw 写入（Sanctum token 鉴权）
// Chat Logs — OpenClaw 写入 + 后台查询，统一用 auth.hybrid（支持 JWT + Sanctum）
Route::middleware('auth.hybrid')->group(function () {
    Route::post('/chat-logs', [ChatLogController::class, 'store']);
    Route::get('/chat-logs', [ChatLogController::class, 'index']);
    Route::get('/chat-logs/conversation/{conversationId}', [ChatLogController::class, 'conversation']);
});

// 企业微信回调
Route::get('/wework/callback', [WeworkCallbackController::class, 'verify']);
Route::post('/wework/callback', [WeworkCallbackController::class, 'receive']);

// Posts — all require auth
Route::middleware('auth.hybrid')->group(function () {
    Route::apiResource('/posts', PostController::class)->only(['index', 'show', 'store', 'update', 'destroy']);
});
