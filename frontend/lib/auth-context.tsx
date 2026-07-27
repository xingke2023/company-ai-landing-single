'use client';

import React, { createContext, useContext, useState, useEffect, useRef, useCallback } from 'react';
import { authApi } from './api';
import type { User, LoginCredentials, RegisterCredentials } from './api';

// localStorage 在部分 web-view（微信开发者工具模拟器、隐私/无痕模式）会抛错。
// 包一层保证读写永不抛错——否则一处 setItem 抛错会让整个登录流程中断（me() 没机会跑，user 永远 null）。
const safeLS = {
  get(k: string): string | null {
    try { return window.localStorage.getItem(k); } catch { return null; }
  },
  set(k: string, v: string): void {
    try { window.localStorage.setItem(k, v); } catch { /* storage 不可用，忽略 */ }
  },
  remove(k: string): void {
    try { window.localStorage.removeItem(k); } catch { /* ignore */ }
  },
};

interface AuthContextType {
  user: User | null;
  token: string | null;
  loading: boolean;
  authFailed: boolean;
  authErrorMsg: string | null;
  retry: () => Promise<void>;
  login: (credentials: LoginCredentials) => Promise<void>;
  register: (credentials: RegisterCredentials) => Promise<void>;
  logout: () => Promise<void>;
  isAuthenticated: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [authFailed, setAuthFailed] = useState(false);
  const [authErrorMsg, setAuthErrorMsg] = useState<string | null>(null);
  const urlTokenRef = useRef<string | null>(null);

  // 用 URL 携带的 token 调 /me 换取 user。关键：即使 localStorage 不可用也照常 setUser，
  // 因为 user 是 React state，本就不依赖 localStorage。
  const ingestToken = useCallback(async (t: string): Promise<boolean> => {
    safeLS.set('auth_token', t);
    try {
      const { user: meUser } = await authApi.me(t);
      setToken(t);
      setUser(meUser);
      setAuthFailed(false);
      setAuthErrorMsg(null);
      safeLS.set('auth_user', JSON.stringify(meUser));
      return true;
    } catch (e) {
      safeLS.remove('auth_token');
      setAuthFailed(true);
      setAuthErrorMsg(e instanceof Error ? e.message : String(e));
      return false;
    }
  }, []);

  useEffect(() => {
    let cancelled = false;

    const bootstrap = async () => {
      // 1) 优先处理 URL 里的 ?token=（小程序 web-view 携带登录态进入）
      let urlToken: string | null = null;
      try {
        urlToken = new URLSearchParams(window.location.search).get('token');
      } catch { urlToken = null; }

      if (urlToken) {
        urlTokenRef.current = urlToken;
        await ingestToken(urlToken);
        // 抹掉 URL 里的 token，避免泄漏到历史记录/分享链接
        try {
          const url = new URL(window.location.href);
          url.searchParams.delete('token');
          window.history.replaceState({}, '', url.pathname + url.search + url.hash);
        } catch { /* ignore */ }
        if (!cancelled) setLoading(false);
        return;
      }

      // 2) 常规：从 localStorage 恢复登录态
      const storedToken = safeLS.get('auth_token');
      const storedUser = safeLS.get('auth_user');
      if (storedToken && storedUser && !cancelled) {
        try {
          setToken(storedToken);
          setUser(JSON.parse(storedUser));
        } catch {
          safeLS.remove('auth_token');
          safeLS.remove('auth_user');
        }
      }
      if (!cancelled) setLoading(false);
    };

    bootstrap();
    return () => { cancelled = true; };
  }, [ingestToken]);

  // 报表页"加载失败"时的重试：用保存的 URL token 重新换 user（不依赖已被抹掉的 URL）
  const retry = useCallback(async () => {
    if (!urlTokenRef.current) return;
    setLoading(true);
    await ingestToken(urlTokenRef.current);
    setLoading(false);
  }, [ingestToken]);

  const login = async (credentials: LoginCredentials) => {
    const response = await authApi.login(credentials);
    const authToken = response.jwt_token || response.token;
    setToken(authToken);
    setUser(response.user);
    setAuthFailed(false);
    safeLS.set('auth_token', authToken);
    safeLS.set('auth_user', JSON.stringify(response.user));
  };

  const register = async (credentials: RegisterCredentials) => {
    const response = await authApi.register(credentials);
    const authToken = response.jwt_token || response.token;
    setToken(authToken);
    setUser(response.user);
    setAuthFailed(false);
    safeLS.set('auth_token', authToken);
    safeLS.set('auth_user', JSON.stringify(response.user));
  };

  const logout = async () => {
    if (token) {
      try {
        await authApi.logout(token);
      } catch (error) {
        console.error('Logout error:', error);
      }
    }
    setToken(null);
    setUser(null);
    safeLS.remove('auth_token');
    safeLS.remove('auth_user');
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        token,
        loading,
        authFailed,
        authErrorMsg,
        retry,
        login,
        register,
        logout,
        isAuthenticated: !!user && !!token,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
