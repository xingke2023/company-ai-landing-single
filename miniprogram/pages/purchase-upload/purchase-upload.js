// pages/purchase-upload/purchase-upload.js
// 上传进货单 —— 拍照/相册/文件 → AI 识别 → 预览核对(改/删) → 确认入库（自动收货、加库存）。
// 全程 ES5 风格（var/function，无箭头/模板串/解构）。
var api = require('../../utils/api.js');

function getWin() {
  if (wx.getWindowInfo) { return wx.getWindowInfo(); }
  if (wx.getSystemInfoSync) { return wx.getSystemInfoSync(); }
  return {};
}

function localToday() {
  var d = new Date();
  function p(n) { return (n < 10 ? '0' : '') + n; }
  return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate());
}

function numStr(v) {
  if (v == null) { return ''; }
  var n = Number(v);
  if (isNaN(n)) { return String(v); }
  return (Math.round(n * 1000) / 1000).toString();
}

// 内联 feather 图标（与聊天页「+」展开的拍照/相册/文件一致）
function svgIcon(svg) { return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg); }
function feather(path) {
  return svgIcon('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#2A1F19" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' + path + '</svg>');
}
var ICONS = {
  camera: feather('<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/>'),
  album: feather('<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>'),
  file: feather('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="10" y1="9" x2="8" y2="9"/>'),
};

Page({
  data: {
    statusBarHeight: 20,
    stage: 'pick', // 'pick' | 'review'
    purchaseDate: '',
    today: '',
    storeName: '',
    operatorName: '',
    summary: '',
    imagePaths: [],       // 识别接口返回的单据图 /storage URL，入库时回传
    items: [],            // [{ product_name, ordered_qty, unit_price, unit }]（数值为字符串供 input 绑定）
    recognizing: false,
    submitting: false,
    icons: ICONS,
  },

  onLoad: function () {
    var sys = getWin();
    var t = localToday();
    this.setData({ statusBarHeight: sys.statusBarHeight || 20, purchaseDate: t, today: t });

    var app = getApp();
    if (!app.globalData || !app.globalData.token) {
      wx.showToast({ title: '请先登录', icon: 'none' });
      setTimeout(function () { wx.navigateBack(); }, 600);
      return;
    }
    this._loadStoreName();
  },

  // 门店名 + 操作人：优先用登录缓存的 user，没有 store_name 则调 /me 拉取
  _loadStoreName: function () {
    var self = this;
    var app = getApp();
    var u = app.globalData.user || {};
    self.setData({ operatorName: u.name || '', storeName: u.store_name || '' });
    if (u.store_name) { return; }
    api.me().then(function (res) {
      var user = (res && res.user) || {};
      self.setData({ storeName: user.store_name || '', operatorName: user.name || self.data.operatorName });
      // 回写缓存，供其它页复用
      if (user.store_name) {
        app.globalData.user = user;
        try { wx.setStorageSync('user', user); } catch (e) { /* ignore */ }
      }
    }).catch(function () { /* 忽略 */ });
  },

  onDateChange: function (e) {
    this.setData({ purchaseDate: e.detail.value });
  },

  onBack: function () { wx.navigateBack(); },

  // ─── 三种上传入口 ────────────────────────────────────────────────────────────
  onCamera: function () { this._chooseImage('camera'); },
  onAlbum: function () { this._chooseImage('album'); },

  _chooseImage: function (src) {
    var self = this;
    if (self.data.recognizing) { return; }
    wx.chooseMedia({
      count: 1,
      mediaType: ['image'],
      sizeType: ['compressed'],
      sourceType: [src],
      success: function (r) {
        var f = r.tempFiles && r.tempFiles[0];
        if (f) { self._upload(f.tempFilePath); }
      },
      fail: function () { /* 取消 */ },
    });
  },

  onFile: function () {
    var self = this;
    if (self.data.recognizing) { return; }
    wx.chooseMessageFile({
      count: 1,
      type: 'file',
      extension: ['xlsx', 'xls', 'csv'],
      success: function (r) {
        var f = r.tempFiles && r.tempFiles[0];
        if (f) { self._upload(f.path); }
      },
      fail: function () { /* 取消 */ },
    });
  },

  _upload: function (filePath) {
    var self = this;
    self.setData({ recognizing: true });
    wx.showLoading({ title: 'AI 识别中…', mask: true });
    api.purchaseRecognize(filePath).then(function (res) {
      wx.hideLoading();
      self.setData({ recognizing: false });
      var raw = (res && res.items) || [];
      if (!raw.length) {
        wx.showModal({
          title: '未识别到进货数据',
          content: (res && res.summary) || '请换一张更清晰的图片，或改用 Excel 文件。',
          showCancel: false,
          confirmText: '知道了',
        });
        return;
      }
      var items = raw.map(function (it) {
        return {
          product_name: String(it.product_name || ''),
          ordered_qty: numStr(it.ordered_qty),
          unit_price: numStr(it.unit_price),
          unit: String(it.unit || ''),
        };
      });
      self.setData({
        stage: 'review',
        summary: (res && res.summary) || '',
        imagePaths: (res && res.image_paths) || [],
        items: items,
      });
    }).catch(function (err) {
      wx.hideLoading();
      self.setData({ recognizing: false });
      var msg = (err && err.message) || '识别失败';
      if (msg === 'Unauthenticated') {
        wx.showToast({ title: '登录已失效，请重新登录', icon: 'none' });
        setTimeout(function () { wx.navigateBack(); }, 800);
        return;
      }
      wx.showToast({ title: msg, icon: 'none' });
    });
  },

  // ─── 预览编辑 ────────────────────────────────────────────────────────────────
  onItemInput: function (e) {
    var i = e.currentTarget.dataset.index;
    var field = e.currentTarget.dataset.field;
    if (field !== 'product_name' && field !== 'ordered_qty' && field !== 'unit_price' && field !== 'unit') { return; }
    var patch = {};
    patch['items[' + i + '].' + field] = e.detail.value;
    this.setData(patch);
  },

  onRemoveItem: function (e) {
    var i = e.currentTarget.dataset.index;
    var items = this.data.items.slice();
    items.splice(i, 1);
    this.setData({ items: items });
  },

  onAddRow: function () {
    var items = this.data.items.concat([{ product_name: '', ordered_qty: '', unit_price: '', unit: '' }]);
    this.setData({ items: items });
  },

  onReUpload: function () {
    this.setData({ stage: 'pick', items: [], summary: '', imagePaths: [] });
  },

  // ─── 确认入库 ────────────────────────────────────────────────────────────────
  onConfirm: function () {
    var self = this;
    if (self.data.submitting) { return; }

    var payload = [];
    var rows = self.data.items;
    for (var i = 0; i < rows.length; i++) {
      var name = (rows[i].product_name || '').trim();
      var qty = Number(rows[i].ordered_qty);
      if (!name) { continue; }
      if (!qty || qty <= 0) {
        wx.showToast({ title: '第 ' + (i + 1) + ' 行数量无效', icon: 'none' });
        return;
      }
      payload.push({
        product_name: name,
        ordered_qty: qty,
        unit_price: Number(rows[i].unit_price) || 0,
        unit: (rows[i].unit || '').trim(),
      });
    }
    if (!payload.length) {
      wx.showToast({ title: '没有可提交的记录', icon: 'none' });
      return;
    }

    self.setData({ submitting: true });
    wx.showLoading({ title: '入库中…', mask: true });
    api.purchaseCommit({
      date: self.data.purchaseDate,
      items: payload,
      image_paths: self.data.imagePaths,
    }).then(function (res) {
      wx.hideLoading();
      self.setData({ submitting: false });
      wx.showToast({ title: (res && res.message) || '已入库', icon: 'success' });
      setTimeout(function () { wx.navigateBack(); }, 1200);
    }).catch(function (err) {
      wx.hideLoading();
      self.setData({ submitting: false });
      var msg = (err && err.message) || '入库失败';
      if (msg === 'Unauthenticated') {
        wx.showToast({ title: '登录已失效，请重新登录', icon: 'none' });
        setTimeout(function () { wx.navigateBack(); }, 800);
        return;
      }
      wx.showToast({ title: msg, icon: 'none' });
    });
  },

  noop: function () {},
});
