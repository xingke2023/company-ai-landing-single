// pages/purchase-orders/purchase-orders.js
// 历史进货单记录 —— 列出历史上传/录入的进货单（含原始单据图 + 明细）。ES5 风格。
var api = require('../../utils/api.js');

function getWin() {
  if (wx.getWindowInfo) { return wx.getWindowInfo(); }
  if (wx.getSystemInfoSync) { return wx.getSystemInfoSync(); }
  return {};
}

function fmtNum(v) {
  var n = Number(v);
  if (isNaN(n)) { return String(v == null ? '' : v); }
  return (Math.round(n * 1000) / 1000).toString();
}

function fullUrl(p) {
  if (!p) { return ''; }
  if (/^https?:\/\//.test(p)) { return p; }
  var app = getApp();
  var base = (app.globalData && app.globalData.apiBaseUrl) || '';
  return base.replace(/\/api\/?$/, '') + p;
}

var IMG_RE = /\.(jpg|jpeg|png|webp|gif)$/i;
function fileExt(p) {
  var m = String(p || '').match(/\.([a-z0-9]+)$/i);
  return m ? m[1].toLowerCase() : '';
}

var WEEK_LABELS = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
function p2(n) { return (n < 10 ? '0' : '') + n; }
function dateStr(d) { return d.getFullYear() + '-' + p2(d.getMonth() + 1) + '-' + p2(d.getDate()); }
function localToday() { return dateStr(new Date()); }
function dateByOffset(n) {
  var d = new Date();
  d.setDate(d.getDate() + n);
  return dateStr(d);
}

// 本周一→周日（周一为首），future 的天不可选
function getWeekDays() {
  var now = new Date();
  var day = now.getDay();
  var offset = day === 0 ? -6 : 1 - day;
  var monday = new Date(now);
  monday.setDate(now.getDate() + offset);
  var today = dateStr(now);
  var arr = [];
  for (var i = 0; i < 7; i++) {
    var d = new Date(monday);
    d.setDate(monday.getDate() + i);
    var ds = dateStr(d);
    arr.push({ label: WEEK_LABELS[i], date: ds, dayNum: d.getDate(), isFuture: ds > today, isToday: ds === today });
  }
  return arr;
}

Page({
  data: {
    statusBarHeight: 20,
    orders: [],
    loading: true,
    txDate: '',
    today: '',
    yesterday: '',
    dayBefore2: '',
    weekDays: [],
  },

  onLoad: function () {
    var sys = getWin();
    var t = localToday();
    this.setData({
      statusBarHeight: sys.statusBarHeight || 20,
      txDate: t, today: t, yesterday: dateByOffset(-1), dayBefore2: dateByOffset(-2),
      weekDays: getWeekDays(),
    });

    var app = getApp();
    if (!app.globalData || !app.globalData.token) {
      wx.showToast({ title: '请先登录', icon: 'none' });
      setTimeout(function () { wx.navigateBack(); }, 600);
      return;
    }
    this._load();
  },

  onBack: function () { wx.navigateBack(); },

  onPickDay: function (e) {
    if (e.currentTarget.dataset.future) { return; }
    var d = e.currentTarget.dataset.date;
    if (d && d !== this.data.txDate) { this.setData({ txDate: d }); this._load(); }
  },

  onDateChange: function (e) {
    this.setData({ txDate: e.detail.value });
    this._load();
  },

  // 折叠/展开某一单
  onToggle: function (e) {
    var i = e.currentTarget.dataset.index;
    var key = 'orders[' + i + '].expanded';
    var patch = {};
    patch[key] = !this.data.orders[i].expanded;
    this.setData(patch);
  },

  _load: function () {
    var self = this;
    self.setData({ loading: true });
    api.purchaseList({ date: self.data.txDate }).then(function (res) {
      var list = (res && res.data) || [];
      var orders = list.map(function (o, idx) {
        var items = (o.items || []).map(function (it) {
          return {
            name: (it.product && it.product.name) || it.product_name || '-',
            qty: fmtNum(it.ordered_qty),
            unit: (it.product && it.product.unit) || '',
            price: it.unit_price ? fmtNum(it.unit_price) : '',
          };
        });
        // 原始单据：图片 → 缩略图预览；其它(Excel/CSV) → 文件，可下载/打开
        var photos = [];
        var files = [];
        (o.image_paths || []).forEach(function (p) {
          var url = fullUrl(p);
          if (IMG_RE.test(p)) {
            photos.push(url);
          } else {
            files.push({ url: url, name: String(p).split('/').pop(), ext: fileExt(p) });
          }
        });
        return {
          id: o.id,
          order_no: o.order_no,
          date: o.actual_delivery_date ? String(o.actual_delivery_date).slice(0, 10) : '',
          supplier: (o.supplier && o.supplier.name) || '',
          total: o.total_amount ? fmtNum(o.total_amount) : '0',
          skuCount: items.length,
          items: items,
          photos: photos,
          files: files,
          expanded: idx === 0, // 只展开最近一单，其余折叠
        };
      });
      self.setData({ orders: orders, loading: false });
    }).catch(function (err) {
      self.setData({ loading: false });
      var msg = (err && err.message) || '';
      if (msg === 'Unauthenticated') {
        wx.showToast({ title: '登录已失效，请重新登录', icon: 'none' });
        setTimeout(function () { wx.navigateBack(); }, 800);
      }
    });
  },

  onPreviewPhoto: function (e) {
    var urls = e.currentTarget.dataset.urls;
    var cur = e.currentTarget.dataset.url;
    if (urls && urls.length) { wx.previewImage({ current: cur, urls: urls }); }
  },

  // 下载并打开原始文件（Excel/CSV 等）
  onOpenFile: function (e) {
    var url = e.currentTarget.dataset.url;
    var ext = e.currentTarget.dataset.ext || '';
    if (!url) { return; }
    wx.showLoading({ title: '下载中…', mask: true });
    wx.downloadFile({
      url: url,
      success: function (res) {
        wx.hideLoading();
        if (res.statusCode !== 200 || !res.tempFilePath) {
          wx.showToast({ title: '下载失败', icon: 'none' });
          return;
        }
        wx.openDocument({
          filePath: res.tempFilePath,
          fileType: ext || undefined,
          showMenu: true,
          fail: function () { wx.showToast({ title: '该文件暂不支持预览', icon: 'none' }); },
        });
      },
      fail: function () {
        wx.hideLoading();
        wx.showToast({ title: '下载失败', icon: 'none' });
      },
    });
  },
});
