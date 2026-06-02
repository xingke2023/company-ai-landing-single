'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { BackToChatBar, useMiniProgram } from '@/components/back-to-chat-bar'
import {
  customerOrderApi,
  type CustomerOrder,
  ORDER_TYPE_LABELS,
  ORDER_STATUS_LABELS,
  ORDER_STATUS_CLS,
} from '@/lib/api/customer-orders'

const TABS: { v?: number; label: string }[] = [
  { v: undefined, label: '全部' },
  { v: 1, label: '待确认' },
  { v: 2, label: '待付款' },
  { v: 3, label: '待发货' },
  { v: 4, label: '已完成' },
]

export default function OrdersPage() {
  const { token, isAuthenticated, loading } = useAuth()
  const router = useRouter()
  const { inMiniProgram } = useMiniProgram()

  const [orders, setOrders] = useState<CustomerOrder[]>([])
  const [fetching, setFetching] = useState(true)
  const [tab, setTab] = useState<number | undefined>(undefined)

  useEffect(() => {
    if (loading || isAuthenticated) return
    if (!inMiniProgram) router.push('/login')
  }, [loading, isAuthenticated, inMiniProgram, router])

  const load = async (status?: number) => {
    if (!token) return
    setFetching(true)
    try {
      const res = await customerOrderApi.list(token, status ? { status } : undefined)
      setOrders(res.data)
    } catch (e) {
      console.error(e)
    } finally {
      setFetching(false)
    }
  }

  useEffect(() => {
    if (token) load(tab)
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token, tab])

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      <div className="bg-white border-b px-4 py-3 flex items-center justify-between sticky top-0 z-10">
        <h1 className="text-lg font-semibold text-gray-800">顾客订单</h1>
        <Link href="/orders/new" className="text-sm bg-[#E65C46] text-white px-3 py-1.5 rounded-lg active:opacity-80">
          + 新建订单
        </Link>
      </div>

      <div className="bg-white border-b flex overflow-x-auto">
        {TABS.map((t) => (
          <button
            key={t.label}
            onClick={() => setTab(t.v)}
            className={`flex-1 min-w-[64px] py-2.5 text-sm font-medium whitespace-nowrap ${
              tab === t.v ? 'text-[#E65C46] border-b-2 border-[#E65C46]' : 'text-gray-500'
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      <div className="p-3">
        {fetching && orders.length === 0 ? (
          <div className="text-center py-16 text-gray-400 text-sm">加载中...</div>
        ) : orders.length === 0 ? (
          <div className="text-center py-16 text-gray-400 text-sm">暂无订单</div>
        ) : (
          <div className="space-y-2">
            {orders.map((o) => (
              <Link
                key={o.id}
                href={`/orders/${o.id}`}
                className="block bg-white rounded-xl border border-gray-100 p-3.5 active:bg-gray-50"
              >
                <div className="flex items-center justify-between">
                  <span className="text-sm font-medium text-gray-700">{o.order_no}</span>
                  <span className={`text-[11px] px-1.5 py-0.5 rounded border ${ORDER_STATUS_CLS[o.status]}`}>
                    {ORDER_STATUS_LABELS[o.status]}
                  </span>
                </div>
                <div className="flex items-center justify-between mt-2">
                  <span className="text-sm text-gray-600">
                    {o.customer?.name ?? o.customer_name ?? '散客'}
                    <span className="text-[11px] text-gray-400 ml-2">{ORDER_TYPE_LABELS[o.type]}</span>
                  </span>
                  <b className="text-gray-800">¥{o.total_amount}</b>
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>

      <BackToChatBar />
    </div>
  )
}
