<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class QuickAction extends Model
{
    protected $fillable = [
        'key',
        'emoji',
        'label',
        'badge',
        'action_type',
        'prompt',
        'target_path',
        'target_title',
        'web_label',
        'admin_only',
        'store_id',
        'enabled',
        'sort_order',
    ];

    protected function casts(): array
    {
        return [
            'admin_only' => 'boolean',
            'enabled' => 'boolean',
            'sort_order' => 'integer',
        ];
    }

    public function items(): HasMany
    {
        return $this->hasMany(QuickActionItem::class)->orderBy('sort_order')->orderBy('id');
    }

    public function store(): BelongsTo
    {
        return $this->belongsTo(Store::class);
    }

    /**
     * 转成小程序 chat.js 期望的 quickActions 数组项结构。
     * 结构与原写死数组完全一致，小程序拿到即可直接 setData。
     */
    public function toClientArray(): array
    {
        $node = [
            'key' => $this->key,
            'emoji' => $this->emoji ?? '',
            'label' => $this->label,
            'badge' => $this->badge ?? '',
        ];

        if ($this->admin_only) {
            $node['adminOnly'] = true;
        }

        switch ($this->action_type) {
            case 'prompt':
                $node['prompt'] = $this->prompt ?? '';
                break;

            case 'web':
                // 先发 AI 文字摘要，再追加「打开完整页」web-view 链接
                $node['prompt'] = $this->prompt ?? '';
                $node['web'] = [
                    'path' => $this->target_path,
                    'title' => $this->target_title,
                    'label' => $this->web_label,
                ];
                break;

            case 'open':
                // 直接打开 web-view 页（report.js 自动补 ?token=&from=miniapp）
                $node['open'] = [
                    'path' => $this->target_path,
                    'title' => $this->target_title,
                ];
                break;

            case 'menu':
                $node['items'] = $this->items->map(function (QuickActionItem $item) {
                    $sub = [
                        'key' => 'qai-' . $item->id,
                        'emoji' => $item->emoji ?? '',
                        'label' => $item->label,
                        'desc' => $item->desc ?? '',
                    ];
                    if ($item->item_type === 'route') {
                        $sub['route'] = $item->route;
                    } else {
                        $sub['prompt'] = $item->prompt ?? '';
                    }
                    return $sub;
                })->all();
                break;
        }

        return $node;
    }
}
