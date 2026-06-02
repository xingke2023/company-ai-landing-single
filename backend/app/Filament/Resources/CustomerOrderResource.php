<?php

namespace App\Filament\Resources;

use App\Filament\Resources\CustomerOrderResource\Pages;
use App\Models\CustomerOrder;
use Filament\Actions;
use Filament\Forms;
use Filament\Resources\Resource;
use Filament\Schemas;
use Filament\Schemas\Schema;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Support\Facades\DB;

class CustomerOrderResource extends Resource
{
    protected static ?string $model = CustomerOrder::class;

    protected static string|\BackedEnum|null $navigationIcon = 'heroicon-o-clipboard-document-list';

    protected static string|\UnitEnum|null $navigationGroup = '订单管理';

    protected static ?string $navigationLabel = '顾客订单';

    protected static ?string $modelLabel = '顾客订单';

    protected static ?string $pluralModelLabel = '顾客订单';

    protected static ?int $navigationSort = 1;

    public static function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Schemas\Components\Section::make('订单信息')
                    ->columns(3)
                    ->schema([
                        Forms\Components\Select::make('customer_id')
                            ->label('顾客')
                            ->relationship('customer', 'name')
                            ->searchable()
                            ->preload()
                            ->nullable(),
                        Forms\Components\TextInput::make('customer_name')
                            ->label('顾客姓名（散客）')
                            ->maxLength(50),
                        Forms\Components\TextInput::make('customer_phone')
                            ->label('顾客手机')
                            ->tel()
                            ->maxLength(20),
                        Forms\Components\Select::make('type')
                            ->label('订单类型')
                            ->options([1 => '预订', 2 => '送货', 3 => '团购', 4 => '自提'])
                            ->default(1)
                            ->required(),
                        Forms\Components\Select::make('payment_method')
                            ->label('支付方式')
                            ->options([1 => '现金', 2 => '微信', 3 => '支付宝', 4 => '银行卡'])
                            ->nullable(),
                        Forms\Components\TextInput::make('discount_amount')
                            ->label('优惠金额')
                            ->numeric()
                            ->default(0)
                            ->prefix('¥'),
                        Forms\Components\TextInput::make('delivery_address')
                            ->label('配送地址')
                            ->maxLength(255)
                            ->columnSpan(2),
                        Forms\Components\DateTimePicker::make('delivery_at')
                            ->label('期望送达/自提时间'),
                    ]),

                Schemas\Components\Section::make('订单明细')
                    ->schema([
                        Forms\Components\Repeater::make('items')
                            ->label('商品明细')
                            ->relationship('items')
                            ->columns(4)
                            ->schema([
                                Forms\Components\TextInput::make('product_name')
                                    ->label('商品')
                                    ->required()
                                    ->maxLength(100),
                                Forms\Components\TextInput::make('qty')
                                    ->label('数量')
                                    ->numeric()
                                    ->required()
                                    ->default(1),
                                Forms\Components\TextInput::make('unit')
                                    ->label('单位')
                                    ->maxLength(20),
                                Forms\Components\TextInput::make('unit_price')
                                    ->label('单价')
                                    ->numeric()
                                    ->required()
                                    ->default(0)
                                    ->prefix('¥'),
                            ])
                            ->defaultItems(1)
                            ->columnSpanFull(),
                    ]),

                Forms\Components\Textarea::make('remark')
                    ->label('备注')
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('order_no')
                    ->label('单号')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('customer.name')
                    ->label('顾客')
                    ->placeholder(fn (CustomerOrder $record): string => $record->customer_name ?? '散客')
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
                Tables\Columns\TextColumn::make('delivery_at')
                    ->label('送达/自提')
                    ->dateTime('Y-m-d H:i')
                    ->placeholder('—')
                    ->toggleable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('下单时间')
                    ->dateTime('Y-m-d H:i')
                    ->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('status')
                    ->label('状态')
                    ->options([1 => '待确认', 2 => '待付款', 3 => '待发货', 4 => '已完成', 5 => '已取消']),
                Tables\Filters\SelectFilter::make('type')
                    ->label('类型')
                    ->options([1 => '预订', 2 => '送货', 3 => '团购', 4 => '自提']),
                Tables\Filters\Filter::make('created_at')
                    ->schema([
                        Forms\Components\DatePicker::make('from')->label('开始日期'),
                        Forms\Components\DatePicker::make('until')->label('结束日期'),
                    ])
                    ->query(function ($query, array $data) {
                        return $query
                            ->when($data['from'], fn ($q) => $q->whereDate('created_at', '>=', $data['from']))
                            ->when($data['until'], fn ($q) => $q->whereDate('created_at', '<=', $data['until']));
                    }),
            ])
            ->actions([
                Actions\Action::make('updateStatus')
                    ->label('更新状态')
                    ->icon('heroicon-o-arrow-path')
                    ->schema([
                        Forms\Components\Select::make('status')
                            ->label('新状态')
                            ->options([1 => '待确认', 2 => '待付款', 3 => '待发货', 4 => '已完成', 5 => '已取消'])
                            ->required(),
                    ])
                    ->action(function (CustomerOrder $record, array $data): void {
                        $newStatus = (int) $data['status'];
                        DB::transaction(function () use ($record, $newStatus): void {
                            $wasCompleted = $record->status === 4;
                            $record->update(['status' => $newStatus]);
                            if ($newStatus === 4 && ! $wasCompleted && $record->customer_id) {
                                $record->customer?->recordConsumption((float) $record->total_amount);
                            }
                        });
                    }),
                Actions\EditAction::make(),
                Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Actions\BulkActionGroup::make([
                    Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->defaultSort('created_at', 'desc');
    }

    /**
     * 后台保存订单后：按明细重算各行小计与订单总额（减优惠）。
     */
    public static function recalculateTotals(CustomerOrder $order): void
    {
        $order->loadMissing('items');
        $total = 0;
        foreach ($order->items as $item) {
            $subtotal = round((float) $item->qty * (float) $item->unit_price, 2);
            if ((float) $item->subtotal !== $subtotal) {
                $item->update(['subtotal' => $subtotal]);
            }
            $total += $subtotal;
        }
        $order->update(['total_amount' => max(0, $total - (float) $order->discount_amount)]);
    }

    public static function getRelations(): array
    {
        return [];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListCustomerOrders::route('/'),
            'create' => Pages\CreateCustomerOrder::route('/create'),
            'edit' => Pages\EditCustomerOrder::route('/{record}/edit'),
        ];
    }
}
