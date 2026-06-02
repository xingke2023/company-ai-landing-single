<?php

namespace App\Filament\Resources;

use App\Filament\Resources\CustomerResource\Pages;
use App\Filament\Resources\CustomerResource\RelationManagers;
use App\Models\Customer;
use Filament\Actions;
use Filament\Forms;
use Filament\Resources\Resource;
use Filament\Schemas;
use Filament\Schemas\Schema;
use Filament\Tables;
use Filament\Tables\Table;

class CustomerResource extends Resource
{
    protected static ?string $model = Customer::class;

    protected static string|\BackedEnum|null $navigationIcon = 'heroicon-o-user-group';

    protected static string|\UnitEnum|null $navigationGroup = '客户管理';

    protected static ?string $navigationLabel = '顾客档案';

    protected static ?string $modelLabel = '顾客';

    protected static ?string $pluralModelLabel = '顾客档案';

    protected static ?int $navigationSort = 1;

    public static function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Schemas\Components\Section::make('基本信息')
                    ->columns(3)
                    ->schema([
                        Forms\Components\TextInput::make('name')
                            ->label('姓名')
                            ->required()
                            ->maxLength(50),
                        Forms\Components\TextInput::make('phone')
                            ->label('手机号')
                            ->tel()
                            ->maxLength(20),
                        Forms\Components\Select::make('gender')
                            ->label('性别')
                            ->options([0 => '未知', 1 => '男', 2 => '女'])
                            ->default(0),
                        Forms\Components\DatePicker::make('birthday')
                            ->label('生日'),
                        Forms\Components\TextInput::make('address')
                            ->label('默认地址')
                            ->maxLength(255)
                            ->columnSpan(2),
                    ]),

                Schemas\Components\Section::make('会员资料')
                    ->columns(3)
                    ->schema([
                        Forms\Components\Select::make('level')
                            ->label('会员等级')
                            ->options([1 => '普通', 2 => '银卡', 3 => '金卡'])
                            ->default(1)
                            ->required(),
                        Forms\Components\TextInput::make('points')
                            ->label('积分')
                            ->numeric()
                            ->default(0),
                        Forms\Components\Select::make('status')
                            ->label('状态')
                            ->options([0 => '流失', 1 => '正常', 2 => '黑名单'])
                            ->default(1)
                            ->required(),
                        Forms\Components\TagsInput::make('tags')
                            ->label('分群标签')
                            ->placeholder('添加标签')
                            ->suggestions(['高频', '批发', 'VIP', '价格敏感', '生鲜偏好', '流失预警'])
                            ->columnSpanFull(),
                    ]),

                Forms\Components\Textarea::make('notes')
                    ->label('备注')
                    ->columnSpanFull(),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->label('姓名')
                    ->searchable()
                    ->sortable(),
                Tables\Columns\TextColumn::make('phone')
                    ->label('手机号')
                    ->searchable()
                    ->placeholder('—'),
                Tables\Columns\TextColumn::make('level')
                    ->label('等级')
                    ->badge()
                    ->formatStateUsing(fn (int $state): string => match ($state) {
                        1 => '普通', 2 => '银卡', 3 => '金卡', default => '普通',
                    })
                    ->color(fn (int $state): string => match ($state) {
                        2 => 'warning', 3 => 'success', default => 'gray',
                    }),
                Tables\Columns\TextColumn::make('points')
                    ->label('积分')
                    ->numeric()
                    ->sortable(),
                Tables\Columns\TextColumn::make('total_spent')
                    ->label('累计消费')
                    ->money('CNY')
                    ->sortable(),
                Tables\Columns\TextColumn::make('order_count')
                    ->label('订单数')
                    ->numeric()
                    ->toggleable(),
                Tables\Columns\TextColumn::make('status')
                    ->label('状态')
                    ->badge()
                    ->formatStateUsing(fn (int $state): string => match ($state) {
                        0 => '流失', 1 => '正常', 2 => '黑名单', default => '正常',
                    })
                    ->color(fn (int $state): string => match ($state) {
                        1 => 'success', 2 => 'danger', default => 'gray',
                    }),
                Tables\Columns\TextColumn::make('last_order_at')
                    ->label('最近下单')
                    ->dateTime('Y-m-d H:i')
                    ->placeholder('—')
                    ->sortable()
                    ->toggleable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->label('建档时间')
                    ->dateTime('Y-m-d')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('level')
                    ->label('等级')
                    ->options([1 => '普通', 2 => '银卡', 3 => '金卡']),
                Tables\Filters\SelectFilter::make('status')
                    ->label('状态')
                    ->options([0 => '流失', 1 => '正常', 2 => '黑名单']),
                Tables\Filters\TrashedFilter::make(),
            ])
            ->actions([
                Actions\EditAction::make(),
                Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Actions\BulkActionGroup::make([
                    Actions\DeleteBulkAction::make(),
                    Actions\RestoreBulkAction::make(),
                ]),
            ])
            ->defaultSort('created_at', 'desc');
    }

    public static function getRelations(): array
    {
        return [
            RelationManagers\FollowUpsRelationManager::class,
            RelationManagers\OrdersRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListCustomers::route('/'),
            'create' => Pages\CreateCustomer::route('/create'),
            'edit' => Pages\EditCustomer::route('/{record}/edit'),
        ];
    }
}
