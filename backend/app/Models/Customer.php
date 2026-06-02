<?php

namespace App\Models;

use Database\Factories\CustomerFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Customer extends Model
{
    /** @use HasFactory<CustomerFactory> */
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'store_id',
        'name',
        'phone',
        'gender',
        'birthday',
        'level',
        'points',
        'total_spent',
        'order_count',
        'last_order_at',
        'tags',
        'address',
        'source',
        'status',
        'notes',
        'created_by',
    ];

    protected function casts(): array
    {
        return [
            'birthday' => 'date',
            'total_spent' => 'decimal:2',
            'last_order_at' => 'datetime',
            'tags' => 'array',
        ];
    }

    public function levelLabel(): string
    {
        return match ($this->level) {
            1 => '普通',
            2 => '银卡',
            3 => '金卡',
            default => '普通',
        };
    }

    public function statusLabel(): string
    {
        return match ($this->status) {
            0 => '流失',
            1 => '正常',
            2 => '黑名单',
            default => '正常',
        };
    }

    /**
     * 订单完成时滚动累计消费、订单数、最近下单时间，并按消费额计积分（每 1 元 1 分）。
     */
    public function recordConsumption(float $amount): void
    {
        $this->increment('order_count');
        $this->increment('points', (int) floor($amount));
        $this->total_spent = (float) $this->total_spent + $amount;
        $this->last_order_at = now();
        $this->save();
    }

    public function store(): BelongsTo
    {
        return $this->belongsTo(Store::class);
    }

    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * @return HasMany<CustomerFollowUp, $this>
     */
    public function followUps(): HasMany
    {
        return $this->hasMany(CustomerFollowUp::class);
    }

    /**
     * @return HasMany<CustomerOrder, $this>
     */
    public function orders(): HasMany
    {
        return $this->hasMany(CustomerOrder::class);
    }
}
