'use client'

import { useEffect, useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { BackToChatBar } from '@/components/back-to-chat-bar'
import {
  customerOrderApi,
  type CustomerOrder,
  type OrderStatus,
  ORDER_TYPE_LABELS,
  ORDER_STATUS_LABELS,
  ORDER_STATUS_CLS,
} from '@/lib/api/customer-orders'

// 当前状态 → 可流转到的下一步动作
const NEXT_ACTIONS: Record<number, { status: OrderStatus; label: string; primary?: boolean }[]> = {
  1: [{ status: 2, label: '确认订单', primary: true }, { status: 5, label: '取消' }],
  2: [{ status: 3, label: '标记已付款', primary: true }, { status: 5, label: '取消' }],
  3: [{ status: 4, label: '完成订单', primary: true }, { status: 5, label: '取消' }],
  4: [],
  5: [],
}

export default function OrderDetailPage() {
  const { token } = useAuth()
  const router = useRouter()
  const params = useParams()
  const id = Number(params.id)

  const [order, setOrder] = useState<CustomerOrder | null>(null)
  const [loading, setLoading] = useState(true)
  const [updating, setUpdating] = useState(false)

  const load = async () => {
    if (!token) return
    setLoading(true)
    try {
      const res = await customerOrderApi.get(id, token)
      setOrder(res.data)
    } catch (e) {
      console.error(e)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    if (token) load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token, id])

  const changeStatus = async (status: OrderStatus) => {
    if (!token || !order) return
    if (status === 5 && !confirm('确认取消该订单？')) return
    setUpdating(true)
    try {
      const res = await customerOrderApi.updateStatus(order.id, status, token)
      setOrder(res.data)
    } catch (e) {
      console.error(e)
      alert(e instanceof Error ? e.message : '操作失败')
    } finally {
      setUpdating(false)
    }
  }

  if (loading || !order) {
    return <div className="flex items-center justify-center h-screen text-gray-400">加载中...</div>
  }

  const actions = NEXT_ACTIONS[order.status] ?? []

  return (
    <div className="min-h-screen bg-gray-50 pb-28">
      <div className="bg-white border-b px-4 py-3 flex items-center gap-3 sticky top-0 z-10">
        <button onClick={() => router.back()} className="text-gray-400 text-sm">← 返回</button>
        <h1 className="text-lg font-semibold text-gray-800">订单详情</h1>
      </div>

      <div className="p-3 space-y-3">
        <div className="bg-white rounded-xl border border-gray-100 p-4">
          <div className="flex items-center justify-between">
            <span className="text-sm font-medium text-gray-700">{order.order_no}</span>
            <span className={`text-xs px-2 py-0.5 rounded border ${ORDER_STATUS_CLS[order.status]}`}>
              {ORDER_STATUS_LABELS[order.status]}
            </span>
          </div>
          <div className="grid grid-cols-2 gap-y-1.5 mt-3 text-sm">
            <span className="text-gray-400">顾客</span>
            <span className="text-right text-gray-700">{order.customer?.name ?? order.customer_name ?? '散客'}</span>
            <span className="text-gray-400">手机</span>
            <span className="text-right text-gray-700">{order.customer?.phone ?? order.customer_phone ?? '—'}</span>
            <span className="text-gray-400">类型</span>
            <span className="text-right text-gray-700">{ORDER_TYPE_LABELS[order.type]}</span>
            {order.delivery_at && (
              <>
                <span className="text-gray-400">送达/自提</span>
                <span className="text-right text-gray-700">{order.delivery_at.slice(0, 16).replace('T', ' ')}</span>
              </>
            )}
            <span className="text-gray-400">下单时间</span>
            <span className="text-right text-gray-700">{order.created_at.slice(0, 16).replace('T', ' ')}</span>
          </div>
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-4">
          <h2 className="text-sm font-semibold text-gray-700 mb-2">商品明细</h2>
          <div className="space-y-1.5">
            {order.items?.map((it) => (
              <div key={it.id} className="flex items-center justify-between text-sm">
                <span className="text-gray-700">{it.product_name} <span className="text-gray-400 text-xs">×{it.qty}{it.unit ?? ''}</span></span>
                <span className="text-gray-600">¥{it.subtotal}</span>
              </div>
            ))}
          </div>
          <div className="border-t border-gray-50 mt-2 pt-2 space-y-1 text-sm">
            {Number(order.discount_amount) > 0 && (
              <div className="flex justify-between text-gray-400"><span>优惠</span><span>-¥{order.discount_amount}</span></div>
            )}
            <div className="flex justify-between font-semibold">
              <span className="text-gray-600">合计</span>
              <span className="text-[#E65C46]">¥{order.total_amount}</span>
            </div>
          </div>
        </div>

        {order.remark && (
          <div className="bg-white rounded-xl border border-gray-100 p-4 text-sm text-gray-600">{order.remark}</div>
        )}
      </div>

      {actions.length > 0 && (
        <div className="fixed bottom-0 inset-x-0 bg-white border-t px-4 py-3 flex gap-2">
          {actions.map((a) => (
            <button
              key={a.status}
              onClick={() => changeStatus(a.status)}
              disabled={updating}
              className={`flex-1 py-2.5 rounded-xl text-sm font-semibold disabled:opacity-50 ${
                a.primary ? 'bg-[#E65C46] text-white' : 'bg-gray-100 text-gray-500'
              }`}
            >
              {a.label}
            </button>
          ))}
        </div>
      )}

      <BackToChatBar />
    </div>
  )
}
