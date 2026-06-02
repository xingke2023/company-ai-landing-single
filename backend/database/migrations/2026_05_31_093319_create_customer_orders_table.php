<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customer_orders', function (Blueprint $table): void {
            $table->id();
            $table->unsignedBigInteger('store_id')->index();
            $table->string('order_no', 32)->unique();
            $table->unsignedBigInteger('customer_id')->nullable();
            $table->string('customer_name', 50)->nullable();
            $table->string('customer_phone', 20)->nullable();
            $table->tinyInteger('type')->default(1)->comment('1:预订 2:送货 3:团购 4:自提');
            $table->tinyInteger('status')->default(1)->comment('1:待确认 2:待付款 3:待发货 4:已完成 5:已取消');
            $table->decimal('total_amount', 12, 2)->default(0);
            $table->decimal('discount_amount', 12, 2)->default(0);
            $table->decimal('paid_amount', 12, 2)->default(0);
            $table->tinyInteger('payment_method')->nullable()->comment('1:现金 2:微信 3:支付宝 4:银行卡');
            $table->string('delivery_address', 255)->nullable();
            $table->timestamp('delivery_at')->nullable();
            $table->text('remark')->nullable();
            $table->unsignedBigInteger('operator_id')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['store_id', 'status']);
            $table->index('customer_id');

            $table->foreign('store_id')->references('id')->on('stores');
            $table->foreign('customer_id')->references('id')->on('customers')->nullOnDelete();
            $table->foreign('operator_id')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customer_orders');
    }
};
