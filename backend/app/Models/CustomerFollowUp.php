<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CustomerFollowUp extends Model
{
    protected $fillable = [
        'customer_id',
        'store_id',
        'type',
        'content',
        'follow_up_at',
        'next_follow_up_at',
        'operator_id',
    ];

    protected function casts(): array
    {
        return [
            'follow_up_at' => 'datetime',
            'next_follow_up_at' => 'date',
        ];
    }

    public function typeLabel(): string
    {
        return match ($this->type) {
            1 => '电话',
            2 => '微信',
            3 => '到店',
            4 => '短信',
            5 => '其他',
            default => '其他',
        };
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function operator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'operator_id');
    }
}
