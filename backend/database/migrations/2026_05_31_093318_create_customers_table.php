<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customers', function (Blueprint $table): void {
            $table->id();
            $table->unsignedBigInteger('store_id')->index();
            $table->string('name', 50);
            $table->string('phone', 20)->nullable()->index();
            $table->tinyInteger('gender')->default(0)->comment('0:未知 1:男 2:女');
            $table->date('birthday')->nullable();
            $table->tinyInteger('level')->default(1)->comment('会员等级 1:普通 2:银卡 3:金卡');
            $table->integer('points')->default(0);
            $table->decimal('total_spent', 12, 2)->default(0)->comment('累计消费');
            $table->integer('order_count')->default(0);
            $table->timestamp('last_order_at')->nullable();
            $table->json('tags')->nullable()->comment('分群标签数组');
            $table->string('address', 255)->nullable();
            $table->tinyInteger('source')->default(1)->comment('1:手动 2:AI 3:导入');
            $table->tinyInteger('status')->default(1)->comment('0:流失 1:正常 2:黑名单');
            $table->text('notes')->nullable();
            $table->unsignedBigInteger('created_by')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['store_id', 'phone']);
            $table->index(['store_id', 'status']);

            $table->foreign('store_id')->references('id')->on('stores');
            $table->foreign('created_by')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customers');
    }
};
