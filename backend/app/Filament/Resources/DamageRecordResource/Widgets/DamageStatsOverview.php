<?php

namespace App\Filament\Resources\DamageRecordResource\Widgets;

use App\Models\DamageRecord;
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use Illuminate\Support\Facades\Auth;

class DamageStatsOverview extends StatsOverviewWidget
{
    protected ?string $heading = '损耗统计报告';

    protected function getStats(): array
    {
        $storeId = Auth::user()?->resolveStoreId();
        $today = today();

        $days = [
            ['今天', $today->copy(), 'danger'],
            ['昨天', $today->copy()->subDay(), 'warning'],
            ['前天', $today->copy()->subDays(2), 'gray'],
        ];

        $stats = [];
        foreach ($days as [$label, $date, $color]) {
            $row = $this->aggregate($storeId, fn ($q) => $q->whereDate('occurred_at', $date));
            $stats[] = Stat::make($label.' · '.$date->format('m-d'), '¥'.number_format((float) $row->claim, 2))
                ->description($row->cnt.' 笔 · 数量 '.$this->num($row->qty))
                ->descriptionIcon('heroicon-m-trash')
                ->color($color);
        }

        // 本月累计
        $month = $this->aggregate($storeId, fn ($q) => $q->whereDate('occurred_at', '>=', $today->copy()->startOfMonth()));
        $stats[] = Stat::make('本月累计', '¥'.number_format((float) $month->claim, 2))
            ->description($month->cnt.' 笔 · 数量 '.$this->num($month->qty))
            ->descriptionIcon('heroicon-m-calendar-days')
            ->color('info');

        return $stats;
    }

    /** 单次查询取 数量/索赔金额/笔数；按 admin 绑定门店过滤（未绑定=全门店）。 */
    private function aggregate(?int $storeId, callable $scope): object
    {
        $query = DamageRecord::query()
            ->when($storeId, fn ($q) => $q->where('store_id', $storeId));

        return $scope($query)
            ->selectRaw('COALESCE(SUM(qty),0) as qty, COALESCE(SUM(total_claimed),0) as claim, COUNT(*) as cnt')
            ->first();
    }

    private function num(mixed $v): string
    {
        return rtrim(rtrim(number_format((float) $v, 2, '.', ''), '0'), '.') ?: '0';
    }
}
