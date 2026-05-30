// utils/request.js
// wx.request 封装：自动注入 Authorization。
// 用 Promise 链而非 async/await，避免触发微信开发者工具的 @babel/runtime 转译路径。

function callBackend(path, options) {
  return new Promise(function (resolve, reject) {
    var app = getApp();
    var base = app.globalData.apiBaseUrl;
    var token = app.globalData.token || '';
    var headers = Object.assign(
      { 'Content-Type': 'application/json', Accept: 'application/json' },
      token ? { Authorization: 'Bearer ' + token } : {},
      options.header || {}
    );

    wx.request({
      url: base + path,
      method: options.method || 'GET',
      data: options.data || {},
      header: headers,
      timeout: options.timeout || 60000,
      success: function (res) { resolve(res); },
      fail: function (err) { reject(err); },
    });
  });
}

/**
 * 账号密码登录 —— 舌尖后端 POST /login
 * body: { login: 用户名或邮箱, password }
 * 成功返回 { token, jwt_token, store_id, user }
 */
function login(username, password, storeId) {
  var body = { login: username, password: password };
  if (storeId) { body.store_id = storeId; }
  return callBackend('/login', {
    method: 'POST',
    data: body,
  }).then(function (res) {
    if (res.statusCode === 200 && res.data && (res.data.jwt_token || res.data.token)) {
      var app = getApp();
      // 用 JWT（无状态）而非 Sanctum opaque token：后端 auth.hybrid 对 JWT 走独立路径，
      // 不经会话 guard，避免 web-view 携带 cookie 触发 TransientToken（缺 abilities）500。
      var authToken = res.data.jwt_token || res.data.token;
      app.globalData.token = authToken;
      app.globalData.user = res.data.user;
      app.globalData.storeId = res.data.store_id;
      try {
        wx.setStorageSync('token', authToken);
        wx.setStorageSync('user', res.data.user);
        wx.setStorageSync('storeId', res.data.store_id);
      } catch (e) { /* ignore */ }
      return res.data;
    }
    // 多门店账号：后端返回 422 + stores 列表 → 抛出带 stores 的错误，由 UI 弹门店选择
    if (res.statusCode === 422 && res.data && res.data.stores && res.data.stores.length) {
      var multiErr = new Error(res.data.message || '该账号属于多个门店，请选择门店');
      multiErr.multiStore = true;
      multiErr.stores = res.data.stores;
      throw multiErr;
    }
    var msg = (res.data && (res.data.message || res.data.detail)) || ('HTTP ' + res.statusCode);
    throw new Error(msg);
  });
}

function clearAuth() {
  var app = getApp();
  app.globalData.token = '';
  app.globalData.user = null;
  app.globalData.storeId = null;
  try {
    wx.removeStorageSync('token');
    wx.removeStorageSync('user');
    wx.removeStorageSync('storeId');
  } catch (e) { /* ignore */ }
}

function request(path, options) {
  options = options || {};
  return callBackend(path, options).then(function (res) {
    if (res.statusCode === 401) {
      // 没有保存密码，无法静默重登，清空登录态让页面回到登录表单
      clearAuth();
      throw new Error('Unauthenticated');
    }
    if (res.statusCode < 200 || res.statusCode >= 300) {
      var msg = (res.data && (res.data.message || res.data.detail)) || ('HTTP ' + res.statusCode);
      throw new Error(msg);
    }
    return res.data;
  });
}

module.exports = { request: request, login: login, clearAuth: clearAuth };
