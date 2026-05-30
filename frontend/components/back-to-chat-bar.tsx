'use client'

import { useEffect, useState } from 'react'
import Script from 'next/script'

/**
 * 退回小程序聊天页（pages/chat/chat）。
 * 依赖微信 JSSDK（jweixin）已加载；navigateBack 不可用时退回 reLaunch。
 * 做了 1.5s 去抖：避免「导航栏图标点击」和「未登录重定向」同时触发导致多次 navigateBack（多退一页）。
 */
let lastBackAt = 0
export function backToChat() {
  const now = Date.now()
  if (now - lastBackAt < 1500) return
  lastBackAt = now
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const mp = (window as any).wx?.miniProgram
  if (mp?.navigateBack) {
    mp.navigateBack()
  } else if (mp?.reLaunch) {
    mp.reLaunch({ url: '/pages/chat/chat' })
  }
}

/** 是否运行在小程序 web-view 内：优先用小程序传入的 ?from=miniapp，UA 作兜底 */
function detectMiniProgram(): boolean {
  if (typeof window === 'undefined') return false
  const fromMini = new URLSearchParams(window.location.search).get('from') === 'miniapp'
  const uaMini = /miniProgram/i.test(navigator.userAgent)
  return fromMini || uaMini
}

/**
 * 供页面复用：返回 { inMiniProgram, backToChat }。
 * 页面可用 inMiniProgram 决定顶部返回按钮行为、未登录时是否退回聊天页等。
 */
export function useMiniProgram() {
  const [inMiniProgram, setInMiniProgram] = useState(false)
  useEffect(() => {
    if (detectMiniProgram()) setInMiniProgram(true)
  }, [])
  return { inMiniProgram, backToChat }
}

/**
 * 可复用的「返回聊天」底部栏 —— 所有在小程序 web-view 内展示的页面都放它。
 * 仅在小程序环境内渲染；普通浏览器返回 null。
 */
export function BackToChatBar() {
  const { inMiniProgram } = useMiniProgram()
  if (!inMiniProgram) return null
  return (
    <>
      <Script src="https://res.wx.qq.com/open/js/jweixin-1.6.0.js" strategy="afterInteractive" />
      <div className="fixed bottom-0 inset-x-0 z-50 flex justify-center px-4 pt-3 pb-[calc(env(safe-area-inset-bottom)+12px)] bg-gradient-to-t from-white via-white/90 to-transparent pointer-events-none">
        <button
          onClick={backToChat}
          className="pointer-events-auto bg-[#E65C46] text-white text-sm font-semibold px-8 py-3 rounded-full shadow-lg active:opacity-80"
        >
          ← 返回聊天
        </button>
      </div>
    </>
  )
}
