(function () {
  'use strict';

  var BROWSE = 'https://steamcommunity.com/workshop/browse/?appid=431960';
  var API = 'https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/';
  var N = (typeof QW !== 'undefined') ? QW : null;
  var st = { sort: 'trend', types: ['Scene', 'Video', 'Web'], cats: ['Wallpaper', 'Preset', 'Resource'], ages: ['g'], cols: 4, page: 1, list: [], q: '', totalPages: 0, totalCount: 0 };
  var SORTS = {
    trend: { s: 'trend', d: 0 },
    toprated: { s: 'toprated', d: 0 },
    mostrecent: { s: 'mostrecent', d: 0 },
    lastupdated: { s: 'lastupdated', d: 0 }
  };
  var vList = [], vIdx = 0, vScale = 1, vX = 0, vY = 0;

  function $(id) { return document.getElementById(id); }

  /* 任何脚本错误都显示出来，避免“看起来卡死却说不出原因” */
  window.onerror = function (msg, src, line, col) {
    try {
      var bar = document.getElementById('qwErrBar');
      if (!bar) {
        bar = document.createElement('div');
        bar.id = 'qwErrBar';
        bar.setAttribute('onclick', 'this.style.display=\'none\'');
        document.body.appendChild(bar);
      }
      bar.style.display = 'block';
      bar.textContent = '脚本错误：' + msg + '  @' + String(src || '').split('/').pop() + ':' + line + '（点这条可关闭）';
    } catch (e) {}
    return false;
  };

  /* 安全绑定：元素不存在也不抛错，避免一处异常导致整屏按钮全失效 */
  function on(id, fn) {
    var el = typeof id === 'string' ? document.getElementById(id) : id;
    if (el) el.onclick = fn;
    return el;
  }
  function safe(name, fn) {
    try { fn(); } catch (e) {
      try { console.log('INIT_FAIL ' + name + ' ' + (e && e.message ? e.message : e)); } catch (e2) {}
    }
  }
  function qs(s) { return document.querySelector(s); }

  function esc(s) {
    var t = String(s === null || s === undefined ? '' : s);
    return t.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&#34;').replace(/'/g, '&#39;');
  }

  function clearToasts() {
    var w = $('toasts');
    if (w) w.innerHTML = '';
  }

  function toast(msg, ms) {
    var wrap = $('toasts');
    if (!wrap) return;
    while (wrap.children.length >= 2) wrap.removeChild(wrap.firstChild);
    var d = document.createElement('div');
    d.className = 'toast';
    d.textContent = msg;
    wrap.appendChild(d);
    setTimeout(function () {
      d.style.transition = 'opacity .25s';
      d.style.opacity = '0';
      setTimeout(function () { if (d.parentNode) d.parentNode.removeChild(d); }, 260);
    }, ms || 2400);
  }

  function fmtSize(b) {
    b = Number(b) || 0;
    if (!b) return '—';
    var u = ['B', 'KB', 'MB', 'GB', 'TB'], i = 0;
    while (b >= 1024 && i < u.length - 1) { b /= 1024; i++; }
    return (i === 0 ? b : b.toFixed(b < 10 ? 2 : 1)) + ' ' + u[i];
  }

  function fmtDate(t) {
    var n = Number(t) || 0;
    if (!n) return '—';
    var d = new Date(n * 1000);
    if (isNaN(d.getTime())) return '—';
    function p(x) { return (x < 10 ? '0' : '') + x; }
    return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate());
  }

  function visName(v) {
    var m = { 0: '公开', 1: '仅好友', 2: '私有', 3: '未列出' };
    return m[v] || '未知';
  }

  function copyText(text) {
    try {
      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text);
        return true;
      }
    } catch (e) {}
    try {
      var ta = document.createElement('textarea');
      ta.value = text;
      ta.style.cssText = 'position:fixed;left:-9999px;top:0';
      document.body.appendChild(ta);
      ta.select();
      var ok = document.execCommand('copy');
      document.body.removeChild(ta);
      return ok;
    } catch (e2) { return false; }
  }

  function nativeReady() {
    if (!N && typeof window.QW !== 'undefined' && window.QW) N = window.QW;
    return !!(N && typeof N.httpGet === 'function');
  }

  function probe(m) {
    try { if (N && N.probe) N.probe(String(m)); } catch (e) {}
    try { console.log(m); } catch (e) {}
  }

  function httpGet(url) {
    if (!nativeReady()) throw new Error('原生桥未就绪');
    var raw = N.httpGet(url);
    if (raw === null || raw === undefined || raw === '') throw new Error('空响应');
    if (raw.charAt(0) === '{') {
      var j = null;
      try { j = JSON.parse(raw); } catch (e) {}
      if (j && j.ok === false) throw new Error(j.err || '请求失败');
    }
    return raw;
  }

  function httpPost(url, body) {
    if (!nativeReady()) throw new Error('原生桥未就绪');
    var raw = N.httpPost(url, body);
    var j = null;
    try { j = JSON.parse(raw); } catch (e) { throw new Error('接口返回异常：' + String(raw).slice(0, 140)); }
    if (j && j.ok === false) throw new Error(j.err || '请求失败');
    return j;
  }

  function fetchDetail(id) {
    var j = httpPost(API, 'itemcount=1&publishedfileids[0]=' + encodeURIComponent(id));
    var list = (j && j.response && j.response.publishedfiledetails) || [];
    if (!list.length) throw new Error('接口没有返回作品');
    var d = list[0];
    if (d.result && d.result !== 1) throw new Error('作品不可见（result=' + d.result + '）');
    return d;
  }

  function browseUrl(p) {
    var s = SORTS[st.sort] || SORTS.trend;
    var u = BROWSE + '&browsesort=' + s.s + '&section=readytouseitems&p=' + p;
    if (s.d) u += '&days=' + s.d;
    if (st.q) u += '&searchtext=' + encodeURIComponent(st.q);
    u = addTagGroup(u, ['Scene', 'Video', 'Web'], st.types || []);
    u = addTagGroup(u, ['Wallpaper', 'Preset', 'Resource'], st.cats || []);
    var AGE = { g: 'Everyone', m: 'Questionable', a: 'Mature' };
    var ag = st.ages || [], asel = [];
    for (var i = 0; i < ag.length; i++) { if (AGE[ag[i]]) asel.push(AGE[ag[i]]); }
    u = addTagGroup(u, ['Everyone', 'Questionable', 'Mature'], asel);
    return u;
  }

  /* 组内多选：全选＝不限；单项用 requiredtags（精确）；多项排除未选的（等价 OR） */
  function addTagGroup(u, all, sel) {
    if (!sel.length || sel.length >= all.length) return u;
    if (sel.length === 1) return u + '&requiredtags%5B%5D=' + encodeURIComponent(sel[0]);
    for (var i = 0; i < all.length; i++) {
      if (sel.indexOf(all[i]) < 0) u += '&excludedtags%5B%5D=' + encodeURIComponent(all[i]);
    }
    return u;
  }

  var TAGMAP = { 'Video': '视频', 'Scene': '场景', 'Web': '网页', 'Application': '应用', 'Wallpaper': '壁纸', 'Anime': '动漫', 'Preset': '预设', 'Resource': '资源', 'Girls': '女性', 'Girlhood': '少女' };
  var TAGSKIP = { 'Everyone': 1, 'Approved': 1, 'Other resolution': 1, 'Wallpaper': 1 };

  function unesc(t) {
    return String(t == null ? '' : t)
      .replace(/\\u([0-9a-fA-F]{4})/g, function (_, h) { return String.fromCharCode(parseInt(h, 16)); })
      .replace(/\\n/g, ' ').replace(/\\r/g, ' ').replace(/\\t/g, ' ')
      .replace(/\\\//g, '/').replace(/\\"/g, '"').replace(/\\\\/g, '\\');
  }

  function findArr(html) {
    var s = html.indexOf('results');
    while (s >= 0) {
      var b = html.indexOf('[', s);
      if (b >= 0 && b - s < 24) return b;
      s = html.indexOf('results', s + 1);
    }
    return -1;
  }

  function pickTag(tags) {
    for (var i = 0; i < tags.length; i++) {
      var v = String(tags[i] || '').trim();
      if (!v || TAGSKIP[v]) continue;
      if (/^\d+\s*x\s*\d+$/i.test(v)) continue;
      return TAGMAP[v] || v;
    }
    return '';
  }

  function parsePage(html) {
    var items = [], tp = 0, tc = 0;
    var m1 = html.match(/total_pages\D{1,8}(\d+)/);
    var m2 = html.match(/total_count\D{1,8}(\d+)/);
    if (m1) tp = parseInt(m1[1], 10) || 0;
    if (m2) tc = parseInt(m2[1], 10) || 0;

    var b = findArr(html);
    if (b >= 0) {
      var d = 0, q = false, esc = false, end = -1;
      for (var k = b; k < html.length; k++) {
        var c = html.charAt(k);
        if (q) {
          if (c === '"') q = false;
        } else {
          if (c === '"') q = true;
          else if (c === '[') d++;
          else if (c === ']') { d--; if (d === 0) { end = k; break; } }
        }
      }
      if (end > b) {
        try {
          var arr = JSON.parse(unesc(html.slice(b, end + 1)));
          for (var i = 0; i < arr.length; i++) {
            var r = arr[i];
            if (!r || !r.publishedfileid) continue;
            var tg = [];
            if (r.tags) for (var t = 0; t < r.tags.length; t++) tg.push(r.tags[t].display_name || r.tags[t].tag || '');
            items.push({
              id: String(r.publishedfileid),
              title: unesc(r.title || ''),
              img: r.preview_url || '',
              desc: unesc(r.short_description || ''),
              tag: pickTag(tg),
              subs: r.subscriptions || 0
            });
          }
        } catch (e) { items = []; }
      }
    }

    if (!items.length) {
      var reG = /publishedfileid\W{1,8}(\d{5,})/g, mm, seen = {};
      while ((mm = reG.exec(html))) {
        var id = mm[1];
        if (seen[id]) continue;
        seen[id] = 1;
        var seg = html.slice(mm.index, Math.min(html.length, mm.index + 2400));
        var tm = seg.match(/title\W{1,8}([^"\\]{0,200})/);
        var pm = seg.match(/preview_url\W{1,8}([^"\\]{0,300})/);
        var dm = seg.match(/short_description\W{1,8}([^"\\]{0,400})/);
        items.push({
          id: id,
          title: unesc(tm ? tm[1] : '') || ('作品 ' + id),
          img: unesc(pm ? pm[1] : ''),
          desc: unesc(dm ? dm[1] : ''),
          tag: '',
          subs: 0
        });
        if (items.length >= 30) break;
      }
    }
    return { items: items, totalPages: tp, totalCount: tc };
  }

  function parseList(html) { return parsePage(html).items; }

  /* 缩略图降尺寸：Steam CDN 支持 imw/imh，把封面裁到 320×180，老手机省内存省解码 */
  function thumbSrc(u) {
    var s = String(u || '');
    if (!s) return '';
    if (s.indexOf('steamusercontent') < 0 && s.indexOf('steamstatic') < 0) return s;
    try {
      if (/[?&]imw=/.test(s)) s = s.replace(/([?&])imw=\d+/, '$1imw=320');
      else s += (s.indexOf('?') >= 0 ? '&' : '?') + 'imw=320';
      if (/[?&]imh=/.test(s)) s = s.replace(/([?&])imh=\d+/, '$1imh=180');
      else s += '&imh=180';
    } catch (e) {}
    return s;
  }

  var LAZY_GIF = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';
  var lazyIO = null;
  function initLazy() {
    if (lazyIO) return true;
    if (!window.IntersectionObserver) return false;
    lazyIO = new IntersectionObserver(function (es) {
      for (var i = 0; i < es.length; i++) {
        var e = es[i];
        if (!e.isIntersecting) continue;
        var im = e.target, u = im.getAttribute('data-src');
        if (u) { im.src = u; im.removeAttribute('data-src'); }
        try { lazyIO.unobserve(im); } catch (e2) {}
      }
    }, { rootMargin: '400px 0px' });
    return true;
  }
  function lazyBind(root) {
    if (!lazyIO || !root || !root.querySelectorAll) return;
    var ims = root.querySelectorAll('img[data-src]');
    for (var i = 0; i < ims.length; i++) { try { lazyIO.observe(ims[i]); } catch (e) {} }
  }

  function cardHtml(it, i, lz) {
    var src = thumbSrc(it.img);
    var im = '';
    if (src) {
      im = lz
        ? '<img loading="lazy" decoding="async" src="' + LAZY_GIF + '" data-src="' + esc(src) + '" alt="">'
        : '<img loading="lazy" decoding="async" src="' + esc(src) + '" alt="">';
    } else {
      im = '<div class="th-empty">⌁</div>';
    }
    return '<article class="card" data-i="' + i + '" data-id="' + esc(it.id) + '">'
      + '<div class="thumb">'
      + im
      + (it.tag ? '<span class="ctag">' + esc(it.tag) + '</span>' : '')
      + '</div>'
      + '<div class="ttl">' + esc(it.title) + '</div>'
      + '<div class="desc">' + esc(it.desc || (it.subs ? '订阅 ' + fmtNum(it.subs) : '暂无简介')) + '</div>'
      + '</article>';
  }

  function render() {
    var g = $('grid');
    if (!st.list.length) {
      g.innerHTML = '<div class="empty">这一页没有作品。换个筛选条件，或检查网络/登录状态。</div>';
      return;
    }
    var h = '';
    var lz = initLazy();
    for (var i = 0; i < st.list.length; i++) h += cardHtml(st.list[i], i, lz);
    g.innerHTML = h;
    if (lz) lazyBind(g);
  }

  function showErr(msg) {
    $('errBar').classList.remove('hide');
    $('errTxt').textContent = msg;
  }
  function clearErr() { $('errBar').classList.add('hide'); }

  function loadList() {
    clearErr();
    $('grid').innerHTML = '<div class="empty">正在连接 Steam…<br><span style="font-size:12px;color:#5f6c7d">若长时间无响应：请开加速器后点下面「点击刷新」，或先到设置里登录</span></div>';
    setTimeout(function () {
      try {
        var html = httpGet(browseUrl(st.page));
        probe('HTML_LEN=' + (html ? html.length : -1) + ' p=' + st.page);
        var pg = parsePage(html);
        var items = pg.items;
        probe('PARSE n=' + items.length + ' tp=' + pg.totalPages + ' tc=' + pg.totalCount);
        if (!items.length) throw new Error('没有解析到作品（换个关键词/筛选，或先登录 Steam）');
        st.list = items;
        st.totalPages = pg.totalPages || 0;
        st.totalCount = pg.totalCount || 0;
        render();
        updatePager();
        probe('LIST_OK n=' + items.length + ' first=' + items[0].id);
      } catch (e) {
        probe('LIST_FAIL ' + (e && e.message ? e.message : e));
        st.list = [];
        $('grid').innerHTML = '<div class="empty">没有内容</div>';
        showErr('加载失败：' + (e.message || '未知错误'));
      }
    }, 30);
  }

  function fmtNum(n) { return String(n).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }

  function updatePager() {
    var t = '第 ' + st.page + ' 页';
    if (st.totalPages) t += ' / 共 ' + st.totalPages + ' 页';
    if (st.totalCount) t += ' · ' + fmtNum(st.totalCount) + ' 个作品';
    $('pgInfo').textContent = t;
    $('pgPrev').disabled = st.page <= 1;
    $('pgNext').disabled = !!(st.totalPages && st.page >= st.totalPages);
  }

  function applyCols(n, persist) {
    n = parseInt(n, 10);
    if (!n || n < 1) n = 4;
    if (n > 8) n = 8;
    st.cols = n;
    if (persist !== false) { try { localStorage.setItem('qw_cols', String(n)); } catch (e) {} }
    $('grid').style.gridTemplateColumns = 'repeat(' + n + ',minmax(0,1fr))';
    var chips = document.querySelectorAll('#cCols .chip');
    for (var i = 0; i < chips.length; i++) {
      var v = chips[i].getAttribute('data-v');
      var on = (String(n) === v) || (v === 'custom' && (n === 1 || n > 4));
      chips[i].classList.toggle('on', on);
    }
    $('colCustomWrap').classList.toggle('hide', !(n === 1 || n > 4));
    $('colCustom').value = n;
  }

  function bigImg(u) {
    if (!u) return '';
    return String(u).split('?')[0];
  }

  function applyT() {
    $('vImg').style.transform = 'translate(' + vX + 'px,' + vY + 'px) scale(' + vScale + ')';
  }

  function openViewer(list, idx) {
    vList = list || [];
    vIdx = idx || 0;
    vScale = 1; vX = 0; vY = 0;
    applyT();
    showViewerFrame();
  }

  function showViewerFrame() {
    var it = vList[vIdx];
    if (!it) return;
    $('vImg').src = bigImg(it.img || it.preview_url || '');
    $('vIdx').textContent = (vIdx + 1) + ' / ' + vList.length;
    $('viewer').classList.remove('hide');
    window.__vwAt = Date.now();
    window.__lastOverlay = 'viewer';
    vScale = 1; vX = 0; vY = 0;
    applyT();
  }

  function openDetail(id) {
    window.__dtAt = Date.now();
    window.__dtId = String(id);
    var it = null;
    for (var i = 0; i < st.list.length; i++) if (st.list[i].id === id) { it = st.list[i]; break; }
    if (!it) it = { id: id, title: '作品 ' + id, img: '' };
    $('detailTitle').textContent = it.title;
    $('detailBody').innerHTML = '<div class="empty">读取详情中…</div>';
    $('detailFoot').innerHTML = '';
    $('detail').classList.remove('hide');
    setTimeout(function () {
      /* 竞态保护：快速连点两张卡片时，只渲染最后一次点击的作品 */
      if (String(window.__dtId) !== String(id)) return;
      try {
        var d = fetchDetail(id);
        if (String(window.__dtId) !== String(id)) return;
        renderDetail(d, it);
      } catch (e) {
        if (String(window.__dtId) !== String(id)) return;
        renderDetailBasic(it, e.message);
      }
    }, 30);
  }

  function closeDetail() {
    if (Date.now() - (window.__dtAt || 0) < 400) return;
    $('detail').classList.add('hide');
    var v = $('viewer');
    if (v) v.classList.add('hide');
    $('detailBody').innerHTML = '';
    $('detailFoot').innerHTML = '';
  }

  var curDetail = { id: '', img: '' };
  var heroHintTimer = 0;

  function heroHint() {
    if (heroHintTimer) return;
    heroHintTimer = setTimeout(function () {
      heroHintTimer = 0;
      toast('双击图片可放大查看原图', 2000);
    }, 260);
  }

  function renderDetailBasic(it, err) {
    var img = bigImg(it.img);
    curDetail = { id: it.id, img: img, title: it.title || ('作品 ' + it.id), tag: it.tag || '' };
    var h = (img ? '<img class="dhero" id="dHero" src="' + esc(img) + '" alt="">' : '')
      + '<div class="kv"><b>作品 ID</b><span>' + esc(it.id) + '</span></div>'
      + (err ? '<p class="tip" style="color:#ff8a8a">详情读取失败：' + esc(err) + '</p>' : '');
    h += dtip();
    $('detailBody').innerHTML = h;
    $('detailFoot').innerHTML = drowHtml(it.id, it.img, false, it.tag);
  }

  function renderDetail(d, it) {
    var img = bigImg(d.preview_url || (it ? it.img : ''));
    curDetail = { id: String(d.publishedfileid || (it ? it.id : '')), img: img, title: (d.title || (it ? it.title : '') || ''), hcontent_file: String(d.hcontent_file || ''), file_size: d.file_size || '', tag: ((it && it.tag) || '') };
    var h = '';
    if (img) h += '<img class="dhero" id="dHero" src="' + esc(img) + '" alt="">';
    h += '<div class="kv">'
      + '<b>作品 ID</b><span>' + esc(d.publishedfileid || '') + '</span>'
      + '<b>文件大小</b><span>' + (d.file_size ? fmtSize(d.file_size) : '未知') + '</span>'
      + '<b>创建时间</b><span>' + fmtDate(d.time_created) + '</span>'
      + '<b>更新时间</b><span>' + fmtDate(d.time_updated) + '</span>'
      + '<b>订阅数</b><span>' + (d.subscriptions != null ? d.subscriptions : '—') + '</span>'
      + '<b>评分</b><span>' + (d.vote_data && d.vote_data.score != null
        ? (Math.round(d.vote_data.score * 100) + '%（' + d.vote_data.votes_up + ' 赞 / ' + d.vote_data.votes_down + ' 踩）')
        : '—') + '</span>'
      + '<b>可见性</b><span>' + visName(d.visibility) + '</span>'
      + '</div>';
    if (d.description) h += '<div class="desc">' + esc(d.description) + '</div>';
    h += dtip();
    $('detailBody').innerHTML = h;
    $('detailFoot').innerHTML = drowHtml(d.publishedfileid, img, true, (it && it.tag) || curDetail.tag);
  }

  function dtip() {
    return '<p class="tip">单击图片看提示，双击看大图。封面与作品文件都从顶栏 ⤓ 进入下载列表。「下载封面」无需登录；「下载原项目」需先登录 Steam 账号，成品存到 /storage/emulated/0/QW-Workshop/&lt;作品ID&gt;/ 目录。</p>';
  }

  function drowHtml(id, img, full, tag) {
    var isScene = String(tag || '') === '场景';
    return '<div class="drow">'
      + '<button class="btn mini" data-act="steam" data-id="' + esc(id) + '">在 Steam 打开</button>'
      + '<button class="btn mini" data-act="copy" data-id="' + esc(id) + '">复制链接</button>'
      + (img ? '<button class="btn mini" data-act="save" data-id="' + esc(id) + '" data-img="' + esc(img) + '">下载封面</button>' : '')
      + '<button class="btn mini" data-act="dl" data-id="' + esc(id) + '">下载原项目</button>'
      + (isScene ? '<span class="tip" style="align-self:center;margin:0 0 0 8px;font-size:13px;opacity:.75">可提取项目中的图片</span>' : '')
      + '</div>';
  }

  /* ---------------- 抽屉 ---------------- */

  function extOf(u) {
    var m = String(u || '').match(/\.(jpe?g|png|gif|webp|mp4|webm)(\?|$)/i);
    return m ? ('.' + m[1].toLowerCase()) : '.jpg';
  }

  /* ---- 存储权限：点下载前先确认能写，没权限就自动跳系统授权页 ---- */
  var __pendSave = null;

  function ensureStorage(onReady) {
    try {
      if (!nativeReady() || typeof N.storageState !== 'function') return true;
      if (String(N.storageState() || 'ok') === 'ok') return true;
      /* 防打扰：12 小时内已跳过授权页仍未授权，就不再反复弹，直接存应用专属目录 */
      var last = 0;
      try { last = parseInt(localStorage.getItem('qw_ask_s') || '0', 10) || 0; } catch (e3) { last = 0; }
      if (last && (Date.now() - last) < 43200000) {
        toast('未获得「所有文件访问权限」，本次存到应用专属目录', 3200);
        return true;
      }
      try { localStorage.setItem('qw_ask_s', String(Date.now())); } catch (e4) {}
      __pendSave = (typeof onReady === 'function') ? onReady : null;
      toast('需要「所有文件访问权限」才能保存，已打开系统授权页；开启后返回会自动继续', 5200);
      try { N.askStorage(); } catch (e1) {}
      return false;
    } catch (e2) { return true; }
  }

  /* 从系统授权页返回 App 时，如果已经授权就把刚才那次下载接着做掉 */
  document.addEventListener('visibilitychange', function () {
    try {
      if (document.visibilityState !== 'visible') return;
      if (!__pendSave) return;
      var f = __pendSave;
      if (!nativeReady() || typeof N.storageState !== 'function') { __pendSave = null; return; }
      if (String(N.storageState() || '') !== 'ok') return;
      __pendSave = null;
      toast('已获得文件权限，继续下载');
      try { f(); } catch (e) { toast('继续下载失败：' + (e && e.message ? e.message : e), 3200); }
    } catch (e0) {}
  });

  function saveCover(url, id) {
    if (!url) { toast('没有可保存的封面地址'); return; }
    if (!ensureStorage(function () { saveCover(url, id); })) return;
    if (!nativeReady()) { toast('原生桥未就绪'); return; }
    var name = 'qw_' + (id || Date.now()) + extOf(url);
    dlAdd({
      key: 'f' + name,
      title: (curDetail.title || ('封面 ' + id)),
      img: url,
      kind: 'cover',
      url: url,
      sub: id ? String(id) : '',
      file: name
    });
    setTimeout(openDl, 90);
    toast('已加入下载列表：' + name, 2200);
  }

  /* ---------------- 下载列表 ---------------- */

  var dlTasks = [];
  var dlTimer = 0;
  var dlOpenedAt = 0;

  function dlLoad(force) {
    if (!force && dlTasks && dlTasks.length) return;
    try {
      var a = JSON.parse(localStorage.getItem('qw_dl') || '[]');
      dlTasks = (a && a.length) ? a : [];
      for (var i0 = 0; i0 < dlTasks.length; i0++) {
        if (!dlTasks[i0].sub && dlTasks[i0].item) dlTasks[i0].sub = String(dlTasks[i0].item);
        /* 老记录可能没有 item 字段，用 sub / key 补回来（「提取图片」判断要用） */
        if (!dlTasks[i0].item && dlTasks[i0].sub) dlTasks[i0].item = String(dlTasks[i0].sub);
        if (!dlTasks[i0].item) {
          var km = String(dlTasks[i0].key || '').match(/^i(\d{4,})$/);
          if (km) dlTasks[i0].item = km[1];
        }
      }
    } catch (e) { dlTasks = []; }
  }

  function dlInitOnce() {
    try {
      var a = JSON.parse(localStorage.getItem('qw_dl') || '[]') || [];
      var ch = 0;
      for (var i = 0; i < a.length; i++) {
        if (a[i].status === 2 || a[i].status === 1) { a[i].status = 16; a[i].err = '上次进度已中断'; ch = 1; }
      }
      if (ch) localStorage.setItem('qw_dl', JSON.stringify(a));
    } catch (e) {}
  }

  function dlSave() {
    try {
      var out = [];
      var src = dlTasks;
      /* 上限 200 条：localStorage 约 5MB，长列表会静默写失败导致记录全丢 */
      if (src.length > 200) src = src.slice(src.length - 200);
      for (var i = 0; i < src.length; i++) {
        var t = src[i];
        out.push({ key: t.key, title: t.title, img: t.img, kind: t.kind, url: t.url, file: t.file || '', path: t.path, sub: t.sub || '',
                   item: t.item || '', manifest: t.manifest || '', tag: t.tag || '',
                   total: t.total || 0, done: t.done || 0, status: t.status || 0, err: t.err || '' });
      }
      localStorage.setItem('qw_dl', JSON.stringify(out));
    } catch (e) {}
  }

  function fmtBytes(n) {
    n = Number(n) || 0;
    if (n >= 1073741824) return (n / 1073741824).toFixed(2) + ' GB';
    if (n >= 1048576) return (n / 1048576).toFixed(1) + ' MB';
    if (n >= 1024) return Math.round(n / 1024) + ' KB';
    return n + ' B';
  }

  function dlAdd(t) {
    try {
      dlLoad();
      var found = null;
      for (var i = 0; i < dlTasks.length; i++) if (dlTasks[i].key === t.key) found = dlTasks[i];
      if (found) { renderDl(); return; }
      t.total = 0; t.done = 0; t.status = 1; t.err = '';
      dlTasks.push(t);
      dlSave();
      renderDl();
      dlRun(t);
    } catch (e) {
      dbg('dl', 'dlAdd: ' + (e && e.message ? e.message : e));
      toast('加入下载列表失败：' + (e && e.message ? e.message : e), 3000);
    }
  }

  function dlRun(t) {
    if (t.kind === 'item') { return dlRunItem(t); }
    if (!t.url) { t.status = 16; t.err = '缺少地址'; renderDl(); return; }
    if (!t.file) { t.file = 'qw_' + Date.now() + '.bin'; }
    var start = 0;
    try { start = parseInt(N.fileLen(dlPath(t)), 10) || 0; } catch (e4) { start = 0; }
    if (t.total > 0 && start >= t.total) { t.status = 8; t.done = start; dlSave(); renderDl(); return; }
    t.status = 2; t.err = ''; t.done = start;
    renderDl();

    var ctl = { stop: false, reader: null };
    t._c = ctl;
    var hdr = {};
    if (start > 0) hdr['Range'] = 'bytes=' + start + '-';

    fetch(t.url, { headers: hdr, cache: 'no-store' }).then(function (res) {
      if (start > 0 && res.status === 200) {
        try { N.resetFile(dlPath(t)); } catch (e5) {}
        t.done = start = 0;
      }
      if (!res.ok && res.status !== 206) throw new Error('HTTP ' + res.status);
      var total = 0;
      var cr = res.headers.get('content-range');
      if (cr) { var m = cr.match(/\/(\d+)/); if (m) total = parseInt(m[1], 10); }
      if (!total) {
        var cl = res.headers.get('content-length');
        if (cl) total = start + (parseInt(cl, 10) || 0);
      }
      if (total > 0) { t.total = total; renderDl(); }
      var reader = res.body.getReader();
      ctl.reader = reader;

      function pump() {
        return reader.read().then(function (r) {
          if (ctl.stop) throw new Error('aborted');
          if (r.done) {
            t.status = 8; t.done = t.total > 0 ? t.total : start; dlSave(); renderDl(); return;
          }
          var ch = r.value;
          var str = '', CH = 0x8000;
          for (var i2 = 0; i2 < ch.length; i2 += CH) {
            str += String.fromCharCode.apply(null, ch.subarray(i2, i2 + CH));
          }
          var rr = String(N.appendBytes(dlPath(t), btoa(str)) || '');
          if (rr.indexOf('ok') !== 0) throw new Error(rr);
          t.done = (Number(t.done) || 0) + ch.length;
          renderDl();
          return pump();
        });
      }
      return pump();
    }).catch(function (e) {
      t._c = null;
      var msg = (e && e.message) ? e.message : String(e);
      if (msg.indexOf('aborted') >= 0) { t.status = 16; t.err = '已暂停'; }
      else if (msg.indexOf('ENOENT') >= 0 || msg.indexOf('EACCES') >= 0 || msg.indexOf('Permission denied') >= 0) {
        t.status = 16;
        t.err = '无法写入 QW-Workshop 目录：缺少文件权限（已弹出授权页，开启后点「重试」）';
        try { if (nativeReady() && N.askStorage) N.askStorage(); } catch (e8) {}
      }
      else { t.status = 16; t.err = msg + (t.done > 0 ? '（可继续）' : ''); }
      dlSave(); renderDl();
    });
  }

  function dlPause(t) {
    if (t._c) {
      t._c.stop = true;
      try { if (t._c.reader) t._c.reader.cancel(); } catch (e) {}
      t._c = null;
    }
    t.status = 16; t.err = '已暂停'; dlSave(); renderDl();
  }

function qwAutoMove(t) {
    var id0 = (t && (t.item || t.id)) || '';
    if (!id0) return;
    var k = 'qw_mv_' + id0;
    try { if (localStorage.getItem(k) === '1') return; } catch (e0) {}
    try {
      if (nativeReady() && N.moveDone) { N.moveDone(String(id0)); localStorage.setItem(k, '1'); }
    } catch (e1) {}
  }
function copyAllDone() {
  try {
    var n = 0;
    for (var i = 0; i < dlTasks.length; i++) {
      var t = dlTasks[i];
      if (t && t.status === 8 && t.item) { t._saf = false; qwSafCopy(t); n++; }
    }
    renderDl();
    if (!n) toast('当前没有已完成的任务', 2600);
  } catch (e) {}
}
function qwSafCopy(t) {
  try {
    if (t._saf || !t.item) return;
    t._saf = true;
    var id = String(t.item || '');
    t._safmsg = id ? ('已存到 QW-Workshop/' + id + '/') : '已存到 QW-Workshop/';
  } catch (e) {}
}
function qwArchiveAll() {}

function dlStatusText(t) {
    if (t.kind === 'item') {
      if (t.status === 8) { qwSafCopy(t); return '已完成 · ' + fmtBytes(t.total || t.done) + (t._safmsg ? ' · ' + t._safmsg : ''); }
      if (t.status === 16) return (t.err || '已中断') + (t.done > 0 ? ' · 已下 ' + fmtBytes(t.done) : '');
      var np = (t.total > 0) ? Math.floor(t.done * 100 / t.total) : 0;
      return (t.phase || '准备中…') + (t.total > 0 ? ' · ' + np + '% · ' + fmtBytes(t.done) + ' / ' + fmtBytes(t.total) : '');
    }
    if (t.status === 8) return '已完成 · ' + fmtBytes(t.total || t.done);
    if (t.status === 16) {
      if (t.err === '已暂停') return '已暂停 · ' + fmtBytes(t.done) + (t.total > 0 ? ' / ' + fmtBytes(t.total) : '') + '（可继续）';
      return '失败 / 已取消' + (t.err ? '：' + t.err : '');
    }
    if (t.status === 1) return '排队中…';
    var p = (t.total > 0) ? Math.floor(t.done * 100 / t.total) : 0;
    if (!t.total) return '连接中… ' + fmtBytes(t.done);
    return p + '% · ' + fmtBytes(t.done) + ' / ' + fmtBytes(t.total);
  }

  function dlPct(t) {
    if (t.status === 8) return 100;
    if (t.total > 0) return Math.min(100, Math.floor(t.done * 100 / t.total));
    return 0;
  }

  /* ---- 下载列表多选 ---- */
  var dlSelOn = false, dlSel = {};

  function dlSelCount() {
    var n = 0;
    for (var k in dlSel) if (dlSel[k]) n++;
    return n;
  }

  function dlSelSync() {
    var d = $('dlSelDel'), c = $('dlSelCancel');
    if (d) { d.classList.toggle('hide', !dlSelOn); d.textContent = '删除选中(' + dlSelCount() + ')'; }
    if (c) c.classList.toggle('hide', !dlSelOn);
    var b = $('dlList');
    if (b) b.className = 'dls-list' + (dlSelOn ? ' sel' : '');
  }

  function dlSelEnter(k) {
    dlSelOn = true; dlSel = {};
    if (k) dlSel[k] = 1;
    renderDl(); dlSelSync();
  }

  function dlSelClear() {
    dlSelOn = false; dlSel = {};
    renderDl(); dlSelSync();
  }

  function dlSelToggle(k) {
    if (!k) return;
    if (dlSel[k]) delete dlSel[k]; else dlSel[k] = 1;
    renderDl(); dlSelSync();
  }

  /* ---------- 删除确认（可选同时删本地文件） ---------- */
  var cfmCb = null, cfmChkOn = false;

  function avatarInit(s) {
    s = String(s || '').trim();
    if (!s) return '?';
    var c = s.charAt(0);
    return c.toUpperCase();
  }

  function cfmOpen(sub, onOk) {
    var m = $('cfmMask');
    if (!m) { try { onOk(false); } catch (e0) {} return; }
    cfmCb = onOk; cfmChkOn = false;
    var s = $('cfmSub'); if (s) s.textContent = sub;
    var c = $('cfmChk'); if (c) c.classList.remove('on');
    clearToasts();
    m.classList.remove('hide');
  }

  function cfmClose() {
    var m = $('cfmMask'); if (m) m.classList.add('hide');
    cfmCb = null; cfmChkOn = false;
  }

  function cfmInit() {
    var c = $('cfmChk');
    if (c) c.onclick = function () { cfmChkOn = !cfmChkOn; this.classList.toggle('on', cfmChkOn); };
    var no = $('cfmNo'); if (no) no.onclick = function () { cfmClose(); };
    var yes = $('cfmYes');
    if (yes) yes.onclick = function () {
      var cb = cfmCb, del = cfmChkOn;
      cfmClose();
      if (cb) { try { cb(del); } catch (e) { toast('操作失败：' + (e && e.message ? e.message : e)); } }
    };
  }

  function baseDir() {
    var b = '';
    try { b = nativeReady() ? String(N.getDir() || '') : ''; } catch (e) {}
    if (!b) b = '/storage/emulated/0/QW-Workshop';
    if (b.charAt(b.length - 1) !== '/') b += '/';
    return b;
  }

  function localPathOf(t) {
    var base = baseDir();
    if (t.kind === 'item') return base + String(t.item || '') + '/';
    return base + (t.sub ? (String(t.sub) + '/') : '') + String(t.file || '');
  }

  function delLocalFor(list) {
    var ok = 0, fail = 0, none = 0;
    for (var i = 0; i < list.length; i++) {
      var p = localPathOf(list[i]), r = '';
      try { if (nativeReady() && N.deletePath) r = String(N.deletePath(p) || ''); } catch (e) { r = 'err'; }
      if (r.indexOf('ok') === 0) ok++;
      else if (r === 'noexist') none++;
      else fail++;
    }
    return { ok: ok, fail: fail, none: none };
  }

  function dlSelDelete() {
    var keys = [];
    for (var k in dlSel) if (dlSel[k]) keys.push(k);
    if (!keys.length) { toast('请先勾选要删除的条目'); return; }
    dlLoad();
    var keep = [], hits = [];
    for (var i = 0; i < dlTasks.length; i++) {
      var t = dlTasks[i], hit = false;
      for (var j = 0; j < keys.length; j++) if (keys[j] === t.key) hit = true;
      if (hit) { hits.push(t); continue; }
      keep.push(t);
    }
    cfmOpen('将从列表移除 ' + hits.length + ' 条记录，进行中的任务会先取消。', function (del) {
      for (var h = 0; h < hits.length; h++) {
        var t2 = hits[h];
        if (t2.kind === 'item') {
          try { if (natAvail() && QW.itemCancel) QW.itemCancel(String(t2.item)); } catch (e1) {}
        }
        else if (t2.status !== 8 && t2.file) { try { N.resetFile(dlPath(t2)); } catch (e2) {} }
      }
      var r = del ? delLocalFor(hits) : null;
      dlTasks = keep; dlSave();
      dlSelOn = false; dlSel = {};
      renderDl(); dlSelSync();
      if (r) toast('已删除 ' + hits.length + ' 条记录，清理本地文件 ' + r.ok + ' 项' + (r.fail ? ('，' + r.fail + ' 项没删掉') : ''), 3000);
      else toast('已删除 ' + hits.length + ' 条记录（本地文件保留）', 2600);
    });
  }

  /* 打开文件 / 所在目录 */
  function dlOpenPath(t) {
    var p = '';
    var base = baseDir();
    if (t.kind === 'item') p = base + String(t.item || '') + '/';
    else p = base + (t.sub ? String(t.sub) + '/' : '') + String(t.file || '');
    var r = '';
    try { if (nativeReady() && N.openPath) r = String(N.openPath(p) || ''); } catch (e) { r = 'err:' + (e && e.message ? e.message : e); }
    if (r.indexOf('ok') === 0) return;
    try { copyText(p); } catch (e2) {}
    toast('打不开文件管理器，路径已复制：' + p, 3200);
  }

  /* 只有「场景」类作品才提供「提取项目中的图片」，视频 / 网页类不展示 */
  function isSceneTask(t) {
    if (!t) return false;
    var id0 = String(t.item || t.sub || '');
    if (!id0) { var m0 = String(t.key || '').match(/(\d{5,})/); if (m0) id0 = m0[1]; }
    if (!id0) { var m1 = String(t.path || '').match(/(\d{5,})/); if (m1) id0 = m1[1]; }
    if (t.tag) { probe('SC1 ' + t.key + ' tag=' + t.tag); return String(t.tag) === '场景'; }
    /* 只缓存「是场景」的成功结果；判定失败不缓存，等列表/文件就绪后重算 */
    if (t._scene === 1) return true;
    var listTag = '', found = false;
    for (var i = 0; i < st.list.length; i++) {
      if (st.list[i] && String(st.list[i].id) === id0) { listTag = String(st.list[i].tag || ''); found = true; break; }
    }
    if (found && listTag) {
      if (listTag === '场景') t._scene = 1;
      t._dbg = 'lst found=' + (found ? 1 : 0) + ' lt=' + listTag + ' n=' + st.list.length;
      return listTag === '场景';
    }
    /* 兜底：场景类作品目录里一定有 scene.pkg，视频类没有 */
    var sc = false, lens = [];
    try {
      if (nativeReady() && N.fileLen) {
        var dirs = ['/storage/emulated/0/QW-Workshop/' + id0 + '/', String(t.path || '')];
        try { dirs.push(String(N.getDir() || '') + '/' + String(t.path || '')); } catch (e0) {}
        for (var k = 0; k < dirs.length; k++) {
          if (!dirs[k]) continue;
          var n = 0;
          try { n = parseInt(N.fileLen(dirs[k] + 'scene.pkg'), 10) || 0; } catch (e1) { n = -1; }
          lens.push(k + ':' + n);
          if (n > 0) { sc = true; break; }
        }
      } else { lens.push('noFileLen'); }
    } catch (e) {}
    t._dbg = 'fb ' + lens.join(',') + ' f=' + (found ? 1 : 0) + ' lt=' + listTag + ' n=' + st.list.length + ' sc=' + (sc ? 1 : 0);
    if (sc) t._scene = 1;
    return sc;
  }

  function renderDl() {
    var box = $('dlList');
    if (!box) return;
    if (!dlTasks.length) {
      box.innerHTML = '<div class="dls-empty">暂无下载任务。点「下载封面」或「下载原项目」会出现在这里。</div>';
      dlSelOn = false; dlSel = {}; box.className = 'dls-list'; dlSelSync();
      return;
    }
    /* 增量更新：行数与 key 序列不变时，只刷新状态文字 / 进度条 / 选中态，
       避免 natTick 每 900ms 全量重建几十行 DOM（低端机掉帧） */
    var sig = '';
    for (var s0 = 0; s0 < dlTasks.length; s0++) sig += dlTasks[s0].key + '|';
    var canDiff = (box.__sig === sig) && box.querySelectorAll('.dl-row').length === dlTasks.length;
    if (canDiff) {
      var rows = box.querySelectorAll('.dl-row');
      for (var d0 = 0; d0 < dlTasks.length; d0++) {
        var td = dlTasks[d0], rd = rows[d0];
        if (!rd) { canDiff = false; break; }
        var subEl = rd.querySelector('.dl-sub'), barEl = rd.querySelector('.dl-bar > i');
        var txtNow = dlStatusText(td);
        if (subEl && subEl.textContent !== txtNow) subEl.textContent = txtNow;
        if (barEl) barEl.style.width = dlPct(td) + '%';
        rd.classList.toggle('sel', !!(dlSelOn && dlSel[td.key]));
        /* 按钮区随状态变化（完成/暂停/中断），状态变了就重建整行 */
        var stNow = td.status + ':' + (td.kind || '');
        if (rd.__st !== stNow) { canDiff = false; break; }
      }
      if (canDiff) { box.className = 'dls-list' + (dlSelOn ? ' sel' : ''); dlSelSync(); return; }
    }
    var h = '';
    var scDbgArr = [];
    for (var i = 0; i < dlTasks.length; i++) {
      var t = dlTasks[i];
      var acts;
      var opBtn = '';
      if (t.status === 8) {
        var wpBtn = (t.kind !== 'cover' && (t.item || t.sub || t.path) && isSceneTask(t)) ? ('<button class="btn mini" data-dlact="wp" data-k="' + esc(t.key) + '">提取项目中的图片</button>') : '';
        try { scDbgArr.push(String(t.key) + ' it=' + (t.item || '') + ' tg=' + (t.tag || '') + ' ic=' + (isSceneTask(t) ? 1 : 0) + ' ' + (t._dbg || '')); } catch (e9) {}
        acts = wpBtn + opBtn + '<button class="btn mini prim" data-dlact="redl" data-k="' + esc(t.key) + '">重新下载</button>';
      }
      else if (t.status === 16) acts = '<button class="btn mini" data-dlact="resume" data-k="' + esc(t.key) + '">' + (t.done > 0 ? '继续' : '重试') + '</button>' + (t.done > 0 ? opBtn : '');
      else acts = '<button class="btn mini" data-dlact="pause" data-k="' + esc(t.key) + '">暂停</button>';
      h += '<div class="dl-row' + (dlSelOn && dlSel[t.key] ? ' sel' : '') + '" data-k="' + esc(t.key) + '" data-st="' + esc(t.status + ':' + (t.kind || '')) + '">'
        + '<div class="dl-check"></div>'
        + (t.img ? '<img class="dl-thumb" src="' + esc(t.img) + '" alt="">' : '<div class="dl-thumb"></div>')
        + '<div class="dl-main"><div class="dl-title">' + esc(t.title || '') + '</div>'
        + '<div class="dl-sub">' + esc(dlStatusText(t)) + '</div>'
        + '<div class="dl-bar"><i style="width:' + dlPct(t) + '%"></i></div></div>'
        + '<div class="dl-acts">' + acts + '</div></div>';
    }
    box.innerHTML = h;
    box.__sig = sig;
    /* 给每行打上状态标记，供下一次增量比对 */
    var newRows = box.querySelectorAll('.dl-row');
    for (var r1 = 0; r1 < newRows.length && r1 < dlTasks.length; r1++) {
      newRows[r1].__st = dlTasks[r1].status + ':' + (dlTasks[r1].kind || '');
    }
    if (scDbgArr.length && window.__scdbg === 1) box.insertAdjacentHTML('beforeend', '<div style="font-size:11px;color:#7d95ad;padding:6px 4px;line-height:1.6">SCDBG ' + esc(scDbgArr.join(' ; ')) + '</div>');
    box.className = 'dls-list' + (dlSelOn ? ' sel' : '');
  }
  function openDl() {
    try {
      dlLoad();
      renderDl();
      var s = $('dlSheet');
      if (!s) { toast('界面缺少下载列表节点'); return; }
      clearToasts();
      s.classList.remove('hide');
      dlOpenedAt = Date.now();
    } catch (e) { toast('打不开下载列表：' + (e.message || e), 3000); }
  }

  function closeDl() {
    if (Date.now() - dlOpenedAt < 350) return;
    $('dlSheet').classList.add('hide');
  }

  function dlPoll() {}

window.qwBack = function () {
    try {
      var now = Date.now();
      var g = window.__backGuard;
      if (window.__lastOverlay === 'viewer') {
        window.__lastOverlay = null;
        $('viewer').classList.add('hide');
        window.__backGuard = { kind: 'viewer', t: now };
        dbg('bk', 'closed viewer via lastOverlay');
        return;
      }
      dbg('bk', 'call v=' + (!$('viewer').classList.contains('hide')) + ' d=' + (!$('detail').classList.contains('hide')));
      var v = $('viewer');
      if (v && !v.classList.contains('hide')) {
        $('viewer').classList.add('hide');
        window.__backGuard = { kind: 'viewer', t: now };
        return;
      }
      var l0 = $('dlSheet');
      if (l0 && !l0.classList.contains('hide')) { l0.classList.add('hide'); window.__backGuard = null; return; }
      var s0 = $('settings');
      if (s0 && !s0.classList.contains('hide')) { closeSettings(); window.__backGuard = null; return; }
      var dr = $('drawer');
      if (dr && dr.classList.contains('open')) { closeDrawer(); window.__backGuard = null; return; }
      var d = $('detail');
      if (d && !d.classList.contains('hide')) {
        if (g && g.kind === 'viewer' && now - g.t < 1500) return;
        closeDetail();
        window.__backGuard = { kind: 'detail', t: now };
        return;
      }
      if (nativeReady()) N.finishApp();
    } catch (e) {}
  };

  function dlPath(t) {
    var sid = (t && (t.sub || t.item)) ? String(t.sub || t.item) : '';
    var sub = sid ? (sid + '/') : '';
    var nm = (t && t.file) ? String(t.file) : '';
    return sub + nm;
  }

  function dirOf(t) {
    var d = '';
    try { d = nativeReady() ? String(N.getDir() || '') : ''; } catch (e) {}
    if (!d) d = '/storage/emulated/0/QW-Workshop';
    var sub = (t && t.item) ? String(t.item) + '/' : '';
    return String(d).replace(/\/+$/, '') + '/' + sub + (t && t.file ? t.file : '');
  }
  function dlByKey(k) {
    for (var i = 0; i < dlTasks.length; i++) if (dlTasks[i].key === k) return dlTasks[i];
    return null;
  }

  function dlPack() {
    var id = String((curDetail && curDetail.id) || '');
    if (!id) { toast('先打开一个作品再点「下载原项目」'); return; }
    if (!natAvail()) { toast('原生下载内核不可用'); return; }
    if (!NATDL.loggedIn) {
      openSettings();
      setTimeout(function () { try { natRender(true); } catch (e) {} }, 120);
      toast('下载原项目需要先登录 Steam 账号（不登录可浏览、可下载封面）', 3600);
      return;
    }
    var d = curDetail || {};
    var mid = String(d.hcontent_file || d.manifest || '');
    if (!mid || mid === '0') { toast('该条目缺少 hcontent_file，无法定位 depot 清单'); return; }
    dlAdd({
      key: 'i' + id, title: String(d.title || ('作品 ' + id)), img: String(d.img || d.preview_url || ''),
      kind: 'item', item: id, manifest: mid, url: '', path: 'QW-Workshop/' + id + '/', tag: String(d.tag || '')
    });
    setTimeout(openDl, 90);
    toast('已加入下载列表：原项目 ' + id, 2400);
  }

  function openDrawer() {
    syncDrawer();
    $('drawer').classList.add('open');
    $('scrim').classList.add('on');
    window.__drawerAt = Date.now();
  }
  function closeDrawer() {
    $('drawer').classList.remove('open');
    $('scrim').classList.remove('on');
  }

  /* ---- 设备默认列数：手机 2 列、平板 4 列 ---- */
  function defColsFor(w) {
    w = w || window.innerWidth || 400;
    if (w <= 600) return 2;
    if (w <= 960) return 3;
    return 4;
  }

  /* ---- 筛选记忆：下次打开沿用上次点「应用」的选择 ---- */
  function saveFilter() {
    try {
      localStorage.setItem('qw_f', JSON.stringify({
        sort: st.sort, types: st.types, cats: st.cats, ages: st.ages
      }));
    } catch (e) {}
  }
  function restoreFilter() {
    var o = null;
    try { o = JSON.parse(localStorage.getItem('qw_f') || 'null'); } catch (e) { o = null; }
    if (!o || typeof o !== 'object') return;
    if (o.sort && SORTS[o.sort]) st.sort = o.sort;
    if (o.types && o.types.length) st.types = o.types;
    if (o.cats && o.cats.length) st.cats = o.cats;
    if (o.ages && o.ages.length && o.ages.length <= 3) st.ages = o.ages;
  }

  function setChip(group, val) {
    var chips = document.querySelectorAll('#' + group + ' .chip');
    for (var i = 0; i < chips.length; i++) {
      chips[i].classList.toggle('on', chips[i].getAttribute('data-v') === val);
    }
  }
  function setChipMulti(group, vals) {
    var chips = document.querySelectorAll('#' + group + ' .chip');
    for (var i = 0; i < chips.length; i++) {
      chips[i].classList.toggle('on', (vals || []).indexOf(chips[i].getAttribute('data-v')) >= 0);
    }
  }
  function getChip(group) {
    var chips = document.querySelectorAll('#' + group + ' .chip'), out = [];
    for (var i = 0; i < chips.length; i++) {
      if (chips[i].classList.contains('on')) out.push(chips[i].getAttribute('data-v'));
    }
    return out;
  }

  function syncDrawer() {
    setChip('cSort', st.sort);
    setChipMulti('cType', st.types);
    setChipMulti('cCat', st.cats);
    var chips = document.querySelectorAll('#cAge .chip');
    for (var i = 0; i < chips.length; i++) {
      chips[i].classList.toggle('on', st.ages.indexOf(chips[i].getAttribute('data-v')) >= 0);
    }
    setChip('cCols', (st.cols === 1 || st.cols > 4) ? 'custom' : String(st.cols));
  }

  function applyDrawer() {
    st.sort = getChip('cSort')[0] || 'trend';
    st.types = getChip('cType');
    if (!st.types.length) st.types = ['Scene', 'Video', 'Web'];
    st.cats = getChip('cCat');
    if (!st.cats.length) st.cats = ['Wallpaper', 'Preset', 'Resource'];
    var ages = getChip('cAge');
    st.ages = ages;
    st.page = 1;
    saveFilter();
    closeDrawer();
    loadList();
    toast('筛选已应用');
  }

  function resetDrawer() {
    st.sort = 'trend';
    st.types = ['Scene', 'Video', 'Web'];
    st.cats = ['Wallpaper', 'Preset', 'Resource'];
    st.ages = ['g'];
    syncDrawer();
    setChip('cAge', 'g');
    try { localStorage.removeItem('qw_cols'); } catch (e) {}
    applyCols(defColsFor(), false);
    saveFilter();
  }

  /* ---------------- 登录（内嵌在设置里，不跳转到别的页面） ---------------- */

  function b64Bytes(arr) {
    var s = '';
    for (var i = 0; i < arr.length; i++) s += String.fromCharCode(arr[i] & 255);
    return btoa(s);
  }

  function modPow(b, e, m) {
    var r = 1n;
    b = b % m;
    while (e > 0n) {
      if (e & 1n) r = (r * b) % m;
      b = (b * b) % m;
      e >>= 1n;
    }
    return r;
  }

  /* Steam 的密码用 RSA(PKCS#1 v1.5) 加密：本地算完再发，密码不进任何本地文件 */
  function rsaEnc(pwd, modHex, expHex) {
    var hex = String(modHex || '');
    if (!hex || !expHex) throw new Error('公钥为空');
    if (hex.length % 2) hex = '0' + hex;
    var mlen = hex.length / 2;
    var pb = new TextEncoder().encode(pwd);
    var pad = mlen - pb.length - 3;
    if (pad < 8) throw new Error('密码过长，无法加密');
    var em = [0, 2];
    for (var i = 0; i < pad; i++) {
      var r = 0;
      while (r === 0) r = Math.floor(Math.random() * 255) + 1;
      em.push(r & 255);
    }
    em.push(0);
    for (var j = 0; j < pb.length; j++) em.push(pb[j]);
    var eh = '';
    for (var k = 0; k < em.length; k++) eh += ('0' + em[k].toString(16)).slice(-2);
    var c = modPow(BigInt('0x' + eh), BigInt('0x' + expHex), BigInt('0x' + hex));
    var ch = c.toString(16);
    while (ch.length < hex.length) ch = '0' + ch;
    var out = [];
    for (var q = 0; q < ch.length; q += 2) out.push(parseInt(ch.substr(q, 2), 16));
    return b64Bytes(out);
  }

  function postForm(url, obj) {
    var kv = [];
    for (var k in obj) {
      if (!Object.prototype.hasOwnProperty.call(obj, k)) continue;
      kv.push(encodeURIComponent(k) + '=' + encodeURIComponent(obj[k]));
    }
    return N.httpPost(url, kv.join('&'));
  }

  function capUrl(gid) {
    return 'https://steamcommunity.com/login/rendercaptcha/?gid=' + encodeURIComponent(gid);
  }

  function doSteamLogin() {
    var eu = $('stUser');
    if (!eu) return;
    var u = (eu.value || '').trim();
    var p = $('stPass').value || '';
    var c = ($('stCode').value || '').trim();
    var mode = ($('stCode').getAttribute('data-mode') || '');
    var esid = ($('stCode').getAttribute('data-sid') || '');
    if (!u || !p) { toast('请填写 Steam 账号和密码'); return; }
    window.__loginBusy = true; window.__acc = u;
    /* 安全：不再明文保存账号，只留打码名用于界面显示与头像 */
    try {
      localStorage.setItem('qw_me_disp', maskName(u));
      localStorage.removeItem('qw_lastacc');
    } catch (eB) {}

    // 网页会话已在：这次只补下载会话，不重复提交网页登录
    var sidNow = '';
    try { sidNow = String(N.getLogin() || ''); } catch (e0) {}
    if (sidNow) {
      window.__dn = { u: u, p: p, code: c, mode: mode, guardSent: false, at: Date.now() };
      if (natAvail()) {
        if (NATDL.guard && c) { try { QW.stGuard(c); } catch (e9) {} }
        else { natStart(u, p); }
      }
      var b0 = $('btnStLogin');
      if (b0) { b0.disabled = true; b0.textContent = '连接中…'; }
      if ($('stMsg')) $('stMsg').textContent = '正在用同一个账号连接下载会话…';
      setTimeout(function () { window.__loginBusy = false; }, 1500);
      return;
    }


    // 同一套凭据：同时开浏览会话（下面的网页登录）与下载会话（Steam 客户端协议）
    window.__dn = { u: u, p: p, code: c, mode: mode, guardSent: false, at: Date.now() };
    if (natAvail()) {
      if (NATDL.guard && c) { try { QW.stGuard(c); } catch (e9) {} }
      else { natStart(u, p); }
    }
    if (!nativeReady()) { toast('原生桥未就绪，无法登录'); return; }
    var b = $('btnStLogin');
    b.disabled = true;
    b.textContent = '登录中…';
    function reset(msg) {
      window.__loginBusy = false;
      b.disabled = false;
      b.textContent = '登录 Steam';
      if (msg && $('stMsg')) $('stMsg').textContent = msg;
    }
    setTimeout(function () {
      try {
        var rkTxt = postForm('https://steamcommunity.com/login/getrsakey/', { username: u, donotcache: String(Date.now()) });
        probe('LOGIN_RK ' + String(rkTxt || '').slice(0, 160));
        var rk = JSON.parse(rkTxt || '{}');
        if (!rk || !rk.success || !rk.publickey_mod) throw new Error((rk && rk.message) || '获取登录公钥失败');
        var enc = rsaEnc(p, rk.publickey_mod, rk.publickey_exp);
        var txt = postForm('https://steamcommunity.com/login/dologin/', {
          username: u,
          password: enc,
          rsatimestamp: rk.timestamp,
          remember_login: 'true',
          donotcache: String(Date.now()),
          emailauth: mode === 'email' ? c : '',
          twofactorcode: mode === 'two' ? c : '',
          loginfriendlyname: 'QWWorkshop',
          captchagid: ($('stCap') && ($('stCap').value || '').trim()) ? (window.__capGid || '-1') : '-1',
          captcha_text: (($('stCap') && $('stCap').value) || '').trim(),
          emailsteamid: mode === 'email' ? esid : ''
        });
        probe('LOGIN_DL ' + String(txt || '').slice(0, 200));
        dbg('dn', 'len=' + String(txt || '').length + '\n' + String(txt || ''));
        var res = JSON.parse(txt || '{}') || {};
        if (res.success || res.login_complete) {
          window.__capGid = '';
          var cbx = $('capBox'); if (cbx) cbx.style.display = 'none';
          var sid = res.steamID || (res.transfer_parameters && (res.transfer_parameters.steamid || res.transfer_parameters.steamID)) || '';
          var ti = res.transfer_info || [];
          for (var i = 0; i < ti.length; i++) {
            var tp = ti[i].params || {};
            if (!sid && (tp.steamid || tp.steamID)) sid = tp.steamid || tp.steamID;
            try { postForm(ti[i].url, tp); } catch (e2) {}
          }
          if (sid) { try { N.setLogin(String(sid)); } catch (e3) {} }
          if (!sid) {
            var mm = String(txt || '').match(/steam[Ii][Dd](?:64)?"?\s*:\s*"?(\d{6,20})/);
            if (mm) { sid = mm[1]; try { N.setLogin(String(sid)); } catch (e4) {} }
          }
          dbg('ok', 'sid=' + sid + '\n' + String(txt || ''));
          var pe = $('stPass'); if (pe) pe.value = '';
          toast(sid ? '登录成功' : '登录成功（未取到 SteamID，正在按 Cookie 反查）');
          window.__loginBusy = false; loginFormOpen = false;
          refreshLogin();
          if (!sid) { probe('LOGIN_NOSID'); fetchMe(true); }
          return;
        }
        if (res.needs_twofactor || res.requires_twofactor) {
          $('stCode').classList.remove('hide');
          $('stCode').setAttribute('data-mode', 'two');
          $('stCode').setAttribute('placeholder', '手机令牌码');
          reset('需要两步验证：填入手机令牌码后，再点一次「登录 Steam」。');
        } else if (res.emailauth_needed) {
          $('stCode').classList.remove('hide');
          $('stCode').setAttribute('data-mode', 'email');
          $('stCode').setAttribute('data-sid', res.emailsteamid || '');
          $('stCode').setAttribute('placeholder', '邮箱验证码');
          var dom = res.emaildomain ? ('@' + res.emaildomain) : '你的邮箱';
          reset('Steam 已向 ' + dom + ' 发送验证码：填进来后再点一次「登录 Steam」。');
        } else if (res.captcha_needed) {
          var gid = String(res.captchagid || res.captcha_gid || '');
          window.__capGid = gid;
          var cbox = $('capBox'), cim = $('capImg');
          if (cbox) cbox.style.display = 'flex';
          if (cim && gid && gid !== '-1') {
            cim.onclick = function () { cim.src = capUrl(gid) + '&_r=' + Date.now(); };
            cim.src = capUrl(gid) + '&_r=' + Date.now();
            dbg('cap', 'gid=' + gid);
          }
          reset('需要图形验证码（新设备或网络异常常触发）：把图里的字符填进下面的框，再点一次「登录 Steam」；看不清可点图片重载。');
        } else {
          reset('登录失败：' + (res.message || 'Steam 未返回原因'));
        }
      } catch (e) {
        var em = String((e && e.message) || e || '');
        if (/429|too many|rate limit/i.test(em)) {
          reset('Steam 限流了（同一网络短时间登录次数太多）：等 5～10 分钟，或换网络（手机流量 / 换个加速器节点）再试。原始信息：' + em.slice(0, 90));
        } else {
          reset('登录出错：' + em);
        }
      }
    }, 30);
  }

  function maskTxt(s) {
    s = String(s || '');
    s = s.replace(/([0-9a-fA-F]{24,})/g, '<HEX>');
    s = s.replace(/(token|auth|webcookie|nonce|steamLoginSecure|sessionid)(["']?\s*[=:]\s*["']?)[^&;,"'}]{4,}/gi, '$1$2<v>');
    return s;
  }

  function dbg(name, text) {
    /* 默认关闭：cookie / 令牌 / transfer_info 等敏感内容不落盘；
       需要排查时在控制台执行 window.__dbg=1 再复现。 */
    try { if (!window.__dbg) return; } catch (e0) { return; }
    try { if (nativeReady()) N.saveText('dbg_' + name + '.txt', maskTxt(text)); } catch (e) {}
  }

  var meTried = false;

  function fetchMe(notify) {
    if (meTried && !notify) return;
    meTried = true;
    if (!nativeReady()) return;
    setTimeout(function () {
      var ck = '';
      try { ck = String(N.getCookies('https://steamcommunity.com') || ''); } catch (e0) {}
      dbg('ck', 'community=' + ck.length + ' | ' + ck);
      var sid = '';
      if (ck && ck.length > 0) try {
        var xml = String(N.httpGet('https://steamcommunity.com/my/?xml=1') || '');
        dbg('me', 'len=' + xml.length + '\n' + xml.slice(0, 400));
        var doc = new DOMParser().parseFromString(xml, 'text/xml');
        var s64 = doc.querySelector('steamID64');
        sid = s64 ? s64.textContent.trim() : '';
        if (!sid) {
          var m1 = xml.match(/<steamID64>\s*(\d{6,20})\s*<\/steamID64>/);
          if (m1) sid = m1[1];
        }
      } catch (e1) {}
      if (!sid) {
        try {
          var acc = String(N.httpGet('https://store.steampowered.com/account/') || '');
          dbg('acc', 'len=' + acc.length + '\n' + acc);
          var m2 = acc.match(/Steam\s*ID\s*[：:]\s*(\d{6,20})/i)
            || acc.match(/steamid"?\s*>\s*(?:Steam ID\s*[：:]?\s*)?(\d{6,20})/i)
            || acc.match(/g_steamID\s*=\s*"(\d{6,20})"/)
            || acc.match(/"steamid"\s*:\s*"?(\d{6,20})/)
            || acc.match(/steamid64["'\s:]*(\d{6,20})/i)
            || acc.match(/\/profiles\/(\d{6,20})/);
          if (m2) sid = m2[1];
          if (!sid) {
            var m3 = acc.match(/accountid["'\s:]*(\d{4,10})/i) || acc.match(/accountid=(\d{4,10})/i);
            if (m3) sid = String(76561197960265728 + parseInt(m3[1], 10));
          }
        } catch (e2) {}
      }
      if (!sid) { if (notify) toast('还没读到 Steam 登录状态'); return; }
      try { N.setLogin(sid); } catch (e3) {}
      refreshLogin();
      if (notify) toast('已登录：' + sid, 2500);
    }, 120);
  }

  var loginFormOpen = false;
  function loginFormState() {
    var sid = '';
    if (nativeReady()) { try { sid = String(N.getLogin() || ''); } catch (e) {} }
    var dnOn = !!(natAvail() && NATDL.loggedIn);
    return { sid: sid, dnOn: dnOn, on: !!(sid || dnOn) };
  }
  function refreshLogin() {
    var box = $('loginBox');
    if (!box) return;
    var st0 = loginFormState(), sid = st0.sid, dnOn = st0.dnOn, on = st0.on;
    var acc = String(window.__acc || '');
    if (!acc) { try { acc = String(localStorage.getItem('qw_me_disp') || ''); } catch (eA) {} }
    if (!on) loginFormOpen = true;
    if (on && !loginFormOpen) {
      var st;
      if (sid && dnOn) st = '已登录 · 网页会话与下载会话都已连接';
      else if (dnOn) st = '下载会话已连接 · 网页会话未登录（受限内容看不全）';
      else st = '网页会话已登录 · 下载会话未连接';
      var accFull = String(NATDL.account || window.__acc || '');
      if (!accFull) { try { accFull = String(localStorage.getItem('qw_me_disp') || ''); } catch (eXF) {} }
      window.__meAcc = accFull;
      var disp = accFull ? (window.__meShow ? accFull : maskName(accFull))
        : (sid ? ('SteamID ' + maskSid(sid)) : '已连接');
      box.innerHTML = '<div class="avatar" id="lAvatar">' + esc(avatarInit(disp)) + '</div>'
        + '<div style="flex:1;min-width:150px"><div class="lname" id="lName" title="点一下显示 / 隐藏账号">'
        + esc(disp)
        + '</div></div>'
        + '<div class="lbtns">'
        + (sid ? '<button class="btn mini" id="btnReload">刷新资料</button>' : '')
        + '<button class="btn mini" id="btnRelogin">重新登录</button>'
        + '<button class="btn mini" id="btnLogout">退出登录</button></div>';
      if ($('btnReload')) $('btnReload').onclick = function () { loadProfile(sid); };
      var ln0 = $('lName');
      if (ln0) {
        ln0.style.cursor = 'pointer';
        ln0.onclick = function () {
          window.__meShow = !window.__meShow;
          var a0 = String(window.__meAcc || '');
          ln0.textContent = a0 ? (window.__meShow ? a0 : maskName(a0)) : ln0.textContent;
          toast(window.__meShow ? '已显示完整账号，再点一次隐藏' : '已隐藏账号', 1600);
        };
      }
      $('btnRelogin').onclick = function () {
        loginFormOpen = true;
        refreshLogin();
        var iu = $('stUser');
        if (iu) { iu.value = ''; try { iu.focus(); } catch (eF) {} }
      };
      $('btnLogout').onclick = function () {
        try { N.logout(); } catch (e1) {}
        try { if (natAvail() && QW.stLogout) QW.stLogout(); } catch (e2) {}
        NATDL.loggedIn = false; NATDL.account = '';
        meTried = false; window.__meShow = false; loginFormOpen = true;
        toast('已退出登录（网页会话与下载会话一起清掉了）');
        refreshLogin();
      };
      natRender();
      if (sid) loadProfile(sid);
      return;
    }
    var note;
    if (sid && dnOn) note = '已登录。换账号请填新账号密码再登录。';
    else if (dnOn) note = '下载会话已连接' + (NATDL.account ? (' · ' + esc(maskName(NATDL.account))) : '') + '。网页会话未登录：填同一账号密码，点「登录 Steam」即可。';
    else if (sid) note = '网页会话已登录（SteamID ' + esc(sid) + '），只差下载会话：填同一个账号密码，点一次「登录 Steam」，两边一起连上。';
    else note = '未登录。一次登录，同时用于浏览与原项目下载；需要验证码时这里会出现输入框。';
    box.innerHTML = '<div class="lform">'
      + '<input id="stUser" class="lin" type="text" autocomplete="username" spellcheck="false"'
      + ' placeholder="' + (acc ? ('Steam 账号（上次：' + esc(maskName(acc)) + '）') : 'Steam 账号') + '">'
      + '<input id="stPass" class="lin" type="password" autocomplete="current-password" placeholder="密码">'
      + '<input id="stCode" class="lin hide" type="text" inputmode="numeric" data-mode="" placeholder="令牌码 / 邮箱验证码（需要时填）">'
      + '<div id="capBox" style="display:none;gap:10px;align-items:center;margin:8px 0">'
      + '<img id="capImg" alt="点击重试" style="height:56px;min-width:120px;border-radius:6px;background:#fff;padding:3px;cursor:pointer">'
      + '<input id="stCap" class="lin" style="flex:1;margin:0" type="text" autocomplete="off" spellcheck="false" placeholder="填图中的字符">'
      + '</div>'
      + '<div class="lbtns"><button class="btn mini prim" id="btnStLogin">登录 Steam</button>'
      + (on ? '<button class="btn mini" id="btnCancelLogin">取消</button>' : '')
      + '<button class="btn mini" id="btnLogout2">退出登录</button></div>'
      + '<div class="lsub" id="stMsg">' + note + '</div>'
      + '</div>';
    $('btnStLogin').onclick = doSteamLogin;
    if ($('btnCancelLogin')) $('btnCancelLogin').onclick = function () { loginFormOpen = false; refreshLogin(); };
    if ($('btnLogout2')) $('btnLogout2').onclick = function () {
      try { N.logout(); } catch (e3) {}
      try { if (natAvail() && QW.stLogout) QW.stLogout(); } catch (e4) {}
      NATDL.loggedIn = false; NATDL.account = ''; meTried = false; loginFormOpen = false;
      toast('已退出登录');
      refreshLogin();
    };
    if (!meTried) setTimeout(function () { fetchMe(false); }, 120);
    natRender();
  }
  function maskSid(v) {
    v = String(v || '');
    if (!v) return '';
    if (v.length <= 6) return v.slice(0, 2) + '•••';
    return v.slice(0, 3) + '•••' + v.slice(-3);
  }
  function maskName(n) {
    n = String(n || '');
    if (!n) return '';
    if (n.length <= 2) return n.charAt(0) + '*';
    if (n.length <= 4) return n.charAt(0) + '***';
    return n.slice(0, 1) + '***' + n.slice(-2);
  }

  /* 老版本把账号明文存在 qw_lastacc，升级后一次性迁移为打码名并抹掉明文 */
  function migrAcc() {
    try {
      var old = localStorage.getItem('qw_lastacc');
      if (old) {
        try { localStorage.setItem('qw_me_disp', maskName(old)); } catch (e0) {}
        localStorage.removeItem('qw_lastacc');
      }
    } catch (e) {}
  }

  function loadProfile(sid) {
    setTimeout(function () {
      var name = '', avUrl = '';
      try {
        var xml0 = String(N.httpGet('https://steamcommunity.com/profiles/' + sid + '/?xml=1') || '');
        if (xml0 && xml0.charAt(0) !== '{') {
          var d0 = new DOMParser().parseFromString(xml0, 'text/xml');
          var nm0 = d0.querySelector('steamID');
          var av0 = d0.querySelector('avatarFull') || d0.querySelector('avatarMedium');
          if (nm0) name = nm0.textContent.trim();
          if (av0) avUrl = av0.textContent.trim();
        }
      } catch (e0) {}
      try {
        var acc = String(N.httpGet('https://store.steampowered.com/account/') || '');
        if (acc && acc.charAt(0) !== '{') {
          var mt = acc.match(/<title>([^<]{1,60}?)\s*的帐户/);
          if (!name && mt) name = mt[1].trim();
          var ma = acc.match(/https:\/\/avatars[^"'\s\\]+_full\.jpg/) || acc.match(/https:\/\/avatars[^"'\s\\]+\.jpg/);
          if (!avUrl && ma) avUrl = ma[0];
        }
      } catch (e1) {}
      if (!name || !avUrl) {
        try {
          var xml = String(N.httpGet('https://steamcommunity.com/profiles/' + sid + '/?xml=1') || '');
          var doc = new DOMParser().parseFromString(xml, 'text/xml');
          var nm = doc.querySelector('steamID');
          var av = doc.querySelector('avatarFull');
          if (!name && nm) name = nm.textContent.trim();
          if (!avUrl && av) avUrl = av.textContent.trim();
        } catch (e2) {}
      }
      window.__meName = name || '';
      var li = $('lAvatar');
      if (li && avUrl) {
        var safeAv = String(avUrl).replace(/["'\\\s()]/g, '');
        li.style.backgroundImage = 'url("' + safeAv + '")';
        li.textContent = '';
        li.title = name || '';
      }
    }, 60);
  }

  /* ---------------- 预览手势 ---------------- */

  function bindViewer() {
    var stage = qs('.vstage');
    if (!stage) return;
    var d0 = 0, s0 = 1, p0 = null, lastTap = 0, maxT = 0;

    function dist(t) {
      var dx = t[0].clientX - t[1].clientX, dy = t[0].clientY - t[1].clientY;
      return Math.sqrt(dx * dx + dy * dy);
    }

    stage.addEventListener('touchstart', function (e) {
      if (e.touches.length > maxT) maxT = e.touches.length;
      if (e.touches.length === 2) {
        d0 = dist(e.touches);
        s0 = vScale;
        p0 = null;
      } else if (e.touches.length === 1) {
        p0 = { x: e.touches[0].clientX - vX, y: e.touches[0].clientY - vY };
      }
    }, { passive: true });

    stage.addEventListener('touchmove', function (e) {
      if (e.touches.length === 2) {
        e.preventDefault();
        var d = dist(e.touches);
        if (d0 > 0) {
          vScale = Math.min(6, Math.max(1, s0 * d / d0));
          if (vScale <= 1) { vX = 0; vY = 0; }
          applyT();
        }
      } else if (e.touches.length === 1 && p0 && vScale > 1) {
        e.preventDefault();
        vX = e.touches[0].clientX - p0.x;
        vY = e.touches[0].clientY - p0.y;
        applyT();
      }
    }, { passive: false });

    stage.addEventListener('touchend', function (e) {
      if (e.touches.length !== 0) return;
      var now = Date.now();
      if (maxT <= 1 && now - lastTap < 320) {
        if (vScale > 1.05) { vScale = 1; vX = 0; vY = 0; }
        else { vScale = 2.5; vX = 0; vY = 0; }
        applyT();
        lastTap = 0; maxT = 0;
        return;
      }
      if (maxT > 1) lastTap = 0; else lastTap = now;
      if (vScale <= 1.02) { vScale = 1; vX = 0; vY = 0; applyT(); }
      maxT = 0;
    });

    $('vClose').onclick = function () {
      if (Date.now() - (window.__vwAt || 0) < 400) return;
      $('viewer').classList.add('hide');
    };
  }

  /* ---------------- 设置与诊断 ---------------- */

  var __geoCache = '';
  var GEO_CN = {'China':'中国','United States':'美国','Hong Kong':'香港','Taiwan':'台湾','Japan':'日本','Singapore':'新加坡','South Korea':'韩国','Korea':'韩国','Germany':'德国','United Kingdom':'英国','Russia':'俄罗斯','Canada':'加拿大','France':'法国','Netherlands':'荷兰','India':'印度','Australia':'澳大利亚','Brazil':'巴西','Vietnam':'越南','Thailand':'泰国','Malaysia':'马来西亚','Philippines':'菲律宾','Indonesia':'印度尼西亚','Turkey':'土耳其','Ukraine':'乌克兰','Poland':'波兰','Sweden':'瑞典','Norway':'挪威','Finland':'芬兰','Switzerland':'瑞士','Spain':'西班牙','Italy':'意大利','Mexico':'墨西哥','Argentina':'阿根廷','United Arab Emirates':'阿联酋','Macau':'澳门'};
  function ipGeo() {
    if (__geoCache) return __geoCache;
    if (!nativeReady()) { __geoCache = '未知'; return __geoCache; }
    var urls = ['https://ip.useragentinfo.com/json',
                'https://ip-api.com/json/?lang=en&fields=country'];
    for (var i = 0; i < urls.length; i++) {
      try {
        var s = String(N.httpGet(urls[i]) || '');
        if (s.charAt(0) !== '{') continue;
        var j = JSON.parse(s);
        var cc = String(j.country || j.country_name || j.countryCode || '').trim();
        if (!cc) continue;
        __geoCache = GEO_CN[cc] || cc;
        return __geoCache;
      } catch (e) {}
    }
    __geoCache = '未知';
    return __geoCache;
  }

  function refreshStor() {
    var s = $('storTxt'), p = $('pathTxt');
    var dir = '', stt = 'ok';
    try { dir = nativeReady() ? String(N.getDir() || '') : ''; } catch (e) {}
    try { stt = (nativeReady() && typeof N.storageState === 'function') ? String(N.storageState() || 'ok') : 'ok'; } catch (e2) {}
    if (p) p.textContent = (dir || '/storage/emulated/0/QW-Workshop') + '/<作品ID>/';
    if (s) {
      var pub = dir.indexOf('/Android/data/') >= 0 || dir.indexOf('/Android/') >= 0;
      if (stt === 'ok' && !pub) s.textContent = '已授权（写入公共目录）';
      else if (stt === 'ok' && pub) s.textContent = '未授权（已自动改存应用专属目录）';
      else s.textContent = '需要授权（点下方按钮开启「所有文件访问权限」）';
    }
  }

  function openSettings() {
    try { refreshStor(); } catch (e0) {}
    try { natInit(); natRender(true); } catch (e) { var db = document.getElementById('dnStat'); if (db) db.textContent = '下载会话初始化失败：' + (e && e.message ? e.message : e); try { probe('NATERR ' + (e && e.message ? e.message : e)); } catch (e2) {} }
    window.__cfgAt = Date.now();
    $('settings').classList.remove('hide'); refreshLogin(); }
  function closeSettings() {
    if (Date.now() - (window.__cfgAt || 0) < 400) return;
    $('settings').classList.add('hide');
  }


  function ping() {
    $('diagTxt').textContent = '检测中…';
    setTimeout(function () {
      var t0 = Date.now();
      try {
        var html = String(N.httpGet('https://store.steampowered.com/account/') || '');
        var ms = Date.now() - t0;
        if (!html || html.length < 500) throw new Error('返回内容过短');
        var sid = '';
        try { sid = N.getLogin() || ''; } catch (e) {}
        var mt = html.match(/<title>([^<]{1,60}?)\s*的帐户/);
        var geo = '';
        try { geo = ipGeo(); } catch (eg) { geo = ''; }
        var gt = '（' + (geo || '未知') + '）';
        var line = 'Steam 页面 ' + ms + 'ms / ' + Math.round(html.length / 1024) + 'KB';
        if (mt) line += ' · 已登录 ' + maskName(mt[1].trim()) + (sid ? '（SteamID ' + maskSid(sid) + '）' : '') + ' · IP ' + gt;
        else line += (sid ? ' · 有 SteamID 但页面未识别昵称' : '') + ' · IP ' + gt;
        $('diagTxt').textContent = line;
        toast('连通正常 · ' + ms + 'ms');
      } catch (e) {
        $('diagTxt').textContent = '异常：' + (e.message || '');
        toast('不通：' + (e.message || ''), 3200);
      }
    }, 30);
  }

  /* ---------------- 绑定 ---------------- */

  var qTimer = 0;
  function doSearch() {
    var box = $('q');
    var t = String((box && box.value) || '').replace(/^\s+|\s+$/g, '');
    if (!t) { st.q = ''; st.page = 1; loadList(); toast('已显示全部作品'); return; }
    var m = t.match(/[?&]id=(\d{4,})/) || t.match(/^(\d{4,})$/);
    if (m) { openDetail(m[1]); return; }
    st.q = t; st.page = 1; loadList(); toast('搜索：' + t);
  }
  function bind() {
    /* —— 最先绑核心按钮：后面任何一条绑定失败都不影响这些 —— */
    on('gateYes', function () {
      if (window.__gateOk) return;
      window.__gateOk = 1;
      try { localStorage.setItem('qw_agree', '1'); } catch (e) {}
      /* 先立刻把免责声明整块从屏幕上拿掉，让点击有即时反馈；
         重活（恢复登录 / 拉首页）延后到下一两帧，避免低端机主线程被占住后全屏点不动 */
      var g = $('gate');
      if (g) {
        g.classList.add('hide');
        try { g.style.display = 'none'; } catch (e0) {}
      }
      try { toast('欢迎使用 QW 工坊'); } catch (e) {}
      setTimeout(function () {
        try { refreshLogin(); } catch (e) {}
        setTimeout(function () { try { loadList(); } catch (e) {} }, 80);
      }, 90);
    });
    on('gateNo', function () {
      var g = $('gate');
      if (g) { g.style.transition = 'opacity .2s'; g.style.opacity = '0'; }
      var quit = function () {
        try { if (nativeReady() && N.exit) { N.exit(); return; } } catch (e) {}
        try { if (window.QW && QW.exit) { QW.exit(); return; } } catch (e2) {}
        try { if (nativeReady() && N.finishApp) { N.finishApp(); return; } } catch (e3) {}
        if (g) { g.style.opacity = '1'; }
        toast('请手动退出应用（长按返回键或从任务列表关闭）', 3600);
      };
      setTimeout(quit, 200);
    });
    on('btnMenu', openDrawer);
    on('btnCfg', openSettings);
    on('btnDl', openDl);
    on('btnRefresh', loadList);
    on('btnStor', function () {
      try { if (nativeReady() && N.askStorage) { N.askStorage(); toast('请在系统页面允许「所有文件访问权限」后返回', 3600); } }
      catch (e) { toast('打开授权页失败：' + (e && e.message ? e.message : e)); }
    });
    on('dClose', closeDrawer);
    on('cfgClose', closeSettings);
    on('dlClose', closeDl);
    on('detailClose', closeDetail);
    on('vClose', function () { var v = $('viewer'); if (v) v.classList.add('hide'); });

    $('btnMenu').onclick = openDrawer;
    $('dClose').onclick = closeDrawer;
    $('scrim').onclick = function () {
      if (Date.now() - (window.__drawerAt || 0) < 350) return;
      closeDrawer();
    };
    $('detailClose').onclick = closeDetail;
    $('detail').addEventListener('click', function (e) {
      if (e.target && e.target.id === 'detail') closeDetail();
    });
    $('dApply').onclick = applyDrawer;
    $('dReset').onclick = function () { resetDrawer(); toast('已重置筛选'); };

    $('btnRefresh').onclick = function () {
      var b = this;
      b.classList.remove('spin');
      void b.offsetWidth;
      b.classList.add('spin');
      setTimeout(function () { b.classList.remove('spin'); }, 900);
      loadList();
      toast('已刷新');
    };
    $('btnRetry').onclick = function () { loadList(); };
    $('btnDl').onclick = openDl;
    $('btnCfg').onclick = openSettings;
    $('cfgClose').onclick = closeSettings;
    $('settings').onclick = function (e) { if (e.target === $('settings')) closeSettings(); };
    $('btnPing').onclick = ping;

    $('dlClose').onclick = closeDl;
    $('dlCancelAll').onclick = function () {
      dlLoad();
      var n = 0;
      for (var i = 0; i < dlTasks.length; i++) {
        var t = dlTasks[i];
        if (t.status === 8 || t.status === 16) continue;
        dlPause(t);
        n++;
      }
      dlSave(); renderDl();
      toast(n ? ('已取消 ' + n + ' 个任务') : '没有进行中的任务');
    };
    $('dlClearDone').onclick = function () {
      dlLoad();
      var keep = [], hits = [];
      for (var i = 0; i < dlTasks.length; i++) {
        var t = dlTasks[i];
        if (t.status === 8 || (t.status === 16 && t.err !== '已暂停')) hits.push(t); else keep.push(t);
      }
      if (!hits.length) { toast('没有已完成 / 已取消的记录'); return; }
      cfmOpen('将清除 ' + hits.length + ' 条已完成 / 已取消记录。', function (del) {
        var r = del ? delLocalFor(hits) : null;
        dlTasks = keep; dlSave(); renderDl();
        if (r) toast('已清除 ' + hits.length + ' 条记录，清理本地文件 ' + r.ok + ' 项' + (r.fail ? ('，' + r.fail + ' 项没删掉') : ''), 3000);
        else toast('已清除 ' + hits.length + ' 条记录（本地文件保留）', 2600);
      });
    };
    $('dlSelDel').onclick = function () { dlSelDelete(); };
    $('dlSelCancel').onclick = function () { dlSelClear(); };

    var dlBox = $('dlList');
    var lpTimer = 0, lpFired = false;

    function dlPressStart(e) {
      var row = (e.target && e.target.closest) ? e.target.closest('.dl-row') : null;
      if (!row) return;
      if (e.target.closest('[data-dlact]')) return;
      var k0 = row.getAttribute('data-k');
      lpFired = false;
      if (lpTimer) clearTimeout(lpTimer);
      lpTimer = setTimeout(function () {
        lpTimer = 0; lpFired = true;
        try { row.classList.add('longpress'); } catch (e0) {}
        dlSelEnter(k0);
        toast('已进入多选，点条目继续勾选', 1800);
      }, 480);
    }
    function dlPressEnd() {
      if (lpTimer) { clearTimeout(lpTimer); lpTimer = 0; }
      /* 部分 WebView 手势被吞时不触发 click，兜底复位防止下一次点击被吃掉 */
      if (lpFired) setTimeout(function () { lpFired = false; }, 500);
    }

    dlBox.addEventListener('touchstart', dlPressStart, { passive: true });
    dlBox.addEventListener('touchend', dlPressEnd);
    dlBox.addEventListener('touchmove', dlPressEnd);
    dlBox.addEventListener('mousedown', dlPressStart);
    dlBox.addEventListener('mouseup', dlPressEnd);
    dlBox.addEventListener('mouseleave', dlPressEnd);

    dlBox.addEventListener('click', function (e) {
      if (lpFired) { lpFired = false; return; }
      var b = (e.target && e.target.closest) ? e.target.closest('[data-dlact]') : null;
      var row = (e.target && e.target.closest) ? e.target.closest('.dl-row') : null;
      var k2 = b ? b.getAttribute('data-k') : (row ? row.getAttribute('data-k') : '');
      if (!k2) return;
      dlLoad();
      var t = dlByKey(k2);
      if (!t) return;
      if (dlSelOn) { dlSelToggle(k2); return; }
      if (!b) return;
      var act = b.getAttribute('data-dlact');
      if (act === 'wp') { try { probe('DLACT wp ' + String(t && t.item)); } catch (e5) {} qwWpRun(t); return; }
      if (act === 'open') { dlOpenPath(t); return; }
      if (act === 'redl') {
        t._doneToast = 0; t.err = '';
        if (t.kind === 'item') {
          t.status = 0; t.phase = '准备中…';
          dlSave(); renderDl();
          setTimeout(function () { dlRunItem(t); }, 30);
        } else {
          t.done = 0; t.total = 0; t._c = null;
          try { N.resetFile(dlPath(t)); } catch (e9) {}
          dlSave(); renderDl();
          setTimeout(function () { dlRun(t); }, 30);
        }
        toast('已重新开始：' + (t.title || ''), 2200);
        return;
      }
      if (act === 'pause') { if (t.kind === 'item') dlItemPause(t); else dlPause(t); return; }
      if (act === 'resume') { if (t.kind === 'item') dlRunItem(t); else dlRun(t); return; }
    });

    $('q').addEventListener('keydown', function (e) {
      var k = e.key || '';
      if (!(k === 'Enter' || k === 'Go' || k === 'Search' || e.keyCode === 13)) return;
      e.preventDefault();
      this.blur();
      doSearch();
    });
    $('q').addEventListener('search', function () { doSearch(); });
    $('q').addEventListener('input', function () {
      var vv = this.value || '';
      if (qTimer) clearTimeout(qTimer);
      qTimer = setTimeout(function () {
        qTimer = 0;
        if (String(vv).trim()) doSearch();
        else if (st.q) { st.q = ''; st.page = 1; loadList(); }
      }, 700);
    });

    $('pgPrev').onclick = function () { if (st.page > 1) { st.page--; loadList(); } else { toast('已经是第一页了'); } };
    $('pgNext').onclick = function () {
      if (st.totalPages && st.page >= st.totalPages) { toast('已经是最后一页了'); return; }
      st.page++; loadList();
    };
    $('pgGo').onclick = function () {
      var n = parseInt($('pgJump').value, 10);
      if (!n || n < 1) { toast('请输入页码'); return; }
      if (st.totalPages && n > st.totalPages) n = st.totalPages;
      st.page = n;
      $('pgJump').value = '';
      loadList();
    };

    var single = [['cSort'], ['cType'], ['cCat']];
    for (var i = 0; i < single.length; i++) {
      (function (g) {
        var chips = document.querySelectorAll('#' + g + ' .chip');
        for (var k = 0; k < chips.length; k++) {
          chips[k].onclick = function () {
            if (g === 'cSort') { setChip(g, this.getAttribute('data-v')); return; }
            /* 多选组：至少保留一个 */
            this.classList.toggle('on');
            var any = false, all = document.querySelectorAll('#' + g + ' .chip');
            for (var q = 0; q < all.length; q++) { if (all[q].classList.contains('on')) any = true; }
            if (!any) { this.classList.add('on'); toast('这一组至少选一个', 1800); }
          };
        }
      })(single[i][0]);
    }

    var ac = document.querySelectorAll('#cAge .chip');
    for (var a = 0; a < ac.length; a++) {
      ac[a].onclick = function () {
        this.classList.toggle('on');
        var any = false, all = document.querySelectorAll('#cAge .chip');
        for (var k = 0; k < all.length; k++) {
          if (all[k].classList.contains('on')) any = true;
        }
        if (!any) { this.classList.add('on'); toast('年龄分级至少选一个', 2000); }
      };
    }

    var cc = document.querySelectorAll('#cCols .chip');
    for (var c = 0; c < cc.length; c++) {
      cc[c].onclick = function () {
        var v = this.getAttribute('data-v');
        if (v === 'custom') { $('colCustomWrap').classList.remove('hide'); return; }
        applyCols(v);
      };
    }
    $('colCustomOk').onclick = function () { applyCols($('colCustom').value); };


    /* gate 按钮已在 bind() 开头用 on() 绑定，此处不再重复 */
    on('btnSponsor', function () {
      var s = $('sponsor');
      if (s) s.classList.remove('hide');
    });
    on('sponsorClose', function () {
      var s = $('sponsor');
      if (s) s.classList.add('hide');
    });
    $('btnGateAgain').onclick = function () {
      closeSettings();
      window.__gateOk = 0;
      var g = $('gate');
      if (g) { try { g.style.display = ''; } catch (e) {} g.classList.remove('hide'); }
    };

    document.addEventListener('click', function (e) {
      var t = e.target;
      if (!t || !t.closest) return;
      var btn = t.closest('[data-act]');
      if (btn) {
        var act = btn.getAttribute('data-act');
        var id = btn.getAttribute('data-id') || '';
        if (act === 'steam') {
          if (nativeReady()) N.openUrl('https://steamcommunity.com/sharedfiles/filedetails/?id=' + id);
          return;
        }
        if (act === 'copy') {
          var url = 'https://steamcommunity.com/sharedfiles/filedetails/?id=' + id;
          toast(copyText(url) ? '已复制作品链接' : '复制失败');
          return;
        }
        if (act === 'save') { saveCover(btn.getAttribute('data-img') || '', id); return; }
        if (act === 'dl') { dlPack(); return; }
        return;
      }
      if (t.closest('.dhero')) { heroHint(); return; }
      var card = t.closest('.card');
      if (card && card.getAttribute('data-id')) {
        openDetail(card.getAttribute('data-id'));
      }
    });

    document.addEventListener('dblclick', function (e) {
      var t = e.target;
      if (!t || !t.closest) return;
      if (t.closest('.dhero') || t.closest('.vstage img')) {
        if (heroHintTimer) { clearTimeout(heroHintTimer); heroHintTimer = 0; }
        if (t.closest('.vstage img')) return;
        openViewer([{ id: curDetail.id, img: curDetail.img }], 0);
      }
    });

    bindViewer();
  }

  /* ---------------- 启动 ---------------- */

  window.qwOnResume = function () {
    var s0 = $('settings');
    if (s0 && !s0.classList.contains('hide')) { refreshLogin(); }
  };

  function init() {
    var v = '1.1.0';
    if (nativeReady()) { try { v = N.getVersion(); } catch (e) {} }
    safe('migrAcc', migrAcc);              /* 抹掉旧的明文账号，只留打码名 */
    safe('bind', bind);                    /* 先绑按钮，后面任何初始化失败都不影响操作 */
    safe('dlInitOnce', dlInitOnce);
    safe('dlLoad', dlLoad);
    safe('renderDl', renderDl);
    safe('verTxt2', function () { $('verTxt2').textContent = v; });
    safe('dirprobe', function () {
      var d = '', stt = 'na';
      try { d = nativeReady() ? String(N.getDir() || '') : ''; } catch (e) {}
      try { stt = (nativeReady() && N.storageState) ? String(N.storageState() || '') : 'na'; } catch (e2) {}
      probe('DIR=' + d + ' STATE=' + stt);
    });
    probe('BOOT v=' + v + ' ready=' + nativeReady());

    var agreed = null;
    try { agreed = localStorage.getItem('qw_agree'); } catch (e) {}
    if (agreed === '1') { var g0 = $('gate'); if (g0) g0.classList.add('hide'); }

    var w0 = window.innerWidth || 400;
    var defCols = defColsFor(w0);
    var c0 = defCols;
    try { c0 = parseInt(localStorage.getItem('qw_cols'), 10) || defCols; } catch (e) {}
    restoreFilter();
    if (!st.types || !st.types.length || st.types.indexOf('Application') >= 0) st.types = ['Scene', 'Video', 'Web'];
    if (!st.cats || !st.cats.length) st.cats = ['Wallpaper', 'Preset', 'Resource'];
    safe('applyCols', function () { applyCols(c0, false); });
    safe('refreshLogin', refreshLogin);
    safe('loadList', loadList);
  }

  function autoCols() {
    var saved = null;
    try { saved = localStorage.getItem('qw_cols'); } catch (e) {}
    if (saved) return;                       /* 用户手动选过就固定 */
    var w = window.innerWidth || 400;
    applyCols(defColsFor(w), false);
  }
  /* 旋转 / 窗口宽度跨断点时，即使没手动设置也要重新按断点取列数 */
  var __lastBand = -1;
  function bandOf(w) { return w <= 600 ? 0 : (w <= 960 ? 1 : 2); }
  window.addEventListener('orientationchange', function () { setTimeout(function () { __lastBand = -1; autoCols(); }, 120); });
  var rsTimer = 0;
  window.addEventListener('resize', function () {
    if (rsTimer) clearTimeout(rsTimer);
    rsTimer = setTimeout(function () {
      var w = window.innerWidth || 400, b = bandOf(w);
      if (b !== __lastBand) { __lastBand = b; try { localStorage.removeItem('qw_cols'); } catch (e) {} autoCols(); }
      else autoCols();
    }, 260);
  });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

/* ================= 原生 Steam 下载器（v0.9.0，复用旧基座 JavaSteam） ================= */
var NATDL = { loggedIn: false, busy: false, guard: false, guardType: '', restoring: false, hasToken: false,
              account: '', text: '', _init: 0 };

function natAvail() { return !!(window.QW && window.QW.stState && window.QW.itemStart); }

function natJson(o) { try { return JSON.parse(String(o || '{}')); } catch (e) { return null; } }

function natInit() {
  if (!natAvail()) return;
  if (!NATDL._init) {
    NATDL._init = 1;
    try { QW.stInit(); probe('ST_INIT ok'); } catch (e) { probe('ST_INIT_ERR ' + (e && e.message ? e.message : e)); }
  }
  natTick();
  if (!window.__natTimer) window.__natTimer = setInterval(natTick, 900);
}

function natStateText(j) {
  if (!j) return '未登录。在设置里登录 Steam 账号后即可下载原项目（不登录只能浏览与下载封面）。';
  if (j.loggedIn) return '下载会话已连接' + (NATDL.account ? ' · ' + maskName(NATDL.account) : '');
  if (j.guard) return '需要 Steam Guard 验证码' + (String(j.guardType || '') === 'email' ? '（邮箱）' : (String(j.guardType || '') ? '（手机令牌）' : ''));
  if (j.restoring || (j.hasToken && !j.loggedIn)) return '正在恢复上次会话…';
  if (j.busy) return '正在登录…';
  return '未登录。在设置里登录 Steam 账号后即可下载原项目（不登录只能浏览与下载封面）。';
}

function natTick() {
  if (!natAvail()) return;
  var j = natJson(QW.stState());
  if (!j) return;
  var wasLogin = NATDL.loggedIn, wasGuard = NATDL.guard;
  NATDL.loggedIn = !!j.loggedIn;
  NATDL.busy = !!j.busy;
  NATDL.guard = !!j.guard;
  NATDL.guardType = String(j.guardType || '');
  NATDL.restoring = !!j.restoring;
  NATDL.hasToken = !!j.hasToken;
  if (j.account) NATDL.account = String(j.account);
  NATDL.text = natStateText(j);
  var firstTick = !NATDL.ticked;
  NATDL.ticked = 1;
  if (NATDL.guard && window.__dn && window.__dn.code && !window.__dn.guardSent) {
    window.__dn.guardSent = true;
    try { QW.stGuard(window.__dn.code); } catch (e8) {}
  }
  /* 连接状态只在设置页展示，不再弹任何提示 */
  if (wasLogin !== NATDL.loggedIn && !window.__loginBusy) {
    if (NATDL.loggedIn) loginFormOpen = false;
    try { refreshLogin(); } catch (e6) {}
  }
  natRender();
  natProgress();
}

function natRender() {
  var el = document.getElementById('dnStat');
  var txt;
  if (!natAvail()) txt = '下载会话：原生内核不可用';
  else if (NATDL.loggedIn) txt = '下载会话：已连接' + (NATDL.account ? ' · ' + maskName(NATDL.account) : '') + '（可直接下载原项目）';
  else if (NATDL.guard) txt = '下载会话：需要 Steam Guard 验证码 —— 把验证码填进上面的框，再点一次「登录 Steam」';
  else if (NATDL.busy) txt = '下载会话：登录中…';
  else if (NATDL.hasToken || NATDL.restoring) txt = '下载会话：正在恢复上次会话…';
  else txt = '下载会话：未登录（上面登录一次即可同时用于浏览与下载）';
  if (el) el.textContent = txt;
}

function natStart(u, p) {
  if (!natAvail()) return;
  try {
    QW.stInit();
    QW.stLogin(u, p);
    NATDL.busy = true;
    natRender();
  } catch (e) {
    try { probe('ST_LOGIN_ERR ' + (e && e.message ? e.message : e)); } catch (e2) {}
  }
}

function natProgress() {
  if (!natAvail() || !QW.itemProgress) return;
  var changed = false;
  for (var i = 0; i < dlTasks.length; i++) {
    var t = dlTasks[i];
    if (t.kind !== 'item') continue;
    /* 已完成的任务不让内核空快照回写状态，避免重进 App 后被打回「准备中 / 0%」 */
    if (t.status === 8) continue;
    var before = [t.done, t.total, t.status, t.phase || '', t.err || ''].join('|');
    var p = natJson(QW.itemProgress(String(t.item)));
    if (!p) continue;
    /* 内核重启后 map 是空的，返回的空快照一律忽略 */
    if (!p.done && !p.error && !p.paused && (Number(p.total) || 0) <= 0 && (Number(p.received) || 0) <= 0) continue;
    t.total = Number(p.total) || 0;
    t.done = Number(p.received) || 0;
    t.phase = String(p.phase || '');
    if (p.done) { t.status = 8; t.err = ''; }
    else if (p.error) { t.status = 16; t.err = String(p.error); }
    else if (p.paused) { t.status = 16; t.err = '已暂停'; }
    else { t.status = 2; t.err = ''; }
    if (before !== [t.done, t.total, t.status, t.phase || '', t.err || ''].join('|')) changed = true;
    if (p.done && !t._doneToast) { t._doneToast = 1; toast('原项目下载完成：' + (t.title || t.item), 3600); }
    if (p.done) qwAutoMove(t);
  }
  if (changed) { dlSave(); if ($('dlSheet') && !$('dlSheet').classList.contains('hide')) renderDl(); }
}

function dlRunItem(t) {
  if (!ensureStorage(function () { dlRunItem(t); })) { t.status = 16; t.err = '等待文件权限（已打开授权页，授权后自动继续）'; renderDl(); return; }
  if (!natAvail()) { t.status = 16; t.err = '原生下载内核不可用'; renderDl(); return; }
  if (!NATDL.loggedIn) {
    t.status = 16; t.err = '未登录 Steam 账号'; renderDl();
    openSettings();
    setTimeout(function () { try { natRender(true); } catch (e) {} }, 120);
    return;
  }
  t.status = 2; t.err = ''; t.phase = '准备中…'; t._doneToast = 0;
  dlSave(); renderDl();
  try { QW.itemStart(String(t.item), String(t.manifest), String(t.title || ''), String(t.img || '')); }
  catch (e) { t.status = 16; t.err = (e && e.message ? e.message : String(e)); renderDl(); return; }
  setTimeout(natProgress, 500);
}

function dlItemPause(t) {
  try { QW.itemPause(String(t.item)); } catch (e) {}
  t.status = 16; t.err = '已暂停'; dlSave(); renderDl();
}

  /* 从场景包（scene.pkg）里提取内嵌图片 → 下载目录/图片 */
  /* 居中提示小弹窗（自动消失） */
  function popCard(title, sub, ms) {
    var el = document.getElementById('qwCard');
    if (!el) {
      el = document.createElement('div');
      el.id = 'qwCard';
      el.style.cssText = 'position:fixed;left:50%;top:50%;transform:translate(-50%,-50%);z-index:10000;' +
        'background:rgba(20,20,26,.96);color:#fff;padding:20px 26px;border-radius:16px;text-align:center;' +
        'box-shadow:0 10px 40px rgba(0,0,0,.55);min-width:240px;max-width:76vw;pointer-events:none';
      document.body.appendChild(el);
    }
    var parts = String(sub || '').split('\n');
    el.innerHTML = '<div style="font-size:19px;font-weight:600;margin-bottom:8px">' + esc(title) + '</div>' +
      (sub ? '<div style="font-size:14px;line-height:1.55;opacity:.85;word-break:break-all">' +
        parts.map(function (s) { return esc(s); }).join('<br>') + '</div>' : '');
    if (popCard._t) clearTimeout(popCard._t);
    popCard._t = setTimeout(function () {
      var e2 = document.getElementById('qwCard');
      if (e2 && e2.parentNode) e2.parentNode.removeChild(e2);
    }, ms || 2200);
  }

  function showWpProg(p) {
    if (p < 0) p = 0;
    if (p > 100) p = 100;
    var el = document.getElementById('wpProg');
    if (!el) {
      el = document.createElement('div');
      el.id = 'wpProg';
      el.style.cssText = 'position:fixed;left:50%;transform:translateX(-50%);bottom:100px;z-index:9999;' +
        'background:rgba(18,18,22,.95);color:#fff;padding:10px 18px;border-radius:12px;font-size:15px;' +
        'line-height:1.5;box-shadow:0 6px 24px rgba(0,0,0,.45);min-width:180px;text-align:center;pointer-events:none';
      document.body.appendChild(el);
    }
    el.textContent = '正在提取图片… ' + p + '%';
  }

  function hideWpProg() {
    var el = document.getElementById('wpProg');
    if (el && el.parentNode) el.parentNode.removeChild(el);
  }

  function qwWpRun(t) {
    var dir = '/storage/emulated/0/QW-Workshop/' + String(t.item || '') + '/';
    if (!(typeof N !== 'undefined' && N.wpStart)) { toast('当前内核不支持提取，请确认安装的是最新版', 3200); return; }
    var had = false;
    try { had = (typeof N !== 'undefined' && N.wpHas) ? !!N.wpHas(dir) : false; } catch (eH) {}
    if (had) {
      popCard('您已经提取过了', '图片在 QW-Workshop/' + String(t.item || '') + '/图片/\n要重新提取，请先在文件管理里删掉旧图片', 3200);
      return;
    }
    var stt = '';
    try { stt = String(N.wpStart(dir) || ''); } catch (e) {
      toast('提取启动失败：' + (e && e.message ? e.message : e), 4000);
      return;
    }
    if (stt === 'busy') { toast('上一张还在提取，稍等一下', 2400); return; }
    var wpT0 = Date.now();
    showWpProg(0);
    var tick = setInterval(function () {
      var p = 0, res = '';
      if (Date.now() - wpT0 > 120000) {
        clearInterval(tick); hideWpProg();
        toast('提取超时，请重试或检查文件完整性', 3600);
        return;
      }
      try { p = parseInt(N.wpPct(), 10) || 0; } catch (e1) {}
      try { res = String(N.wpPoll() || ''); } catch (e2) {}
      showWpProg(p);
      if (!res) return;
      clearInterval(tick);
      showWpProg(100);
      /* 提取很快，浮窗至少停留 1 秒，保证肉眼能看到百分比 */
      setTimeout(hideWpProg, Math.max(320, 1050 - (Date.now() - wpT0)));
      var j = null;
      try { j = JSON.parse(res); } catch (e3) {}
      try { probe('WP ret=' + String(res).slice(0, 400)); } catch (e4) {}
      if (j && j.ok) {
        var files = j.files || [];
        var names = [];
        for (var i = 0; i < files.length && i < 3; i++) names.push(String(files[i]).split('/').pop());
        var extra = files.length > 3 ? (' 等 ' + files.length + ' 张') : '';
        popCard('提取完成', '共 ' + files.length + ' 张图片\nQW-Workshop/' + String(t.item || '') + '/图片/\n' + names.join('、') + extra, 2600);
      } else {
        popCard('提取失败', (j && j.msg) ? String(j.msg) : ('提取失败：' + String(res).slice(0, 120)), 3400);
      }
    }, 260);
  }

try { cfmInit(); } catch (eCfm) {}
setTimeout(natInit, 600);

})();