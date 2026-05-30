// app.js
App({
  globalData: {
    apiBaseUrl: 'https://paper.xingke888.com/api',
    token: '',
    user: null,
    storeId: null,
  },

  onLaunch: function () {
    try {
      var token = wx.getStorageSync('token') || '';
      // 没有 token 一律视为未登录：不恢复可能残留的 user/storeId，
      // 否则聊天页会"假登录"（显示已登录但 token 为空，导致报表/AI 页闪退）。
      this.globalData.token = token;
      this.globalData.user = token ? (wx.getStorageSync('user') || null) : null;
      this.globalData.storeId = token ? (wx.getStorageSync('storeId') || null) : null;
      if (!token) {
        try {
          wx.removeStorageSync('user');
          wx.removeStorageSync('storeId');
        } catch (e2) { /* ignore */ }
      }
    } catch (e) {
      this.globalData.token = '';
      this.globalData.user = null;
      this.globalData.storeId = null;
    }
  },
});
