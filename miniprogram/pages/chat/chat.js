// pages/chat/chat.js
// 不使用 async/await，避免微信开发者工具触发 @babel/runtime 转译。
var api = require('../../utils/api.js');

var _msgId = 0;
function nextId() { return 'm' + (++_msgId); }

// 窗口信息：优先用新版 wx.getWindowInfo（含 statusBarHeight/windowWidth/windowHeight），
// 老基础库回退 wx.getSystemInfoSync。替代已废弃的 getSystemInfoSync 直接调用。
function getWin() {
  if (wx.getWindowInfo) { return wx.getWindowInfo(); }
  if (wx.getSystemInfoSync) { return wx.getSystemInfoSync(); }
  return {};
}

// ─── 查询类卡片 → markdown 文本（舌尖后端 query intent 的 reply 仅为占位，数据在 card_data）──
function fmtNum(v) {
  var n = Number(v);
  if (isNaN(n)) { return String(v == null ? '' : v); }
  return (Math.round(n * 1000) / 1000).toString();
}

function cardToMarkdown(cardType, cardData) {
  if (!cardData) { return ''; }
  var d = cardData;
  var lines = [];
  var i, j, it, list;

  if (cardType === 'inventory') {
    list = d.data || (Array.isArray(d) ? d : []);
    if (!list.length) { return '暂无库存数据。'; }
    lines.push('📦 **当前库存**');
    for (i = 0; i < list.length; i++) {
      it = list[i];
      var iname = (it.product && it.product.name) || it.product_name || '-';
      var iunit = (it.product && it.product.unit) || it.unit || '';
      var q = Number(it.current_qty);
      var flag = q === 0 ? '（售罄）' : (q < 5 ? '（偏少）' : '');
      lines.push('- ' + iname + '：' + fmtNum(it.current_qty) + iunit + flag);
    }
    return lines.join('\n');
  }

  if (cardType === 'sales_today' || cardType === 'sales_report') {
    var s = d.data || d || {};
    lines.push('💰 **今日销售**');
    var amt = Number(s.total_amount || 0);
    var tqty = Number(s.total_qty || 0);
    lines.push('- 营业额：' + (amt > 0 ? '¥' + amt.toFixed(2) : '—'));
    if (tqty > 0) { lines.push('- 出库总量：' + fmtNum(tqty) + ' 斤'); }
    lines.push('- 订单数：' + (s.total_orders || 0));
    var pay = s.payment_breakdown || {};
    var payLabels = { '1': '现金', '2': '微信', '3': '支付宝', '4': '银行卡', '5': '混合' };
    var payKeys = Object.keys(pay);
    if (payKeys.length) {
      lines.push('');
      lines.push('**支付方式**');
      for (i = 0; i < payKeys.length; i++) {
        lines.push('- ' + (payLabels[payKeys[i]] || payKeys[i]) + '：¥' + Number(pay[payKeys[i]]).toFixed(2));
      }
    }
    return lines.join('\n');
  }

  if (cardType === 'daily_overview') {
    list = (d.data && d.data.products) || (d.data && d.data.length ? d.data : (Array.isArray(d) ? d : []));
    if (!list || !list.length) { return '今日暂无营运数据。'; }
    lines.push('📊 **每日营运概览**');
    lines.push('（开盘 +进货 -销售 = 结余）');
    for (i = 0; i < list.length; i++) {
      it = list[i];
      var onm = it.product_name || (it.product && it.product.name) || '-';
      lines.push('- ' + onm + '：' + fmtNum(it.opening_qty || 0) + ' +' + fmtNum(it.received_qty || 0) +
        ' -' + fmtNum(it.sold_qty || 0) + ' = **' + fmtNum(it.closing_qty || 0) + '**' + (it.sold_out_at ? ' 🔴售罄' : ''));
    }
    return lines.join('\n');
  }

  if (cardType === 'purchase_orders') {
    list = d.data || (Array.isArray(d) ? d : []);
    if (!list.length) { return '今日暂无进货单。'; }
    var stMap = { '1': '待处理', '2': '已确认', '3': '已收货', '4': '已取消' };
    lines.push('🚚 **进货单**');
    for (i = 0; i < list.length; i++) {
      var o = list[i];
      lines.push('');
      lines.push('**进货单 #' + o.id + '** · ' + (stMap[o.status] || o.status) + (o.date ? ' · ' + o.date : ''));
      var oitems = o.items || [];
      for (j = 0; j < oitems.length; j++) {
        var pi = oitems[j];
        var pn = (pi.product && pi.product.name) || pi.product_name || '-';
        lines.push('- ' + pn + ' ' + fmtNum(pi.ordered_qty) + (pi.unit || '') + (pi.unit_price ? ' × ¥' + pi.unit_price : ''));
      }
    }
    return lines.join('\n');
  }

  if (cardType === 'daily_logs') {
    list = d.data || (Array.isArray(d) ? d : []);
    if (!list.length) { return '今日暂无操作记录。'; }
    var srcMap = { '1': 'AI', '2': '手动', '3': '后台' };
    lines.push('📝 **今日操作日志**');
    for (i = 0; i < list.length; i++) {
      var lg = list[i];
      var ts = lg.created_at ? String(lg.created_at).replace('T', ' ').slice(11, 16) : '';
      var content = lg.content || lg.message || lg.intent || '-';
      lines.push('- ' + (ts ? '`' + ts + '` ' : '') + '[' + (srcMap[lg.source] || '?') + '] ' + content);
    }
    return lines.join('\n');
  }

  if (cardType === 'weather') {
    var meta = d || {};
    var w = meta.data || meta || {};
    var city = meta.city || w.city || '香港';
    var date = meta.date || w.date || '';
    var th = w.temperature_high != null ? w.temperature_high : (w.temperature != null ? w.temperature : null);
    var tl = w.temperature_low != null ? w.temperature_low : null;
    var temp = th != null ? (tl != null ? tl + '°~' + th + '°' : th + '°') : '';
    var cond = w.condition || w.weather || w.description || '';
    lines.push('🌦️ **' + city + ' 天气**' + (date ? ' · ' + date : ''));
    if (temp) { lines.push('- 气温：' + temp); }
    if (cond) { lines.push('- 天气：' + cond); }
    if (w.rain_probability != null) { lines.push('- 降水概率：' + w.rain_probability + '%'); }
    if (w.suggestion) { lines.push(''); lines.push('💡 ' + w.suggestion); }
    return lines.join('\n');
  }

  if (cardType === 'suggestions') {
    var inner = d.data || d || {};
    var pur = inner.purchase_suggestions || [];
    var promo = inner.promo_suggestions || [];
    var uMap = { urgent: '🔴紧急', high: '🟠重要', medium: '🟡建议', low: '参考' };
    lines.push('💡 **经营建议**');
    lines.push('');
    lines.push('🚛 **进货建议**');
    if (!pur.length) { lines.push('- 暂无，库存充足'); }
    for (i = 0; i < pur.length; i++) {
      it = pur[i];
      lines.push('- ' + (uMap[it.urgency] || '') + ' **' + it.product_name + '**（余' + fmtNum(it.current_qty || 0) +
        (it.unit || '') + '）：' + (it.action || it.reason || ''));
    }
    lines.push('');
    lines.push('🎯 **促销建议**');
    if (!promo.length) { lines.push('- 暂无，销售正常'); }
    for (i = 0; i < promo.length; i++) {
      it = promo[i];
      lines.push('- ' + (uMap[it.urgency] || '') + ' **' + it.product_name + '**：' + (it.action || it.reason || ''));
    }
    return lines.join('\n');
  }

  if (cardType === 'customers') {
    list = d.data || (Array.isArray(d) ? d : []);
    if (!list.length) { return '没有找到匹配的顾客。'; }
    lines.push('👤 **顾客档案**');
    for (i = 0; i < list.length; i++) {
      var cu = list[i];
      lines.push('- **' + (cu.name || '-') + '**' + (cu.phone ? ' `' + cu.phone + '`' : '') +
        ' ｜ ' + (cu.level || '普通') + ' ｜ 消费¥' + (cu.total_spent || 0) +
        ' ｜ 订单' + (cu.order_count || 0) + ' ｜ 积分' + (cu.points || 0));
    }
    return lines.join('\n');
  }

  if (cardType === 'customer_orders') {
    list = d.data || (Array.isArray(d) ? d : []);
    if (!list.length) { return '暂无顾客订单。'; }
    lines.push('🧾 **顾客订单**');
    for (i = 0; i < list.length; i++) {
      var co = list[i];
      var cot = co.created_at ? String(co.created_at).replace('T', ' ').slice(5, 16) : '';
      lines.push('- `' + (co.order_no || '') + '` ' + (co.customer_name || '散客') +
        ' ｜ ' + (co.type || '') + ' ｜ ' + (co.status || '') + ' ｜ ¥' + (co.total_amount || 0) +
        (cot ? ' ｜ ' + cot : ''));
    }
    return lines.join('\n');
  }

  return '';
}

// ─── 内联 SVG 图标（WeChat / WeUI 风格，细线 24x24，URL-encoded data URI）──
function svgIcon(svg) { return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg); }
var ICON_STROKE = '%232A1F19'; // #2A1F19
var ICON_RED = '%23E65C46';
function feather(path, color) {
  if (!color) color = '#2A1F19';
  return svgIcon('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="' + color + '" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' + path + '</svg>');
}
function botSvg(color) {
  // 友好机器人头像：天线 + 圆角头框 + 两眼 + 一抹微笑
  // 与 feather() 区别：眼睛是实心圆，需要 fill
  return svgIcon(
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="' + color + '" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">' +
    '<line x1="12" y1="2.5" x2="12" y2="5"/>' +
    '<circle cx="12" cy="5.2" r="1.2" fill="' + color + '" stroke="none"/>' +
    '<rect x="3.6" y="7" width="16.8" height="13" rx="2.6"/>' +
    '<circle cx="9" cy="13.5" r="1.4" fill="' + color + '" stroke="none"/>' +
    '<circle cx="15" cy="13.5" r="1.4" fill="' + color + '" stroke="none"/>' +
    '<path d="M9.5 17 Q12 18.4 14.5 17"/>' +
    '</svg>'
  );
}
var ICONS = {
  mic: feather('<path d="M12 1a3 3 0 0 0-3 3v8a3 3 0 0 0 6 0V4a3 3 0 0 0-3-3z"/><path d="M19 10v2a7 7 0 0 1-14 0v-2"/><line x1="12" y1="19" x2="12" y2="23"/><line x1="8" y1="23" x2="16" y2="23"/>'),
  keyboard: feather('<rect x="2" y="6" width="20" height="12" rx="2"/><line x1="6" y1="10" x2="6.01" y2="10"/><line x1="10" y1="10" x2="10.01" y2="10"/><line x1="14" y1="10" x2="14.01" y2="10"/><line x1="18" y1="10" x2="18.01" y2="10"/><line x1="6" y1="14" x2="6.01" y2="14"/><line x1="18" y1="14" x2="18.01" y2="14"/><line x1="10" y1="14" x2="14" y2="14"/>'),
  plus: feather('<line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>'),
  close: feather('<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>'),
  camera: feather('<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/>'),
  album: feather('<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>'),
  file: feather('<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="10" y1="9" x2="9" y2="9"/><line x1="10" y1="9" x2="8" y2="9"/>'),
  arrowUp: feather('<line x1="12" y1="19" x2="12" y2="5"/><polyline points="5 12 12 5 19 12"/>', '#FFFFFF'),
  bot: botSvg('#E65C46'),       // 红色版（用于白色圆形头像内部）
  botWhite: botSvg('#FFFFFF'),  // 白色版（用于红色按钮等深色背景）
};

// ─── Markdown → HTML (轻量版，给 rich-text 用) ──────────────────────────────
function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

/**
 * 把 markdown 文本解析成结构化块数组，由 wxml 逐块渲染。
 * 块类型：
 *   { type:'h',  level:1|2|3, html:'...' }
 *   { type:'li', ordered:bool, marker:'1.' | '•', html:'...' }
 *   { type:'code', text:'...' }
 *   { type:'p',  html:'...' }    // 包含可选的 <br>
 * inline html 仅含: <strong> <em> <code> <span style="link"> <br>
 */
function inlineMd(s) {
  if (s == null) return '';
  s = String(s);
  // inline code 先抽出（防止后续转义破坏）
  var codes = [];
  s = s.replace(/`([^`\n]+)`/g, function (_m, c) {
    codes.push(c);
    return ' IC' + (codes.length - 1) + ' ';
  });
  // 转义 HTML 特殊字符
  s = s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  // 加粗
  s = s.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>');
  s = s.replace(/__([^_\n]+)__/g, '<strong>$1</strong>');
  // 斜体
  s = s.replace(/\*([^*\n]+)\*/g, '<em>$1</em>');
  // 链接（仅视觉，rich-text 不能跳）
  s = s.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<span style="color:#E65C46;text-decoration:underline;">$1</span>');
  // 还原 inline code
  s = s.replace(/ IC(\d+) /g, function (_m, i) {
    var c = codes[+i].replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return '<code style="background:rgba(42,31,25,0.10);padding:1rpx 8rpx;border-radius:6rpx;font-family:monospace;font-size:0.92em;">' + c + '</code>';
  });
  return s;
}

function mdParse(text) {
  if (!text) return [];
  var raw = String(text);

  // 1. 抽出 fenced code block
  var codeBlocks = [];
  raw = raw.replace(/```(\w+)?\n?([\s\S]*?)```/g, function (_m, lang, content) {
    if (lang === 'card') {
      var parsed = null;
      try { parsed = JSON.parse(String(content).trim()); } catch (eP) { /* ignore */ }
      if (parsed && typeof parsed === 'object') {
        codeBlocks.push({ kind: 'card', data: parsed });
        return 'CB' + (codeBlocks.length - 1) + '';
      }
    }
    codeBlocks.push({ kind: 'code', text: String(content) });
    return 'CB' + (codeBlocks.length - 1) + '';
  });

  var blocks = [];
  var lines = raw.split('\n');
  var pBuf = []; // 累积普通段落的多行
  var orderedCounter = 0;

  function flushParagraph() {
    if (pBuf.length === 0) return;
    var joined = pBuf.join('\n');
    // 把段落里的 \n 转成 <br>
    var html = inlineMd(joined).replace(/\n/g, '<br>');
    blocks.push({ type: 'p', html: html });
    pBuf = [];
  }

  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];

    // 代码块占位符 → 独立块（可能是普通代码块，也可能是 card 卡片）
    var cbm = line.match(/CB(\d+)/);
    if (cbm) {
      flushParagraph();
      var entry = codeBlocks[+cbm[1]];
      if (entry && entry.kind === 'card') {
        blocks.push({ type: 'card', data: entry.data });
      } else {
        blocks.push({ type: 'code', text: (entry && entry.text) || '' });
      }
      continue;
    }

    // 标题
    var hm = line.match(/^(#{1,3})\s+(.+)$/);
    if (hm) {
      flushParagraph();
      blocks.push({ type: 'h', level: hm[1].length, html: inlineMd(hm[2]) });
      continue;
    }

    // 有序列表
    var olm = line.match(/^\s*(\d+)\.\s+(.+)$/);
    if (olm) {
      flushParagraph();
      blocks.push({ type: 'li', ordered: true, marker: olm[1] + '.', html: inlineMd(olm[2]) });
      continue;
    }

    // 无序列表
    var ulm = line.match(/^\s*[-*]\s+(.+)$/);
    if (ulm) {
      flushParagraph();
      blocks.push({ type: 'li', ordered: false, marker: '•', html: inlineMd(ulm[1]) });
      continue;
    }

    // 空行 → 段落分隔
    if (line.trim() === '') {
      flushParagraph();
      continue;
    }

    // 其它：累积为段落
    pBuf.push(line);
  }
  flushParagraph();

  // 计算 ordered list 的 marker 最大宽度（保证对齐）
  var maxOrderedDigits = 1;
  for (var k = 0; k < blocks.length; k++) {
    var b = blocks[k];
    if (b.type === 'li' && b.ordered) {
      var n = b.marker.length;
      if (n > maxOrderedDigits) maxOrderedDigits = n;
    }
  }
  for (var j = 0; j < blocks.length; j++) {
    blocks[j].k = 'b' + j; // 每个块唯一 key，避免 wx:key 用对象导致 "[object Object]" 冲突
    if (blocks[j].type === 'li') {
      blocks[j].markerWidth = blocks[j].ordered
        ? Math.max(48, maxOrderedDigits * 18 + 8) + 'rpx'  // 18rpx/位
        : '36rpx';
    }
  }

  return blocks;
}

function mdToHtml(text) {
  if (!text) return '';
  var s = String(text);

  // 1. 先抽出 ```code block```（避免里面的字符被转义/被其它规则破坏）
  var codeBlocks = [];
  s = s.replace(/```([\s\S]*?)```/g, function (_m, code) {
    codeBlocks.push(code.replace(/^[a-zA-Z0-9_-]+\n/, ''));
    return 'CB' + (codeBlocks.length - 1) + '';
  });

  // 2. 抽出 `inline code`
  var inlineCodes = [];
  s = s.replace(/`([^`\n]+)`/g, function (_m, code) {
    inlineCodes.push(code);
    return 'IC' + (inlineCodes.length - 1) + '';
  });

  // 3. 转义剩余 HTML 特殊字符
  s = escapeHtml(s);

  // 4. 标题（行起始 # / ## / ###）
  s = s.replace(/(^|\n)### (.+)/g, '$1<h3 style="font-size:30rpx;font-weight:700;margin:10rpx 0 6rpx;">$2</h3>');
  s = s.replace(/(^|\n)## (.+)/g,  '$1<h2 style="font-size:34rpx;font-weight:700;margin:12rpx 0 8rpx;">$2</h2>');
  s = s.replace(/(^|\n)# (.+)/g,   '$1<h1 style="font-size:38rpx;font-weight:700;margin:14rpx 0 10rpx;">$2</h1>');

  // 5. 加粗 / 斜体（先 ** 后 *）
  s = s.replace(/\*\*([^*\n]+)\*\*/g, '<strong style="font-weight:700;">$1</strong>');
  s = s.replace(/__([^_\n]+)__/g,     '<strong style="font-weight:700;">$1</strong>');
  s = s.replace(/\*([^*\n]+)\*/g,     '<em style="font-style:italic;">$1</em>');

  // 6. 列表 —— 用文本内 marker + paragraph 缩进，避免 rich-text 不支持 list-style counter
  //    无序：•  有序：保留原数字
  //    text-indent 负值 + padding-left 实现"挂起缩进"
  s = s.replace(/(^|\n)[-*] (.+)/g,
    '$1<p style="margin:6rpx 0;padding-left:44rpx;text-indent:-28rpx;">•&nbsp;&nbsp;$2</p>');
  s = s.replace(/(^|\n)(\d+)\.\s+(.+)/g,
    '$1<p style="margin:6rpx 0;padding-left:56rpx;text-indent:-44rpx;"><span style="display:inline-block;width:44rpx;text-align:right;">$2.</span>&nbsp;$3</p>');

  // 7. 链接 [text](url) —— rich-text 不会真的跳转，仅作为视觉
  s = s.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<span style="color:#E65C46;text-decoration:underline;">$1</span>');

  // 8. 收掉 block 元素紧邻的一个 \n（保留剩余 \n 用作段落分隔变 <br>）
  s = s.replace(/\n(<\/?(?:p|h[1-3]|li)[^>]*>)/g, '$1');
  s = s.replace(/(<\/(?:p|h[1-3]|li)>)\n/g, '$1');

  // 9. 剩余换行 → <br>
  s = s.replace(/\n/g, '<br>');

  // 9. 还原 inline code
  s = s.replace(/IC(\d+)/g, function (_m, i) {
    return '<code style="background:rgba(42,31,25,0.08);padding:2rpx 8rpx;border-radius:6rpx;font-family:monospace;font-size:0.92em;">' + escapeHtml(inlineCodes[+i]) + '</code>';
  });

  // 10. 还原代码块
  s = s.replace(/CB(\d+)/g, function (_m, i) {
    var code = escapeHtml(codeBlocks[+i]).replace(/\n/g, '<br>');
    return '<pre style="background:rgba(42,31,25,0.08);padding:14rpx 18rpx;border-radius:12rpx;font-family:monospace;font-size:24rpx;overflow:auto;margin:8rpx 0;"><code>' + code + '</code></pre>';
  });

  return s;
}

Page({
  data: {
    statusBarHeight: 0,
    appTitle: '舌尖生鲜', // 顶部标题，后台 app_config 可覆盖
    user: null,
    logging: false,
    loginForm: { username: '', password: '' },

    msgs: [],
    typing: false,
    fontSize: 'md',

    chatInput: '',
    aiBusy: false,

    scrollAnchor: 'anchor-bottom',
    msgsHeight: 400,

    plusOpen: false,
    voiceMode: false,
    recording: false,

    icons: ICONS,

    // 快捷功能菜单。badge 可以是数字（'3'）或字符（'NEW'），留空则不显示。
    // 点击后 prompt 直接作为用户消息发出去，AI 来响应。
    // 若 items 非空，则改为弹出底部子菜单，由用户选择具体子项。
    quickActions: [
      { key: 'inventory', emoji: '📦', label: '今日库存', badge: '',
        open: { path: '/inventory', title: '今日库存' } },
      {
        key: 'sales', emoji: '💰', label: '今日销售', badge: '',
        items: [
          { key: 'sales-stat',   emoji: '📊', label: '销售统计',     desc: '每日销售报表', route: '/pages/report/report?path=%2Fsales-report&title=%E9%94%80%E5%94%AE%E7%BB%9F%E8%AE%A1' },
          { key: 'sales-upload', emoji: '📤', label: '上传销售报表', desc: '拍照/相册/文件 AI 识别入库', route: '/pages/sales-upload/sales-upload' },
        ],
      },
      { key: 'damage',    emoji: '🗑️', label: '损耗记录', badge: '',
        route: '/pages/damage/damage' },
      {
        key: 'purchase', emoji: '🚚', label: '进货单记录', badge: '',
        items: [
          { key: 'purchase-history', emoji: '📋', label: '历史进货单记录', desc: '看历史上传的单据', route: '/pages/purchase-orders/purchase-orders' },
          { key: 'purchase-upload',  emoji: '📤', label: '上传进货单',     desc: '拍照/相册/文件 AI 识别入库', route: '/pages/purchase-upload/purchase-upload' },
        ],
      },
      {
        key: 'crm', emoji: '👤', label: '客户管理', badge: 'NEW',
        items: [
          { key: 'crm-customers', emoji: '👤', label: '顾客档案', desc: '会员/跟进/消费记录', route: '/pages/report/report?path=%2Fcrm&title=%E9%A1%BE%E5%AE%A2%E7%AE%A1%E7%90%86' },
          { key: 'crm-orders',    emoji: '🧾', label: '顾客订单', desc: '预订/送货/团购/自提', route: '/pages/report/report?path=%2Forders&title=%E9%A1%BE%E5%AE%A2%E8%AE%A2%E5%8D%95' },
        ],
      },
      {
        key: 'report', emoji: '📊', label: '经营查询', badge: '',
        items: [
          { key: 'overview',  emoji: '📊', label: '每日营运概况', desc: '往日库存/进货/已售/售罄', route: '/pages/report/report' },
          { key: 'purchase',  emoji: '🚚', label: '最近进货',     desc: '进货单明细',             prompt: '查一下最近的进货单' },
          { key: 'suggest',   emoji: '💡', label: '进货建议',     desc: '补货优先级',             prompt: '给我一些进货和促销建议' },
          { key: 'logs',      emoji: '📝', label: '操作日志',     desc: '今日远程指令留档',       prompt: '看一下今天的操作日志' },
        ],
      },
      { key: 'weather',   emoji: '🌦️', label: '查天气', prompt: '明天天气怎么样', badge: '' },
      { key: 'help',      emoji: '💡', label: '使用说明', prompt: '你能帮我做什么', badge: '' },
      // 仅管理员可见（user.is_admin）：经 /admin/sso 用 JWT 免登录进 Filament 后台。
      // report.js 会把 path 拼成 paper.xingke888.com/admin/sso?token=<JWT>&from=miniapp，
      // AdminSsoController 解 JWT→写 web session→跳 /admin。
      { key: 'admin', emoji: '🛠️', label: '后台管理', badge: '', adminOnly: true,
        open: { path: '/admin/sso', title: '后台管理' } },
    ],

    // 经营报表 — 锚定在 chip 上方的 popover
    reportMenuOpen: false,
    reportMenuItems: [],
    reportMenuStyle: '',     // popover 容器定位 (px)
    reportMenuArrowStyle: '',// 小三角横向偏移 (px)
  },

  onLoad: function () {
    var sys = getWin();
    this.setData({
      statusBarHeight: sys.statusBarHeight || 20,
      msgsHeight: (sys.windowHeight || 600) - 140,
    });

    var app = getApp();
    this._sessionId = null;

    // 应用配置（标题等）——公开接口，登录前也拉取
    this._loadAppConfig();

    // 开启右上角「…」菜单里的转发给朋友 / 分享到朋友圈
    if (wx.showShareMenu) {
      wx.showShareMenu({ withShareTicket: false, menus: ['shareAppMessage', 'shareTimeline'] });
    }

    // 只有 token + user 都在才算登录；并后台校验 token 是否仍有效
    if (app.globalData.token && app.globalData.user) {
      this.setData({ user: app.globalData.user });
      this._greetLoggedIn(app.globalData.user);
      this._validateSession();
      this._loadQuickActions();
    } else {
      this.setData({ user: null });
    }
    // 未登录则停留在底部登录表单，等待用户输入账号密码
  },

  // 校验缓存的 token 是否仍有效，失效则清登录态回登录表单（避免"假登录")
  _validateSession: function () {
    var self = this;
    api.me().catch(function (err) {
      var msg = (err && err.message) || '';
      if (msg === 'Unauthenticated') {
        // request() 在 401 时已 clearAuth，这里只需更新 UI
        self.setData({ user: null, msgs: [] });
        wx.nextTick(function () { self._recomputeMsgsHeight(); });
        wx.showToast({ title: '登录已失效，请重新登录', icon: 'none' });
      }
    });
  },

  // 拉取应用配置（标题等）；失败则保留 data 里的默认标题
  _loadAppConfig: function () {
    var self = this;
    api.appConfig().then(function (res) {
      var cfg = (res && res.data) || {};
      if (cfg.miniprogram_title) {
        self.setData({ appTitle: cfg.miniprogram_title });
      }
    }).catch(function () { /* 保留默认标题 */ });
  },

  // 从后台拉取底部快捷按钮配置；失败/空则保留 data 里写死的默认数组（避免空白）
  _loadQuickActions: function () {
    var self = this;
    api.quickActions().then(function (res) {
      var list = res && res.data;
      if (list && list.length) {
        self.setData({ quickActions: list });
        wx.nextTick(function () { self._recomputeMsgsHeight(); });
      }
    }).catch(function () { /* 保留默认按钮 */ });
  },

  onReady: function () {
    this._recomputeMsgsHeight();
  },

  // 转发给朋友（右上角菜单 / button open-type="share" 都会触发）
  onShareAppMessage: function () {
    return {
      title: '舌尖香港 · AI 店长助手 🥬',
      path: '/pages/chat/chat',
    };
  },

  // 分享到朋友圈
  onShareTimeline: function () {
    return {
      title: '舌尖香港 · AI 店长助手 🥬',
    };
  },

  _recomputeMsgsHeight: function () {
    var self = this;
    var sys = getWin();
    var total = sys.windowHeight || 600;
    var q = wx.createSelectorQuery().in(self);
    q.select('.header').boundingClientRect();
    q.select('.bottom').boundingClientRect();
    q.exec(function (rects) {
      var headerH = (rects && rects[0] && rects[0].height) || 60;
      var bottomH = (rects && rects[1] && rects[1].height) || 80;
      var next = Math.max(120, Math.floor(total - headerH - bottomH));
      if (next !== self.data.msgsHeight) {
        self.setData({ msgsHeight: next });
        self._scrollDown();
      }
    });
  },

  _greetLoggedIn: function (user) {
    var name = (user && user.name) || '老板';
    var self = this;
    self._pushAi('嗨，' + name + '！👋 欢迎回来～', 600);
    setTimeout(function () {
      self._pushAi('我是舌尖香港 · AI 店长助手 🥬\n\n直接在下面输入框跟我说，我能帮你：\n📦 查库存 / 报剩余\n💰 录销售 / 查今日销售\n🚚 记进货\n🌦️ 查天气', 1100);
    }, 1500);
  },

  onFontSize: function (e) {
    var size = e.currentTarget.dataset.size;
    if (size === 'sm' || size === 'md' || size === 'lg') {
      this.setData({ fontSize: size });
    }
  },

  onInput: function (e) {
    this.setData({ chatInput: e.detail.value });
  },

  onQuickAction: function (e) {
    if (this.data.aiBusy) return;
    var key = e.currentTarget.dataset.key || '';
    var action = null;
    var list = this.data.quickActions || [];
    for (var i = 0; i < list.length; i++) {
      if (list[i].key === key) { action = list[i]; break; }
    }
    if (action && action.items && action.items.length) {
      this._openReportMenu(action.items, key);
      return;
    }
    // 带 route 配置：直接 navigateTo 小程序原生页（如损耗记录，不走 AI/web-view）
    if (action && action.route) {
      if (!this._requireLogin()) return;
      wx.navigateTo({
        url: action.route,
        fail: function () { wx.showToast({ title: '页面不存在', icon: 'none' }); },
      });
      return;
    }
    // 带 open 配置：直接打开 web-view 页（功能聚合/我的等，不走 AI）
    if (action && action.open) {
      var ou = '/pages/report/report?path=' + encodeURIComponent(action.open.path);
      if (action.open.title) { ou += '&title=' + encodeURIComponent(action.open.title); }
      wx.navigateTo({ url: ou });
      return;
    }
    // 带 web 配置的快捷项：发 AI 文字摘要后，追加一个「打开完整页」按钮打开 web-view
    if (action && action.web) {
      this._sendWithWebLink(action.prompt, action.web);
      return;
    }
    var prompt = e.currentTarget.dataset.prompt || (action && action.prompt) || '';
    if (!prompt) return;
    this.setData({ chatInput: prompt });
    this.onSend();
  },

  // 发送 prompt 拿 AI 文字摘要，成功后追加一个 navigate 卡片按钮打开对应 web-view 页
  _sendWithWebLink: function (prompt, web) {
    var self = this;
    if (!prompt || self.data.aiBusy) return;
    self._pushUser(prompt);
    self.setData({ aiBusy: true, typing: true });
    self._scrollDown();
    api.aiMessage(prompt, { sessionId: self._sessionId }).then(function (res) {
      self._handleAiResult(res);
      self._pushWebLinkCard(web);
    }).catch(function (err) {
      self._handleAiError(err);
    });
  },

  // 追加一条「打开完整页」链接按钮消息
  _pushWebLinkCard: function (web) {
    var url = '/pages/report/report?path=' + encodeURIComponent(web.path);
    if (web.title) { url += '&title=' + encodeURIComponent(web.title); }
    var msgs = this.data.msgs.concat([{
      id: nextId(),
      from: 'ai',
      weblink: { label: web.label || '打开完整页', url: url },
    }]);
    this.setData({ msgs: msgs });
    this._scrollDown();
  },

  onWebLink: function (e) {
    var url = e.currentTarget.dataset.url;
    if (!url) return;
    if (!this._requireLogin()) return;
    wx.navigateTo({
      url: url,
      fail: function () { wx.showToast({ title: '打开失败', icon: 'none' }); },
    });
  },

  _openReportMenu: function (items, key) {
    var self = this;
    var sys = getWin();
    var winW = sys.windowWidth || 375;
    var winH = sys.windowHeight || 667;
    // 弹层目标宽度 (rpx -> px): 360rpx
    var menuW = Math.round(360 * winW / 750);
    var margin = Math.round(16 * winW / 750); // 距屏幕边缘
    var gap = Math.round(16 * winW / 750);    // chip 到弹层的间距

    wx.createSelectorQuery().in(self).select('.qa-chip-' + key).boundingClientRect(function (rect) {
      var anchorCenterX, anchorTop;
      if (rect) {
        anchorCenterX = rect.left + rect.width / 2;
        anchorTop = rect.top;
      } else {
        anchorCenterX = winW / 2;
        anchorTop = winH - 200;
      }
      var left = Math.round(anchorCenterX - menuW / 2);
      if (left < margin) left = margin;
      if (left + menuW > winW - margin) left = winW - margin - menuW;
      var bottom = Math.round(winH - anchorTop + gap);
      var arrowLeft = Math.round(anchorCenterX - left); // 三角形相对 popover 左边
      self.setData({
        reportMenuItems: items,
        reportMenuOpen: true,
        reportMenuStyle: 'left:' + left + 'px;bottom:' + bottom + 'px;width:' + menuW + 'px;',
        reportMenuArrowStyle: 'left:' + arrowLeft + 'px;',
      });
    }).exec();
  },

  closeReportMenu: function () {
    if (this.data.reportMenuOpen) this.setData({ reportMenuOpen: false });
  },

  // 阻止 popover 内部点击穿透到遮罩
  noop: function () {},

  // 需要登录才能打开的页面：无 token 时显示登录窗口（不跳转，避免报表页闪退）
  _requireLogin: function () {
    var app = getApp();
    if (app.globalData && app.globalData.token) return true;
    this.setData({ user: null });
    wx.showToast({ title: '请先登录', icon: 'none' });
    wx.nextTick(this._recomputeMsgsHeight.bind(this));
    return false;
  },

  onReportItem: function (e) {
    var route = e.currentTarget.dataset.route || '';
    var prompt = e.currentTarget.dataset.prompt || '';
    this.setData({ reportMenuOpen: false });
    if (route) {
      if (!this._requireLogin()) return;
      wx.navigateTo({ url: route });
      return;
    }
    if (!prompt || this.data.aiBusy) return;
    this.setData({ chatInput: prompt });
    this.onSend();
  },

  /** AI 卡片按钮 — 根据 intent 分发到不同小程序能力 */
  onCardAction: function (e) {
    var ds = e.currentTarget.dataset;
    var intent = ds.intent || '';
    var payload = ds.payload || {};
    if (typeof payload === 'string') {
      try { payload = JSON.parse(payload); } catch (eP) { payload = {}; }
    }
    var label = ds.label || '按钮';

    if (intent === 'copy' && payload.text) {
      wx.setClipboardData({
        data: String(payload.text),
        success: function () { wx.showToast({ title: '已复制', icon: 'success' }); },
      });
      return;
    }

    if (intent === 'navigate' && payload.url) {
      wx.navigateTo({
        url: String(payload.url),
        fail: function () { wx.showToast({ title: '页面不存在', icon: 'none' }); },
      });
      return;
    }

    if (intent === 'message' && payload.message) {
      this.setData({ chatInput: String(payload.message) });
      this.onSend();
      return;
    }

    // 默认 / 未知 intent：把按钮信息当成新一条用户消息发回 AI，让它接着处理
    var fallback = '我点击了"' + label + '"';
    if (intent) fallback += '（intent: ' + intent + '）';
    if (payload && typeof payload === 'object' && Object.keys(payload).length) {
      try { fallback += '\n附加数据：' + JSON.stringify(payload); } catch (eS) {}
    }
    this.setData({ chatInput: fallback });
    this.onSend();
  },

  // ─── 媒体输入 ─────────────────────────────────────────────────────────────
  togglePlusMenu: function () {
    var self = this;
    self.setData({ plusOpen: !self.data.plusOpen, voiceMode: false });
    wx.nextTick(function () { self._recomputeMsgsHeight(); });
  },

  closePlusMenu: function () {
    var self = this;
    if (self.data.plusOpen) {
      self.setData({ plusOpen: false });
      wx.nextTick(function () { self._recomputeMsgsHeight(); });
    }
  },

  toggleVoiceMode: function () {
    var self = this;
    self.setData({ voiceMode: !self.data.voiceMode, plusOpen: false });
    wx.nextTick(function () { self._recomputeMsgsHeight(); });
  },

  onPickImage: function (e) {
    var self = this;
    if (self.data.aiBusy) return;
    var src = e && e.currentTarget && e.currentTarget.dataset && e.currentTarget.dataset.src;
    self.closePlusMenu();
    var sourceType = src === 'camera' ? ['camera'] : ['album'];
    wx.chooseMedia({
      count: 1,
      mediaType: ['image'],
      sourceType: sourceType,
      success: function (r) {
        var f = r.tempFiles && r.tempFiles[0];
        if (!f) return;
        self._pushMedia({ type: 'image', tempPath: f.tempFilePath });
        self.setData({ aiBusy: true, typing: true });
        self._scrollDown();
        wx.getFileSystemManager().readFile({
          filePath: f.tempFilePath,
          encoding: 'base64',
          success: function (rf) {
            api.aiMessage('', { imageBase64: rf.data, sessionId: self._sessionId }).then(function (res) {
              self._handleAiResult(res);
            }).catch(function (err) {
              self._handleAiError(err);
            });
          },
          fail: function () {
            self.setData({ aiBusy: false, typing: false });
            self._pushAi('❌ 图片读取失败，请重试。');
          },
        });
      },
      fail: function () { /* user cancelled */ },
    });
  },

  onPickFile: function () {
    var self = this;
    if (self.data.aiBusy) return;
    self.closePlusMenu();
    wx.chooseMessageFile({
      count: 1,
      type: 'file',
      success: function (r) {
        var f = r.tempFiles && r.tempFiles[0];
        if (!f) return;
        self._pushMedia({ type: 'file', tempPath: f.path, name: f.name, size: f.size });
        // 舌尖后端暂无文件解析接口，先提示用户改用文字/图片
        self._pushAi('📄 已收到文件「' + (f.name || '未命名') + '」，不过文件分析功能暂未开放，请改用文字或图片告诉我哦～');
      },
      fail: function () { /* user cancelled */ },
    });
  },

  onVoiceStart: function () {
    var self = this;
    if (self.data.recording) return;
    var mgr = wx.getRecorderManager();
    self._recorder = mgr;
    self._recordStart = Date.now();
    mgr.onError(function (err) {
      wx.showToast({ title: '录音错误：' + ((err && err.errMsg) || ''), icon: 'none' });
      self.setData({ recording: false });
    });
    mgr.onStop(function (res) {
      var dur = Math.round((Date.now() - self._recordStart) / 100) / 10;
      self.setData({ recording: false });
      if (!res || !res.tempFilePath) return;
      if (dur < 0.6) {
        wx.showToast({ title: '说话时间太短', icon: 'none' });
        return;
      }
      self._pushMedia({ type: 'voice', tempPath: res.tempFilePath, duration: dur });
      self.setData({ aiBusy: true, typing: true });
      self._scrollDown();
      api.aiVoice(res.tempFilePath, self._sessionId).then(function (data) {
        self._handleAiResult(data);
      }).catch(function (err) {
        self._handleAiError(err);
      });
    });
    mgr.start({
      duration: 60000,
      sampleRate: 16000,
      numberOfChannels: 1,
      encodeBitRate: 48000,
      format: 'mp3',
    });
    self.setData({ recording: true });
  },

  onVoiceEnd: function () {
    if (this._recorder && this.data.recording) {
      this._recorder.stop();
    }
  },

  onPlayVoice: function (e) {
    var url = e.currentTarget.dataset.url || e.currentTarget.dataset.path;
    if (!url) return;
    if (this._audio) { try { this._audio.destroy(); } catch (eD) {} }
    var a = wx.createInnerAudioContext();
    a.src = url;
    a.onError(function () { wx.showToast({ title: '播放失败', icon: 'none' }); });
    a.play();
    this._audio = a;
  },

  onPreviewImage: function (e) {
    var url = e.currentTarget.dataset.url || e.currentTarget.dataset.path;
    if (!url) return;
    wx.previewImage({ current: url, urls: [url] });
  },

  _pushMedia: function (entry) {
    var msg = { id: nextId(), from: 'user' };
    for (var k in entry) { if (entry.hasOwnProperty(k)) msg[k] = entry[k]; }
    var msgs = this.data.msgs.concat([msg]);
    this.setData({ msgs: msgs });
    this._scrollDown();
  },

  onLoginInput: function (e) {
    var field = e.currentTarget.dataset.field;
    if (field !== 'username' && field !== 'password') return;
    var form = {};
    for (var k in this.data.loginForm) {
      if (this.data.loginForm.hasOwnProperty(k)) form[k] = this.data.loginForm[k];
    }
    form[field] = e.detail.value;
    this.setData({ loginForm: form });
  },

  onLogin: function () {
    if (this.data.logging) return;
    var self = this;
    var username = (self.data.loginForm.username || '').trim();
    var password = self.data.loginForm.password || '';
    if (!username || !password) {
      wx.showToast({ title: '请输入账号和密码', icon: 'none' });
      return;
    }
    self._doLogin(username, password, null);
  },

  // 实际登录；storeId 为空先不带，多门店账号会收到 stores 列表 → 弹门店选择后带 store_id 重登
  _doLogin: function (username, password, storeId) {
    var self = this;
    self.setData({ logging: true });
    wx.nextTick(function () { self._recomputeMsgsHeight(); });

    api.login(username, password, storeId).then(function () {
      var app = getApp();
      self.setData({
        user: app.globalData.user,
        logging: false,
        loginForm: { username: '', password: '' },
      });
      wx.nextTick(function () { self._recomputeMsgsHeight(); });
      self._greetLoggedIn(app.globalData.user);
      self._loadQuickActions();
    }).catch(function (err) {
      self.setData({ logging: false });
      wx.nextTick(function () { self._recomputeMsgsHeight(); });
      if (err && err.multiStore && err.stores && err.stores.length) {
        var items = err.stores.map(function (id) { return '门店 ' + id; });
        wx.showActionSheet({
          itemList: items,
          success: function (r) {
            self._doLogin(username, password, err.stores[r.tapIndex]);
          },
          fail: function () { /* 用户取消选择 */ },
        });
        return;
      }
      wx.showToast({ title: (err && err.message) || '登录失败', icon: 'none' });
    });
  },

  // 退出登录：确认后清登录态，回到登录表单
  onLogout: function () {
    var self = this;
    wx.showModal({
      title: '退出登录',
      content: '确定要退出当前账号吗？',
      confirmText: '退出',
      confirmColor: '#E65C46',
      success: function (r) {
        if (!r.confirm) { return; }
        api.logout().then(function () {
          self._sessionId = null;
          self.setData({ user: null, msgs: [], chatInput: '', loginForm: { username: '', password: '' } });
          wx.nextTick(function () { self._recomputeMsgsHeight(); });
          wx.showToast({ title: '已退出', icon: 'none' });
        });
      },
    });
  },

  _scrollDown: function () {
    var self = this;
    self.setData({ scrollAnchor: '' });
    setTimeout(function () { self.setData({ scrollAnchor: 'anchor-bottom' }); }, 30);
  },

  _pushUser: function (text) {
    var msgs = this.data.msgs.concat([{ id: nextId(), from: 'user', text: text }]);
    this.setData({ msgs: msgs });
    this._scrollDown();
  },

  _pushAi: function (text, delay) {
    var self = this;
    delay = delay || 0;
    if (delay > 0) {
      self.setData({ typing: true });
      self._scrollDown();
      setTimeout(function () {
        var msgs = self.data.msgs.concat([{ id: nextId(), from: 'ai', text: text, blocks: mdParse(text) }]);
        self.setData({ msgs: msgs, typing: false });
        self._scrollDown();
      }, delay);
    } else {
      var msgs = self.data.msgs.concat([{ id: nextId(), from: 'ai', text: text, blocks: mdParse(text) }]);
      self.setData({ msgs: msgs });
      self._scrollDown();
    }
  },

  _appendToLastAi: function (text) {
    var msgs = this.data.msgs.slice();
    var last = msgs[msgs.length - 1];
    if (!last || last.from !== 'ai') return;
    var newText = (last.text || '') + text;
    msgs[msgs.length - 1] = { id: last.id, from: 'ai', text: newText, blocks: mdParse(newText) };
    this.setData({ msgs: msgs });
    this._scrollDown();
  },

  // AI 回复成功：渲染 reply 文本并维持会话 id
  _handleAiResult: function (res) {
    this.setData({ typing: false, aiBusy: false });
    if (res && res.session_id) { this._sessionId = res.session_id; }
    // 查询类 intent 的 reply 仅为占位，真实数据在 card_data，优先格式化卡片
    var text = '';
    if (res && res.card_type) {
      text = cardToMarkdown(res.card_type, res.card_data);
    }
    if (!text) {
      text = (res && res.reply ? String(res.reply).trim() : '') || '（空回复）';
    }
    this._pushAi(text);
  },

  // AI 调用失败：登录失效则回到登录态，其它错误内联提示
  _handleAiError: function (err) {
    this.setData({ typing: false, aiBusy: false });
    var msg = (err && err.message) || String(err);
    if (msg === 'Unauthenticated') {
      this.setData({ user: null });
      this._sessionId = null;
      this._pushAi('⚠️ 登录已过期，请在下方重新登录后再聊。');
      this._recomputeMsgsHeight();
      return;
    }
    this._pushAi('❌ AI 暂时不可用：' + msg);
  },

  onSend: function () {
    var self = this;
    var text = (self.data.chatInput || '').trim();
    if (!text || self.data.aiBusy) return;

    self._pushUser(text);
    self.setData({ chatInput: '', aiBusy: true, typing: true });
    self._scrollDown();

    api.aiMessage(text, { sessionId: self._sessionId }).then(function (res) {
      self._handleAiResult(res);
    }).catch(function (err) {
      self._handleAiError(err);
    });
  },
});
