// pages/sales-upload/sales-upload.js
// 上传销售报表 —— 拍照/相册/文件 → AI(deepseek-4-pro) 识别 → 预览核对(可改/删) → 确认入库（今日销售补充）。
// 全程 ES5 风格（var/function，无箭头/模板串/解构），避免微信开发者工具 ES6→ES5 转译。
var api = require('../../utils/api.js');

function getWin() {
  if (wx.getWindowInfo) { return wx.getWindowInfo(); }
  if (wx.getSystemInfoSync) { return wx.getSystemInfoSync(); }
  return {};
}

// 内联 feather 线性图标（与聊天页「+」展开的拍照/相册/文件一致）
function svgIcon(svg) { return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg); }
function feather(path) {
  return svgIcon('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="#2A1F19" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' + path + '</svg>');
}
var ICONS = {
  camera: feather('<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/>'),
  album: feather('<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>'),
  file: feather('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="10" y1="9" x2="8" y2="9"/>'),
};

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

Page({
  data: {
    statusBarHeight: 20,
    stage: 'pick', // 'pick' | 'review'
    saleDate: '',
    uploadId: null,
    summary: '',
    items: [], // [{ product_name, qty, amount, unit }]（qty/amount 为字符串，供 input 绑定）
    recognizing: false,
    submitting: false,
    icons: ICONS,
  },

  onLoad: function () {
    var sys = getWin();
    this.setData({ statusBarHeight: sys.statusBarHeight || 20, saleDate: localToday() });

    var app = getApp();
    if (!app.globalData || !app.globalData.token) {
      wx.showToast({ title: '请先登录', icon: 'none' });
      setTimeout(function () { wx.navigateBack(); }, 600);
    }
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
        if (f) { self._upload(f.path, f.name); }
      },
      fail: function () { /* 取消 */ },
    });
  },

  // 上传到 /sales/upload/recognize，拿到识别明细进入预览阶段
  _upload: function (filePath, name) {
    var self = this;
    self.setData({ recognizing: true });
    wx.showLoading({ title: 'AI 识别中…', mask: true });
    api.salesUploadRecognize(filePath, { saleDate: self.data.saleDate, name: name }).then(function (res) {
      wx.hideLoading();
      self.setData({ recognizing: false });
      var raw = (res && res.items) || [];
      if (!raw.length) {
        wx.showModal({
          title: '未识别到销售数据',
          content: (res && res.summary) || '请换一张更清晰的图片，或改用 Excel 文件。',
          showCancel: false,
          confirmText: '知道了',
        });
        return;
      }
      var items = raw.map(function (it) {
        return {
          product_name: String(it.product_name || ''),
          qty: numStr(it.qty),
          amount: numStr(it.amount),
          unit: String(it.unit || ''),
        };
      });
      self.setData({
        stage: 'review',
        uploadId: res.upload_id || null,
        summary: (res && res.summary) || '',
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
    if (field !== 'product_name' && field !== 'qty' && field !== 'amount' && field !== 'unit') { return; }
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
    var items = this.data.items.concat([{ product_name: '', qty: '', amount: '', unit: '' }]);
    this.setData({ items: items });
  },

  onReUpload: function () {
    this.setData({ stage: 'pick', items: [], uploadId: null, summary: '' });
  },

  // ─── 确认入库 ────────────────────────────────────────────────────────────────
  onConfirm: function () {
    var self = this;
    if (self.data.submitting) { return; }
    if (!self.data.uploadId) { wx.showToast({ title: '请先上传识别', icon: 'none' }); return; }

    var payload = [];
    var rows = self.data.items;
    for (var i = 0; i < rows.length; i++) {
      var name = (rows[i].product_name || '').trim();
      var qty = Number(rows[i].qty);
      if (!name) { continue; }
      if (!qty || qty <= 0) {
        wx.showToast({ title: '第 ' + (i + 1) + ' 行数量无效', icon: 'none' });
        return;
      }
      payload.push({
        product_name: name,
        qty: qty,
        amount: Number(rows[i].amount) || 0,
        unit: (rows[i].unit || '').trim(),
      });
    }
    if (!payload.length) {
      wx.showToast({ title: '没有可提交的记录', icon: 'none' });
      return;
    }

    self.setData({ submitting: true });
    wx.showLoading({ title: '入库中…', mask: true });
    api.salesUploadCommit(self.data.uploadId, payload).then(function (res) {
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
