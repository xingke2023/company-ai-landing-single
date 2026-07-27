import { apiClient } from './client';
import type { AuthResponse, LoginCredentials, RegisterCredentials, User } from './types';

export const authApi = {
  // SSO 注册（后端桥接外部 Auth Center 建号，成功后自动登录）
  register: (data: RegisterCredentials) =>
    apiClient.post<AuthResponse>('/auth/sso/register', {
      username: data.username,
      password: data.password,
      name: data.name,
      email: data.email,
    }),

  // SSO 单点登录（后端桥接外部 Auth Center）；LoginCredentials.login 映射为 SSO 的 identifier 字段
  login: (data: LoginCredentials) =>
    apiClient.post<AuthResponse>('/auth/sso/login', { identifier: data.login, password: data.password }),

  logout: (token: string) =>
    apiClient.post<{ message: string }>('/logout', undefined, token),

  me: (token: string) =>
    apiClient.get<{ user: User }>('/me', token),
};
