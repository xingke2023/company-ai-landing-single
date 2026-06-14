// pages/industry/industry.js
// 启动「选择行业」页 —— 每次进入小程序先选行业，再进聊天页加载该行业菜单。
// 全程 ES5 风格（var/function，无箭头/模板串/解构），避免微信开发者工具 ES6→ES5 转译。
var api = require('../../utils/api.js');

// 窗口信息（自定义导航需要 statusBarHeight）
function getWin() {
  if (wx.getWindowInfo) { return wx.getWindowInfo(); }
  if (wx.getSystemInfoSync) { return wx.getSystemInfoSync(); }
  return {};
}

// ─── 行业线条图标（feather 风格 24x24，data URI，按 slug 映射；无映射则回退 emoji）──
function svgIcon(svg) { return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg); }
function lineSvg(path) {
  return svgIcon(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" ' +
    'stroke="#E65C46" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">' +
    path + '</svg>'
  );
}
var INDUSTRY_ICON = {
  fresh: lineSvg('<path d="M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z"/><path d="M2 21c0-3 1.85-5.36 5.08-6"/>'),
  restaurant: lineSvg('<path d="M3 2v7c0 1.1.9 2 2 2a2 2 0 0 0 2-2V2"/><path d="M5 11v11"/><path d="M19 2v20"/><path d="M19 2a4 4 0 0 0-4 4v5a2 2 0 0 0 2 2h2"/>'),
  apparel: lineSvg('<path d="M20.38 3.46 16 2a4 4 0 0 1-8 0L3.62 3.46a2 2 0 0 0-1.34 2.23l.58 3.47a1 1 0 0 0 .99.84H6v10c0 1.1.9 2 2 2h8a2 2 0 0 0 2-2V10h2.15a1 1 0 0 0 .99-.84l.58-3.47a2 2 0 0 0-1.34-2.23z"/>'),
  convenience: lineSvg('<circle cx="8" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M2 2h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57L24 6H6"/>'),
  beauty: lineSvg('<circle cx="6" cy="6" r="3"/><circle cx="6" cy="18" r="3"/><line x1="20" y1="4" x2="8.12" y2="15.88"/><line x1="14.47" y1="14.48" x2="20" y2="20"/><line x1="8.12" y1="8.12" x2="12" y2="12"/>'),
  manufacturing: lineSvg('<path d="M2 20a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8l-7 5V8l-7 5V4a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z"/><path d="M7 18h.01"/><path d="M12 18h.01"/><path d="M17 18h.01"/>'),
  insurance: lineSvg('<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>'),
  finance: lineSvg('<line x1="3" y1="22" x2="21" y2="22"/><line x1="6" y1="18" x2="6" y2="11"/><line x1="10" y1="18" x2="10" y2="11"/><line x1="14" y1="18" x2="14" y2="11"/><line x1="18" y1="18" x2="18" y2="11"/><polygon points="12 2 20 7 4 7"/>'),
  ecommerce: lineSvg('<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/>'),
  erp_crm: lineSvg('<line x1="12" y1="20" x2="12" y2="10"/><line x1="18" y1="20" x2="18" y2="4"/><line x1="6" y1="20" x2="6" y2="16"/><line x1="3" y1="20" x2="21" y2="20"/>'),
  cross_border: lineSvg('<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>')
};

// 给行业列表补 icon 字段（线条图标 data URI）；无映射的留空，wxml 回退 emoji
function withIcons(list) {
  var out = [];
  for (var i = 0; i < list.length; i++) {
    var it = list[i];
    var icon = INDUSTRY_ICON[it.slug] || '';
    out.push({
      slug: it.slug, emoji: it.emoji, name: it.name,
      title: it.title, description: it.description, icon: icon,
      api_base: it.api_base || '', api_token: it.api_token || '', ai_path: it.ai_path || '',
      ai_media: !!it.ai_media
    });
  }
  return out;
}

// 拉取失败时的兜底行业列表（与后端 IndustrySeeder 一致，保证离线也能选）
var FALLBACK = [
  { slug: 'fresh',         emoji: '🥬', name: '生鲜门店', title: '舌尖生鲜',    description: '果蔬肉禽 · 进货/库存/损耗/销售', ai_media: true },
  { slug: 'erp_crm',       emoji: '📊', name: '进销存及CRM', title: '进销存及CRM', description: '商品/采购/销售/客户/线索/商机', api_base: 'https://app2.xingke888.com/api', ai_media: true },
  { slug: 'restaurant',    emoji: '🍜', name: '餐饮快餐', title: 'AI 餐饮店长', description: '点餐/营业额/备料/损耗' },
  { slug: 'apparel',       emoji: '👕', name: '服装零售', title: 'AI 服装店长', description: '上新/库存/销售/会员' },
  { slug: 'convenience',   emoji: '🏪', name: '便利超市', title: 'AI 便利店长', description: '进货/库存/销售/促销' },
  { slug: 'beauty',        emoji: '💇', name: '美业服务', title: 'AI 美业管家', description: '预约/会员/消费/员工' },
  { slug: 'manufacturing', emoji: '🏭', name: '制造业',   title: 'AI 生产助手', description: '订单/产能/物料/排程' },
  { slug: 'insurance',     emoji: '🛡️', name: '保险',     title: 'AI 保险助手', description: '保单/客户/续保/业绩' },
  { slug: 'finance',       emoji: '💰', name: '金融',     title: 'AI 金融助手', description: '账户/对账/客户/风控' },
  { slug: 'ecommerce',     emoji: '🛒', name: '电商',     title: 'AI 电商助手',  description: '订单/库存/退款/客服' },
  { slug: 'cross_border', emoji: '🌐', name: '跨境电商', title: 'AI 跨境助手',  description: '文案/翻译/五点/侵权检测' }
];

Page({
  data: {
    statusBarHeight: 20,
    brandTitle: '企业AI落地行业应用案例', // 默认；后台 app_settings.industry_page_title 可覆盖
    brandSub: '请选择你的行业',          // 默认；后台 app_settings.industry_page_subtitle 可覆盖
    industries: [],
    loading: true
  },

  onLoad: function () {
    var win = getWin();
    this.setData({ statusBarHeight: (win && win.statusBarHeight) || 20 });
    this._loadTitle();
    this._load();
  },

  // 拉取落地页大标题（后台可配）；失败则保留默认
  _loadTitle: function () {
    var self = this;
    api.appConfig().then(function (res) {
      var cfg = (res && res.data) || {};
      var patch = {};
      if (cfg.industry_page_title) { patch.brandTitle = cfg.industry_page_title; }
      if (cfg.industry_page_subtitle) { patch.brandSub = cfg.industry_page_subtitle; }
      if (patch.brandTitle || patch.brandSub) { self.setData(patch); }
    }).catch(function () { /* 保留默认标题 */ });
  },

  _load: function () {
    var self = this;
    api.industries().then(function (res) {
      var list = (res && res.data) || [];
      if (list && list.length) {
        self.setData({ industries: withIcons(list), loading: false });
      } else {
        self.setData({ industries: withIcons(FALLBACK), loading: false });
      }
    }).catch(function () {
      // 网络/接口异常时用兜底列表，避免空白页卡住
      self.setData({ industries: withIcons(FALLBACK), loading: false });
    });
  },

  // 选中某行业 → 存 globalData（仅会话级）→ 跳聊天页
  onShareAppMessage: function () {
    return {
      title: this.data.brandTitle || '企业AI落地行业应用案例',
      path: '/pages/industry/industry'
    };
  },

  onPick: function (e) {
    var slug = e.currentTarget.dataset.slug;
    var list = this.data.industries || [];
    var picked = null;
    for (var i = 0; i < list.length; i++) {
      if (list[i].slug === slug) { picked = list[i]; break; }
    }
    if (!picked) { return; }

    getApp().globalData.industry = {
      slug: picked.slug,
      title: picked.title || picked.name,
      greeting: picked.greeting || '', // 行业欢迎语，空则聊天页用通用兜底
      apiBase: picked.api_base || '',    // 非空=该行业接口走外部后端
      apiToken: picked.api_token || '', // 非空=服务账号 token，小程序无感直接使用
      aiPath: picked.ai_path || '',     // 非空=覆盖默认 /ai/message 路径
      aiMedia: !!picked.ai_media        // true=聊天启用语音/拍照/相册/文件
    };
    wx.redirectTo({ url: '/pages/chat/chat' });
  }
});
