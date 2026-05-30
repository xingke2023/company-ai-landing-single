'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { useMiniProgram } from '@/components/back-to-chat-bar'

// 角色 code → 中文
const ROLE_LABELS: Record<string, string> = {
  SUPER_ADMIN: '超级管理员',
  ADMIN: '管理员',
  STORE_MANAGER: '店长',
  STORE_STAFF: '店员',
  CASHIER: '收银员',
}

// 常用功能入口。href 指向 web 页（站内导航）；action 触发特殊行为（回聊天等）
type Fn = { label: string; emoji: string; desc: string; href?: string; action?: 'chat'; bg: string }
const FUNCTIONS: Fn[] = [
  { label: '今日库存', emoji: '📦', desc: '当前库存 / 流水', href: '/inventory', bg: 'bg-emerald-50' },
  { label: '销售报表', emoji: '📊', desc: '每日销售明细', href: '/sales-report', bg: 'bg-orange-50' },
  { label: '问 AI 助手', emoji: '💬', desc: '进货/损耗/建议/天气', action: 'chat', bg: 'bg-violet-50' },
]

export default function HubPage() {
  const { user, token, isAuthenticated, loading, retry, authErrorMsg, logout } = useAuth()
  const router = useRouter()
  const { inMiniProgram, backToChat } = useMiniProgram()
  const [authError, setAuthError] = useState(false)

  useEffect(() => {
    if (loading || isAuthenticated) return
    if (inMiniProgram) {
      setAuthError(true)
    } else {
      router.push('/login')
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [loading, isAuthenticated, inMiniProgram, router])

  // 站内跳转时带上 from=miniapp，保证目标页仍识别为小程序 web-view
  const withMp = (href: string) => (inMiniProgram ? `${href}?from=miniapp` : href)

  const onLogout = async () => {
    await logout()
    if (inMiniProgram) backToChat()
    else router.push('/login')
  }

  if (authError && !isAuthenticated) {
    return (
      <div className="flex flex-col items-center justify-center h-screen gap-4 px-8 text-center">
        <p className="text-gray-500">登录态加载失败，请重试</p>
        {authErrorMsg && <p className="text-xs text-gray-400 break-all max-w-xs">原因：{authErrorMsg}</p>}
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

  // 内容只在拿到用户信息后渲染，避免出现"空信息"的一闪
  if (loading || !isAuthenticated || !user) {
    return <div className="flex items-center justify-center h-screen text-gray-400">加载中...</div>
  }

  const roleLabels = (user.roles ?? []).map(r => ROLE_LABELS[r] ?? r)
  const infoRows: { label: string; value?: string | null }[] = [
    { label: '账号', value: user.username ? '@' + user.username : null },
    { label: '邮箱', value: user.email },
    { label: '身份', value: user.is_admin ? '管理员' : '门店员工' },
    { label: '门店', value: user.store_name ? `${user.store_name}（#${user.store_id}）` : null },
    { label: '地址', value: user.store_address },
  ]

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* 用户头部 */}
      <div className="bg-gradient-to-br from-[#E65C46] to-[#c9402a] px-3.5 pt-4 pb-4 text-white">
        <div className="flex items-center gap-2.5">
          <div className="w-12 h-12 rounded-full bg-white/20 border border-white/40 flex items-center justify-center text-xl font-bold shrink-0">
            {user.name.slice(0, 1)}
          </div>
          <div className="min-w-0 flex-1">
            <div className="text-base font-bold truncate">{user.name}</div>
            <div className="flex items-center gap-1.5 flex-wrap mt-1">
              {roleLabels.length > 0 ? roleLabels.map(r => (
                <span key={r} className="text-[10px] bg-white/20 rounded px-1.5 py-0.5">{r}</span>
              )) : (
                <span className="text-[10px] bg-white/20 rounded px-1.5 py-0.5">{user.is_admin ? '管理员' : '门店员工'}</span>
              )}
            </div>
          </div>
        </div>
      </div>

      <div className="p-3">
        {/* 账户信息 */}
        <div className="bg-white rounded-xl border border-gray-100 divide-y divide-gray-50 mb-3">
          {infoRows.filter(r => r.value).map(r => (
            <div key={r.label} className="flex items-center justify-between px-3.5 py-2.5 text-sm">
              <span className="text-gray-400 shrink-0">{r.label}</span>
              <span className="text-gray-800 text-right truncate ml-3">{r.value}</span>
            </div>
          ))}
        </div>

        <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2 px-0.5">常用功能</p>
        <div className="flex flex-wrap gap-2">
          {FUNCTIONS.map(fn => {
            const chip = (
              <span className="inline-flex items-center gap-1.5 bg-white border border-gray-200 rounded-full px-3 py-1.5 text-sm text-gray-700 active:bg-gray-50">
                <span className="text-base leading-none">{fn.emoji}</span>
                {fn.label}
              </span>
            )
            if (fn.href) {
              return <Link key={fn.label} href={withMp(fn.href)}>{chip}</Link>
            }
            return (
              <button key={fn.label} onClick={() => { if (inMiniProgram) backToChat() }}>{chip}</button>
            )
          })}

          {/* 后台管理：仅管理员可见。走 /admin/sso?token= 用 JWT 免登录进 Filament（绕过 web-view 里
              会一直转圈的 Livewire 登录表单）。整页跳转 <a>，因为 /admin 是 Laravel 而非 Next 路由。 */}
          {user.is_admin && token && (
            <a
              href={`/admin/sso?token=${encodeURIComponent(token)}`}
              className="inline-flex items-center gap-1.5 bg-white border border-gray-200 rounded-full px-3 py-1.5 text-sm text-gray-700 active:bg-gray-50"
            >
              <span className="text-base leading-none">🛠️</span>
              后台管理
            </a>
          )}
        </div>

        {/* 账号 */}
        <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mt-4 mb-2 px-0.5">账号</p>
        <button
          onClick={onLogout}
          className="inline-flex items-center gap-1.5 bg-white border border-gray-200 rounded-full px-3 py-1.5 text-sm text-red-500 active:bg-gray-50"
        >
          ⏏️ 退出登录
        </button>
      </div>
    </div>
  )
}
