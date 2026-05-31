// utils/api.js
// 全部使用 ES5 风格（function + var，无解构 / 无默认参数 / 无箭头函数），
// 避免微信开发者工具的 ES6→ES5 转译触发 @babel/runtime helper require。

var req = require('./request.js');
var request = req.request;
var login = req.login;
var clearAuth = req.clearAuth;

/**
 * 文字 / 图片 AI 消息 —— 舌尖后端 POST /ai/message
 * @param {string} text  用户文字（图片识别时可传空字符串）
 * @param {object} opts  { imageBase64?, sessionId? }  imageBase64 为原始 base64（无 data: 前缀）
 * @returns {Promise<object>} { reply, intent, operations, card_type, card_data, session_id }
 */
function aiMessage(text, opts) {
  opts = opts || {};
  return request('/ai/message', {
    method: 'POST',
    data: {
      text: text || '',
      image_base64: opts.imageBase64 || undefined,
      session_id: opts.sessionId || undefined,
    },
    timeout: 90000,
  });
}

/**
 * 语音 AI 消息 —— 舌尖后端 POST /ai/voice（multipart，字段名 audio）
 * @param {string} filePath  录音临时文件路径（mp3）
 * @param {number} [sessionId]
 * @returns {Promise<object>} { reply, intent, session_id, ... }
 */
function aiVoice(filePath, sessionId) {
  return new Promise(function (resolve, reject) {
    var app = getApp();
    var token = app.globalData.token || '';
    var base = app.globalData.apiBaseUrl;
    if (!token) { reject(new Error('Unauthenticated')); return; }
    var formData = {};
    if (sessionId) { formData.session_id = sessionId; }
    wx.uploadFile({
      url: base + '/ai/voice',
      filePath: filePath,
      name: 'audio',
      header: {
        Authorization: 'Bearer ' + token,
        Accept: 'application/json',
      },
      formData: formData,
      timeout: 120000,
      success: function (res) {
        if (res.statusCode === 401) { reject(new Error('Unauthenticated')); return; }
        var data = null;
        try { data = JSON.parse(res.data); } catch (e) { /* ignore */ }
        if (res.statusCode < 200 || res.statusCode >= 300) {
          var msg = (data && (data.message || data.reply)) || ('HTTP ' + res.statusCode);
          reject(new Error(msg));
          return;
        }
        if (!data) { reject(new Error('语音响应解析失败')); return; }
        resolve(data);
      },
      fail: function (err) {
        reject(new Error(err && err.errMsg ? err.errMsg : '语音上传失败'));
      },
    });
  });
}

/**
 * 批量录入损耗 —— 舌尖后端 POST /damage/batch
 * @param {Array} items  [{ product_name, qty, reason, notes?, occurred_at?, image_base64?[] }]
 * @returns {Promise<object>} { message, total, success, failed, records, errors }
 */
function damageBatch(items) {
  return request('/damage/batch', {
    method: 'POST',
    data: { items: items || [] },
    timeout: 120000,
  });
}

/**
 * 损耗记录列表 —— 舌尖后端 GET /damage?date=&status=&product_id=&supplier_id=
 * @param {string} date  YYYY-MM-DD（一般传当天）
 * @returns {Promise<object>} Laravel 分页对象 { data:[...], current_page, total, ... }
 */
function damageList(date) {
  return request('/damage', {
    method: 'GET',
    data: date ? { date: date } : {},
    timeout: 20000,
  });
}

/**
 * 上传销售报表（图片/Excel）→ AI 识别（不写库）—— 舌尖后端 POST /sales/upload/recognize
 * multipart：字段名 file；formData 可带 sale_date。
 * @param {string} filePath  图片/文件临时路径
 * @param {object} [opts]     { saleDate?, name? }
 * @returns {Promise<object>} { upload_id, sale_date, items:[{product_name,qty,amount,unit}], summary }
 */
function salesUploadRecognize(filePath, opts) {
  opts = opts || {};
  return new Promise(function (resolve, reject) {
    var app = getApp();
    var token = app.globalData.token || '';
    var base = app.globalData.apiBaseUrl;
    if (!token) { reject(new Error('Unauthenticated')); return; }
    var formData = {};
    if (opts.saleDate) { formData.sale_date = opts.saleDate; }
    wx.uploadFile({
      url: base + '/sales/upload/recognize',
      filePath: filePath,
      name: 'file',
      header: { Authorization: 'Bearer ' + token, Accept: 'application/json' },
      formData: formData,
      timeout: 120000,
      success: function (res) {
        if (res.statusCode === 401) { clearAuth(); reject(new Error('Unauthenticated')); return; }
        var data = null;
        try { data = JSON.parse(res.data); } catch (e) { /* ignore */ }
        if (res.statusCode < 200 || res.statusCode >= 300) {
          var msg = (data && (data.message || data.detail)) || ('HTTP ' + res.statusCode);
          reject(new Error(msg));
          return;
        }
        if (!data) { reject(new Error('识别响应解析失败')); return; }
        resolve(data);
      },
      fail: function (err) {
        reject(new Error(err && err.errMsg ? err.errMsg : '上传失败'));
      },
    });
  });
}

/**
 * 确认识别明细 → 写入今日销售补录 —— 舌尖后端 POST /sales/upload/{id}/commit
 * @param {number} uploadId
 * @param {Array} items  [{ product_name, qty, amount, unit }]
 * @returns {Promise<object>} { message, processed, failed }
 */
function salesUploadCommit(uploadId, items) {
  return request('/sales/upload/' + uploadId + '/commit', {
    method: 'POST',
    data: { items: items || [] },
    timeout: 60000,
  });
}

/**
 * 上传进货单据（图片/Excel）→ AI 识别（不写库）—— POST /purchase-orders/recognize
 * @param {string} filePath
 * @returns {Promise<object>} { items:[{product_name,ordered_qty,unit_price,unit}], summary, image_paths }
 */
function purchaseRecognize(filePath) {
  return new Promise(function (resolve, reject) {
    var app = getApp();
    var token = app.globalData.token || '';
    var base = app.globalData.apiBaseUrl;
    if (!token) { reject(new Error('Unauthenticated')); return; }
    wx.uploadFile({
      url: base + '/purchase-orders/recognize',
      filePath: filePath,
      name: 'file',
      header: { Authorization: 'Bearer ' + token, Accept: 'application/json' },
      timeout: 120000,
      success: function (res) {
        if (res.statusCode === 401) { clearAuth(); reject(new Error('Unauthenticated')); return; }
        var data = null;
        try { data = JSON.parse(res.data); } catch (e) { /* ignore */ }
        if (res.statusCode < 200 || res.statusCode >= 300) {
          var msg = (data && (data.message || data.detail)) || ('HTTP ' + res.statusCode);
          reject(new Error(msg));
          return;
        }
        if (!data) { reject(new Error('识别响应解析失败')); return; }
        resolve(data);
      },
      fail: function (err) {
        reject(new Error(err && err.errMsg ? err.errMsg : '上传失败'));
      },
    });
  });
}

/**
 * 确认进货明细 → 入库（建单+收货+加库存）—— POST /purchase-orders
 * @param {object} data  { date, items:[{product_name,ordered_qty,unit_price,unit}], image_paths }
 */
function purchaseCommit(data) {
  return request('/purchase-orders', { method: 'POST', data: data || {}, timeout: 60000 });
}

/**
 * 历史进货单列表 —— GET /purchase-orders?date=&status=
 * @returns {Promise<object>} Laravel 分页对象 { data:[...], ... }
 */
function purchaseList(params) {
  return request('/purchase-orders', { method: 'GET', data: params || {}, timeout: 20000 });
}

// 校验当前 token 是否有效（401 时 request() 会自动 clearAuth 并抛 Unauthenticated）
function me() {
  return request('/me', { method: 'GET', timeout: 15000 });
}

// 聊天页底部快捷按钮配置（后台可配）——返回 { data: [ ...quickActions ] }
function quickActions() {
  return request('/quick-actions', { method: 'GET', timeout: 15000 });
}

// 公开应用配置（小程序标题等品牌文案）——无需登录，返回 { data: { key: value } }
function appConfig() {
  return request('/app-config', { method: 'GET', timeout: 15000 });
}

// 退出登录：尽力通知后端使 token 失效，无论成败都清掉本地登录态
function logout() {
  return request('/logout', { method: 'POST', timeout: 10000 })
    .catch(function () { /* 忽略网络/401 错误 */ })
    .then(function () { clearAuth(); });
}

module.exports = {
  login: login,
  me: me,
  logout: logout,
  quickActions: quickActions,
  appConfig: appConfig,
  aiMessage: aiMessage,
  aiVoice: aiVoice,
  damageBatch: damageBatch,
  damageList: damageList,
  salesUploadRecognize: salesUploadRecognize,
  salesUploadCommit: salesUploadCommit,
  purchaseRecognize: purchaseRecognize,
  purchaseCommit: purchaseCommit,
  purchaseList: purchaseList,
};
