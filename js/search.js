/* ── Universal Search — American Yawp MS ──
   Cmd+K / Ctrl+K to open, Esc to close.
   Searches chapter headings, body text, and vocabulary terms. */

(function () {
  'use strict';

  var INDEX = null;
  var modal = null;
  var input = null;
  var results = null;
  var overlay = null;
  var selectedIdx = -1;

  // ── Determine base path (handles /primary-sources/ subdir) ──
  var basePath = '';
  if (location.pathname.indexOf('/primary-sources/') !== -1) {
    basePath = '../';
  }

  // ── Build the modal DOM ──
  function createModal() {
    overlay = document.createElement('div');
    overlay.className = 'search-overlay';
    overlay.setAttribute('role', 'presentation');

    modal = document.createElement('div');
    modal.className = 'search-modal';
    modal.setAttribute('role', 'dialog');
    modal.setAttribute('aria-label', 'Search');

    var header = document.createElement('div');
    header.className = 'search-header';

    var icon = document.createElement('span');
    icon.className = 'search-icon';
    icon.innerHTML = '&#x1F50D;';
    icon.setAttribute('aria-hidden', 'true');

    input = document.createElement('input');
    input.type = 'text';
    input.className = 'search-input';
    input.placeholder = 'Search chapters, vocab, topics...';
    input.setAttribute('aria-label', 'Search the textbook');
    input.setAttribute('autocomplete', 'off');
    input.setAttribute('spellcheck', 'false');

    var kbd = document.createElement('kbd');
    kbd.className = 'search-kbd';
    kbd.textContent = 'esc';

    header.appendChild(icon);
    header.appendChild(input);
    header.appendChild(kbd);

    results = document.createElement('div');
    results.className = 'search-results';
    results.setAttribute('role', 'listbox');
    results.setAttribute('aria-label', 'Search results');

    var hint = document.createElement('div');
    hint.className = 'search-hint';
    hint.innerHTML = 'Type to search across all 15 chapters';

    modal.appendChild(header);
    modal.appendChild(results);
    modal.appendChild(hint);

    document.body.appendChild(overlay);
    document.body.appendChild(modal);

    // Events
    input.addEventListener('input', debounce(onSearch, 150));
    input.addEventListener('keydown', onKeyNav);
    overlay.addEventListener('click', closeSearch);
  }

  // ── Open / Close ──
  function openSearch() {
    if (!modal) createModal();
    if (!INDEX) loadIndex();
    overlay.classList.add('active');
    modal.classList.add('active');
    document.body.style.overflow = 'hidden';
    input.value = '';
    results.innerHTML = '';
    selectedIdx = -1;
    input.focus();
  }

  function closeSearch() {
    if (!modal) return;
    overlay.classList.remove('active');
    modal.classList.remove('active');
    document.body.style.overflow = '';
  }

  function isOpen() {
    return modal && modal.classList.contains('active');
  }

  // ── Load index ──
  function loadIndex() {
    if (INDEX) return;
    var xhr = new XMLHttpRequest();
    xhr.open('GET', basePath + 'js/search-index.json', true);
    xhr.onload = function () {
      if (xhr.status === 200) {
        try { INDEX = JSON.parse(xhr.responseText); } catch (e) { INDEX = []; }
      }
    };
    xhr.send();
  }

  // ── Search logic ──
  function onSearch() {
    var q = input.value.trim().toLowerCase();
    if (!q || q.length < 2) {
      results.innerHTML = '';
      selectedIdx = -1;
      return;
    }
    if (!INDEX) { results.innerHTML = '<div class="search-empty">Loading index...</div>'; return; }

    var hits = [];
    var words = q.split(/\s+/);

    INDEX.forEach(function (ch) {
      // Search sections
      ch.sections.forEach(function (sec) {
        var score = 0;
        var headingLower = sec.heading.toLowerCase();
        var textLower = sec.text.toLowerCase();

        words.forEach(function (w) {
          if (headingLower.indexOf(w) !== -1) score += 10;
          if (textLower.indexOf(w) !== -1) score += 1;
        });

        if (score > 0) {
          hits.push({
            type: 'section',
            chapter: ch.chapter,
            title: ch.title,
            file: ch.file,
            heading: sec.heading,
            id: sec.id,
            preview: highlightSnippet(sec.preview, words),
            score: score
          });
        }
      });

      // Search vocab
      ch.vocab.forEach(function (v) {
        var score = 0;
        var termLower = v.term.toLowerCase();
        var defLower = v.def.toLowerCase();

        words.forEach(function (w) {
          if (termLower.indexOf(w) !== -1) score += 15;
          if (defLower.indexOf(w) !== -1) score += 2;
        });

        if (score > 0) {
          hits.push({
            type: 'vocab',
            chapter: ch.chapter,
            title: ch.title,
            file: ch.file,
            heading: v.term,
            id: '',
            preview: v.def,
            score: score
          });
        }
      });
    });

    // Sort by score descending
    hits.sort(function (a, b) { return b.score - a.score; });

    // Render top 20
    renderResults(hits.slice(0, 20), q);
  }

  function highlightSnippet(text, words) {
    // Find the position of the first matching word and extract surrounding context
    var lower = text.toLowerCase();
    var bestPos = -1;
    words.forEach(function (w) {
      var pos = lower.indexOf(w);
      if (pos !== -1 && (bestPos === -1 || pos < bestPos)) bestPos = pos;
    });

    var start = Math.max(0, bestPos - 40);
    var snippet = text.substring(start, start + 200);
    if (start > 0) snippet = '...' + snippet;
    if (start + 200 < text.length) snippet += '...';
    return snippet;
  }

  function renderResults(hits, q) {
    selectedIdx = -1;
    if (hits.length === 0) {
      results.innerHTML = '<div class="search-empty">No results for "' + escapeHtml(q) + '"</div>';
      return;
    }

    var html = '';
    hits.forEach(function (hit, i) {
      var href = basePath + hit.file + (hit.id ? '#' + hit.id : '');
      var icon = hit.type === 'vocab' ? '<span class="search-result-badge">Vocab</span>' : '';
      html += '<a class="search-result-item" href="' + href + '" role="option" data-idx="' + i + '">';
      html += '<div class="search-result-title">' + icon + '<strong>Ch ' + hit.chapter + ':</strong> ' + escapeHtml(hit.heading) + '</div>';
      html += '<div class="search-result-preview">' + escapeHtml(hit.preview) + '</div>';
      html += '<div class="search-result-meta">' + escapeHtml(hit.title) + '</div>';
      html += '</a>';
    });

    results.innerHTML = html;
  }

  // ── Keyboard navigation ──
  function onKeyNav(e) {
    var items = results.querySelectorAll('.search-result-item');
    if (!items.length) return;

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      selectedIdx = Math.min(selectedIdx + 1, items.length - 1);
      updateSelection(items);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      selectedIdx = Math.max(selectedIdx - 1, 0);
      updateSelection(items);
    } else if (e.key === 'Enter' && selectedIdx >= 0) {
      e.preventDefault();
      items[selectedIdx].click();
    }
  }

  function updateSelection(items) {
    items.forEach(function (el, i) {
      el.classList.toggle('selected', i === selectedIdx);
    });
    if (items[selectedIdx]) {
      items[selectedIdx].scrollIntoView({ block: 'nearest' });
    }
  }

  // ── Global keyboard shortcut ──
  document.addEventListener('keydown', function (e) {
    // Cmd+K or Ctrl+K
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
      e.preventDefault();
      if (isOpen()) closeSearch(); else openSearch();
    }
    // Escape
    if (e.key === 'Escape' && isOpen()) {
      e.preventDefault();
      closeSearch();
    }
  });

  // ── Expose for button clicks ──
  window.openYawpSearch = openSearch;

  // ── Auto-inject search button into the page nav ──
  function injectSearchButton() {
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'search-btn';
    btn.setAttribute('aria-label', 'Search (Cmd+K)');
    btn.innerHTML = '<span class="search-btn-icon" aria-hidden="true">&#x1F50D;</span><kbd>' +
      (navigator.platform.indexOf('Mac') !== -1 ? '\u2318K' : 'Ctrl+K') + '</kbd>';
    btn.addEventListener('click', openSearch);

    // Chapter pages: insert before the last child of .chapter-nav
    var chapterNav = document.querySelector('.chapter-nav');
    if (chapterNav) {
      var lastLink = chapterNav.lastElementChild;
      chapterNav.insertBefore(btn, lastLink);
      return;
    }

    // Supporting pages: append to .nav-bar
    var navBar = document.querySelector('.nav-bar');
    if (navBar) {
      navBar.appendChild(btn);
      return;
    }

    // Index page: append to .util-links
    var utilLinks = document.querySelector('.util-links');
    if (utilLinks) {
      btn.style.display = 'inline-flex';
      btn.style.marginLeft = '6px';
      utilLinks.appendChild(btn);
    }
  }

  // ── Preload index and inject button on page load ──
  function onReady() {
    loadIndex();
    injectSearchButton();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', onReady);
  } else {
    onReady();
  }

  // ── Helpers ──
  function debounce(fn, ms) {
    var timer;
    return function () {
      clearTimeout(timer);
      timer = setTimeout(fn, ms);
    };
  }

  function escapeHtml(str) {
    var div = document.createElement('div');
    div.textContent = str;
    return div.innerHTML;
  }
})();
