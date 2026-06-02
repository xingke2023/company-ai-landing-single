<?php

namespace App\Filament\Resources\CustomerResource\RelationManagers;

use Filament\Actions;
use Filament\Forms;
use Filament\Resources\RelationManagers\RelationManager;
use Filament\Schemas\Schema;
use Filament\Tables;
use Filament\Tables\Table;

class FollowUpsRelationManager extends RelationManager
{
    protected static string $relationship = 'followUps';

    protected static ?string $title = '跟进记录';

    public function form(Schema $schema): Schema
    {
        return $schema
            ->schema([
                Forms\Components\Select::make('type')
                    ->label('跟进方式')
                    ->options([1 => '电话', 2 => '微信', 3 => '到店', 4 => '短信', 5 => '其他'])
                    ->default(1)
                    ->required(),
                Forms\Components\DateTimePicker::make('follow_up_at')
                    ->label('跟进时间')
                    ->default(now()),
                Forms\Components\DatePicker::make('next_follow_up_at')
                    ->label('下次跟进'),
                Forms\Components\Textarea::make('content')
                    ->label('跟进内容')
                    ->required()
                    ->columnSpanFull(),
            ]);
    }

    public function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('follow_up_at')
                    ->label('跟进时间')
                    ->dateTime('Y-m-d H:i')
                    ->sortable(),
                Tables\Columns\TextColumn::make('type')
                    ->label('方式')
                    ->badge()
                    ->formatStateUsing(fn (int $state): string => match ($state) {
                        1 => '电话', 2 => '微信', 3 => '到店', 4 => '短信', 5 => '其他', default => '其他',
                    }),
                Tables\Columns\TextColumn::make('content')
                    ->label('内容')
                    ->wrap(),
                Tables\Columns\TextColumn::make('next_follow_up_at')
                    ->label('下次跟进')
                    ->date('Y-m-d')
                    ->placeholder('—'),
                Tables\Columns\TextColumn::make('operator.name')
                    ->label('跟进人')
                    ->placeholder('—'),
            ])
            ->headerActions([
                Actions\CreateAction::make()
                    ->mutateFormDataUsing(function (array $data): array {
                        $data['store_id'] = $this->getOwnerRecord()->store_id;
                        $data['operator_id'] = auth()->id();

                        return $data;
                    }),
            ])
            ->actions([
                Actions\EditAction::make(),
                Actions\DeleteAction::make(),
            ])
            ->defaultSort('follow_up_at', 'desc');
    }
}
