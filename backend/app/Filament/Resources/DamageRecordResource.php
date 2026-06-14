<?php

namespace App\Filament\Resources;

use App\Filament\Resources\DamageRecordResource\Pages;
use App\Models\DamageRecord;
use Filament\Forms\Components\DatePicker;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Tables;
use Filament\Tables\Columns\Summarizers\Sum;
use Filament\Tables\Grouping\Group;
use Filament\Tables\Table;

class DamageRecordResource extends Resource
{
    protected static ?string $model = DamageRecord::class;

    protected static string|\BackedEnum|null $navigationIcon = 'heroicon-o-trash';

    protected static string|\UnitEnum|null $navigationGroup = '库存管理';

    protected static ?string $navigationLabel = '损耗统计';

    protected static ?string $modelLabel = '损耗记录';

    protected static ?string $pluralModelLabel = '损耗统计';

    protected static ?int $navigationSort = 6;

    public static function form(Schema $schema): Schema
    {
        return $schema->schema([]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('occurred_at')
                    ->label('损耗日期')
                    ->date('Y-m-d')
                    ->sortable(),
                Tables\Columns\TextColumn::make('store.name')
                    ->label('门店')
                    ->sortable()
                    ->searchable(),
                Tables\Columns\TextColumn::make('product.name')
                    ->label('商品')
                    ->searchable(),
                Tables\Columns\TextColumn::make('qty')
                    ->label('数量')
                    ->numeric(decimalPlaces: 2)
                    ->suffix(fn (DamageRecord $record): string => ' '.($record->product?->unit ?? ''))
                    ->sortable()
                    ->summarize(Sum::make()->label('合计')->numeric(decimalPlaces: 2)),
                Tables\Columns\TextColumn::make('reason')
                    ->label('原因')
                    ->badge()
                    ->color('warning'),
                Tables\Columns\TextColumn::make('supplier.name')
                    ->label('供应商')
                    ->placeholder('未关联')
                    ->toggleable(),
                Tables\Columns\TextColumn::make('total_claimed')
                    ->label('索赔金额')
                    ->money('CNY')
                    ->placeholder('—')
                    ->sortable()
                    ->summarize(Sum::make()->label('合计')->money('CNY')),
                Tables\Columns\TextColumn::make('status')
                    ->label('状态')
                    ->badge()
                    ->formatStateUsing(fn (int $state): string => match ($state) {
                        1 => '已上报',
                        2 => '已提交供应商',
                        3 => '已退款',
                        4 => '已关闭',
                        default => '未知',
                    })
                    ->color(fn (int $state): string => match ($state) {
                        1 => 'gray',
                        2 => 'info',
                        3 => 'success',
                        4 => 'danger',
                        default => 'gray',
                    }),
                Tables\Columns\ImageColumn::make('image_paths')
                    ->label('照片')
                    ->getStateUsing(fn (DamageRecord $record): array => collect($record->image_paths ?? [])
                        ->map(fn (string $p): string => str_starts_with($p, 'http') ? $p : url($p))
                        ->all())
                    ->circular()
                    ->stacked()
                    ->limit(3)
                    ->limitedRemainingText()
                    ->toggleable(),
                Tables\Columns\TextColumn::make('operator.name')
                    ->label('上报人')
                    ->placeholder('—')
                    ->toggleable(),
                Tables\Columns\TextColumn::make('notes')
                    ->label('备注')
                    ->placeholder('—')
                    ->wrap()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('store_id')
                    ->label('门店')
                    ->relationship('store', 'name'),
                Tables\Filters\SelectFilter::make('supplier_id')
                    ->label('供应商')
                    ->relationship('supplier', 'name'),
                Tables\Filters\SelectFilter::make('status')
                    ->label('状态')
                    ->options([
                        1 => '已上报',
                        2 => '已提交供应商',
                        3 => '已退款',
                        4 => '已关闭',
                    ]),
                Tables\Filters\Filter::make('occurred_at')
                    ->form([
                        DatePicker::make('from')->label('开始日期'),
                        DatePicker::make('until')->label('结束日期'),
                    ])
                    ->query(function ($query, array $data) {
                        return $query
                            ->when($data['from'], fn ($q) => $q->whereDate('occurred_at', '>=', $data['from']))
                            ->when($data['until'], fn ($q) => $q->whereDate('occurred_at', '<=', $data['until']));
                    }),
            ])
            ->groups([
                Group::make('occurred_at')
                    ->label('按日期')
                    ->date(),
                Group::make('store.name')
                    ->label('按门店'),
            ])
            ->defaultGroup('occurred_at')
            ->defaultSort('occurred_at', 'desc')
            ->actions([])
            ->bulkActions([]);
    }

    public static function getRelations(): array
    {
        return [];
    }

    public static function getWidgets(): array
    {
        return [
            DamageRecordResource\Widgets\DamageStatsOverview::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListDamageRecords::route('/'),
        ];
    }
}
