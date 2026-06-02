<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create a demo user
        $demoUser = User::factory()->create([
            'name' => 'Demo User',
            'email' => 'demo@example.com',
        ]);

        // Create 5 more users
        $users = User::factory(5)->create();

        // Create posts for demo user
        \App\Models\Post::factory(5)->create([
            'user_id' => $demoUser->id,
        ]);

        // Create posts for other users
        foreach ($users as $user) {
            \App\Models\Post::factory(rand(2, 5))->create([
                'user_id' => $user->id,
            ]);
        }

        // 基础租户骨架：组织 / 区域 / 默认门店（store_id=1）
        $this->call(OrgStoreSeeder::class);

        // 小程序聊天页底部快捷按钮（后台可配）
        $this->call(QuickActionSeeder::class);

        // 应用配置（小程序标题等）
        $this->call(AppSettingSeeder::class);
    }
}
