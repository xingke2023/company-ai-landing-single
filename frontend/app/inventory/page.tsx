'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { inventoryApi, type InventoryItem, type InventoryTransaction } from '@/lib/api/inventory'
import { useMiniProgram } from '@/components/back-to-chat-bar'

// 本地日期 YYYY-MM-DD（不能用 toISOString，UTC 会偏一天）
function dateStr(d: Date) {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}
function todayStr() {
  return dateStr(new Date())
}

const WEEK_LABELS = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']

// 本周一 → 周日 的 7 天（周一为首）。future 的天不可选。
function getWeekDays() {
  const now = new Date()
  const day = now.getDay() // 0=周日, 1=周一 ... 6=周六
  const offsetToMonday = day === 0 ? -6 : 1 - day
  const monday = new Date(now)
  monday.setDate(now.getDate() + offsetToMonday)
  const today = dateStr(now)
  return WEEK_LABELS.map((label, i) => {
    const d = new Date(monday)
    d.setDate(monday.getDate() + i)
    const ds = dateStr(d)
    return { label, date: ds, dayNum: d.getDate(), isFuture: ds > today, isToday: ds === today }
  })
}

export default function InventoryPage() {
  const { token, isAuthenticated, loading, retry, authErrorMsg } = useAuth()
  const router = useRouter()
  const { inMiniProgram, backToChat } = useMiniProgram()

  const [inventory, setInventory] = useState<InventoryItem[]>([])
  const [transactions, setTransactions] = useState<InventoryTransaction[]>([])
  const [activeTab, setActiveTab] = useState<'inventory' | 'transactions'>('inventory')
  const [fetching, setFetching] = useState(true)
  const [authError, setAuthError] = useState(false)

  // 当前库存：搜索 + 分类筛选
  const [query, setQuery] = useState('')
  const [category, setCategory] = useState('全部')

  // 库存流水：按日期查询（默认今天）
  const [txDate, setTxDate] = useState(todayStr())
  const [txLoading, setTxLoading] = useState(false)

  useEffect(() => {
    // 小程序 web-view 内**不自动退回**踢人；改为显示「加载失败，点击重试」。普通浏览器才跳 /login。
    if (loading || isAuthenticated) return
    if (inMiniProgram) {
      setAuthError(true)
    } else {
      router.push('/login')
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [loading, isAuthenticated, inMiniProgram, router])

  // 当前库存：进页拉一次
  useEffect(() => {
    if (!token) return
    const run = async () => {
      setFetching(true)
      try {
        const res = await inventoryApi.list(token)
        setInventory(res.data)
      } catch (err) {
        console.error(err)
      } finally {
        setFetching(false)
      }
    }
    run()
  }, [token])

  // 库存流水：按所选日期拉取
  useEffect(() => {
    if (!token) return
    const run = async () => {
      setTxLoading(true)
      try {
        const res = await inventoryApi.transactions(token, txDate)
        setTransactions(res.data)
      } catch (err) {
        console.error(err)
      } finally {
        setTxLoading(false)
      }
    }
    run()
  }, [token, txDate])

  if (authError && !isAuthenticated) {
    return (
      <div className="flex flex-col items-center justify-center h-screen gap-4 px-8 text-center">
        <p className="text-gray-500">登录态加载失败，请重试</p>
        {authErrorMsg && (
          <p className="text-xs text-gray-400 break-all max-w-xs">原因：{authErrorMsg}{!token && '（未收到 token）'}</p>
        )}
        <button
          onClick={() => { setAuthError(false); retry() }}
          className="bg-[#E65C46] text-white text-sm font-semibold px-8 py-2.5 rounded-full active:opacity-80"
        >
          点击重试
        </button>
        {inMiniProgram && (
          <button onClick={backToChat} className="text-gray-400 text-sm underline">返回聊天</button>
        )}
      </div>
    )
  }

  if (loading || fetching) {
    return <div className="flex items-center justify-center h-screen text-gray-500">加载中...</div>
  }

  // 分类标签（默认全部）：从库存商品里取唯一分类
  const categories = ['全部', ...Array.from(new Set(inventory.map(i => i.category_name || '未分类')))]

  // 库存流水：本周星期选择器
  const weekDays = getWeekDays()

  const filteredInventory = inventory.filter(item => {
    const matchQuery = !query || (item.product_name || '').toLowerCase().includes(query.toLowerCase())
    const matchCategory = category === '全部' || (item.category_name || '未分类') === category
    return matchQuery && matchCategory
  })

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* 顶部导航 */}
      <div className="bg-white border-b px-3 py-2 flex items-center justify-between sticky top-0 z-10">
        <h1 className="text-base font-semibold text-gray-800">库存管理</h1>
        {!inMiniProgram && (
          <a href="/manage" className="text-sm text-[#941100] hover:underline font-medium">AI助手 →</a>
        )}
      </div>

      {/* Tab 切换 */}
      <div className="bg-white border-b flex sticky top-[41px] z-10">
        <button
          onClick={() => setActiveTab('inventory')}
          className={`flex-1 py-2.5 text-sm font-medium transition-colors ${
            activeTab === 'inventory' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'
          }`}
        >
          当前库存 ({inventory.length})
        </button>
        <button
          onClick={() => setActiveTab('transactions')}
          className={`flex-1 py-2.5 text-sm font-medium transition-colors ${
            activeTab === 'transactions' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'
          }`}
        >
          库存流水 ({transactions.length})
        </button>
      </div>

      <div className="p-3">
        {activeTab === 'inventory' && (
          <>
            {/* 搜索 */}
            <input
              value={query}
              onChange={e => setQuery(e.target.value)}
              placeholder="搜索商品名"
              className="w-full mb-2 px-3 py-2 text-sm rounded-lg border bg-white focus:outline-none focus:ring-1 focus:ring-blue-400"
            />

            {/* 分类标签 */}
            <div className="flex gap-1.5 overflow-x-auto pb-2 mb-1 -mx-3 px-3">
              {categories.map(c => (
                <button
                  key={c}
                  onClick={() => setCategory(c)}
                  className={`shrink-0 px-3 py-1 text-xs rounded-full border transition-colors ${
                    category === c
                      ? 'bg-blue-600 text-white border-blue-600'
                      : 'bg-white text-gray-500 border-gray-200'
                  }`}
                >
                  {c}
                </button>
              ))}
            </div>

            {filteredInventory.length === 0 ? (
              <div className="text-center py-16 text-gray-400">
                <div className="text-4xl mb-3">📦</div>
                <p>{inventory.length === 0 ? '暂无库存记录' : '没有匹配的商品'}</p>
              </div>
            ) : (
              <div className="grid grid-cols-2 gap-1.5">
                {filteredInventory.map(item => {
                  const qty = item.current_qty
                  return (
                    <div key={item.id} className="bg-white rounded-lg border border-gray-100 px-2.5 py-1.5 flex items-center justify-between gap-1">
                      <div className="min-w-0 flex items-center gap-1">
                        <span className="text-sm text-gray-800 truncate">{item.product_name}</span>
                        {qty <= 0 ? (
                          <span className="text-[10px] bg-red-100 text-red-600 px-1 py-0.5 rounded shrink-0">罄</span>
                        ) : qty <= 5 ? (
                          <span className="text-[10px] bg-yellow-100 text-yellow-700 px-1 py-0.5 rounded shrink-0">低</span>
                        ) : null}
                      </div>
                      <div className="text-sm font-semibold text-gray-800 shrink-0 tabular-nums">
                        {qty}
                        <span className="text-xs font-normal text-gray-400 ml-0.5">{item.unit}</span>
                      </div>
                    </div>
                  )
                })}
              </div>
            )}
          </>
        )}

        {activeTab === 'transactions' && (
          <>
            {/* 星期选择（本周一→周日，默认今天） */}
            <div className="flex gap-1 mb-2">
              {weekDays.map(d => (
                <button
                  key={d.date}
                  disabled={d.isFuture}
                  onClick={() => setTxDate(d.date)}
                  className={`flex-1 flex flex-col items-center py-1.5 rounded-lg border text-xs transition-colors ${
                    d.isFuture
                      ? 'opacity-40 text-gray-300 border-gray-100 bg-white'
                      : txDate === d.date
                      ? 'bg-blue-600 text-white border-blue-600'
                      : 'bg-white text-gray-600 border-gray-200'
                  }`}
                >
                  <span>{d.label}</span>
                  <span className={`text-[10px] mt-0.5 ${
                    txDate === d.date ? 'text-white/80' : d.isToday ? 'text-blue-600 font-semibold' : 'text-gray-400'
                  }`}>
                    {d.dayNum}
                  </span>
                </button>
              ))}
            </div>

            {/* 任意日期选择 */}
            <div className="flex items-center gap-2 mb-2">
              <input
                type="date"
                value={txDate}
                max={todayStr()}
                onChange={e => setTxDate(e.target.value)}
                className="px-3 py-1.5 text-sm rounded-lg border bg-white focus:outline-none focus:ring-1 focus:ring-blue-400"
              />
              <button
                onClick={() => setTxDate(todayStr())}
                className="px-3 py-1.5 text-xs rounded-lg border bg-white text-gray-500 active:bg-gray-50"
              >
                今天
              </button>
            </div>

            {txLoading ? (
              <div className="text-center py-16 text-gray-400">加载中...</div>
            ) : transactions.length === 0 ? (
              <div className="text-center py-16 text-gray-400">
                <div className="text-4xl mb-3">📋</div>
                <p>{txDate} 暂无流水记录</p>
              </div>
            ) : (
              <div className="bg-white rounded-xl border divide-y divide-gray-100">
                {transactions.map(tx => {
                  const isIn = tx.transaction_type === 1 || tx.transaction_type === 8 || tx.transaction_type === 6
                  const isAdjust = tx.transaction_type === 4
                  return (
                    <div key={tx.id} className="flex items-center gap-2 px-3 py-2">
                      <span className={`text-[10px] px-1.5 py-0.5 rounded shrink-0 ${
                        isIn ? 'bg-green-100 text-green-700' : isAdjust ? 'bg-yellow-100 text-yellow-700' : 'bg-red-100 text-red-600'
                      }`}>
                        {tx.type_label}
                      </span>
                      <div className="min-w-0 flex-1">
                        <div className="text-sm text-gray-800 truncate">{tx.product_name}</div>
                        {tx.notes && <div className="text-[11px] text-gray-400 truncate">{tx.notes}</div>}
                      </div>
                      <div className="text-right shrink-0">
                        <div className={`text-sm font-semibold tabular-nums ${tx.qty_change > 0 ? 'text-green-600' : 'text-red-500'}`}>
                          {tx.qty_change > 0 ? '+' : ''}{tx.qty_change}{tx.unit}
                        </div>
                        <div className="text-[11px] text-gray-400">{tx.created_at}</div>
                      </div>
                    </div>
                  )
                })}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  )
}
