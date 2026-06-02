<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customer_order_items', function (Blueprint $table): void {
            $table->id();
            $table->unsignedBigInteger('customer_order_id');
            $table->unsignedBigInteger('product_id')->nullable();
            $table->string('product_name', 100);
            $table->decimal('qty', 10, 3);
            $table->string('unit', 20)->nullable();
            $table->decimal('unit_price', 10, 2)->default(0);
            $table->decimal('subtotal', 12, 2)->default(0);
            $table->timestamps();

            $table->index('customer_order_id');

            $table->foreign('customer_order_id')->references('id')->on('customer_orders')->cascadeOnDelete();
            $table->foreign('product_id')->references('id')->on('products')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customer_order_items');
    }
};
