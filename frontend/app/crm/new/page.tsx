'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { BackToChatBar } from '@/components/back-to-chat-bar'
import { crmApi, type CustomerLevel } from '@/lib/api/crm'

const TAG_SUGGESTIONS = ['高频', '批发', 'VIP', '价格敏感', '生鲜偏好', '流失预警']

export default function NewCustomerPage() {
  const { token } = useAuth()
  const router = useRouter()

  const [name, setName] = useState('')
  const [phone, setPhone] = useState('')
  const [gender, setGender] = useState(0)
  const [level, setLevel] = useState<CustomerLevel>(1)
  const [tags, setTags] = useState<string[]>([])
  const [address, setAddress] = useState('')
  const [notes, setNotes] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [result, setResult] = useState<{ ok: boolean; msg: string } | null>(null)

  const toggleTag = (t: string) =>
    setTags((prev) => (prev.includes(t) ? prev.filter((x) => x !== t) : [...prev, t]))

  const submit = async () => {
    if (!name.trim() || !token) return
    setSubmitting(true)
    setResult(null)
    try {
      const res = await crmApi.create(
        { name: name.trim(), phone: phone.trim() || null, gender, level, tags, address: address.trim() || null, notes: notes.trim() || null },
        token,
      )
      setResult({ ok: true, msg: '已创建' })
      router.push(`/crm/${res.data.id}`)
    } catch (e) {
      setResult({ ok: false, msg: e instanceof Error ? e.message : '创建失败' })
    } finally {
      setSubmitting(false)
    }
  }

  const inputCls = 'w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#E65C46]/40'

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      <div className="bg-white border-b px-4 py-3 flex items-center gap-3 sticky top-0 z-10">
        <button onClick={() => router.back()} className="text-gray-400 text-sm">← 返回</button>
        <h1 className="text-lg font-semibold text-gray-800">新建顾客</h1>
      </div>

      <div className="p-3 space-y-3">
        <div className="bg-white rounded-xl border border-gray-100 p-4 space-y-3">
          <div>
            <label className="text-xs text-gray-400">姓名 *</label>
            <input value={name} onChange={(e) => setName(e.target.value)} className={inputCls} placeholder="顾客姓名" />
          </div>
          <div>
            <label className="text-xs text-gray-400">手机号</label>
            <input value={phone} onChange={(e) => setPhone(e.target.value)} className={inputCls} placeholder="选填" inputMode="tel" />
          </div>
          <div className="flex gap-3">
            <div className="flex-1">
              <label className="text-xs text-gray-400">性别</label>
              <select value={gender} onChange={(e) => setGender(Number(e.target.value))} className={inputCls}>
                <option value={0}>未知</option>
                <option value={1}>男</option>
                <option value={2}>女</option>
              </select>
            </div>
            <div className="flex-1">
              <label className="text-xs text-gray-400">会员等级</label>
              <select value={level} onChange={(e) => setLevel(Number(e.target.value) as CustomerLevel)} className={inputCls}>
                <option value={1}>普通</option>
                <option value={2}>银卡</option>
                <option value={3}>金卡</option>
              </select>
            </div>
          </div>
          <div>
            <label className="text-xs text-gray-400">地址</label>
            <input value={address} onChange={(e) => setAddress(e.target.value)} className={inputCls} placeholder="选填" />
          </div>
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-4">
          <label className="text-xs text-gray-400">分群标签</label>
          <div className="flex flex-wrap gap-2 mt-2">
            {TAG_SUGGESTIONS.map((t) => (
              <button
                key={t}
                onClick={() => toggleTag(t)}
                className={`text-sm px-3 py-1.5 rounded-full border ${
                  tags.includes(t) ? 'bg-violet-50 text-violet-600 border-violet-200' : 'bg-white text-gray-500 border-gray-200'
                }`}
              >
                {t}
              </button>
            ))}
          </div>
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-4">
          <label className="text-xs text-gray-400">备注</label>
          <textarea value={notes} onChange={(e) => setNotes(e.target.value)} rows={3} className={inputCls} />
        </div>

        {result && (
          <div className={`rounded-xl px-3 py-2.5 text-sm font-medium ${result.ok ? 'bg-emerald-50 text-emerald-700' : 'bg-red-50 text-red-600'}`}>
            {result.ok ? '✅ ' : '❌ '}{result.msg}
          </div>
        )}

        <button
          onClick={submit}
          disabled={submitting || !name.trim()}
          className="w-full bg-[#E65C46] text-white py-2.5 rounded-xl text-sm font-semibold disabled:opacity-50 active:opacity-80"
        >
          {submitting ? '保存中...' : '保存顾客'}
        </button>
      </div>

      <BackToChatBar />
    </div>
  )
}
