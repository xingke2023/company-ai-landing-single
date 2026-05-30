// pages/damage/damage.js
// 损耗记录 —— 原生引导式录入页：连录多条 + 统一确认提交。
// 全程 ES5 风格（var/function，无箭头/模板串/解构），避免微信开发者工具 ES6→ES5 转译。
var api = require('../../utils/api.js');

// 窗口信息（自定义导航需要 statusBarHeight）
function getWin() {
  if (wx.getWindowInfo) { return wx.getWindowInfo(); }
  if (wx.getSystemInfoSync) { return wx.getSystemInfoSync(); }
  return {};
}

// 本地时间 'YYYY-MM-DD HH:mm:ss'（不能用 toISOString，UTC 会偏一天，见 CLAUDE.md）
function localNow() {
  var d = new Date();
  function p(n) { return (n < 10 ? '0' : '') + n; }
  return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate()) +
    ' ' + p(d.getHours()) + ':' + p(d.getMinutes()) + ':' + p(d.getSeconds());
}

var MAX_PHOTOS = 3;   // 每条最多 3 张（控制 base64 体积）
var MAX_DRAFTS = 20;  // 每批最多 20 条（与后端 storeBatch 校验一致）

var STATUS_LABELS = { 1: '待提交', 2: '已提交', 3: '已退款', 4: '已关闭' };

function emptyForm() {
  return { product_name: '', qty: '', reason: '变质', customReason: '', notes: '', photos: [] };
}

// 本地当天 'YYYY-MM-DD'（不能用 toISOString，UTC 会偏一天）
function localToday() {
  var d = new Date();
  function p(n) { return (n < 10 ? '0' : '') + n; }
  return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate());
}

function fmtQty(v) {
  var n = Number(v);
  if (isNaN(n)) { return String(v == null ? '' : v); }
  return (Math.round(n * 1000) / 1000).toString();
}

// 解析自然输入的「数量+单位」：'3斤'→{qty:3,unit:'斤'}  '5个'→{qty:5,unit:'个'}  '2'→{qty:2,unit:''}
function parseAmount(str) {
  str = String(str == null ? '' : str).trim();
  var m = str.match(/\d+(\.\d+)?/);
  if (!m) { return { qty: NaN, unit: str }; }
  var qty = parseFloat(m[0]);
  var unit = str.replace(m[0], '').trim();
  return { qty: qty, unit: unit };
}

// 后端图片是 /storage/... 相对路径，拼成完整 URL（apiBaseUrl 去掉结尾 /api）
function fullUrl(p) {
  if (!p) { return ''; }
  if (/^https?:\/\//.test(p)) { return p; }
  var app = getApp();
  var base = (app.globalData && app.globalData.apiBaseUrl) || '';
  return base.replace(/\/api\/?$/, '') + p;
}

Page({
  data: {
    statusBarHeight: 20,
    reasons: ['变质', '包装破损', '运输损坏', '过期', '其他'],
    form: emptyForm(),
    drafts: [],
    stage: 'edit', // 'edit' | 'confirm'
    submitting: false,

    todayRecords: [], // 今日已记录的损耗（进页/提交后拉取）
    todayLoading: true,
  },

  onLoad: function () {
    var sys = getWin();
    this.setData({ statusBarHeight: sys.statusBarHeight || 20 });

    // 未登录守卫：无 token 退回聊天页由其显示登录窗（参照 report.js）
    var app = getApp();
    if (!app.globalData || !app.globalData.token) {
      wx.showToast({ title: '请先登录', icon: 'none' });
      setTimeout(function () { wx.navigateBack(); }, 600);
      return;
    }
    this._loadToday();
  },

  // 拉取今日已记录的损耗，列在页面顶部
  _loadToday: function () {
    var self = this;
    var app = getApp();
    if (!app.globalData || !app.globalData.token) { return; }
    self.setData({ todayLoading: true });
    api.damageList(localToday()).then(function (res) {
      var list = (res && res.data) || [];
      var mapped = list.map(function (r) {
        return {
          id: r.id,
          name: (r.product && r.product.name) || r.product_name || '-',
          unit: (r.product && r.product.unit) || '',
          qty: fmtQty(r.qty),
          reason: r.reason,
          statusLabel: STATUS_LABELS[r.status] || '',
          time: r.occurred_at ? String(r.occurred_at).replace('T', ' ').slice(11, 16) : '',
          notes: r.notes || '',
          photos: (r.image_paths || []).map(fullUrl),
        };
      });
      self.setData({ todayRecords: mapped, todayLoading: false });
    }).catch(function () {
      self.setData({ todayLoading: false });
    });
  },

  onPreviewTodayPhoto: function (e) {
    var urls = e.currentTarget.dataset.urls;
    var cur = e.currentTarget.dataset.url;
    if (urls && urls.length) { wx.previewImage({ current: cur, urls: urls }); }
  },

  onBack: function () {
    wx.navigateBack();
  },

  // ─── 表单输入 ───────────────────────────────────────────────────────────────
  onProductInput: function (e) { this.setData({ 'form.product_name': e.detail.value }); },
  onQtyInput: function (e) { this.setData({ 'form.qty': e.detail.value }); },
  onNotesInput: function (e) { this.setData({ 'form.notes': e.detail.value }); },
  onCustomReasonInput: function (e) { this.setData({ 'form.customReason': e.detail.value }); },

  onPickReason: function (e) {
    var reason = e.currentTarget.dataset.reason;
    this.setData({ 'form.reason': reason });
  },

  // ─── 拍照 / 相册 → base64 ────────────────────────────────────────────────────
  onPickPhoto: function () {
    var self = this;
    var current = self.data.form.photos || [];
    var remain = MAX_PHOTOS - current.length;
    if (remain <= 0) {
      wx.showToast({ title: '最多 ' + MAX_PHOTOS + ' 张', icon: 'none' });
      return;
    }
    wx.chooseMedia({
      count: remain,
      mediaType: ['image'],
      sizeType: ['compressed'],
      sourceType: ['camera', 'album'],
      success: function (r) {
        var files = r.tempFiles || [];
        self._readFilesToBase64(files, 0, (self.data.form.photos || []).slice());
      },
      fail: function () { /* 用户取消 */ },
    });
  },

  // 递归把临时文件逐个读成 base64，读完一次性 setData（ES5 无 async）
  _readFilesToBase64: function (files, idx, acc) {
    var self = this;
    if (idx >= files.length) {
      self.setData({ 'form.photos': acc });
      return;
    }
    var f = files[idx];
    wx.getFileSystemManager().readFile({
      filePath: f.tempFilePath,
      encoding: 'base64',
      success: function (rf) {
        acc.push({ tempPath: f.tempFilePath, base64: rf.data });
      },
      fail: function () { /* 跳过这张 */ },
      complete: function () {
        self._readFilesToBase64(files, idx + 1, acc);
      },
    });
  },

  onRemovePhoto: function (e) {
    var i = e.currentTarget.dataset.index;
    var photos = (this.data.form.photos || []).slice();
    photos.splice(i, 1);
    this.setData({ 'form.photos': photos });
  },

  onPreviewPhoto: function (e) {
    var i = e.currentTarget.dataset.index;
    var photos = this.data.form.photos || [];
    var urls = photos.map(function (p) { return p.tempPath; });
    if (urls.length) { wx.previewImage({ current: urls[i], urls: urls }); }
  },

  // ─── 添加到清单 ──────────────────────────────────────────────────────────────
  _buildDraftFromForm: function () {
    var f = this.data.form;
    var name = (f.product_name || '').trim();
    if (!name) { wx.showToast({ title: '请填写商品名', icon: 'none' }); return null; }
    var parsed = parseAmount(f.qty);
    if (isNaN(parsed.qty) || parsed.qty <= 0) {
      wx.showToast({ title: '请填写数量，如 3斤 / 5个', icon: 'none' });
      return null;
    }
    var reason = f.reason === '其他' ? (f.customReason || '').trim() : f.reason;
    if (!reason) { wx.showToast({ title: '请填写损耗原因', icon: 'none' }); return null; }
    var amountText = (f.qty || '').trim() || (parsed.qty + parsed.unit);
    return {
      product_name: name,
      qty: parsed.qty,            // 纯数值，供后端扣库存
      unit: parsed.unit,          // 用户填的单位（斤/个/件…），可空
      amountText: amountText,     // 原始输入，用于显示
      reason: reason,
      notes: (f.notes || '').trim(),
      photos: (f.photos || []).slice(),
      occurred_at: localNow(),
    };
  },

  onAddDraft: function () {
    if (this.data.drafts.length >= MAX_DRAFTS) {
      wx.showToast({ title: '最多一次录 ' + MAX_DRAFTS + ' 条', icon: 'none' });
      return;
    }
    var draft = this._buildDraftFromForm();
    if (!draft) { return; }
    var drafts = this.data.drafts.concat([draft]);
    this.setData({ drafts: drafts, form: emptyForm() });
    wx.showToast({ title: '已添加', icon: 'success' });
  },

  onRemoveDraft: function (e) {
    var i = e.currentTarget.dataset.index;
    var drafts = this.data.drafts.slice();
    drafts.splice(i, 1);
    this.setData({ drafts: drafts });
  },

  // 把某条草稿拉回表单继续编辑（同时从清单移除）
  onEditDraft: function (e) {
    var i = e.currentTarget.dataset.index;
    var drafts = this.data.drafts.slice();
    var d = drafts[i];
    if (!d) { return; }
    drafts.splice(i, 1);
    var isPreset = this.data.reasons.indexOf(d.reason) >= 0 && d.reason !== '其他';
    this.setData({
      drafts: drafts,
      form: {
        product_name: d.product_name,
        qty: d.amountText || String(d.qty),
        reason: isPreset ? d.reason : '其他',
        customReason: isPreset ? '' : d.reason,
        notes: d.notes || '',
        photos: (d.photos || []).slice(),
      },
    });
  },

  // ─── 确认 / 提交 ─────────────────────────────────────────────────────────────
  // 去确认：若表单还填着一条未添加，先自动收进清单
  onGoConfirm: function () {
    var drafts = this.data.drafts;
    var f = this.data.form;
    if ((f.product_name || '').trim() || f.qty) {
      var draft = this._buildDraftFromForm();
      if (!draft) { return; } // 填了一半 → 校验拦截
      drafts = drafts.concat([draft]);
      this.setData({ drafts: drafts, form: emptyForm() });
    }
    if (!drafts.length) {
      wx.showToast({ title: '请先添加损耗记录', icon: 'none' });
      return;
    }
    this.setData({ stage: 'confirm' });
  },

  onBackToEdit: function () {
    this.setData({ stage: 'edit' });
  },

  onSubmit: function () {
    var self = this;
    if (self.data.submitting) { return; }
    var drafts = self.data.drafts;
    if (!drafts.length) { return; }

    var items = drafts.map(function (d) {
      var item = {
        product_name: d.product_name,
        qty: d.qty,
        reason: d.reason,
        occurred_at: d.occurred_at,
      };
      if (d.unit) { item.unit = d.unit; }
      if (d.notes) { item.notes = d.notes; }
      var imgs = (d.photos || []).map(function (p) { return p.base64; });
      if (imgs.length) { item.image_base64 = imgs; }
      return item;
    });

    self.setData({ submitting: true });
    wx.showLoading({ title: '提交中…', mask: true });

    api.damageBatch(items).then(function (res) {
      wx.hideLoading();
      self.setData({ submitting: false });
      var success = (res && res.success) || 0;
      var failed = (res && res.failed) || 0;
      if (failed > 0) {
        wx.showModal({
          title: '部分提交成功',
          content: '成功 ' + success + ' 条，失败 ' + failed + ' 条。失败的请返回重试。',
          showCancel: false,
          confirmText: '知道了',
          success: function () {
            if (success > 0) { self._finishSubmit(success); }
          },
        });
        return;
      }
      self._finishSubmit(success);
    }).catch(function (err) {
      wx.hideLoading();
      self.setData({ submitting: false });
      var msg = (err && err.message) || '提交失败';
      if (msg === 'Unauthenticated') {
        wx.showToast({ title: '登录已失效，请重新登录', icon: 'none' });
        setTimeout(function () { wx.navigateBack(); }, 800);
        return;
      }
      wx.showToast({ title: msg, icon: 'none' });
    });
  },

  // 提交成功：清空草稿/表单、回到录入态、刷新今日已记录列表（让用户立刻看到新增）
  _finishSubmit: function (success) {
    wx.showToast({ title: '已登记 ' + success + ' 条损耗', icon: 'success' });
    this.setData({ drafts: [], form: emptyForm(), stage: 'edit' });
    this._loadToday();
  },

  noop: function () {},
});
