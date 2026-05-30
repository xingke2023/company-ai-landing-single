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
    var path = options.path ? decodeURIComponent(options.path) : DEFAULT_PATH;
    if (path.charAt(0) !== '/') { path = '/' + path; }

    if (options.title) {
      wx.setNavigationBarTitle({ title: decodeURIComponent(options.title) });
    }

    var app = getApp();
    var token = (app.globalData && app.globalData.token) || '';
    // 没有 token 不加载网页：退回聊天页，由聊天页显示登录窗口（避免“闪退”体验）。
    if (!token) {
      wx.showToast({ title: '请先登录', icon: 'none' });
      setTimeout(function () { wx.navigateBack(); }, 600);
      return;
    }
    this.setData({
      url: WEB_ORIGIN + path + '?token=' + encodeURIComponent(token) + '&from=miniapp',
    });
  },
});
