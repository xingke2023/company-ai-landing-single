import { apiClient } from './client'
import type { Paginated } from './crm'

export type OrderType = 1 | 2 | 3 | 4
export type OrderStatus = 1 | 2 | 3 | 4 | 5

export interface CustomerOrderItem {
  id: number
  customer_order_id: number
  product_id: number | null
  product_name: string
  qty: string
  unit: string | null
  unit_price: string
  subtotal: string
}

export interface CustomerOrder {
  id: number
  store_id: number
  order_no: string
  customer_id: number | null
  customer_name: string | null
  customer_phone: string | null
  type: OrderType
  status: OrderStatus
  total_amount: string
  discount_amount: string
  paid_amount: string
  payment_method: number | null
  delivery_address: string | null
  delivery_at: string | null
  remark: string | null
  operator_id: number | null
  created_at: string
  updated_at: string
  customer?: { id: number; name: string; phone: string | null } | null
  items?: CustomerOrderItem[]
}

export interface CreateOrderItem {
  product_id?: number | null
  product_name: string
  qty: number
  unit?: string
  unit_price: number
}

export interface CreateOrderRequest {
  customer_id?: number | null
  customer_name?: string | null
  customer_phone?: string | null
  type?: OrderType
  discount_amount?: number
  paid_amount?: number
  payment_method?: number | null
  delivery_address?: string | null
  delivery_at?: string | null
  remark?: string | null
  items: CreateOrderItem[]
}

function qs(params?: Record<string, string | number | undefined>): string {
  if (!params) return ''
  const entries = Object.entries(params).filter(([, v]) => v !== undefined && v !== '')
  if (entries.length === 0) return ''
  return '?' + new URLSearchParams(entries.map(([k, v]) => [k, String(v)])).toString()
}

export const customerOrderApi = {
  list: (token: string, params?: { status?: number; type?: number; customer_id?: number; date?: string }) =>
    apiClient.get<Paginated<CustomerOrder>>(`/customer-orders${qs(params)}`, token),

  get: (id: number, token: string) =>
    apiClient.get<{ data: CustomerOrder }>(`/customer-orders/${id}`, token),

  create: (data: CreateOrderRequest, token: string) =>
    apiClient.post<{ message: string; data: CustomerOrder }>('/customer-orders', data, token),

  updateStatus: (id: number, status: OrderStatus, token: string) =>
    apiClient.put<{ message: string; data: CustomerOrder }>(`/customer-orders/${id}/status`, { status }, token),
}

export const ORDER_TYPE_LABELS: Record<number, string> = {
  1: '预订', 2: '送货', 3: '团购', 4: '自提',
}

export const ORDER_STATUS_LABELS: Record<number, string> = {
  1: '待确认', 2: '待付款', 3: '待发货', 4: '已完成', 5: '已取消',
}

export const ORDER_STATUS_CLS: Record<number, string> = {
  1: 'bg-gray-100 text-gray-500 border-gray-200',
  2: 'bg-amber-50 text-amber-600 border-amber-200',
  3: 'bg-blue-50 text-blue-600 border-blue-200',
  4: 'bg-emerald-50 text-emerald-600 border-emerald-200',
  5: 'bg-red-50 text-red-500 border-red-200',
}
