<?php

namespace Database\Seeders;

use App\Models\QuickAction;
use Illuminate\Database\Seeder;

class QuickActionSeeder extends Seeder
{
    /**
     * 把原写死在 miniprogram/pages/chat/chat.js 的 quickActions 种子化。
     * 种入后小程序行为与现状完全一致。store_id=null 表示全门店通用。
     */
    public function run(): void
    {
        if (QuickAction::query()->exists()) {
            return; // 已有数据则跳过，避免重复
        }

        // 1. 今日库存 — web 类型
        QuickAction::create([
            'key' => 'inventory', 'emoji' => '📦', 'label' => '今日库存',
            'action_type' => 'web', 'prompt' => '查一下今日库存',
            'target_path' => '/inventory', 'target_title' => '今日库存',
            'web_label' => '📦 打开完整库存页', 'sort_order' => 10,
        ]);

        // 2. 今日销售 — web 类型
        QuickAction::create([
            'key' => 'sales', 'emoji' => '💰', 'label' => '今日销售',
            'action_type' => 'web', 'prompt' => '今天卖了多少',
            'target_path' => '/sales-report', 'target_title' => '今日销售',
            'web_label' => '📊 打开销售报表', 'sort_order' => 20,
        ]);

        // 3. 经营查询 — menu 类型（4 个子项）
        $report = QuickAction::create([
            'key' => 'report', 'emoji' => '📊', 'label' => '经营查询',
            'action_type' => 'menu', 'sort_order' => 30,
        ]);
        // 用关系 createMany：自动补 quick_action_id + 时间戳，各行列不齐也无妨
        $report->items()->createMany([
            ['emoji' => '📊', 'label' => '每日营运概况', 'desc' => '往日库存/进货/已售/售罄', 'item_type' => 'route', 'route' => '/pages/report/report', 'sort_order' => 10],
            ['emoji' => '🚚', 'label' => '最近进货', 'desc' => '进货单明细', 'item_type' => 'prompt', 'prompt' => '查一下最近的进货单', 'sort_order' => 20],
            ['emoji' => '💡', 'label' => '进货建议', 'desc' => '补货优先级', 'item_type' => 'prompt', 'prompt' => '给我一些进货和促销建议', 'sort_order' => 30],
            ['emoji' => '📝', 'label' => '操作日志', 'desc' => '今日远程指令留档', 'item_type' => 'prompt', 'prompt' => '看一下今天的操作日志', 'sort_order' => 40],
        ]);

        // 4. 查天气 — prompt 类型
        QuickAction::create([
            'key' => 'weather', 'emoji' => '🌦️', 'label' => '查天气',
            'action_type' => 'prompt', 'prompt' => '明天天气怎么样', 'sort_order' => 40,
        ]);

        // 5. 使用说明 — prompt 类型
        QuickAction::create([
            'key' => 'help', 'emoji' => '💡', 'label' => '使用说明',
            'action_type' => 'prompt', 'prompt' => '你能帮我做什么', 'sort_order' => 50,
        ]);

        // 6. 后台管理 — open 类型，仅管理员可见
        QuickAction::create([
            'key' => 'admin', 'emoji' => '🛠️', 'label' => '后台管理',
            'action_type' => 'open', 'target_path' => '/admin/sso', 'target_title' => '后台管理',
            'admin_only' => true, 'sort_order' => 60,
        ]);
    }
}
