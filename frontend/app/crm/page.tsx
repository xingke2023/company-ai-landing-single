'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { BackToChatBar, useMiniProgram } from '@/components/back-to-chat-bar'
import { crmApi, type Customer } from '@/lib/api/crm'

const LEVEL_LABELS: Record<number, string> = { 1: '普通', 2: '银卡', 3: '金卡' }
const LEVEL_CLS: Record<number, string> = {
  1: 'bg-gray-100 text-gray-500',
  2: 'bg-amber-50 text-amber-600',
  3: 'bg-yellow-100 text-yellow-700',
}
const STATUS_LABELS: Record<number, string> = { 0: '流失', 1: '正常', 2: '黑名单' }

export default function CrmPage() {
  const { token, isAuthenticated, loading } = useAuth()
  const router = useRouter()
  const { inMiniProgram } = useMiniProgram()

  const [customers, setCustomers] = useState<Customer[]>([])
  const [fetching, setFetching] = useState(true)
  const [q, setQ] = useState('')

  useEffect(() => {
    if (loading || isAuthenticated) return
    if (!inMiniProgram) router.push('/login')
  }, [loading, isAuthenticated, inMiniProgram, router])

  const load = async (search?: string) => {
    if (!token) return
    setFetching(true)
    try {
      const res = await crmApi.list(token, search ? { q: search } : undefined)
      setCustomers(res.data)
    } catch (e) {
      console.error(e)
    } finally {
      setFetching(false)
    }
  }

  useEffect(() => {
    if (token) load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token])

  if (loading || (fetching && customers.length === 0)) {
    return <div className="flex items-center justify-center h-screen text-gray-400">加载中...</div>
  }

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      <div className="bg-white border-b px-4 py-3 flex items-center justify-between sticky top-0 z-10">
        <h1 className="text-lg font-semibold text-gray-800">顾客管理</h1>
        <Link
          href="/crm/new"
          className="text-sm bg-[#E65C46] text-white px-3 py-1.5 rounded-lg active:opacity-80"
        >
          + 新建顾客
        </Link>
      </div>

      <div className="p-3">
        <div className="flex gap-2 mb-3">
          <input
            value={q}
            onChange={(e) => setQ(e.target.value)}
            onKeyDown={(e) => { if (e.key === 'Enter') load(q) }}
            placeholder="搜索姓名或手机号"
            className="flex-1 border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#E65C46]/40"
          />
          <button
            onClick={() => load(q)}
            className="bg-gray-800 text-white px-4 rounded-xl text-sm active:opacity-80"
          >
            搜索
          </button>
        </div>

        {customers.length === 0 ? (
          <div className="text-center py-16 text-gray-400 text-sm">暂无顾客</div>
        ) : (
          <div className="space-y-2">
            {customers.map((c) => (
              <Link
                key={c.id}
                href={`/crm/${c.id}`}
                className="block bg-white rounded-xl border border-gray-100 p-3.5 active:bg-gray-50"
              >
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <span className="font-semibold text-gray-800">{c.name}</span>
                    <span className={`text-[11px] px-1.5 py-0.5 rounded ${LEVEL_CLS[c.level]}`}>
                      {LEVEL_LABELS[c.level]}
                    </span>
                    {c.status !== 1 && (
                      <span className="text-[11px] px-1.5 py-0.5 rounded bg-red-50 text-red-500">
                        {STATUS_LABELS[c.status]}
                      </span>
                    )}
                  </div>
                  <span className="text-xs text-gray-400">{c.phone ?? '—'}</span>
                </div>
                <div className="flex items-center gap-4 mt-2 text-xs text-gray-500">
                  <span>累计消费 <b className="text-gray-700">¥{c.total_spent}</b></span>
                  <span>订单 <b className="text-gray-700">{c.order_count}</b></span>
                  <span>积分 <b className="text-gray-700">{c.points}</b></span>
                </div>
                {c.tags && c.tags.length > 0 && (
                  <div className="flex flex-wrap gap-1 mt-2">
                    {c.tags.map((t) => (
                      <span key={t} className="text-[11px] px-1.5 py-0.5 rounded bg-violet-50 text-violet-600">{t}</span>
                    ))}
                  </div>
                )}
              </Link>
            ))}
          </div>
        )}
      </div>

      <BackToChatBar />
    </div>
  )
}
