'use client'

import { Suspense, useEffect, useState } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { BackToChatBar } from '@/components/back-to-chat-bar'
import { crmApi, type Customer } from '@/lib/api/crm'
import { customerOrderApi, type CreateOrderItem, type OrderType, ORDER_TYPE_LABELS } from '@/lib/api/customer-orders'

type Row = { product_name: string; qty: string; unit: string; unit_price: string }

const emptyRow = (): Row => ({ product_name: '', qty: '1', unit: '', unit_price: '' })

export default function NewOrderPage() {
  return (
    <Suspense fallback={<div className="flex items-center justify-center h-screen text-gray-400">加载中...</div>}>
      <NewOrderForm />
    </Suspense>
  )
}

function NewOrderForm() {
  const { token } = useAuth()
  const router = useRouter()
  const searchParams = useSearchParams()
  const presetCustomer = searchParams.get('customer_id')

  const [customers, setCustomers] = useState<Customer[]>([])
  const [customerId, setCustomerId] = useState<string>(presetCustomer ?? '')
  const [type, setType] = useState<OrderType>(1)
  const [discount, setDiscount] = useState('')
  const [remark, setRemark] = useState('')
  const [rows, setRows] = useState<Row[]>([emptyRow()])
  const [submitting, setSubmitting] = useState(false)
  const [result, setResult] = useState<{ ok: boolean; msg: string } | null>(null)

  useEffect(() => {
    if (!token) return
    crmApi.list(token).then((r) => setCustomers(r.data)).catch(console.error)
  }, [token])

  const total = rows.reduce((s, r) => s + (Number(r.qty) || 0) * (Number(r.unit_price) || 0), 0)
  const grandTotal = Math.max(0, total - (Number(discount) || 0))

  const updateRow = (i: number, patch: Partial<Row>) =>
    setRows((prev) => prev.map((r, j) => (j === i ? { ...r, ...patch } : r)))
  const removeRow = (i: number) => setRows((prev) => prev.filter((_, j) => j !== i))

  const submit = async () => {
    if (!token) return
    const items: CreateOrderItem[] = rows
      .filter((r) => r.product_name.trim() && Number(r.qty) > 0)
      .map((r) => ({ product_name: r.product_name.trim(), qty: Number(r.qty), unit: r.unit.trim() || undefined, unit_price: Number(r.unit_price) || 0 }))
    if (items.length === 0) {
      setResult({ ok: false, msg: '请至少添加一项有效商品' })
      return
    }
    setSubmitting(true)
    setResult(null)
    try {
      const res = await customerOrderApi.create(
        { customer_id: customerId ? Number(customerId) : null, type, discount_amount: Number(discount) || 0, remark: remark.trim() || null, items },
        token,
      )
      router.push(`/orders/${res.data.id}`)
    } catch (e) {
      setResult({ ok: false, msg: e instanceof Error ? e.message : '创建失败' })
    } finally {
      setSubmitting(false)
    }
  }

  const inputCls = 'border border-gray-200 rounded-lg px-2 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#E65C46]/40'

  return (
    <div className="min-h-screen bg-gray-50 pb-28">
      <div className="bg-white border-b px-4 py-3 flex items-center gap-3 sticky top-0 z-10">
        <button onClick={() => router.back()} className="text-gray-400 text-sm">← 返回</button>
        <h1 className="text-lg font-semibold text-gray-800">新建订单</h1>
      </div>

      <div className="p-3 space-y-3">
        <div className="bg-white rounded-xl border border-gray-100 p-4 space-y-3">
          <div>
            <label className="text-xs text-gray-400">顾客</label>
            <select value={customerId} onChange={(e) => setCustomerId(e.target.value)} className={`${inputCls} w-full`}>
              <option value="">散客（不关联）</option>
              {customers.map((c) => (
                <option key={c.id} value={c.id}>{c.name}{c.phone ? `（${c.phone}）` : ''}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="text-xs text-gray-400">订单类型</label>
            <select value={type} onChange={(e) => setType(Number(e.target.value) as OrderType)} className={`${inputCls} w-full`}>
              {Object.entries(ORDER_TYPE_LABELS).map(([v, label]) => <option key={v} value={v}>{label}</option>)}
            </select>
          </div>
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-4">
          <div className="flex items-center justify-between mb-2">
            <label className="text-sm font-semibold text-gray-700">商品明细</label>
            <button onClick={() => setRows((p) => [...p, emptyRow()])} className="text-sm text-[#E65C46]">+ 添加一行</button>
          </div>
          <div className="space-y-2">
            {rows.map((r, i) => (
              <div key={i} className="flex gap-1.5 items-center">
                <input value={r.product_name} onChange={(e) => updateRow(i, { product_name: e.target.value })} placeholder="商品" className={`${inputCls} flex-1 min-w-0`} />
                <input value={r.qty} onChange={(e) => updateRow(i, { qty: e.target.value })} placeholder="量" inputMode="decimal" className={`${inputCls} w-12`} />
                <input value={r.unit} onChange={(e) => updateRow(i, { unit: e.target.value })} placeholder="单位" className={`${inputCls} w-14`} />
                <input value={r.unit_price} onChange={(e) => updateRow(i, { unit_price: e.target.value })} placeholder="单价" inputMode="decimal" className={`${inputCls} w-16`} />
                {rows.length > 1 && (
                  <button onClick={() => removeRow(i)} className="text-gray-300 text-lg px-1">×</button>
                )}
              </div>
            ))}
          </div>
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-4 space-y-3">
          <div className="flex items-center justify-between">
            <label className="text-sm text-gray-500">优惠金额</label>
            <input value={discount} onChange={(e) => setDiscount(e.target.value)} placeholder="0" inputMode="decimal" className={`${inputCls} w-24 text-right`} />
          </div>
          <div className="flex items-center justify-between text-sm">
            <span className="text-gray-500">合计</span>
            <b className="text-lg text-[#E65C46]">¥{grandTotal.toFixed(2)}</b>
          </div>
          <textarea value={remark} onChange={(e) => setRemark(e.target.value)} rows={2} placeholder="备注" className={`${inputCls} w-full`} />
        </div>

        {result && (
          <div className={`rounded-xl px-3 py-2.5 text-sm font-medium ${result.ok ? 'bg-emerald-50 text-emerald-700' : 'bg-red-50 text-red-600'}`}>
            {result.ok ? '✅ ' : '❌ '}{result.msg}
          </div>
        )}

        <button
          onClick={submit}
          disabled={submitting}
          className="w-full bg-[#E65C46] text-white py-2.5 rounded-xl text-sm font-semibold disabled:opacity-50 active:opacity-80"
        >
          {submitting ? '提交中...' : '创建订单'}
        </button>
      </div>

      <BackToChatBar />
    </div>
  )
}
