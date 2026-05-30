'use client'

import { useEffect, useState, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { salesApi, type SalesReport } from '@/lib/api/sales'
import { useMiniProgram } from '@/components/back-to-chat-bar'

// ─── Types ───────────────────────────────────────────────────────────────────

type SortKey = 'sales_amount' | 'sales_qty' | 'avg_price' | 'transaction_count'

// ─── Helpers ──────────────────────────────────────────────────────────────────

function dateStr(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}
function todayStr(): string {
  return dateStr(new Date())
}

const WEEK_LABELS = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']

// 本周一 → 周日 的 7 天（周一为首）。future 的天不可选。
function getWeekDays() {
  const now = new Date()
  const day = now.getDay() // 0=周日 1=周一 ... 6=周六
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

function fmt(n: number): string {
  return n.toFixed(2)
}

function pct(part: number, total: number): string {
  if (total === 0) return '0%'
  return Math.round((part / total) * 100) + '%'
}

// ─── Component ───────────────────────────────────────────────────────────────

export default function SalesReportPage() {
  const { token, isAuthenticated, loading, retry, authErrorMsg } = useAuth()
  const router = useRouter()

  const [date, setDate] = useState(todayStr())
  const [report, setReport] = useState<SalesReport | null>(null)
  const [fetching, setFetching] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [sortKey, setSortKey] = useState<SortKey>('sales_amount')
  const [sortAsc, setSortAsc] = useState(false)
  const [expandedRow, setExpandedRow] = useState<number | null>(null)
  const [authError, setAuthError] = useState(false)
  const { inMiniProgram, backToChat } = useMiniProgram()

  useEffect(() => {
    // 小程序 web-view 内**不自动 navigateBack 把用户踢走**（鉴权时序/存储不可用都可能误判）；
    // 改为显示「加载失败，点击重试」。普通浏览器才跳 /login。
    if (loading || isAuthenticated) return
    if (inMiniProgram) {
      setAuthError(true)
    } else {
      router.push('/login')
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [loading, isAuthenticated, inMiniProgram, router])

  const fetchReport = useCallback(async () => {
    if (!token) return
    setFetching(true)
    setError(null)
    try {
      const res = await salesApi.report(date, token)
      setReport(res.data)
    } catch {
      setError('加载失败，请重试')
    } finally {
      setFetching(false)
    }
  }, [token, date])

  useEffect(() => {
    fetchReport()
  }, [fetchReport])

  const toggleSort = (key: SortKey) => {
    if (sortKey === key) setSortAsc(v => !v)
    else { setSortKey(key); setSortAsc(false) }
  }

  const sortedProducts = report
    ? [...report.products].sort((a, b) => {
        const av = a[sortKey] ?? 0
        const bv = b[sortKey] ?? 0
        return sortAsc ? (av as number) - (bv as number) : (bv as number) - (av as number)
      })
    : []

  const SortIcon = ({ k }: { k: SortKey }) => (
    <span className={`ml-0.5 text-xs ${sortKey === k ? 'text-blue-500' : 'text-gray-300'}`}>
      {sortKey === k ? (sortAsc ? '↑' : '↓') : '↕'}
    </span>
  )

  const weekDays = getWeekDays()

  if (loading) {
    return <div className="flex items-center justify-center h-screen text-gray-400">加载中...</div>
  }

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

  return (
    <div className="min-h-screen bg-gray-50 pb-20">

      {/* Header */}
      <div className="bg-white border-b px-3 py-2 flex items-center justify-between sticky top-0 z-10 shadow-sm">
        <div className="flex items-center gap-2">
          <button onClick={inMiniProgram ? backToChat : () => router.back()} className="text-gray-400 hover:text-gray-600 text-sm mr-1">←</button>
          <h1 className="text-base font-semibold text-gray-800">每日销售报表</h1>
        </div>
        <button
          onClick={fetchReport}
          disabled={fetching}
          className="text-xs text-blue-600 hover:text-blue-800 disabled:text-gray-300"
        >
          {fetching ? '刷新中…' : '刷新'}
        </button>
      </div>

      <div className="p-3 space-y-2.5 max-w-2xl mx-auto">

        {/* Date selector: 星期一行 + 任意日期 */}
        <div className="bg-white rounded-xl border border-gray-100 p-2.5">
          <div className="flex gap-1 mb-2">
            {weekDays.map(d => (
              <button
                key={d.date}
                disabled={d.isFuture}
                onClick={() => setDate(d.date)}
                className={`flex-1 flex flex-col items-center py-1.5 rounded-lg border text-xs transition-colors ${
                  d.isFuture
                    ? 'opacity-40 text-gray-300 border-gray-100 bg-white'
                    : date === d.date
                    ? 'bg-blue-600 text-white border-blue-600'
                    : 'bg-white text-gray-600 border-gray-200'
                }`}
              >
                <span>{d.label}</span>
                <span className={`text-[10px] mt-0.5 ${
                  date === d.date ? 'text-white/80' : d.isToday ? 'text-blue-600 font-semibold' : 'text-gray-400'
                }`}>
                  {d.dayNum}
                </span>
              </button>
            ))}
          </div>
          <div className="flex items-center gap-2">
            <input
              type="date"
              value={date}
              max={todayStr()}
              onChange={e => setDate(e.target.value)}
              className="flex-1 text-sm border border-gray-200 rounded-lg px-3 py-1.5 focus:outline-none focus:ring-2 focus:ring-blue-300"
            />
            <button
              onClick={() => setDate(todayStr())}
              className="px-3 py-1.5 text-xs rounded-lg border border-gray-200 bg-white text-gray-500 active:bg-gray-50 shrink-0"
            >
              今天
            </button>
          </div>
        </div>

        {error && (
          <div className="bg-red-50 border border-red-100 rounded-xl px-4 py-3 text-sm text-red-600">{error}</div>
        )}

        {fetching && !report && (
          <div className="text-center text-sm text-gray-400 py-12">加载中…</div>
        )}

        {report && (
          <>
            {/* Summary cards — 紧凑：标签+数值同一行 */}
            <div className="grid grid-cols-2 gap-2">
              <div className="bg-orange-50 border border-orange-100 rounded-lg px-2.5 py-1.5 flex items-center justify-between">
                <span className="text-xs text-orange-400">总销售额</span>
                <span className="text-base font-bold text-orange-600 tabular-nums">¥{fmt(report.total_amount)}</span>
              </div>
              <div className="bg-blue-50 border border-blue-100 rounded-lg px-2.5 py-1.5 flex items-center justify-between">
                <span className="text-xs text-blue-400">销售笔数</span>
                <span className="text-base font-bold text-blue-600 tabular-nums">{report.total_orders}</span>
              </div>
              <div className="bg-emerald-50 border border-emerald-100 rounded-lg px-2.5 py-1.5 flex items-center justify-between">
                <span className="text-xs text-emerald-500">总销售量</span>
                <span className="text-base font-bold text-emerald-600 tabular-nums">{report.total_qty}</span>
              </div>
              <div className="bg-purple-50 border border-purple-100 rounded-lg px-2.5 py-1.5 flex items-center justify-between">
                <span className="text-xs text-purple-400">品种数</span>
                <span className="text-base font-bold text-purple-600 tabular-nums">{report.total_skus}</span>
              </div>
            </div>

            {/* 录入来源 + 支付方式 — 紧凑合并 */}
            {report.total_amount > 0 && (
              <div className="bg-white rounded-xl border border-gray-100 p-2.5 space-y-2">
                {/* 录入来源：细条 + 行内图例 */}
                <div>
                  <div className="flex rounded-md overflow-hidden h-2 mb-1.5">
                    {report.source_breakdown.pos.amount > 0 && (
                      <div className="bg-blue-400" style={{ width: pct(report.source_breakdown.pos.amount, report.total_amount) }} />
                    )}
                    {report.source_breakdown.supplement.amount > 0 && (
                      <div className="bg-amber-400" style={{ width: pct(report.source_breakdown.supplement.amount, report.total_amount) }} />
                    )}
                    {report.source_breakdown.ai.amount > 0 && (
                      <div className="bg-emerald-400" style={{ width: pct(report.source_breakdown.ai.amount, report.total_amount) }} />
                    )}
                  </div>
                  <div className="flex flex-wrap gap-x-3 gap-y-1 text-xs">
                    {([
                      { key: 'pos', label: 'POS', color: 'text-blue-500', bg: 'bg-blue-400' },
                      { key: 'supplement', label: '补录', color: 'text-amber-500', bg: 'bg-amber-400' },
                      { key: 'ai', label: 'AI', color: 'text-emerald-500', bg: 'bg-emerald-400' },
                    ] as const).map(({ key, label, color, bg }) => (
                      <span key={key} className="flex items-center gap-1">
                        <span className={`w-2 h-2 rounded-full inline-block ${bg}`} />
                        <span className="text-gray-400">{label}</span>
                        <span className={`font-semibold tabular-nums ${color}`}>¥{fmt(report.source_breakdown[key].amount)}</span>
                        <span className="text-gray-300">{pct(report.source_breakdown[key].amount, report.total_amount)}</span>
                      </span>
                    ))}
                  </div>
                </div>

                {/* 支付方式：行内 chips */}
                {report.payment_breakdown.length > 0 && (
                  <div className="flex flex-wrap gap-x-3 gap-y-1 text-xs pt-2 border-t border-gray-50">
                    {report.payment_breakdown.map(p => (
                      <span key={p.method} className="flex items-center gap-1">
                        <span className="text-gray-500">{p.label}</span>
                        <span className="font-semibold text-gray-700 tabular-nums">¥{fmt(p.amount)}</span>
                        <span className="text-gray-300">({p.count}笔)</span>
                      </span>
                    ))}
                  </div>
                )}
              </div>
            )}

            {/* Per-product table */}
            <div className="bg-white rounded-xl border border-gray-100 overflow-hidden">
              <div className="px-3 py-2 border-b border-gray-50 flex items-center justify-between">
                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide">品种明细</p>
                <p className="text-xs text-gray-300">{report.total_skus} 个品种</p>
              </div>
              {sortedProducts.length === 0 ? (
                <p className="text-center text-sm text-gray-300 py-10">当日暂无销售记录</p>
              ) : (
                <div className="overflow-x-auto">
                  <table className="text-xs w-full border-collapse min-w-[420px]">
                    <thead>
                      <tr className="bg-gray-50">
                        <th className="text-left px-2.5 py-2 text-gray-400 font-medium">商品</th>
                        <th
                          className="text-right px-2.5 py-2 text-gray-400 font-medium cursor-pointer select-none hover:text-blue-500"
                          onClick={() => toggleSort('sales_qty')}
                        >
                          销量<SortIcon k="sales_qty" />
                        </th>
                        <th
                          className="text-right px-2.5 py-2 text-gray-400 font-medium cursor-pointer select-none hover:text-blue-500"
                          onClick={() => toggleSort('sales_amount')}
                        >
                          金额<SortIcon k="sales_amount" />
                        </th>
                        <th
                          className="text-right px-2.5 py-2 text-gray-400 font-medium cursor-pointer select-none hover:text-blue-500"
                          onClick={() => toggleSort('avg_price')}
                        >
                          均价<SortIcon k="avg_price" />
                        </th>
                        <th
                          className="text-right px-2.5 py-2 text-gray-400 font-medium cursor-pointer select-none hover:text-blue-500 hidden sm:table-cell"
                          onClick={() => toggleSort('transaction_count')}
                        >
                          笔数<SortIcon k="transaction_count" />
                        </th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-50">
                      {sortedProducts.map((row, i) => {
                        const isExpanded = expandedRow === row.product_id
                        return (
                          <>
                            <tr
                              key={row.product_id}
                              className={`cursor-pointer transition-colors ${isExpanded ? 'bg-blue-50/50' : 'hover:bg-gray-50/60'}`}
                              onClick={() => setExpandedRow(isExpanded ? null : row.product_id)}
                            >
                              <td className="px-2.5 py-2">
                                <span className="font-medium text-gray-700">{row.product_name}</span>
                                {row.is_fresh && (
                                  <span className="ml-1 text-[10px] bg-green-100 text-green-600 px-1 rounded">鲜</span>
                                )}
                                {i === 0 && (
                                  <span className="ml-1 text-[10px] bg-orange-100 text-orange-500 px-1 rounded">TOP</span>
                                )}
                              </td>
                              <td className="px-2.5 py-2 text-right tabular-nums text-gray-700">
                                {row.sales_qty}<span className="text-gray-300 ml-0.5">{row.unit}</span>
                              </td>
                              <td className="px-2.5 py-2 text-right tabular-nums font-medium text-gray-800">
                                ¥{fmt(row.sales_amount)}
                              </td>
                              <td className="px-2.5 py-2 text-right tabular-nums text-gray-500">
                                {row.avg_price != null ? `¥${fmt(row.avg_price)}` : '—'}
                              </td>
                              <td className="px-2.5 py-2 text-right tabular-nums text-gray-400 hidden sm:table-cell">
                                {row.transaction_count}
                              </td>
                            </tr>
                            {isExpanded && (
                              <tr key={`${row.product_id}-detail`} className="bg-blue-50/30">
                                <td colSpan={5} className="px-4 py-2.5">
                                  <div className="flex gap-4 text-xs">
                                    <div className="flex items-center gap-1">
                                      <span className="w-2 h-2 rounded-full bg-blue-400 inline-block" />
                                      <span className="text-gray-400">POS</span>
                                      <span className="font-medium text-gray-600 tabular-nums ml-1">
                                        {row.sales_breakdown.pos.qty}{row.unit} / ¥{fmt(row.sales_breakdown.pos.amount)}
                                      </span>
                                    </div>
                                    <div className="flex items-center gap-1">
                                      <span className="w-2 h-2 rounded-full bg-amber-400 inline-block" />
                                      <span className="text-gray-400">补录</span>
                                      <span className="font-medium text-gray-600 tabular-nums ml-1">
                                        {row.sales_breakdown.supplement.qty}{row.unit} / ¥{fmt(row.sales_breakdown.supplement.amount)}
                                      </span>
                                    </div>
                                    <div className="flex items-center gap-1">
                                      <span className="w-2 h-2 rounded-full bg-emerald-400 inline-block" />
                                      <span className="text-gray-400">AI</span>
                                      <span className="font-medium text-gray-600 tabular-nums ml-1">
                                        {row.sales_breakdown.ai.qty}{row.unit} / ¥{fmt(row.sales_breakdown.ai.amount)}
                                      </span>
                                    </div>
                                  </div>
                                </td>
                              </tr>
                            )}
                          </>
                        )
                      })}
                    </tbody>
                  </table>
                </div>
              )}
            </div>

          </>
        )}
      </div>
    </div>
  )
}
