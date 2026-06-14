<?php

namespace App\Filament\Resources;

use App\Filament\Resources\QuickActionResource\Pages;
use App\Filament\Resources\QuickActionResource\RelationManagers\ItemsRelationManager;
use App\Models\Industry;
use App\Models\MenuTemplate;
use App\Models\QuickAction;
use Filament\Actions;
use Filament\Forms;
use Filament\Resources\Resource;
use Filament\Schemas\Components\Utilities\Get;
use Filament\Schemas\Schema;
use Filament\Tables;
use Filament\Tables\Table;

class QuickActionResource extends Resource
{
    protected static ?string $model = QuickAction::class;

    protected static string|\BackedEnum|null $navigationIcon = 'heroicon-o-squares-2x2';

    protected static string|\UnitEnum|null $navigationGroup = '系统';

    protected static ?string $navigationLabel = '快捷按钮';

    protected static ?string $modelLabel = '快捷按钮';

    protected static ?string $pluralModelLabel = '快捷按钮';

    protected static ?int $navigationSort = 20;

    public static function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Forms\Components\Select::make('action_type')
                    ->label('按钮类型')
                    ->options([
                        'prompt' => '发送文字给 AI（prompt）',
                        'web' => '发 AI 摘要 + 打开网页（web）',
                        'open' => '直接打开网页（open）',
                        'menu' => '弹出子菜单（menu）',
                        'home' => '返回主页 / 切换行业（home）',
                    ])
                    ->default('prompt')
                    ->required()
                    ->live()
                    ->helperText('选 menu 后，子菜单项在下方「子菜单项」中维护'),

                Forms\Components\TextInput::make('emoji')
                    ->label('图标 Emoji')
                    ->maxLength(16)
                    ->placeholder('📦'),

                Forms\Components\TextInput::make('label')
                    ->label('按钮文字')
                    ->required()
                    ->maxLength(50),

                Forms\Components\TextInput::make('key')
                    ->label('标识 key')
                    ->required()
                    ->maxLength(50)
                    ->helperText('英文唯一标识，用作样式类 qa-chip-{key}'),

                Forms\Components\Textarea::make('prompt')
                    ->label('发给 AI 的文字')
                    ->rows(2)
                    ->columnSpanFull()
                    ->visible(fn (Get $get) => in_array($get('action_type'), ['prompt', 'web']))
                    ->required(fn (Get $get) => in_array($get('action_type'), ['prompt', 'web'])),

                Forms\Components\TextInput::make('target_path')
                    ->label('网页路径')
                    ->maxLength(200)
                    ->placeholder('/inventory、/sales-report、/admin/sso')
                    ->helperText('web-view 加载的路径，自动带 token')
                    ->visible(fn (Get $get) => in_array($get('action_type'), ['web', 'open']))
                    ->required(fn (Get $get) => in_array($get('action_type'), ['web', 'open'])),

                Forms\Components\TextInput::make('target_title')
                    ->label('网页标题')
                    ->maxLength(50)
                    ->visible(fn (Get $get) => in_array($get('action_type'), ['web', 'open'])),

                Forms\Components\TextInput::make('web_label')
                    ->label('「打开完整页」按钮文字')
                    ->maxLength(50)
                    ->placeholder('📦 打开完整库存页')
                    ->visible(fn (Get $get) => $get('action_type') === 'web'),

                Forms\Components\TextInput::make('badge')
                    ->label('角标文字')
                    ->maxLength(20)
                    ->helperText('留空则不显示角标'),

                Forms\Components\TextInput::make('sort_order')
                    ->label('排序（小在前）')
                    ->numeric()
                    ->default(0),

                Forms\Components\Toggle::make('enabled')
                    ->label('启用')
                    ->default(true),

                Forms\Components\Toggle::make('admin_only')
                    ->label('仅管理员可见'),

                Forms\Components\Select::make('store_id')
                    ->label('适用门店')
                    ->relationship('store', 'name')
                    ->searchable()
                    ->preload()
                    ->nullable()
                    ->placeholder('全门店通用')
                    ->helperText('留空 = 所有门店都显示'),

                Forms\Components\Select::make('industry')
                    ->label('所属行业')
                    ->options(fn () => Industry::query()->orderBy('sort_order')->pluck('name', 'slug'))
                    ->searchable()
                    ->nullable()
                    ->placeholder('全行业通用')
                    ->helperText('留空 = 所有行业都显示（通用按钮）；否则属于该行业'),

                Forms\Components\Select::make('menu_template_id')
                    ->label('所属菜单模版')
                    ->options(fn () => MenuTemplate::query()
                        ->orderBy('industry')->orderBy('sort_order')
                        ->get()
                        ->mapWithKeys(fn (MenuTemplate $t) => [$t->id => $t->industry.' · '.$t->name])
                        ->all())
                    ->searchable()
                    ->nullable()
                    ->placeholder('不绑模版（通用按钮）')
                    ->helperText('属于哪套菜单模版；通用按钮（返回主页/天气等）留空'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('emoji')->label('图标'),
                Tables\Columns\TextColumn::make('label')->label('按钮文字')->searchable(),
                Tables\Columns\TextColumn::make('action_type')
                    ->label('类型')
                    ->badge()
                    ->formatStateUsing(fn ($state) => [
                        'prompt' => '文字',
                        'web' => '摘要+网页',
                        'open' => '打开网页',
                        'menu' => '子菜单',
                        'home' => '返回主页',
                    ][$state] ?? $state)
                    ->color(fn ($state) => match ($state) {
                        'menu' => 'warning',
                        'open' => 'info',
                        'web' => 'success',
                        'home' => 'danger',
                        default => 'gray',
                    }),
                Tables\Columns\TextColumn::make('key')->label('key')->toggleable(),
                Tables\Columns\TextColumn::make('store.name')->label('门店')->placeholder('全门店'),
                Tables\Columns\TextColumn::make('industry')->label('行业')->badge()->placeholder('全行业'),
                Tables\Columns\TextColumn::make('menuTemplate.name')->label('模版')->placeholder('通用')->toggleable(),
                Tables\Columns\IconColumn::make('admin_only')->label('仅管理员')->boolean(),
                Tables\Columns\IconColumn::make('enabled')->label('启用')->boolean(),
                Tables\Columns\TextColumn::make('sort_order')->label('排序')->sortable(),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('action_type')
                    ->label('类型')
                    ->options([
                        'prompt' => '文字',
                        'web' => '摘要+网页',
                        'open' => '打开网页',
                        'menu' => '子菜单',
                        'home' => '返回主页',
                    ]),
                Tables\Filters\SelectFilter::make('industry')
                    ->label('行业')
                    ->options(fn () => Industry::query()->orderBy('sort_order')->pluck('name', 'slug')),
                Tables\Filters\SelectFilter::make('menu_template_id')
                    ->label('菜单模版')
                    ->options(fn () => MenuTemplate::query()
                        ->orderBy('industry')->orderBy('sort_order')
                        ->get()
                        ->mapWithKeys(fn (MenuTemplate $t) => [$t->id => $t->industry.' · '.$t->name])
                        ->all()),
                Tables\Filters\TernaryFilter::make('enabled')->label('启用'),
                Tables\Filters\TernaryFilter::make('admin_only')->label('仅管理员'),
            ])
            ->actions([
                Actions\EditAction::make(),
                Actions\DeleteAction::make(),
            ])
            ->bulkActions([
                Actions\BulkActionGroup::make([
                    Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->defaultSort('sort_order');
    }

    public static function getRelations(): array
    {
        return [
            ItemsRelationManager::class,
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListQuickActions::route('/'),
            'create' => Pages\CreateQuickAction::route('/create'),
            'edit' => Pages\EditQuickAction::route('/{record}/edit'),
        ];
    }
}
