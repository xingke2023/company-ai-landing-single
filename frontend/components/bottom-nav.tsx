'use client'

import Link from 'next/link'
import Script from 'next/script'
import { usePathname } from 'next/navigation'
import { useEffect, useState } from 'react'
import { Home, MessageCircle, BarChart3 } from 'lucide-react'
import { backToChat } from '@/components/back-to-chat-bar'

const NAV_ITEMS = [
  { label: '首页', path: '/', icon: Home },
  { label: 'AI助手', path: '/manage', icon: MessageCircle, primary: true },
  { label: '报表', path: '/sales-report', icon: BarChart3 },
]

// Pages with their own bottom input bar — hide the global nav
const HIDDEN_PATHS = ['/manage', '/assistant', '/login', '/register']

export function BottomNav() {
  const pathname = usePathname()
  const [inMiniProgram, setInMiniProgram] = useState(false)

  // 在微信小程序 web-view 内时，中间的聊天图标改为返回小程序聊天页
  useEffect(() => {
    if (typeof window === 'undefined') return
    const fromMini = new URLSearchParams(window.location.search).get('from') === 'miniapp'
    const uaMini = /miniProgram/i.test(navigator.userAgent)
    if (fromMini || uaMini) setInMiniProgram(true)
  }, [])

  if (HIDDEN_PATHS.includes(pathname)) return null

  return (
    <>
      {/* 小程序 web-view 内加载微信 JSSDK，供中间聊天图标 navigateBack 返回小程序聊天页 */}
      {inMiniProgram && (
        <Script src="https://res.wx.qq.com/open/js/jweixin-1.6.0.js" strategy="afterInteractive" />
      )}
    <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 z-50">
      <div className="flex items-center justify-around h-16 max-w-2xl mx-auto">
        {NAV_ITEMS.map((item) => {
          const isActive = pathname === item.path
          const Icon = item.icon

          if (item.primary) {
            const circle = (
              // 用内联 linear-gradient（而非 Tailwind v4 的 bg-gradient，后者用 `in oklab`
              // + @property，微信 web-view 老内核不支持 → 渐变失效变白、白图标隐形）
              <div
                className="w-14 h-14 rounded-full shadow-lg flex items-center justify-center"
                style={{ backgroundImage: 'linear-gradient(135deg, #941100, #FF9300)' }}
              >
                <Icon size={28} color="#ffffff" strokeWidth={2.2} />
              </div>
            )
            // 小程序 web-view 内：点中间聊天图标返回 pages/chat/chat（不做网页跳转）
            if (inMiniProgram) {
              return (
                <button
                  key={item.path}
                  onClick={backToChat}
                  className="flex flex-col items-center justify-center -mt-8"
                  aria-label="返回聊天"
                >
                  {circle}
                </button>
              )
            }
            return (
              <Link
                key={item.path}
                href={item.path}
                className="flex flex-col items-center justify-center -mt-8"
              >
                {circle}
              </Link>
            )
          }

          return (
            <Link
              key={item.path}
              href={item.path}
              className={`flex flex-col items-center justify-center gap-1 px-4 py-2 transition-colors ${
                isActive ? 'text-[#941100]' : 'text-gray-400'
              }`}
            >
              <Icon className="w-6 h-6" />
              <span className="text-xs">{item.label}</span>
            </Link>
          )
        })}
      </div>
    </nav>
    </>
  )
}
