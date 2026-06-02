<?php

namespace App\Filament\Resources\CustomerOrderResource\Pages;

use App\Filament\Resources\CustomerOrderResource;
use App\Models\CustomerOrder;
use Filament\Resources\Pages\CreateRecord;

class CreateCustomerOrder extends CreateRecord
{
    protected static string $resource = CustomerOrderResource::class;

    protected function mutateFormDataBeforeCreate(array $data): array
    {
        $data['store_id'] ??= 1;
        $data['order_no'] ??= CustomerOrder::generateOrderNo();
        $data['operator_id'] ??= auth()->id();
        $data['status'] ??= 1;

        return $data;
    }

    protected function afterCreate(): void
    {
        CustomerOrderResource::recalculateTotals($this->record);
    }
}
