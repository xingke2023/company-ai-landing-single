// pages/report/report.js
// 通用 web-view 容器：按 path 参数加载前端任意页面，并把小程序登录 token 通过 ?token= 传过去。
// 用法：wx.navigateTo({ url: '/pages/report/report?path=%2Finventory&title=今日库存' })
var WEB_ORIGIN = 'https://paper.xingke888.com';
var DEFAULT_PATH = '/sales-report';

Page({
  data: {
    url: '',
  },

  onLoad: function (options) {
    options = options || {};

    if (options.title) {
      wx.setNavigationBarTitle({ title: decodeURIComponent(options.title) });
    }

    // url 参数：完整外部 URL（如 app2 后台页），原样加载、不拼 token、不要求登录
    if (options.url) {
      this.setData({ url: decodeURIComponent(options.url) });
      return;
    }

    var path = options.path ? decodeURIComponent(options.path) : DEFAULT_PATH;
    if (path.charAt(0) !== '/') { path = '/' + path; }

    var app = getApp();
    // 外部行业用该行业的 apiToken + apiBase 域名；普通行业用 paper token
    var ind = app.globalData && app.globalData.industry;
    var isExternal = !!(ind && ind.apiBase);
    var token, webOrigin;
    if (isExternal) {
      token = (ind && ind.apiToken) || '';
      // apiBase 是 https://app2.xingke888.com/api，webOrigin 去掉 /api
      webOrigin = ind.apiBase.replace(/\/api\/?$/, '');
    } else {
      token = (app.globalData && app.globalData.token) || '';
      webOrigin = WEB_ORIGIN;
    }
    // 没有 token 不加载网页：退回聊天页
    if (!token) {
      wx.showToast({ title: '请先登录', icon: 'none' });
      setTimeout(function () { wx.navigateBack(); }, 600);
      return;
    }
    // _t=时间戳：防止微信 web-view 缓存旧 HTML（旧 HTML 引用旧 JS bundle → 404 → 页面卡「加载中」）
    this.setData({
      url: webOrigin + path + '?token=' + encodeURIComponent(token) + '&from=miniapp&_t=' + Date.now(),
    });
  },
});
