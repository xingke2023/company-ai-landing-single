'use client'

import { useEffect, useState } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { BackToChatBar } from '@/components/back-to-chat-bar'
import { crmApi, type Customer, type FollowUp, type FollowUpType } from '@/lib/api/crm'
import { ORDER_STATUS_LABELS, ORDER_STATUS_CLS } from '@/lib/api/customer-orders'

const LEVEL_LABELS: Record<number, string> = { 1: '普通会员', 2: '银卡会员', 3: '金卡会员' }
const FU_TYPES: { v: FollowUpType; label: string }[] = [
  { v: 1, label: '电话' }, { v: 2, label: '微信' }, { v: 3, label: '到店' }, { v: 4, label: '短信' }, { v: 5, label: '其他' },
]

export default function CustomerDetailPage() {
  const { token } = useAuth()
  const router = useRouter()
  const params = useParams()
  const id = Number(params.id)

  const [customer, setCustomer] = useState<Customer | null>(null)
  const [followUps, setFollowUps] = useState<FollowUp[]>([])
  const [loading, setLoading] = useState(true)

  const [fuType, setFuType] = useState<FollowUpType>(1)
  const [fuContent, setFuContent] = useState('')
  const [adding, setAdding] = useState(false)

  const load = async () => {
    if (!token) return
    setLoading(true)
    try {
      const res = await crmApi.get(id, token)
      setCustomer(res.data)
      setFollowUps(res.data.follow_ups ?? [])
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

  const addFollowUp = async () => {
    if (!fuContent.trim() || !token) return
    setAdding(true)
    try {
      await crmApi.addFollowUp(id, { type: fuType, content: fuContent.trim() }, token)
      setFuContent('')
      const res = await crmApi.listFollowUps(id, token)
      setFollowUps(res.data)
    } catch (e) {
      console.error(e)
    } finally {
      setAdding(false)
    }
  }

  if (loading || !customer) {
    return <div className="flex items-center justify-center h-screen text-gray-400">加载中...</div>
  }

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      <div className="bg-white border-b px-4 py-3 flex items-center gap-3 sticky top-0 z-10">
        <button onClick={() => router.back()} className="text-gray-400 text-sm">← 返回</button>
        <h1 className="text-lg font-semibold text-gray-800">顾客详情</h1>
      </div>

      <div className="p-3 space-y-3">
        {/* 基本信息 */}
        <div className="bg-white rounded-xl border border-gray-100 p-4">
          <div className="flex items-center justify-between">
            <span className="text-xl font-bold text-gray-800">{customer.name}</span>
            <span className="text-sm text-violet-600 font-medium">{LEVEL_LABELS[customer.level]}</span>
          </div>
          <div className="text-sm text-gray-500 mt-1">{customer.phone ?? '无手机号'}</div>
          <div className="grid grid-cols-3 gap-2 mt-3 text-center">
            <div className="bg-gray-50 rounded-lg py-2">
              <div className="text-base font-bold text-gray-800">¥{customer.total_spent}</div>
              <div className="text-[11px] text-gray-400">累计消费</div>
            </div>
            <div className="bg-gray-50 rounded-lg py-2">
              <div className="text-base font-bold text-gray-800">{customer.order_count}</div>
              <div className="text-[11px] text-gray-400">订单数</div>
            </div>
            <div className="bg-gray-50 rounded-lg py-2">
              <div className="text-base font-bold text-gray-800">{customer.points}</div>
              <div className="text-[11px] text-gray-400">积分</div>
            </div>
          </div>
          {customer.tags && customer.tags.length > 0 && (
            <div className="flex flex-wrap gap-1 mt-3">
              {customer.tags.map((t) => (
                <span key={t} className="text-[11px] px-1.5 py-0.5 rounded bg-violet-50 text-violet-600">{t}</span>
              ))}
            </div>
          )}
          {customer.address && <div className="text-xs text-gray-400 mt-2">📍 {customer.address}</div>}
          {customer.notes && <div className="text-xs text-gray-500 mt-2">{customer.notes}</div>}
        </div>

        {/* 消费记录 */}
        <div className="bg-white rounded-xl border border-gray-100 p-4">
          <h2 className="text-sm font-semibold text-gray-700 mb-2">消费记录</h2>
          {!customer.orders || customer.orders.length === 0 ? (
            <div className="text-xs text-gray-400 py-2">暂无订单</div>
          ) : (
            <div className="space-y-1.5">
              {customer.orders.map((o) => (
                <div key={o.id} className="flex items-center justify-between text-sm">
                  <span className="text-gray-600">{o.order_no}</span>
                  <span className="flex items-center gap-2">
                    <span className={`text-[11px] px-1.5 py-0.5 rounded border ${ORDER_STATUS_CLS[o.status]}`}>
                      {ORDER_STATUS_LABELS[o.status]}
                    </span>
                    <b className="text-gray-800">¥{o.total_amount}</b>
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* 跟进记录 */}
        <div className="bg-white rounded-xl border border-gray-100 p-4">
          <h2 className="text-sm font-semibold text-gray-700 mb-2">跟进记录</h2>
          <div className="flex gap-2 mb-2">
            <select
              value={fuType}
              onChange={(e) => setFuType(Number(e.target.value) as FollowUpType)}
              className="border border-gray-200 rounded-lg px-2 py-2 text-sm focus:outline-none"
            >
              {FU_TYPES.map((t) => <option key={t.v} value={t.v}>{t.label}</option>)}
            </select>
            <input
              value={fuContent}
              onChange={(e) => setFuContent(e.target.value)}
              placeholder="跟进内容"
              className="flex-1 border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#E65C46]/40"
            />
            <button
              onClick={addFollowUp}
              disabled={adding || !fuContent.trim()}
              className="bg-[#E65C46] text-white px-3 rounded-lg text-sm disabled:opacity-50"
            >
              添加
            </button>
          </div>
          {followUps.length === 0 ? (
            <div className="text-xs text-gray-400 py-2">暂无跟进</div>
          ) : (
            <div className="space-y-2 mt-2">
              {followUps.map((f) => (
                <div key={f.id} className="border-l-2 border-gray-100 pl-3">
                  <div className="flex items-center gap-2 text-xs text-gray-400">
                    <span className="text-violet-600">{FU_TYPES.find((t) => t.v === f.type)?.label}</span>
                    <span>{f.follow_up_at?.slice(0, 16).replace('T', ' ')}</span>
                    {f.operator?.name && <span>· {f.operator.name}</span>}
                  </div>
                  <div className="text-sm text-gray-700 mt-0.5">{f.content}</div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      <BackToChatBar />
    </div>
  )
}
