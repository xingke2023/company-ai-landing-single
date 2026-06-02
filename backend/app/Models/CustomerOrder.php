<?php

namespace App\Models;

use Database\Factories\CustomerOrderFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Str;

class CustomerOrder extends Model
{
    /** @use HasFactory<CustomerOrderFactory> */
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'store_id',
        'order_no',
        'customer_id',
        'customer_name',
        'customer_phone',
        'type',
        'status',
        'total_amount',
        'discount_amount',
        'paid_amount',
        'payment_method',
        'delivery_address',
        'delivery_at',
        'remark',
        'operator_id',
    ];

    protected function casts(): array
    {
        return [
            'total_amount' => 'decimal:2',
            'discount_amount' => 'decimal:2',
            'paid_amount' => 'decimal:2',
            'delivery_at' => 'datetime',
        ];
    }

    public static function generateOrderNo(): string
    {
        return 'CO-'.date('Ymd').'-'.strtoupper(Str::random(6));
    }

    public function statusLabel(): string
    {
        return match ($this->status) {
            1 => '待确认',
            2 => '待付款',
            3 => '待发货',
            4 => '已完成',
            5 => '已取消',
            default => '未知',
        };
    }

    public function typeLabel(): string
    {
        return match ($this->type) {
            1 => '预订',
            2 => '送货',
            3 => '团购',
            4 => '自提',
            default => '预订',
        };
    }

    public function store(): BelongsTo
    {
        return $this->belongsTo(Store::class);
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function operator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'operator_id');
    }

    /**
     * @return HasMany<CustomerOrderItem, $this>
     */
    public function items(): HasMany
    {
        return $this->hasMany(CustomerOrderItem::class);
    }
}
