import { apiClient } from './client'

export type CustomerLevel = 1 | 2 | 3
export type CustomerStatus = 0 | 1 | 2
export type FollowUpType = 1 | 2 | 3 | 4 | 5

export interface Customer {
  id: number
  store_id: number
  name: string
  phone: string | null
  gender: number
  birthday: string | null
  level: CustomerLevel
  points: number
  total_spent: string
  order_count: number
  last_order_at: string | null
  tags: string[] | null
  address: string | null
  source: number
  status: CustomerStatus
  notes: string | null
  created_at: string
  updated_at: string
  follow_ups?: FollowUp[]
  orders?: CustomerOrderBrief[]
}

export interface CustomerOrderBrief {
  id: number
  order_no: string
  type: number
  status: number
  total_amount: string
  created_at: string
}

export interface FollowUp {
  id: number
  customer_id: number
  store_id: number
  type: FollowUpType
  content: string
  follow_up_at: string
  next_follow_up_at: string | null
  operator_id: number | null
  operator?: { id: number; name: string } | null
}

export interface CreateCustomerRequest {
  name: string
  phone?: string | null
  gender?: number
  birthday?: string | null
  level?: CustomerLevel
  tags?: string[]
  address?: string | null
  status?: CustomerStatus
  notes?: string | null
}

export interface CreateFollowUpRequest {
  type?: FollowUpType
  content: string
  follow_up_at?: string
  next_follow_up_at?: string | null
}

export interface Paginated<T> {
  data: T[]
  total: number
  current_page: number
  last_page: number
}

function qs(params?: Record<string, string | number | undefined>): string {
  if (!params) return ''
  const entries = Object.entries(params).filter(([, v]) => v !== undefined && v !== '')
  if (entries.length === 0) return ''
  return '?' + new URLSearchParams(entries.map(([k, v]) => [k, String(v)])).toString()
}

export const crmApi = {
  list: (token: string, params?: { q?: string; status?: number; level?: number; tag?: string }) =>
    apiClient.get<Paginated<Customer>>(`/customers${qs(params)}`, token),

  get: (id: number, token: string) =>
    apiClient.get<{ data: Customer }>(`/customers/${id}`, token),

  create: (data: CreateCustomerRequest, token: string) =>
    apiClient.post<{ message: string; data: Customer }>('/customers', data, token),

  update: (id: number, data: Partial<CreateCustomerRequest>, token: string) =>
    apiClient.put<{ message: string; data: Customer }>(`/customers/${id}`, data, token),

  remove: (id: number, token: string) =>
    apiClient.delete<{ message: string }>(`/customers/${id}`, token),

  listFollowUps: (id: number, token: string) =>
    apiClient.get<{ data: FollowUp[] }>(`/customers/${id}/follow-ups`, token),

  addFollowUp: (id: number, data: CreateFollowUpRequest, token: string) =>
    apiClient.post<{ message: string; data: FollowUp }>(`/customers/${id}/follow-ups`, data, token),
}
