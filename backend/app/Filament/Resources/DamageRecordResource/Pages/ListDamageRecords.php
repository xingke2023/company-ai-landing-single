<?php

namespace App\Filament\Resources\DamageRecordResource\Pages;

use App\Filament\Resources\DamageRecordResource;
use App\Filament\Resources\DamageRecordResource\Widgets\DamageStatsOverview;
use Filament\Resources\Pages\ListRecords;

class ListDamageRecords extends ListRecords
{
    protected static string $resource = DamageRecordResource::class;

    protected function getHeaderActions(): array
    {
        return [];
    }

    protected function getHeaderWidgets(): array
    {
        return [
            DamageStatsOverview::class,
        ];
    }
}
