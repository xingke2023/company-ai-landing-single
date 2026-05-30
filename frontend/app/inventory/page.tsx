'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/lib/auth-context'
import { inventoryApi, type InventoryItem, type InventoryTransaction } from '@/lib/api/inventory'
import { useMiniProgram } from '@/components/back-to-chat-bar'

export default function InventoryPage() {
  const { token, isAuthenticated, loading, retry, authErrorMsg } = useAuth()
  const router = useRouter()
  const { inMiniProgram, backToChat } = useMiniProgram()

  const [inventory, setInventory] = useState<InventoryItem[]>([])
  const [transactions, setTransactions] = useState<InventoryTransaction[]>([])
  const [activeTab, setActiveTab] = useState<'inventory' | 'transactions'>('inventory')
  const [fetching, setFetching] = useState(true)
  const [authError, setAuthError] = useState(false)

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

  useEffect(() => {
    if (!token) return

    const fetchData = async () => {
      setFetching(true)
      try {
        const [invRes, txRes] = await Promise.all([
          inventoryApi.getInventory(token),
          inventoryApi.getTransactions(token),
        ])
        setInventory(invRes.data)
        setTransactions(txRes.data)
      } catch (err) {
        console.error(err)
      } finally {
        setFetching(false)
      }
    }

    fetchData()
  }, [token])

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

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      {/* 顶部导航 */}
      <div className="bg-white border-b px-4 py-3 flex items-center justify-between sticky top-0 z-10">
        <h1 className="text-lg font-semibold text-gray-800">库存管理</h1>
        {/* 小程序内不显示跳转到其它网页的链接，统一用底部「返回聊天」 */}
        {!inMiniProgram && (
          <a href="/manage" className="text-sm text-[#941100] hover:underline font-medium">AI助手 →</a>
        )}
      </div>

      {/* Tab 切换 */}
      <div className="bg-white border-b flex">
        <button
          onClick={() => setActiveTab('inventory')}
          className={`flex-1 py-3 text-sm font-medium transition-colors ${
            activeTab === 'inventory' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'
          }`}
        >
          当前库存 ({inventory.length})
        </button>
        <button
          onClick={() => setActiveTab('transactions')}
          className={`flex-1 py-3 text-sm font-medium transition-colors ${
            activeTab === 'transactions' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'
          }`}
        >
          库存流水 ({transactions.length})
        </button>
      </div>

      <div className="p-4">
        {activeTab === 'inventory' && (
          <>
            {inventory.length === 0 ? (
              <div className="text-center py-16 text-gray-400">
                <div className="text-4xl mb-3">📦</div>
                <p>暂无库存记录</p>
                <p className="text-sm mt-1">通过 AI 助手录入进货信息</p>
                <a href="/assistant" className="mt-4 inline-block bg-blue-500 text-white px-4 py-2 rounded-lg text-sm">
                  去录入
                </a>
              </div>
            ) : (
              <div className="space-y-3">
                {inventory.map(item => (
                  <div key={item.id} className="bg-white rounded-xl shadow-sm border p-4">
                    <div className="flex items-start justify-between">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-medium text-gray-800">{item.product_name}</span>
                          {item.is_fresh && (
                            <span className="text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded">生鲜</span>
                          )}
                        </div>
                        <div className="text-xs text-gray-400 mt-1 space-x-3">
                          {item.last_in_at && <span>最近入库：{item.last_in_at}</span>}
                          {item.last_out_at && <span>最近出库：{item.last_out_at}</span>}
                        </div>
                      </div>
                      <div className="text-right">
                        <div className="text-2xl font-bold text-gray-800">
                          {item.current_qty}
                          <span className="text-sm font-normal text-gray-400 ml-1">{item.unit}</span>
                        </div>
                        {item.available_qty !== item.current_qty && (
                          <div className="text-xs text-gray-400">可用 {item.available_qty}{item.unit}</div>
                        )}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </>
        )}

        {activeTab === 'transactions' && (
          <>
            {transactions.length === 0 ? (
              <div className="text-center py-16 text-gray-400">
                <div className="text-4xl mb-3">📋</div>
                <p>暂无流水记录</p>
              </div>
            ) : (
              <div className="space-y-2">
                {transactions.map(tx => (
                  <div key={tx.id} className="bg-white rounded-xl shadow-sm border px-4 py-3 flex items-center gap-3">
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center text-white text-xs font-medium shrink-0 ${
                      tx.transaction_type === 1 || tx.transaction_type === 8 || tx.transaction_type === 6
                        ? 'bg-green-500'
                        : tx.transaction_type === 4
                        ? 'bg-yellow-500'
                        : 'bg-red-400'
                    }`}>
                      {tx.qty_change > 0 ? '+' : ''}
                      {tx.qty_change > 0 ? '入' : '出'}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2">
                        <span className="font-medium text-gray-800 truncate">{tx.product_name}</span>
                        <span className="text-xs text-gray-400 bg-gray-100 px-1.5 py-0.5 rounded shrink-0">
                          {tx.type_label}
                        </span>
                      </div>
                      <div className="text-xs text-gray-400 mt-0.5 truncate">{tx.notes}</div>
                    </div>
                    <div className="text-right shrink-0">
                      <div className={`font-semibold ${tx.qty_change > 0 ? 'text-green-600' : 'text-red-500'}`}>
                        {tx.qty_change > 0 ? '+' : ''}{tx.qty_change}{tx.unit}
                      </div>
                      <div className="text-xs text-gray-400">{tx.created_at}</div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </>
        )}
      </div>
    </div>
  )
}
