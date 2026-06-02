<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customer_follow_ups', function (Blueprint $table): void {
            $table->id();
            $table->unsignedBigInteger('customer_id');
            $table->unsignedBigInteger('store_id')->index();
            $table->tinyInteger('type')->default(1)->comment('1:电话 2:微信 3:到店 4:短信 5:其他');
            $table->text('content');
            $table->timestamp('follow_up_at')->useCurrent();
            $table->date('next_follow_up_at')->nullable();
            $table->unsignedBigInteger('operator_id')->nullable();
            $table->timestamps();

            $table->index(['store_id', 'follow_up_at']);

            $table->foreign('customer_id')->references('id')->on('customers')->cascadeOnDelete();
            $table->foreign('operator_id')->references('id')->on('users')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customer_follow_ups');
    }
};
