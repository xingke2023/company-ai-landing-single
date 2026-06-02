<?php

namespace App\Filament\Resources\CustomerResource\RelationManagers;

use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables;
use Filament\Tables\Table;

class OrdersRelationManager extends RelationManager
{
    protected static string $relationship = 'orders';

    protected static ?string $title = '订单记录';

    public function form(Schema $schema): Schema
    {
        return $schema->schema([]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('order_no')
                    ->label('单号')
                    ->searchable(),
                Tables\Columns\TextColumn::make('type')
                    ->label('类型')
                    ->badge()
                    ->formatStateUsing(fn (int $state): string => match ($state) {
                        1 => '预订', 2 => '送货', 3 => '团购', 4 => '自提', default => '预订',
                    }),
                Tables\Columns\TextColumn::make('total_amount')
                    ->label('金额')
                    ->money('CNY')
                    ->sortable(),
                Tables\Columns\TextColumn::make('status')
                    ->label('状态')
                    ->badge()
                    ->formatStateUsing(fn (int $state): string => match ($state) {
                        1 => '待确认', 2 => '待付款', 3 => '待发货', 4 => '已完成', 5 => '已取消', default => '未知',
                    })
                    ->color(fn (int $state): string => match ($state) {
                        4 => 'success', 5 => 'danger', 1 => 'gray', default => 'info',
                    }),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('下单时间')
                    ->dateTime('Y-m-d H:i')
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc');
    }
}
