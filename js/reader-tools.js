/* ============================================================
   American Yawp MS — Reader Tools
   Highlighting, Notes, TTS, Font Controls, Line Focus
   ============================================================ */

(function() {
  'use strict';

  // ---- Storage key based on page ----
  var pageKey = location.pathname.replace(/[^a-z0-9]/gi, '_');

  // ==========================================
  // Reading Progress Bar
  // ==========================================
  function initProgressBar() {
    var bar = document.querySelector('.progress-bar');
    if (!bar) return;
    window.addEventListener('scroll', function() {
      var winH = document.documentElement.scrollHeight - window.innerHeight;
      var pct = winH > 0 ? (window.scrollY / winH) * 100 : 0;
      bar.style.width = Math.min(pct, 100) + '%';
    });
  }

  // ==========================================
  // Back to Top Button
  // ==========================================
  function initBackToTop() {
    var btn = document.querySelector('.back-to-top');
    if (!btn) return;
    window.addEventListener('scroll', function() {
      if (window.scrollY > 400) {
        btn.classList.add('visible');
      } else {
        btn.classList.remove('visible');
      }
    });
    btn.addEventListener('click', function() {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  // ==========================================
  // Reader Panel: Toolbox → Aa (reading) / Pencil (search, notes, vocab)
  // ==========================================
  function initReaderPanel() {
    var toolbar = document.querySelector('.reader-toolbar');
    var mainBtn = document.querySelector('.reader-toggle');
    var panel = document.querySelector('.reader-panel');
    if (!toolbar || !mainBtn || !panel) return;

    // Turn main button into toolbox icon; add two sub-buttons (Aa, pencil)
    mainBtn.setAttribute('aria-label', 'Reader tools');
    mainBtn.innerHTML = '\u2699'; // gear
    mainBtn.classList.add('reader-toolbox-main');
    mainBtn.title = 'Reader tools';

    var subAa = document.createElement('button');
    subAa.type = 'button';
    subAa.className = 'reader-toggle reader-sub-toggle reader-sub-aa';
    subAa.setAttribute('aria-label', 'Reading options');
    subAa.innerHTML = 'Aa';
    subAa.title = 'Reading: fonts, size, theme, highlight';

    var subPencil = document.createElement('button');
    subPencil.type = 'button';
    subPencil.className = 'reader-toggle reader-sub-toggle reader-sub-pencil';
    subPencil.setAttribute('aria-label', 'Search, notes, glossary');
    subPencil.innerHTML = '\u270E'; // pencil
    subPencil.title = 'Search, jump to section, notes, glossary';

    toolbar.insertBefore(subPencil, mainBtn);
    toolbar.insertBefore(subAa, mainBtn);

    function showSubButtons(show) {
      subAa.classList.toggle('reader-sub-visible', show);
      subPencil.classList.toggle('reader-sub-visible', show);
    }
    function openPanel(mode) {
      panel.dataset.mode = mode;
      panel.classList.add('open');
      showSubButtons(false);
    }
    function closePanel() {
      panel.classList.remove('open');
    }

    mainBtn.addEventListener('click', function(e) {
      e.stopPropagation();
      if (panel.classList.contains('open')) {
        closePanel();
        showSubButtons(false);
      } else {
        showSubButtons(!subAa.classList.contains('reader-sub-visible'));
      }
    });

    subAa.addEventListener('click', function(e) {
      e.stopPropagation();
      openPanel('reading');
    });
    subPencil.addEventListener('click', function(e) {
      e.stopPropagation();
      openPanel('tools');
    });

    document.addEventListener('click', function(e) {
      if (panel.contains(e.target) || mainBtn.contains(e.target) || subAa.contains(e.target) || subPencil.contains(e.target)) return;
      closePanel();
      showSubButtons(false);
    });
  }

  // Mark panel sections as reading vs tools (so we can show one set at a time)
  function markPanelSections() {
    var panel = document.querySelector('.reader-panel');
    if (!panel) return;
    panel.querySelectorAll('.reader-search-wrap').forEach(function(el) { el.setAttribute('data-in-panel', 'tools'); });
    panel.querySelectorAll('.reader-view-row').forEach(function(el) { el.setAttribute('data-in-panel', 'reading'); });
    panel.querySelectorAll('.reader-reading-time').forEach(function(el) { el.setAttribute('data-in-panel', 'tools'); });
    panel.querySelectorAll('.reader-section-jump').forEach(function(el) { el.setAttribute('data-in-panel', 'tools'); });
    panel.querySelectorAll('.reader-bookmarks-wrap').forEach(function(el) { el.setAttribute('data-in-panel', 'tools'); });
    panel.querySelectorAll('.reader-font-family').forEach(function(el) { el.setAttribute('data-in-panel', 'reading'); });
    panel.querySelectorAll('.reader-reading-width').forEach(function(el) { el.setAttribute('data-in-panel', 'reading'); });
    panel.querySelectorAll('.reader-reading-mode').forEach(function(el) { el.setAttribute('data-in-panel', 'reading'); });
    panel.querySelectorAll('.reader-section').forEach(function(section) {
      if (section.querySelector('[data-font-size], [data-spacing], [data-theme], [data-dyslexia], [data-line-focus], [data-highlight-color]')) {
        section.setAttribute('data-in-panel', 'reading');
      }
      if (section.querySelector('[data-action="notes"], [data-action="pdf"], [data-action="glossary"]')) {
        section.setAttribute('data-in-panel', 'tools');
      }
    });
  }

  // ==========================================
  // Font Size Control
  // ==========================================
  // ==========================================
  // Font Family (Serif / Sans) — Foliate-style
  // ==========================================
  function initFontFamily() {
    var panel = document.querySelector('.reader-panel');
    if (!panel) return;
    var saved = localStorage.getItem('yawp_font_family') || 'serif';
    if (saved === 'sans') document.body.classList.add('font-sans');

    var row = panel.querySelector('.reader-find-view .reader-view-btns') || panel.querySelector('.reader-font-family .reader-btn-row');
    var btns = row ? row.querySelectorAll('[data-font-family]') : [];
    if (btns.length) {
      btns.forEach(function(btn) {
        var f = btn.getAttribute('data-font-family');
        btn.classList.toggle('active', saved === f);
        btn.addEventListener('click', function() {
          document.body.classList.toggle('font-sans', f === 'sans');
          localStorage.setItem('yawp_font_family', f);
          row.querySelectorAll('[data-font-family]').forEach(function(b) { b.classList.remove('active'); });
          btn.classList.add('active');
        });
      });
      return;
    }
    var wrap = document.createElement('div');
    wrap.className = 'reader-section reader-font-family';
    wrap.innerHTML = '<label>Font</label><div class="reader-btn-row"></div>';
    row = wrap.querySelector('.reader-btn-row');
    ['serif', 'sans'].forEach(function(f) {
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'reader-btn' + (saved === f ? ' active' : '');
      btn.textContent = f === 'serif' ? 'Serif' : 'Sans';
      btn.setAttribute('data-font-family', f);
      btn.addEventListener('click', function() {
        document.body.classList.toggle('font-sans', f === 'sans');
        localStorage.setItem('yawp_font_family', f);
        row.querySelectorAll('[data-font-family]').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
      });
      row.appendChild(btn);
    });
    panel.insertBefore(wrap, panel.querySelector('.reader-section'));
  }

  function initFontSize() {
    var btns = document.querySelectorAll('[data-font-size]');
    var saved = localStorage.getItem('yawp_fontSize') || 'normal';
    applyFontSize(saved);

    btns.forEach(function(btn) {
      if (btn.getAttribute('data-font-size') === saved) btn.classList.add('active');
      btn.addEventListener('click', function() {
        btns.forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        var size = btn.getAttribute('data-font-size');
        applyFontSize(size);
        localStorage.setItem('yawp_fontSize', size);
      });
    });
  }

  function applyFontSize(size) {
    document.body.classList.remove('font-large', 'font-xlarge');
    if (size === 'large') document.body.classList.add('font-large');
    if (size === 'xlarge') document.body.classList.add('font-xlarge');
  }

  // ==========================================
  // Line Spacing Control
  // ==========================================
  function initSpacing() {
    injectExtraWideSpacingButton();
    var btns = document.querySelectorAll('[data-spacing]');
    var saved = localStorage.getItem('yawp_spacing') || 'normal';
    applySpacing(saved);

    btns.forEach(function(btn) {
      if (btn.getAttribute('data-spacing') === saved) btn.classList.add('active');
      btn.addEventListener('click', function() {
        btns.forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        var sp = btn.getAttribute('data-spacing');
        applySpacing(sp);
        localStorage.setItem('yawp_spacing', sp);
      });
    });
  }

  function injectExtraWideSpacingButton() {
    var row = document.querySelector('.reader-btn-row [data-spacing="wide"]');
    if (!row || row.closest('.reader-section') === null) return;
    var parent = row.parentNode;
    if (parent.querySelector('[data-spacing="xwide"]')) return;
    var btn = document.createElement('button');
    btn.className = 'reader-btn';
    btn.setAttribute('data-spacing', 'xwide');
    btn.textContent = 'Extra wide';
    parent.appendChild(btn);
  }

  function applySpacing(sp) {
    document.body.classList.remove('spacing-wide', 'spacing-xwide');
    if (sp === 'wide') document.body.classList.add('spacing-wide');
    if (sp === 'xwide') document.body.classList.add('spacing-xwide');
  }

  // ==========================================
  // OpenDyslexic Font (dyslexia-friendly)
  // ==========================================
  function initDyslexiaFont() {
    var btn = document.querySelector('[data-dyslexia]');
    if (!btn) return;
    var saved = localStorage.getItem('yawp_dyslexia') === 'true';
    if (saved) { document.body.classList.add('dyslexia-font'); btn.classList.add('active'); }

    btn.addEventListener('click', function() {
      var on = document.body.classList.toggle('dyslexia-font');
      btn.classList.toggle('active');
      localStorage.setItem('yawp_dyslexia', on);
    });
  }

  // ==========================================
  // Theme Control (Default / Sepia / High Contrast)
  // ==========================================
  function initTheme() {
    var btns = document.querySelectorAll('[data-theme]');
    var saved = localStorage.getItem('yawp_theme') || 'default';
    applyTheme(saved);

    btns.forEach(function(btn) {
      if (btn.getAttribute('data-theme') === saved) btn.classList.add('active');
      btn.addEventListener('click', function() {
        btns.forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        var theme = btn.getAttribute('data-theme');
        applyTheme(theme);
        localStorage.setItem('yawp_theme', theme);
      });
    });
  }

  function applyTheme(theme) {
    document.body.classList.remove('high-contrast', 'sepia', 'dark-mode');
    if (theme === 'contrast') document.body.classList.add('high-contrast');
    if (theme === 'sepia') document.body.classList.add('sepia');
    if (theme === 'dark') document.body.classList.add('dark-mode');
  }

  // ==========================================
  // Text-to-Speech (Kokoro default, compact UI, now-playing bar)
  // ==========================================
  var ttsBtn = null;
  var ttsRate = parseFloat(localStorage.getItem('yawp_tts_rate') || '0.9', 10);
  var ttsScope = localStorage.getItem('yawp_tts_scope') || 'section';
  var ttsVoiceId = localStorage.getItem('yawp_tts_voice') || '';
  var ttsQueue = [];
  var TTS_CHUNK_MAX = 4000;
  var ttsNowPlayingBar = null;
  var ttsPanel = null;

  var KOKORO_VOICES = [
    { id: 'af_bella', label: 'Bella (female)' },
    { id: 'af_heart', label: 'Heart (female)' },
    { id: 'af_nicole', label: 'Nicole (female)' },
    { id: 'am_michael', label: 'Michael (male)' },
    { id: 'am_fenrir', label: 'Fenrir (male)' },
    { id: 'bf_emma', label: 'Emma (British)' }
  ];

  function getTTSRate() { return ttsRate; }

  function getTTSVoice() {
    var voices = speechSynthesis.getVoices();
    if (ttsVoiceId && voices.length) {
      var v = voices.filter(function(x) { return x.voiceURI === ttsVoiceId || x.name === ttsVoiceId; })[0];
      if (v) return v;
    }
    var en = voices.filter(function(x) { return x.lang.startsWith('en'); });
    return en[0] || voices[0] || null;
  }

  function chunkTextForTTS(text) {
    var chunks = [];
    text = text.replace(/\s+/g, ' ').trim();
    if (text.length <= TTS_CHUNK_MAX) {
      chunks.push(text);
      return chunks;
    }
    var sentences = text.match(/[^.!?]+[.!?]\s*/g) || [text];
    var current = '';
    for (var i = 0; i < sentences.length; i++) {
      if (current.length + sentences[i].length > TTS_CHUNK_MAX && current.length > 0) {
        chunks.push(current.trim());
        current = '';
      }
      current += sentences[i];
    }
    if (current.trim()) chunks.push(current.trim());
    return chunks;
  }

  function normalizeForMatch(str) {
    return str.replace(/\s+/g, ' ').trim().toLowerCase();
  }

  function findBlockContainingText(container, chunkText) {
    if (!container || !chunkText) return null;
    var needle = normalizeForMatch(chunkText).slice(0, 80);
    var blocks = container.querySelectorAll('section, .overview');
    for (var i = 0; i < blocks.length; i++) {
      var blockNorm = normalizeForMatch(blocks[i].textContent);
      if (blockNorm.indexOf(needle) !== -1) return blocks[i];
    }
    return null;
  }

  function clearTTSReadingHighlight() {
    document.querySelectorAll('.tts-reading').forEach(function(el) { el.classList.remove('tts-reading'); });
    document.querySelectorAll('.tts-reading-sentence').forEach(function(el) { el.classList.remove('tts-reading-sentence'); });
  }

  function highlightBlockForChunk(chunkText) {
    clearTTSReadingHighlight();
    var container = document.querySelector('.container');
    var block = findBlockContainingText(container, chunkText);
    if (block) {
      block.classList.add('tts-reading');
      block.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }

  function showTTSNowPlaying(visible) {
    if (ttsNowPlayingBar) ttsNowPlayingBar.classList.toggle('visible', !!visible);
    if (ttsBtn) {
      ttsBtn.textContent = visible ? 'Stop Reading' : 'Read Aloud';
      ttsBtn.classList.toggle('active', !!visible);
    }
  }

  function speakChunkQueue(chunks, index) {
    if (index >= chunks.length) {
      clearTTSReadingHighlight();
      showTTSNowPlaying(false);
      return;
    }
    highlightBlockForChunk(chunks[index]);
    var u = new SpeechSynthesisUtterance(chunks[index]);
    u.rate = getTTSRate();
    var voice = getTTSVoice();
    if (voice) u.voice = voice;
    u.onend = function() { speakChunkQueue(chunks, index + 1); };
    u.onerror = function() { speakChunkQueue(chunks, index + 1); };
    speechSynthesis.speak(u);
  }

  function getTextForTTS() {
    var sel = window.getSelection();
    if (sel && sel.toString().trim().length > 0) return sel.toString().trim();

    if (ttsScope === 'chapter') {
      var container = document.querySelector('.container');
      return container ? container.textContent || '' : '';
    }

    var sections = document.querySelectorAll('section, .overview');
    var bestSection = null;
    var bestDist = Infinity;
    var viewMid = window.scrollY + window.innerHeight / 2;
    sections.forEach(function(s) {
      var rect = s.getBoundingClientRect();
      var elMid = window.scrollY + rect.top + rect.height / 2;
      var dist = Math.abs(elMid - viewMid);
      if (dist < bestDist) { bestDist = dist; bestSection = s; }
    });
    return bestSection ? bestSection.textContent : '';
  }

  function getNextSectionAfterCurrent() {
    var current = document.querySelector('section.tts-reading, .overview.tts-reading');
    if (!current) return null;
    var blocks = document.querySelectorAll('.container > section, .container > .overview');
    for (var i = 0; i < blocks.length; i++) {
      if (blocks[i] === current && i + 1 < blocks.length) return blocks[i + 1];
    }
    return null;
  }

  function startTTS(text) {
    var useKokoro = localStorage.getItem('yawp_tts_kokoro') !== 'false' && window.yawpKokoroTTS;
    var kokoroVoice = localStorage.getItem('yawp_tts_kokoro_voice') || 'af_bella';

    var startKokoro = function() {
      showTTSNowPlaying(true);
      window.yawpKokoroTTS.speak(text, {
        rate: getTTSRate(),
        voice: kokoroVoice,
        onSentence: function(sentence) { highlightSentenceInPage(sentence); },
        onEnd: function() {
          clearTTSReadingHighlight();
          showTTSNowPlaying(false);
        }
      });
    };

    if (useKokoro) {
      if (window.yawpKokoroTTS.isReady && window.yawpKokoroTTS.isReady()) {
        startKokoro();
        return;
      }
      if (window.yawpKokoroTTS.load) {
        if (ttsBtn) ttsBtn.textContent = 'Loading…';
        window.yawpKokoroTTS.load().then(startKokoro).catch(function() {
          if (ttsBtn) ttsBtn.textContent = 'Read Aloud';
          startBrowserTTS(text);
        });
        return;
      }
    }
    startBrowserTTS(text);
  }

  function startBrowserTTS(text) {
    showTTSNowPlaying(true);
    var chunks = chunkTextForTTS(text);
    speakChunkQueue(chunks, 0);
  }

  function initTTSClickRefocus() {
    var container = document.querySelector('.container');
    if (!container) return;
    container.addEventListener('click', function(e) {
      if (e.target.closest('a, button, [data-tts], .reader-toolbar, .reader-panel, .notes-panel, .glossary-panel, .vocab-box, .stop-think, .key-idea, .activity-box')) return;
      if (!speechSynthesis.speaking && (!window.yawpKokoroTTS || !window.yawpKokoroTTS.isPlaying || !window.yawpKokoroTTS.isPlaying())) return;
      var target = e.target.closest('section, .overview');
      if (!target) return;
      e.preventDefault();
      speechSynthesis.cancel();
      if (window.yawpKokoroTTS && window.yawpKokoroTTS.stop) window.yawpKokoroTTS.stop();
      var text = target.textContent.trim();
      if (!text) return;
      startTTS(text);
    });
  }

  function initTTS() {
    ttsBtn = document.querySelector('[data-tts]');
    ttsPanel = document.querySelector('.reader-panel');
    if (!ttsBtn || !window.speechSynthesis) return;

    injectTTSNowPlayingBar();
    setTimeout(injectTTSCompact, 50);
    initTTSClickRefocus();

    ttsBtn.addEventListener('click', function() {
      if (speechSynthesis.speaking || (window.yawpKokoroTTS && window.yawpKokoroTTS.isPlaying && window.yawpKokoroTTS.isPlaying())) {
        speechSynthesis.cancel();
        if (window.yawpKokoroTTS && window.yawpKokoroTTS.stop) window.yawpKokoroTTS.stop();
        clearTTSReadingHighlight();
        showTTSNowPlaying(false);
        return;
      }

      var text = getTextForTTS();
      if (!text.trim()) return;
      startTTS(text);
    });
  }

  function findParagraphContainingText(block, sentence) {
    if (!block || !sentence) return null;
    var needle = normalizeForMatch(sentence).slice(0, 60);
    var paras = block.querySelectorAll('p');
    for (var i = 0; i < paras.length; i++) {
      var pNorm = normalizeForMatch(paras[i].textContent);
      if (pNorm.indexOf(needle) !== -1) return paras[i];
    }
    return null;
  }

  function highlightSentenceInPage(sentence) {
    clearTTSReadingHighlight();
    var container = document.querySelector('.container');
    var block = container ? findBlockContainingText(container, sentence) : null;
    if (block) {
      block.classList.add('tts-reading');
      var para = findParagraphContainingText(block, sentence);
      if (para) {
        para.classList.add('tts-reading-sentence');
        para.scrollIntoView({ behavior: 'smooth', block: 'center' });
      } else {
        block.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
    }
  }

  function injectTTSNowPlayingBar() {
    var toolbar = document.querySelector('.reader-toolbar');
    if (!toolbar || toolbar.querySelector('.reader-tts-now-playing')) return;
    var bar = document.createElement('div');
    bar.className = 'reader-tts-now-playing';
    bar.setAttribute('aria-label', 'Reading controls');
    var stopBtn = document.createElement('button');
    stopBtn.type = 'button';
    stopBtn.className = 'reader-tts-bar-btn reader-tts-stop';
    stopBtn.innerHTML = '&#10074;&#10074;';
    stopBtn.title = 'Stop';
    stopBtn.setAttribute('aria-label', 'Stop reading');
    var skipBtn = document.createElement('button');
    skipBtn.type = 'button';
    skipBtn.className = 'reader-tts-bar-btn reader-tts-skip';
    skipBtn.innerHTML = '&#9197;';
    skipBtn.title = 'Next section';
    skipBtn.setAttribute('aria-label', 'Skip to next section');
    stopBtn.addEventListener('click', function() {
      speechSynthesis.cancel();
      if (window.yawpKokoroTTS && window.yawpKokoroTTS.stop) window.yawpKokoroTTS.stop();
      clearTTSReadingHighlight();
      showTTSNowPlaying(false);
    });
    skipBtn.addEventListener('click', function() {
      speechSynthesis.cancel();
      if (window.yawpKokoroTTS && window.yawpKokoroTTS.stop) window.yawpKokoroTTS.stop();
      var nextBlock = getNextSectionAfterCurrent();
      if (nextBlock) {
        var text = nextBlock.textContent;
        if (text.trim()) startTTS(text.trim());
        else showTTSNowPlaying(false);
      } else {
        clearTTSReadingHighlight();
        showTTSNowPlaying(false);
      }
    });
    bar.appendChild(stopBtn);
    bar.appendChild(skipBtn);
    toolbar.insertBefore(bar, toolbar.querySelector('.reader-panel'));
    ttsNowPlayingBar = bar;
  }

  function injectTTSCompact() {
    var toolsLabel = Array.from(document.querySelectorAll('.reader-section label')).find(function(l) { return l.textContent.trim() === 'Tools'; });
    if (!toolsLabel) return;
    var section = toolsLabel.closest('.reader-section');
    if (!section || section.querySelector('.reader-tts-compact-row')) return;

    var row = document.createElement('div');
    row.className = 'reader-tts-compact-row';

    var speedRow = document.createElement('div');
    speedRow.className = 'reader-tts-mini-row';
    [ { value: 0.75, label: '\u2212' }, { value: 0.9, label: '1\u00d7' }, { value: 1.1, label: '+' } ].forEach(function(s) {
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'reader-btn reader-btn-sm' + (Math.abs(ttsRate - s.value) < 0.05 ? ' active' : '');
      btn.textContent = s.label;
      btn.title = s.value === 0.9 ? 'Normal speed' : (s.value < 0.9 ? 'Slower' : 'Faster');
      btn.setAttribute('data-tts-rate', String(s.value));
      btn.addEventListener('click', function() {
        speedRow.querySelectorAll('[data-tts-rate]').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        ttsRate = s.value;
        localStorage.setItem('yawp_tts_rate', String(ttsRate));
      });
      speedRow.appendChild(btn);
    });

    var scopeRow = document.createElement('div');
    scopeRow.className = 'reader-tts-mini-row';
    var sectionBtn = document.createElement('button');
    sectionBtn.type = 'button';
    sectionBtn.className = 'reader-btn reader-btn-sm' + (ttsScope === 'section' ? ' active' : '');
    sectionBtn.textContent = 'Section';
    sectionBtn.setAttribute('data-tts-scope', 'section');
    var chapterBtn = document.createElement('button');
    chapterBtn.type = 'button';
    chapterBtn.className = 'reader-btn reader-btn-sm' + (ttsScope === 'chapter' ? ' active' : '');
    chapterBtn.textContent = 'Chapter';
    chapterBtn.setAttribute('data-tts-scope', 'chapter');
    sectionBtn.addEventListener('click', function() { ttsScope = 'section'; localStorage.setItem('yawp_tts_scope', 'section'); scopeRow.querySelectorAll('[data-tts-scope]').forEach(function(b) { b.classList.remove('active'); }); sectionBtn.classList.add('active'); });
    chapterBtn.addEventListener('click', function() { ttsScope = 'chapter'; localStorage.setItem('yawp_tts_scope', 'chapter'); scopeRow.querySelectorAll('[data-tts-scope]').forEach(function(b) { b.classList.remove('active'); }); chapterBtn.classList.add('active'); });
    scopeRow.appendChild(sectionBtn);
    scopeRow.appendChild(chapterBtn);

    var voiceSel = document.createElement('select');
    voiceSel.className = 'reader-tts-voice-mini';
    voiceSel.title = 'Voice';
    voiceSel.setAttribute('aria-label', 'Voice');
    var savedVoice = localStorage.getItem('yawp_tts_kokoro_voice') || 'af_bella';
    KOKORO_VOICES.forEach(function(v) {
      var opt = document.createElement('option');
      opt.value = v.id;
      opt.textContent = v.label;
      if (v.id === savedVoice) opt.selected = true;
      voiceSel.appendChild(opt);
    });
    voiceSel.addEventListener('change', function() {
      localStorage.setItem('yawp_tts_kokoro_voice', voiceSel.value);
    });

    row.appendChild(speedRow);
    row.appendChild(scopeRow);
    row.appendChild(voiceSel);
    section.appendChild(row);
  }

  // ==========================================
  // Line Focus / Reading Ruler
  // ==========================================
  var lineFocusActive = false;
  var overlayTop, overlayBottom, overlayContainer;

  function initLineFocus() {
    var btn = document.querySelector('[data-line-focus]');
    overlayContainer = document.querySelector('.line-focus-overlay');
    if (!btn || !overlayContainer) return;

    overlayTop = overlayContainer.querySelector('.line-focus-top');
    overlayBottom = overlayContainer.querySelector('.line-focus-bottom');

    btn.addEventListener('click', function() {
      lineFocusActive = !lineFocusActive;
      btn.classList.toggle('active');
      overlayContainer.classList.toggle('active');
    });

    document.addEventListener('mousemove', function(e) {
      if (!lineFocusActive) return;
      var bandHeight = 80;
      var top = Math.max(0, e.clientY - bandHeight / 2);
      var bottom = e.clientY + bandHeight / 2;
      overlayTop.style.height = top + 'px';
      overlayBottom.style.top = bottom + 'px';
      overlayBottom.style.height = (window.innerHeight - bottom) + 'px';
    });
  }

  // ==========================================
  // Text Highlighting
  // ==========================================
  var highlightColor = 'yellow';
  var highlights = [];

  var highlightColors = [
    { id: 'yellow', label: 'Yellow', bg: '#FFF9C4' },
    { id: 'green', label: 'Green', bg: '#C8E6C9' },
    { id: 'blue', label: 'Blue', bg: '#BBDEFB' },
    { id: 'pink', label: 'Pink', bg: '#F8BBD0' }
  ];

  function initHighlighting() {
    var saved = localStorage.getItem('yawp_highlights_' + pageKey);
    if (saved) {
      try { highlights = JSON.parse(saved); } catch(e) { highlights = []; }
      restoreHighlights();
    }

    var section = document.querySelector('.reader-panel .reader-section');
    section = section && [].find.call(document.querySelectorAll('.reader-panel .reader-section'), function(s) {
      return s.querySelector('[data-highlight-color]') || (s.querySelector('label') && s.querySelector('label').textContent.indexOf('Highlight') !== -1);
    });
    if (!section) return;

    var row = section.querySelector('.reader-btn-row');
    if (!row) return;

    var wrap = document.createElement('div');
    wrap.className = 'reader-highlight-wrap';
    var penBtn = document.createElement('button');
    penBtn.type = 'button';
    penBtn.className = 'reader-btn reader-highlight-pen';
    penBtn.setAttribute('aria-label', 'Highlighter');
    penBtn.title = 'Select text, then click to highlight';
    penBtn.innerHTML = '\u270E'; // pencil
    var colorsWrap = document.createElement('div');
    colorsWrap.className = 'reader-highlight-colors';
    colorsWrap.setAttribute('aria-hidden', 'true');
    highlightColors.forEach(function(c) {
      var circle = document.createElement('button');
      circle.type = 'button';
      circle.className = 'reader-btn reader-highlight-color' + (c.id === highlightColor ? ' active' : '');
      circle.setAttribute('data-highlight-color', c.id);
      circle.style.background = c.bg;
      circle.title = c.label;
      circle.setAttribute('aria-label', c.label);
      circle.addEventListener('click', function() {
        highlightColor = c.id;
        colorsWrap.querySelectorAll('[data-highlight-color]').forEach(function(b) { b.classList.remove('active'); });
        circle.classList.add('active');
        colorsWrap.classList.remove('open');
        colorsWrap.setAttribute('aria-hidden', 'true');
        penBtn.title = 'Select text, then click pen to highlight';
      });
      colorsWrap.appendChild(circle);
    });
    var clearBtn = document.createElement('button');
    clearBtn.type = 'button';
    clearBtn.className = 'reader-btn reader-highlight-clear';
    clearBtn.textContent = 'Clear all';
    clearBtn.addEventListener('click', function() { clearAllHighlights(); });

    penBtn.addEventListener('click', function() {
      if (colorsWrap.classList.contains('open')) {
        colorsWrap.classList.remove('open');
        colorsWrap.setAttribute('aria-hidden', 'true');
        highlightSelection();
      } else {
        colorsWrap.classList.add('open');
        colorsWrap.setAttribute('aria-hidden', 'false');
      }
    });

    wrap.appendChild(penBtn);
    wrap.appendChild(colorsWrap);
    wrap.appendChild(clearBtn);
    row.parentNode.replaceChild(wrap, row);
    var extraRow = section.querySelector('.reader-btn-row');
    if (extraRow) extraRow.remove();
  }

  function highlightSelection() {
    var sel = window.getSelection();
    if (!sel || sel.isCollapsed || !sel.rangeCount) return;

    var range = sel.getRangeAt(0);
    var text = sel.toString().trim();
    if (!text) return;

    // Create highlight span
    var span = document.createElement('span');
    span.className = 'user-highlight-' + highlightColor;
    span.setAttribute('data-highlight-id', Date.now());

    try {
      range.surroundContents(span);
    } catch(e) {
      // If selection spans multiple elements, wrap each text node
      return;
    }

    // Save to storage
    highlights.push({
      id: span.getAttribute('data-highlight-id'),
      text: text,
      color: highlightColor,
      section: findParentSection(span)
    });
    localStorage.setItem('yawp_highlights_' + pageKey, JSON.stringify(highlights));
    sel.removeAllRanges();
  }

  function findParentSection(el) {
    var sec = el.closest('section');
    if (sec) {
      var h2 = sec.querySelector('h2');
      return h2 ? h2.textContent : '';
    }
    return '';
  }

  function clearAllHighlights() {
    document.querySelectorAll('[data-highlight-id]').forEach(function(span) {
      var parent = span.parentNode;
      while (span.firstChild) parent.insertBefore(span.firstChild, span);
      parent.removeChild(span);
    });
    highlights = [];
    localStorage.removeItem('yawp_highlights_' + pageKey);
  }

  function restoreHighlights() {
    // Simple restoration: re-highlighting based on saved data is complex
    // For a static site, we store but note that highlights may not persist across content changes
  }

  // ==========================================
  // Notes Panel
  // ==========================================
  var notes = [];

  function initNotes() {
    var saved = localStorage.getItem('yawp_notes_' + pageKey);
    if (saved) {
      try { notes = JSON.parse(saved); } catch(e) { notes = []; }
    }

    var notesBtn = document.querySelector('[data-action="notes"]');
    var panel = document.querySelector('.notes-panel');
    var closeBtn = panel ? panel.querySelector('.notes-close') : null;

    if (notesBtn && panel) {
      notesBtn.addEventListener('click', function() {
        panel.classList.toggle('open');
        renderNotes();
      });
    }
    if (closeBtn) {
      closeBtn.addEventListener('click', function() {
        panel.classList.remove('open');
      });
    }

    // Add note form
    var addBtn = document.querySelector('.add-note-area button');
    var textarea = document.querySelector('.add-note-area textarea');
    if (addBtn && textarea) {
      addBtn.addEventListener('click', function() {
        var text = textarea.value.trim();
        if (!text) return;

        // Check if there's a text selection to attach
        var sel = window.getSelection();
        var selText = (sel && sel.toString().trim()) ? sel.toString().trim().slice(0, 200) : '';

        notes.push({
          id: Date.now(),
          content: text,
          selectedText: selText,
          timestamp: new Date().toLocaleString()
        });
        localStorage.setItem('yawp_notes_' + pageKey, JSON.stringify(notes));
        textarea.value = '';
        renderNotes();
      });
    }
  }

  function renderNotes() {
    var body = document.querySelector('.notes-body');
    if (!body) return;

    if (notes.length === 0) {
      body.innerHTML = '<div class="notes-empty">No notes yet.<br>Select text and add a note, or just type one below.</div>';
      return;
    }

    var html = '';
    notes.forEach(function(note, i) {
      html += '<div class="note-item">';
      html += '<button class="note-delete" data-note-index="' + i + '">&times;</button>';
      if (note.selectedText) {
        html += '<div class="note-text-preview">"' + escapeHtml(note.selectedText.slice(0, 100)) + (note.selectedText.length > 100 ? '...' : '') + '"</div>';
      }
      html += '<div class="note-content">' + escapeHtml(note.content) + '</div>';
      html += '</div>';
    });
    body.innerHTML = html;

    // Attach delete handlers
    body.querySelectorAll('.note-delete').forEach(function(btn) {
      btn.addEventListener('click', function() {
        var idx = parseInt(btn.getAttribute('data-note-index'));
        notes.splice(idx, 1);
        localStorage.setItem('yawp_notes_' + pageKey, JSON.stringify(notes));
        renderNotes();
      });
    });
  }

  function escapeHtml(str) {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  }

  // ==========================================
  // PDF Builder
  // ==========================================
  function initPDFBuilder() {
    var pdfBtn = document.querySelector('[data-action="pdf"]');
    var overlay = document.querySelector('.pdf-modal-overlay');
    if (!pdfBtn || !overlay) return;

    pdfBtn.addEventListener('click', function() {
      buildSectionList();
      overlay.classList.add('open');
    });

    // Cancel button
    var cancelBtn = overlay.querySelector('.pdf-btn-cancel');
    if (cancelBtn) {
      cancelBtn.addEventListener('click', function() {
        overlay.classList.remove('open');
      });
    }

    // Click outside to close
    overlay.addEventListener('click', function(e) {
      if (e.target === overlay) overlay.classList.remove('open');
    });

    // Select all toggle
    var selectAllBtn = overlay.querySelector('.pdf-select-all');
    if (selectAllBtn) {
      selectAllBtn.addEventListener('click', function() {
        var checkboxes = overlay.querySelectorAll('input[type="checkbox"]');
        var allChecked = Array.from(checkboxes).every(function(cb) { return cb.checked; });
        checkboxes.forEach(function(cb) { cb.checked = !allChecked; });
        selectAllBtn.textContent = allChecked ? 'Select All' : 'Deselect All';
      });
    }

    // Print button
    var printBtn = overlay.querySelector('.pdf-btn-print');
    if (printBtn) {
      printBtn.addEventListener('click', function() {
        printSelectedSections();
        overlay.classList.remove('open');
      });
    }
  }

  function buildSectionList() {
    var list = document.querySelector('.pdf-section-list');
    if (!list) return;

    var items = [];

    // Title page
    items.push({ id: '__title__', label: 'Title Page', selector: '.title-page' });

    // TOC, overview, big questions
    if (document.querySelector('.toc')) items.push({ id: '__toc__', label: 'Table of Contents', selector: '.toc' });
    if (document.querySelector('.overview')) items.push({ id: '__overview__', label: 'Chapter Overview', selector: '.overview' });
    if (document.querySelector('.big-questions')) items.push({ id: '__bigq__', label: 'Big Questions', selector: '.big-questions' });

    // Sections
    document.querySelectorAll('section').forEach(function(sec, i) {
      var h2 = sec.querySelector('h2');
      var title = h2 ? h2.textContent : 'Section ' + (i + 1);
      items.push({ id: sec.id || ('section-' + i), label: title, selector: '#' + (sec.id || 'section-' + i) });
    });

    // Activity
    var activity = document.querySelector('.activity-box');
    if (activity) items.push({ id: '__activity__', label: 'Chapter Activity', selector: '.activity-box' });

    var html = '';
    items.forEach(function(item) {
      html += '<li>';
      html += '<input type="checkbox" id="pdf-' + item.id + '" data-selector="' + item.selector + '" checked>';
      html += '<label for="pdf-' + item.id + '">' + escapeHtml(item.label) + '</label>';
      html += '</li>';
    });
    list.innerHTML = html;
  }

  function printSelectedSections() {
    var checkboxes = document.querySelectorAll('.pdf-section-list input[type="checkbox"]');
    var selectors = [];
    checkboxes.forEach(function(cb) {
      if (!cb.checked) {
        selectors.push(cb.getAttribute('data-selector'));
      }
    });

    // Temporarily hide unchecked sections
    var hidden = [];
    selectors.forEach(function(sel) {
      var el = document.querySelector(sel);
      if (el) {
        el.setAttribute('data-pdf-hidden', 'true');
        el.style.display = 'none';
        hidden.push(el);
      }
    });

    window.print();

    // Restore hidden sections after a delay
    setTimeout(function() {
      hidden.forEach(function(el) {
        el.style.display = '';
        el.removeAttribute('data-pdf-hidden');
      });
    }, 1000);
  }

  // ==========================================
  // Glossary: shared term list from .vocab-box (p strong + term-row dt/dd)
  // ==========================================
  function getGlossaryTerms() {
    var terms = [];
    document.querySelectorAll('.vocab-box').forEach(function(box) {
      box.querySelectorAll('p').forEach(function(p) {
        var strong = p.querySelector('strong');
        if (strong) {
          var termText = strong.textContent.replace(/:$/, '').trim();
          var defText = p.textContent.replace(strong.textContent, '').trim();
          if (defText.charAt(0) === ':') defText = defText.substring(1).trim();
          if (termText && defText) terms.push({ term: termText, definition: defText });
        }
      });
      box.querySelectorAll('.term-row').forEach(function(row) {
        var dt = row.querySelector('dt');
        var dd = row.querySelector('dd');
        if (dt && dd) {
          var termText = dt.textContent.replace(/:$/, '').trim();
          var defText = dd.textContent.replace(/^\s*[—–-]\s*/, '').trim();
          if (termText && defText) terms.push({ term: termText, definition: defText });
        }
      });
    });
    return terms;
  }

  // ==========================================
  // Glossary Panel
  // ==========================================
  function initGlossary() {
    var glossaryBtn = document.querySelector('[data-action="glossary"]');
    var panel = document.querySelector('.glossary-panel');
    var closeBtn = panel ? panel.querySelector('.glossary-close') : null;
    if (!glossaryBtn || !panel) return;

    // Build glossary from vocab boxes (both <p><strong> and .term-row dt/dd)
    var terms = getGlossaryTerms();

    // Sort alphabetically
    terms.sort(function(a, b) { return a.term.localeCompare(b.term); });

    // Render glossary
    var body = panel.querySelector('.glossary-body');
    if (body && terms.length > 0) {
      var html = '<div class="glossary-search"><input type="text" placeholder="Search terms..." class="glossary-search-input"></div>';
      terms.forEach(function(t) {
        html += '<div class="glossary-term-item">';
        html += '<div class="glossary-term-word">' + escapeHtml(t.term) + '</div>';
        html += '<div class="glossary-term-def">' + escapeHtml(t.definition) + '</div>';
        html += '</div>';
      });
      body.innerHTML = html;

      // Search filter
      var searchInput = body.querySelector('.glossary-search-input');
      if (searchInput) {
        searchInput.addEventListener('input', function() {
          var q = searchInput.value.toLowerCase();
          body.querySelectorAll('.glossary-term-item').forEach(function(item) {
            var word = item.querySelector('.glossary-term-word').textContent.toLowerCase();
            var def = item.querySelector('.glossary-term-def').textContent.toLowerCase();
            item.style.display = (word.includes(q) || def.includes(q)) ? '' : 'none';
          });
        });
      }
    } else if (body) {
      body.innerHTML = '<div class="glossary-empty">No vocabulary terms found on this page.</div>';
    }

    glossaryBtn.addEventListener('click', function() {
      panel.classList.toggle('open');
    });
    if (closeBtn) {
      closeBtn.addEventListener('click', function() {
        panel.classList.remove('open');
      });
    }
  }

  // ==========================================
  // Glossary terms in text: visual + click-to-define popup
  // ==========================================
  function initGlossaryInText() {
    var container = document.querySelector('.container');
    if (!container) return;
    var terms = getGlossaryTerms();
    if (terms.length === 0) return;

    // Sort by term length descending so we match "Bill of Rights" before "Bill"
    terms = terms.slice().sort(function(a, b) { return b.term.length - a.term.length; });

    function escapeRegex(s) {
      return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }

    function getNonOverlappingMatches(text) {
      var matches = [];
      var termLower;
      var regex;
      for (var i = 0; i < terms.length; i++) {
        termLower = terms[i].term.toLowerCase();
        regex = new RegExp('\\b' + escapeRegex(terms[i].term) + '\\b', 'gi');
        var match;
        while ((match = regex.exec(text)) !== null) {
          matches.push({ start: match.index, end: match.index + match[0].length, text: match[0], definition: terms[i].definition });
        }
      }
      matches.sort(function(a, b) { return a.start !== b.start ? a.start - b.start : b.end + b.start - (a.end + a.start); });
      var merged = [];
      for (var j = 0; j < matches.length; j++) {
        if (merged.length && matches[j].start < merged[merged.length - 1].end) continue;
        merged.push(matches[j]);
      }
      return merged;
    }

    function walkTextNodes(root, fn) {
      var walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, {
        acceptNode: function(node) {
          if (node.parentNode.closest('.vocab-box, .reader-panel, .glossary-panel, .reader-command-palette, script, style, .glossary-term')) return NodeFilter.FILTER_REJECT;
          return NodeFilter.FILTER_ACCEPT;
        }
      });
      var nodes = [];
      while (walker.nextNode()) nodes.push(walker.currentNode);
      nodes.forEach(fn);
    }

    walkTextNodes(container, function(textNode) {
      var text = textNode.textContent;
      if (!text || text.length < 2) return;
      var matches = getNonOverlappingMatches(text);
      if (matches.length === 0) return;

      var fragment = document.createDocumentFragment();
      var lastEnd = 0;
      matches.forEach(function(m) {
        if (m.start > lastEnd) {
          fragment.appendChild(document.createTextNode(text.slice(lastEnd, m.start)));
        }
        var span = document.createElement('span');
        span.className = 'glossary-term';
        span.setAttribute('data-term', m.text);
        span.setAttribute('data-definition', m.definition);
        span.textContent = m.text;
        fragment.appendChild(span);
        lastEnd = m.end;
      });
      if (lastEnd < text.length) {
        fragment.appendChild(document.createTextNode(text.slice(lastEnd)));
      }
      textNode.parentNode.replaceChild(fragment, textNode);
    });

    // Popup for glossary term click
    var popup = document.createElement('div');
    popup.className = 'glossary-term-popup';
    popup.setAttribute('role', 'tooltip');
    document.body.appendChild(popup);

    container.addEventListener('click', function(e) {
      var termEl = e.target.closest('.glossary-term');
      if (!termEl) return;
      e.preventDefault();
      var term = termEl.getAttribute('data-term');
      var def = termEl.getAttribute('data-definition');
      if (!def) return;
      popup.innerHTML = '<strong class="glossary-term-popup-word">' + escapeHtml(term) + '</strong><div class="glossary-term-popup-def">' + escapeHtml(def) + '</div>';
      popup.style.display = 'block';
      var rect = termEl.getBoundingClientRect();
      popup.style.left = Math.max(8, Math.min(rect.left, window.innerWidth - 320)) + 'px';
      popup.style.top = (rect.top + rect.height + 6) + 'px';
    });

    document.addEventListener('click', function(e) {
      if (!popup.contains(e.target) && !e.target.closest('.glossary-term')) {
        popup.style.display = 'none';
      }
    });
    window.addEventListener('scroll', function() {
      popup.style.display = 'none';
    }, true);
  }

  // ==========================================
  // Double-Click Dictionary Lookup
  // ==========================================
  function initDictionary() {
    var popup = document.createElement('div');
    popup.className = 'dict-popup';
    popup.style.display = 'none';
    document.body.appendChild(popup);

    // Double-click any word to look it up
    document.addEventListener('dblclick', function(e) {
      // Don't trigger inside reader panel, notes, or glossary
      if (e.target.closest('.reader-panel, .notes-panel, .glossary-panel, .dict-popup')) return;

      var sel = window.getSelection();
      var word = sel ? sel.toString().trim() : '';
      if (!word || word.includes(' ') || word.length > 30) return;

      // Clean punctuation
      word = word.replace(/[^a-zA-Z\u2019'-]/g, '');
      if (!word || word.length < 2) return;

      // Position popup near click
      var popupX = Math.min(e.pageX - 20, window.innerWidth - 360);
      var popupY = e.pageY + 20;
      popup.style.left = Math.max(10, popupX) + 'px';
      popup.style.top = popupY + 'px';
      popup.innerHTML = '<div class="dict-loading">Looking up \u201c' + escapeHtml(word) + '\u201d\u2026</div>';
      popup.style.display = 'block';

      fetch('https://api.dictionaryapi.dev/api/v2/entries/en/' + encodeURIComponent(word.toLowerCase()))
        .then(function(r) { return r.json(); })
        .then(function(data) {
          if (Array.isArray(data) && data.length > 0) {
            var entry = data[0];
            var html = '<div class="dict-word">' + escapeHtml(entry.word) + '</div>';
            if (entry.phonetic) {
              html += '<div class="dict-phonetic">' + escapeHtml(entry.phonetic) + '</div>';
            }
            var meanings = entry.meanings || [];
            meanings.slice(0, 2).forEach(function(m) {
              html += '<div class="dict-pos">' + escapeHtml(m.partOfSpeech) + '</div>';
              var defs = m.definitions || [];
              defs.slice(0, 2).forEach(function(d) {
                html += '<div class="dict-def">' + escapeHtml(d.definition) + '</div>';
              });
            });
            html += '<a class="dict-wiki-link" href="https://en.wikipedia.org/wiki/Special:Search?search=' + encodeURIComponent(entry.word) + '" target="_blank" rel="noopener">Look up on Wikipedia \u2197</a>';
            popup.innerHTML = html;
          } else {
            popup.innerHTML = '<div class="dict-error">No definition found for \u201c' + escapeHtml(word) + '\u201d</div><a class="dict-wiki-link" href="https://en.wikipedia.org/wiki/Special:Search?search=' + encodeURIComponent(word) + '" target="_blank" rel="noopener">Look up on Wikipedia \u2197</a>';
          }
        })
        .catch(function() {
          popup.innerHTML = '<div class="dict-error">Could not look up this word.</div><a class="dict-wiki-link" href="https://en.wikipedia.org/wiki/Special:Search?search=' + encodeURIComponent(word) + '" target="_blank" rel="noopener">Look up on Wikipedia \u2197</a>';
        });
    });

    // Close popup on click elsewhere
    document.addEventListener('click', function(e) {
      if (!popup.contains(e.target)) {
        popup.style.display = 'none';
      }
    });

    // Close on scroll
    var scrollTimer;
    window.addEventListener('scroll', function() {
      clearTimeout(scrollTimer);
      scrollTimer = setTimeout(function() {
        popup.style.display = 'none';
      }, 150);
    });
  }

  // ==========================================
  // Find & View — combined Search, Reading mode, Font, Width at top
  // ==========================================
  function initFindAndView() {
    var panel = document.querySelector('.reader-panel');
    if (!panel || panel.querySelector('.reader-find-view')) return;
    var wrap = document.createElement('div');
    wrap.className = 'reader-find-view';
    wrap.innerHTML =
      '<div class="reader-section reader-search-wrap">' +
        '<label>Search</label>' +
        '<input type="search" class="reader-search-input" placeholder="Search this chapter (\u2318K)" aria-label="Search text">' +
        '<div class="reader-search-results"></div>' +
      '</div>' +
      '<div class="reader-section reader-view-row">' +
        '<label>View</label>' +
        '<div class="reader-btn-row reader-view-btns">' +
          '<button type="button" class="reader-btn" data-reading-mode="scroll" title="Scroll">Scroll</button>' +
          '<button type="button" class="reader-btn" data-reading-mode="page" title="Page by page">Page</button>' +
          '<button type="button" class="reader-btn" data-reading-width="normal" title="Normal width">Width</button>' +
          '<button type="button" class="reader-btn" data-reading-width="narrow" title="Narrow column">Narrow</button>' +
        '</div>' +
      '</div>';
    panel.insertBefore(wrap, panel.querySelector('h4').nextElementSibling);
  }

  // ==========================================
  // Reading Time Estimate (for students to plan)
  // ==========================================
  function initReadingTime() {
    var panel = document.querySelector('.reader-panel');
    if (!panel || panel.querySelector('.reader-reading-time')) return;
    var main = document.querySelector('.container');
    if (!main) return;
    var text = main.textContent || '';
    var words = text.trim().split(/\s+/).filter(Boolean).length;
    var mins = Math.max(1, Math.round(words / 200));
    var el = document.createElement('div');
    el.className = 'reader-reading-time';
    el.textContent = 'About ' + mins + ' min read';
    var h4 = panel.querySelector('h4');
    panel.insertBefore(el, h4 ? h4.nextElementSibling : null);
  }

  // ==========================================
  // Scroll / Page View Mode (Foliate-style)
  // ==========================================
  function initReadingMode() {
    var panel = document.querySelector('.reader-panel');
    if (!panel) return;
    var container = document.querySelector('.container');
    if (!container) return;
    var blocks = [];
    var overview = container.querySelector('.overview');
    if (overview) blocks.push(overview);
    container.querySelectorAll(':scope > section').forEach(function(s) { blocks.push(s); });

    // Chapters like ch7 use h2.section-heading instead of <section> — build blocks by wrapping each h2 + content (reverse order so DOM stays valid)
    if (blocks.length <= 1) {
      var h2s = Array.from(container.querySelectorAll(':scope > h2.section-heading, :scope > h2[id]'));
      var wrapped = [];
      for (var hi = h2s.length - 1; hi >= 0; hi--) {
        var h2 = h2s[hi];
        var wrap = document.createElement('div');
        wrap.className = 'reader-page-block';
        wrap.appendChild(h2);
        var next = h2.nextElementSibling;
        while (next && next.tagName !== 'H2') {
          var after = next.nextElementSibling;
          wrap.appendChild(next);
          next = after;
        }
        h2.parentNode.insertBefore(wrap, h2);
        wrapped.push(wrap);
      }
      blocks = blocks.concat(wrapped.reverse());
    }
    if (blocks.length === 0) return;

    var saved = localStorage.getItem('yawp_reading_mode') || 'scroll';
    var pageIndex = Math.min(parseInt(localStorage.getItem('yawp_page_index_' + pageKey) || '0', 10), blocks.length - 1);
    var viewRow = panel.querySelector('.reader-find-view .reader-view-btns');
    var scrollBtn = viewRow ? viewRow.querySelector('[data-reading-mode="scroll"]') : null;
    var pageBtn = viewRow ? viewRow.querySelector('[data-reading-mode="page"]') : null;
    var row = viewRow;
    var wrap = null;

    if (!scrollBtn || !pageBtn) {
      wrap = document.createElement('div');
      wrap.className = 'reader-section reader-reading-mode';
      wrap.innerHTML = '<label>Reading mode</label><div class="reader-btn-row"></div>';
      row = wrap.querySelector('.reader-btn-row');
      scrollBtn = document.createElement('button');
      scrollBtn.type = 'button';
      scrollBtn.className = 'reader-btn' + (saved === 'scroll' ? ' active' : '');
      scrollBtn.textContent = 'Scroll';
      scrollBtn.setAttribute('data-reading-mode', 'scroll');
      pageBtn = document.createElement('button');
      pageBtn.type = 'button';
      pageBtn.className = 'reader-btn' + (saved === 'page' ? ' active' : '');
      pageBtn.textContent = 'Page';
      pageBtn.setAttribute('data-reading-mode', 'page');
      row.appendChild(scrollBtn);
      row.appendChild(pageBtn);
      panel.insertBefore(wrap, panel.querySelector('.reader-reading-time'));
    } else {
      scrollBtn.classList.toggle('active', saved === 'scroll');
      pageBtn.classList.toggle('active', saved === 'page');
    }

    function applyMode(mode) {
      var isPage = mode === 'page';
      document.body.classList.toggle('reading-mode-page', isPage);
      if (isPage) {
        blocks.forEach(function(b, i) { b.style.display = i === pageIndex ? 'block' : 'none'; });
        container.querySelectorAll(':scope > *').forEach(function(el) {
          if (blocks.indexOf(el) === -1) el.style.display = 'none';
        });
        var bar = document.querySelector('.reader-page-nav');
        if (bar) bar.style.display = 'flex';
        updatePageNav();
      } else {
        blocks.forEach(function(b) { b.style.display = ''; });
        container.querySelectorAll(':scope > *').forEach(function(el) { el.style.display = ''; });
        var bar = document.querySelector('.reader-page-nav');
        if (bar) bar.style.display = 'none';
      }
    }
    function updatePageNav() {
      var prev = document.querySelector('.reader-page-prev');
      var next = document.querySelector('.reader-page-next');
      var label = document.querySelector('.reader-page-label');
      if (prev) prev.disabled = pageIndex <= 0;
      if (next) next.disabled = pageIndex >= blocks.length - 1;
      if (label) label.textContent = (pageIndex + 1) + ' / ' + blocks.length;
    }

    scrollBtn.addEventListener('click', function() {
      saved = 'scroll';
      localStorage.setItem('yawp_reading_mode', 'scroll');
      row.querySelectorAll('[data-reading-mode]').forEach(function(b) { b.classList.remove('active'); });
      scrollBtn.classList.add('active');
      applyMode('scroll');
    });
    pageBtn.addEventListener('click', function() {
      saved = 'page';
      localStorage.setItem('yawp_reading_mode', 'page');
      row.querySelectorAll('[data-reading-mode]').forEach(function(b) { b.classList.remove('active'); });
      pageBtn.classList.add('active');
      applyMode('page');
    });

    var navBar = document.querySelector('.reader-page-nav');
    if (!navBar) {
      navBar = document.createElement('div');
      navBar.className = 'reader-page-nav';
      navBar.style.display = 'none';
      navBar.innerHTML = '<button type="button" class="reader-page-prev" aria-label="Previous page">&larr;</button><span class="reader-page-label"></span><button type="button" class="reader-page-next" aria-label="Next page">&rarr;</button>';
      var prevBtn = navBar.querySelector('.reader-page-prev');
      var nextBtn = navBar.querySelector('.reader-page-next');
      prevBtn.addEventListener('click', function() {
        if (pageIndex <= 0) return;
        pageIndex--;
        localStorage.setItem('yawp_page_index_' + pageKey, String(pageIndex));
        blocks.forEach(function(b, i) { b.style.display = i === pageIndex ? 'block' : 'none'; });
        updatePageNav();
      });
      nextBtn.addEventListener('click', function() {
        if (pageIndex >= blocks.length - 1) return;
        pageIndex++;
        localStorage.setItem('yawp_page_index_' + pageKey, String(pageIndex));
        blocks.forEach(function(b, i) { b.style.display = i === pageIndex ? 'block' : 'none'; });
        updatePageNav();
      });
      document.body.appendChild(navBar);
    }
    if (saved === 'page') applyMode('page');
  }

  // ==========================================
  // Full-Text Search (current chapter)
  // ==========================================
  function initSearch() {
    var panel = document.querySelector('.reader-panel');
    if (!panel) return;
    var container = document.querySelector('.container');
    if (!container) return;

    var wrap = panel.querySelector('.reader-search-wrap');
    if (!wrap) {
      wrap = document.createElement('div');
      wrap.className = 'reader-section reader-search-wrap';
      wrap.innerHTML = '<label>Search in this chapter</label><input type="search" class="reader-search-input" placeholder="Search..." aria-label="Search text"><div class="reader-search-results"></div>';
      panel.insertBefore(wrap, panel.querySelector('.reader-reading-time'));
    }
    var input = wrap.querySelector('.reader-search-input');
    var resultsEl = wrap.querySelector('.reader-search-results');
    if (!input || !resultsEl) return;
    var searchTimer = null;

    function runSearch(q) {
      q = (q || '').trim().toLowerCase();
      resultsEl.innerHTML = '';
      if (q.length < 2) return;
      var blocks = container.querySelectorAll('section, .overview');
      var hits = [];
      blocks.forEach(function(block) {
        var text = block.textContent;
        var pos = text.toLowerCase().indexOf(q);
        if (pos === -1) return;
        var start = Math.max(0, pos - 30);
        var end = Math.min(text.length, pos + q.length + 60);
        var snippet = (start > 0 ? '\u2026' : '') + text.slice(start, end).replace(/\s+/g, ' ') + (end < text.length ? '\u2026' : '');
        var h2 = block.querySelector('h2');
        hits.push({ block: block, snippet: snippet, title: h2 ? h2.textContent : (block.classList.contains('overview') ? 'Chapter Overview' : 'Section') });
        if (hits.length >= 12) return;
      });
      if (hits.length === 0) {
        resultsEl.innerHTML = '<div class="reader-search-empty">No matches found.</div>';
        return;
      }
      hits.forEach(function(h) {
        var item = document.createElement('button');
        item.type = 'button';
        item.className = 'reader-search-hit';
        item.innerHTML = '<span class="reader-search-hit-title">' + escapeHtml(h.title) + '</span><span class="reader-search-hit-snippet">' + escapeHtml(h.snippet) + '</span>';
        item.addEventListener('click', function() {
          h.block.scrollIntoView({ behavior: 'smooth', block: 'start' });
          resultsEl.innerHTML = '';
          input.value = '';
        });
        resultsEl.appendChild(item);
      });
    }

    input.addEventListener('input', function() {
      clearTimeout(searchTimer);
      searchTimer = setTimeout(function() { runSearch(input.value); }, 200);
    });
    input.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') { resultsEl.innerHTML = ''; input.value = ''; input.blur(); }
    });
  }

  // ==========================================
  // Command palette: Cmd+K / Ctrl+K — search chapter (and / for book)
  // ==========================================
  var CHAPTERS = [
    { num: 1, title: 'Indigenous America', href: 'ch1.html' },
    { num: 2, title: 'Colliding Cultures', href: 'ch2.html' },
    { num: 3, title: 'British North America', href: 'ch3.html' },
    { num: 4, title: 'Colonial Society', href: 'ch4.html' },
    { num: 5, title: 'The American Revolution', href: 'ch5.html' },
    { num: 6, title: 'A New Nation', href: 'ch6.html' },
    { num: 7, title: 'The Early Republic', href: 'ch7.html' },
    { num: 8, title: 'The Market Revolution', href: 'ch8.html' },
    { num: 9, title: 'Democracy in America', href: 'ch9.html' },
    { num: 10, title: 'Religion and Reform', href: 'ch10.html' },
    { num: 11, title: 'The Cotton Revolution', href: 'ch11.html' },
    { num: 12, title: 'Manifest Destiny', href: 'ch12.html' },
    { num: 13, title: 'The Sectional Crisis', href: 'ch13.html' },
    { num: 14, title: 'The Civil War', href: 'ch14.html' },
    { num: 15, title: 'Reconstruction', href: 'ch15.html' }
  ];

  function getChapterSearchHits(q, container) {
    if (!container) return [];
    q = (q || '').trim().toLowerCase();
    if (q.length < 2) return [];
    var blocks = container.querySelectorAll('section, .overview');
    var hits = [];
    blocks.forEach(function(block) {
      var text = block.textContent;
      var pos = text.toLowerCase().indexOf(q);
      if (pos === -1) return;
      var start = Math.max(0, pos - 30);
      var end = Math.min(text.length, pos + q.length + 60);
      var snippet = (start > 0 ? '\u2026' : '') + text.slice(start, end).replace(/\s+/g, ' ') + (end < text.length ? '\u2026' : '');
      var h2 = block.querySelector('h2');
      hits.push({ block: block, snippet: snippet, title: h2 ? h2.textContent : (block.classList.contains('overview') ? 'Chapter Overview' : 'Section') });
      if (hits.length >= 15) return;
    });
    return hits;
  }

  function getBookSearchHits(searchQ, onProgress) {
    var maxHits = 25;
    var hitsPerChapter = 3;
    var collected = [];
    var q = searchQ.trim().toLowerCase();
    if (q.length < 2) return Promise.resolve([]);

    function fetchChapter(ch) {
      return fetch(ch.href).then(function(r) { return r.text(); }).then(function(html) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(html, 'text/html');
        var container = doc.querySelector('.container');
        if (!container) return [];
        var blocks = container.querySelectorAll('section, .overview');
        var chapterHits = [];
        blocks.forEach(function(block) {
          var text = block.textContent;
          var pos = text.toLowerCase().indexOf(q);
          if (pos === -1) return;
          var start = Math.max(0, pos - 30);
          var end = Math.min(text.length, pos + q.length + 60);
          var snippet = (start > 0 ? '\u2026' : '') + text.slice(start, end).replace(/\s+/g, ' ') + (end < text.length ? '\u2026' : '');
          var h2 = block.querySelector('h2');
          var sectionTitle = h2 ? h2.textContent : (block.classList.contains('overview') ? 'Chapter Overview' : 'Section');
          var sectionId = block.id || (h2 && h2.id) || '';
          chapterHits.push({
            chapterNum: ch.num,
            chapterTitle: ch.title,
            href: ch.href + (sectionId ? '#' + sectionId : ''),
            sectionTitle: sectionTitle,
            snippet: snippet
          });
          if (chapterHits.length >= hitsPerChapter) return;
        });
        return chapterHits;
      }).catch(function() { return []; });
    }

    var index = 0;
    function next() {
      if (collected.length >= maxHits || index >= CHAPTERS.length) {
        return Promise.resolve(collected.slice(0, maxHits));
      }
      var ch = CHAPTERS[index++];
      if (onProgress) onProgress('Searching Ch. ' + ch.num + '\u2026');
      return fetchChapter(ch).then(function(chapterHits) {
        collected = collected.concat(chapterHits);
        if (index >= CHAPTERS.length || collected.length >= maxHits) {
          return collected.slice(0, maxHits);
        }
        return next();
      });
    }
    return next();
  }

  function initCommandPalette() {
    var container = document.querySelector('.container');
    if (!container) return;
    var overlay = document.createElement('div');
    overlay.className = 'reader-command-palette';
    overlay.setAttribute('aria-hidden', 'true');
    overlay.innerHTML =
      '<div class="reader-command-palette-backdrop"></div>' +
      '<div class="reader-command-palette-box" role="dialog" aria-label="Search chapter">' +
        '<input type="search" class="reader-command-palette-input" placeholder="Search this chapter… (type / to search whole book)" aria-label="Search">' +
        '<div class="reader-command-palette-results"></div>' +
        '<div class="reader-command-palette-hint">\u2318K to open, Esc to close</div>' +
      '</div>';
    var backdrop = overlay.querySelector('.reader-command-palette-backdrop');
    var input = overlay.querySelector('.reader-command-palette-input');
    var resultsEl = overlay.querySelector('.reader-command-palette-results');
    var searchTimer = null;

    function close() {
      overlay.classList.remove('open');
      overlay.setAttribute('aria-hidden', 'true');
      input.value = '';
      resultsEl.innerHTML = '';
    }
    function open() {
      overlay.classList.add('open');
      overlay.setAttribute('aria-hidden', 'false');
      input.value = '';
      resultsEl.innerHTML = '';
      input.focus();
    }

    function runSearch() {
      var q = input.value.trim();
      var isBookSearch = q.indexOf('/') === 0;
      var searchQ = isBookSearch ? q.slice(1).trim() : q;
      resultsEl.innerHTML = '';
      if (searchQ.length < 2) return;

      if (isBookSearch) {
        resultsEl.innerHTML = '<div class="reader-search-empty reader-search-status">Searching book\u2026</div>';
        getBookSearchHits(searchQ, function(msg) {
          var status = resultsEl.querySelector('.reader-search-status');
          if (status) status.textContent = msg;
        }).then(function(hits) {
          resultsEl.innerHTML = '';
          if (hits.length === 0) {
            resultsEl.innerHTML = '<div class="reader-search-empty">No matches in the book.</div>';
            return;
          }
          hits.forEach(function(h) {
            var item = document.createElement('button');
            item.type = 'button';
            item.className = 'reader-search-hit reader-search-hit-book';
            item.innerHTML = '<span class="reader-search-hit-title">Ch. ' + h.chapterNum + ': ' + escapeHtml(h.chapterTitle) + ' \u2014 ' + escapeHtml(h.sectionTitle) + '</span><span class="reader-search-hit-snippet">' + escapeHtml(h.snippet) + '</span>';
            item.addEventListener('click', function() {
              location.href = h.href;
              close();
            });
            resultsEl.appendChild(item);
          });
        }).catch(function() {
          resultsEl.innerHTML = '<div class="reader-search-empty">Search error. Try again.</div>';
        });
        return;
      }

      var hits = getChapterSearchHits(searchQ, container);
      if (hits.length === 0) {
        resultsEl.innerHTML = '<div class="reader-search-empty">No matches in this chapter.</div>';
        return;
      }
      hits.forEach(function(h) {
        var item = document.createElement('button');
        item.type = 'button';
        item.className = 'reader-search-hit';
        item.innerHTML = '<span class="reader-search-hit-title">' + escapeHtml(h.title) + '</span><span class="reader-search-hit-snippet">' + escapeHtml(h.snippet) + '</span>';
        item.addEventListener('click', function() {
          h.block.scrollIntoView({ behavior: 'smooth', block: 'start' });
          close();
        });
        resultsEl.appendChild(item);
      });
    }

    input.addEventListener('input', function() {
      clearTimeout(searchTimer);
      searchTimer = setTimeout(runSearch, 150);
    });
    input.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') { e.preventDefault(); close(); }
    });
    backdrop.addEventListener('click', close);
    document.body.appendChild(overlay);

    document.addEventListener('keydown', function(e) {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        if (overlay.classList.contains('open')) close();
        else open();
      }
    });
  }

  // ==========================================
  // Bookmarks (Foliate-style) — bookmarks current scroll position; prompts for name
  // ==========================================
  function initBookmarks() {
    var panel = document.querySelector('.reader-panel');
    if (!panel || panel.querySelector('.reader-bookmarks-wrap')) return;
    var container = document.querySelector('.container');
    if (!container) return;
    var blocks = [];
    var overview = container.querySelector('.overview');
    if (overview) blocks.push(overview);
    container.querySelectorAll(':scope > section').forEach(function(s) { blocks.push(s); });
    if (blocks.length <= 1) {
      container.querySelectorAll(':scope > .reader-page-block').forEach(function(b) { blocks.push(b); });
    }
    if (blocks.length === 0) return;

    var storageKey = 'yawp_bookmarks_' + pageKey;
    var bookmarks = [];
    try {
      var saved = localStorage.getItem(storageKey);
      if (saved) bookmarks = JSON.parse(saved);
    } catch (e) {}

    function saveBookmarks() {
      localStorage.setItem(storageKey, JSON.stringify(bookmarks));
      renderBookmarks();
    }
    function getCurrentBlockIndex() {
      var scrollMid = window.scrollY + window.innerHeight / 2;
      for (var i = 0; i < blocks.length; i++) {
        var rect = blocks[i].getBoundingClientRect();
        var top = rect.top + window.scrollY;
        if (scrollMid >= top && scrollMid <= top + rect.height) return i;
      }
      return 0;
    }
    function renderBookmarks() {
      var list = wrap.querySelector('.reader-bookmarks-list');
      list.innerHTML = '';
      if (bookmarks.length === 0) {
        list.innerHTML = '<div class="reader-bookmarks-empty">No bookmarks. Click "Add bookmark" when reading.</div>';
        return;
      }
      bookmarks.forEach(function(bm, idx) {
        var item = document.createElement('button');
        item.type = 'button';
        item.className = 'reader-bookmark-item';
        item.textContent = bm.label;
        item.addEventListener('click', function() {
          var el = blocks[bm.index];
          if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
        });
        var del = document.createElement('button');
        del.type = 'button';
        del.className = 'reader-bookmark-remove';
        del.textContent = '\u00D7';
        del.setAttribute('aria-label', 'Remove bookmark');
        del.addEventListener('click', function(e) {
          e.stopPropagation();
          bookmarks.splice(idx, 1);
          saveBookmarks();
        });
        item.appendChild(del);
        list.appendChild(item);
      });
    }

    var wrap = document.createElement('div');
    wrap.className = 'reader-section reader-bookmarks-wrap';
    wrap.innerHTML = '<label>Bookmarks</label><div class="reader-btn-row"><button type="button" class="reader-btn reader-add-bookmark">Add bookmark</button></div><div class="reader-bookmarks-list"></div>';
    wrap.querySelector('.reader-add-bookmark').addEventListener('click', function() {
      var idx = getCurrentBlockIndex();
      var block = blocks[idx];
      var h2 = block ? block.querySelector('h2') : null;
      var defaultLabel = h2 ? h2.textContent.trim() : (block && block.classList.contains('overview') ? 'Chapter Overview' : 'Section ' + (idx + 1));
      var label = window.prompt('Name this bookmark:', defaultLabel);
      if (label == null || (label = label.trim()) === '') return;
      bookmarks.push({ index: idx, label: label });
      saveBookmarks();
    });
    renderBookmarks();
    panel.appendChild(wrap);
  }

  // ==========================================
  // Jump to Section (Foliate-style navigation)
  // ==========================================
  function initSectionJump() {
    var panel = document.querySelector('.reader-panel');
    if (!panel || panel.querySelector('.reader-section-jump')) return;
    var items = [];
    var overviewEl = document.querySelector('.overview');
    if (overviewEl) items.push({ label: 'Chapter Overview', el: overviewEl });
    document.querySelectorAll('section').forEach(function(sec, i) {
      var h2 = sec.querySelector('h2');
      items.push({ label: h2 ? h2.textContent : ('Section ' + (i + 1)), el: sec });
    });
    if (items.length === 0) return;
    var wrap = document.createElement('div');
    wrap.className = 'reader-section reader-section-jump';
    wrap.innerHTML = '<label>Jump to section</label><select class="reader-jump-select" aria-label="Jump to section"><option value="">-- Choose section --</option></select>';
    var sel = wrap.querySelector('.reader-jump-select');
    items.forEach(function(item, idx) {
      var opt = document.createElement('option');
      opt.value = String(idx);
      opt.textContent = item.label;
      sel.appendChild(opt);
    });
    sel.addEventListener('change', function() {
      var idx = parseInt(sel.value, 10);
      if (isNaN(idx) || !items[idx]) return;
      items[idx].el.scrollIntoView({ behavior: 'smooth', block: 'start' });
      sel.value = '';
    });
    var readingTime = panel.querySelector('.reader-reading-time');
    panel.insertBefore(wrap, readingTime ? readingTime.nextElementSibling : panel.querySelector('h4').nextElementSibling);
  }

  // ==========================================
  // Reading Width / Narrow Column (Foliate-style)
  // ==========================================
  function initReadingWidth() {
    var panel = document.querySelector('.reader-panel');
    if (!panel) return;
    var saved = localStorage.getItem('yawp_reading_width') || 'normal';
    if (saved === 'narrow') document.body.classList.add('reading-width-narrow');

    var row = panel.querySelector('.reader-find-view .reader-view-btns') || panel.querySelector('.reader-reading-width .reader-btn-row');
    var btns = row ? row.querySelectorAll('[data-reading-width]') : [];
    if (btns.length) {
      btns.forEach(function(btn) {
        var mode = btn.getAttribute('data-reading-width');
        btn.classList.toggle('active', saved === mode);
        btn.addEventListener('click', function() {
          row.querySelectorAll('[data-reading-width]').forEach(function(b) { b.classList.remove('active'); });
          btn.classList.add('active');
          document.body.classList.toggle('reading-width-narrow', mode === 'narrow');
          localStorage.setItem('yawp_reading_width', mode);
        });
      });
      return;
    }
    var wrap = document.createElement('div');
    wrap.className = 'reader-section reader-reading-width';
    wrap.innerHTML = '<label>Reading width</label><div class="reader-btn-row"></div>';
    row = wrap.querySelector('.reader-btn-row');
    ['normal', 'narrow'].forEach(function(mode) {
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'reader-btn' + (saved === mode ? ' active' : '');
      btn.textContent = mode === 'normal' ? 'Normal' : 'Narrow column';
      btn.setAttribute('data-reading-width', mode);
      btn.addEventListener('click', function() {
        row.querySelectorAll('.reader-btn').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        document.body.classList.toggle('reading-width-narrow', mode === 'narrow');
        localStorage.setItem('yawp_reading_width', mode);
      });
      row.appendChild(btn);
    });
    var firstSection = panel.querySelector('.reader-section');
    panel.insertBefore(wrap, firstSection);
  }

  // ==========================================
  // Icon-tree panel: icons expand to logical branches
  // ==========================================
  function initReaderPanelTree() {
    var panel = document.querySelector('.reader-panel');
    if (!panel || panel.querySelector('.reader-panel-tree')) return;

    var h4 = panel.querySelector('h4');
    var meta = panel.querySelector('.reader-reading-time') || panel.querySelector('.reader-section-jump') || panel.querySelector('.reader-reading-width');
    var sections = Array.from(panel.querySelectorAll('.reader-section'));
    if (!sections.length) return;

    var branchMap = { text: [], theme: [], a11y: [], audio: [], highlight: [] };
    var toolsSection = null;
    var actionButtons = [];

    sections.forEach(function(section) {
      var label = (section.querySelector('label') || {}).textContent || '';
      if (label.indexOf('Text Size') !== -1 || label.indexOf('Line Spacing') !== -1) branchMap.text.push(section);
      else if (label.indexOf('Theme') !== -1) branchMap.theme.push(section);
      else if (label.indexOf('Accessibility') !== -1) branchMap.a11y.push(section);
      else if (label.indexOf('Tools') !== -1) {
        toolsSection = section;
        var row = section.querySelector('.reader-btn-row');
        if (row) {
          Array.from(row.querySelectorAll('[data-action="notes"], [data-action="pdf"], [data-action="glossary"]')).forEach(function(btn) {
            actionButtons.push(btn);
            btn.parentNode.removeChild(btn);
          });
        }
        branchMap.audio.push(section);
      } else if (label.indexOf('Highlight') !== -1) branchMap.highlight.push(section);
    });

    var tree = document.createElement('div');
    tree.className = 'reader-panel-tree';

    var metaWrap = document.createElement('div');
    metaWrap.className = 'reader-panel-meta';
    if (panel.querySelector('.reader-reading-time')) metaWrap.appendChild(panel.querySelector('.reader-reading-time'));
    if (panel.querySelector('.reader-section-jump')) metaWrap.appendChild(panel.querySelector('.reader-section-jump'));
    if (panel.querySelector('.reader-reading-width')) metaWrap.appendChild(panel.querySelector('.reader-reading-width'));
    if (metaWrap.childNodes.length) tree.appendChild(metaWrap);

    var iconsRow = document.createElement('div');
    iconsRow.className = 'reader-panel-icons';
    var branches = [
      { id: 'text', icon: 'Aa', label: 'Text' },
      { id: 'theme', icon: '\u263C', label: 'Theme' },
      { id: 'a11y', icon: '\u267F', label: 'Accessibility' },
      { id: 'audio', icon: '\u25B6', label: 'Read aloud' },
      { id: 'highlight', icon: '\u270E', label: 'Highlight' }
    ];
    branches.forEach(function(b) {
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'reader-icon-btn';
      btn.setAttribute('data-branch', b.id);
      btn.setAttribute('aria-expanded', 'false');
      btn.setAttribute('aria-label', b.label);
      btn.textContent = b.icon;
      btn.title = b.label;
      iconsRow.appendChild(btn);
    });
    actionButtons.forEach(function(btn) {
      var action = btn.getAttribute('data-action');
      var titles = { notes: 'My Notes', pdf: 'Print / PDF', glossary: 'Glossary' };
      btn.className = 'reader-btn reader-icon-btn reader-icon-action';
      btn.textContent = action === 'notes' ? '\u270D' : (action === 'pdf' ? '\u2399' : '\u2139');
      btn.title = titles[action] || action;
      btn.setAttribute('aria-label', titles[action] || action);
      iconsRow.appendChild(btn);
    });
    tree.appendChild(iconsRow);

    var contentWrap = document.createElement('div');
    contentWrap.className = 'reader-panel-content';
    ['text', 'theme', 'a11y', 'audio', 'highlight'].forEach(function(branchId) {
      var content = document.createElement('div');
      content.className = 'reader-branch-content';
      content.setAttribute('data-branch', branchId);
      branchMap[branchId].forEach(function(section) {
        content.appendChild(section);
      });
      if (content.childNodes.length) contentWrap.appendChild(content);
    });
    tree.appendChild(contentWrap);

    var defaultBranch = 'audio';
    var firstContent = contentWrap.querySelector('.reader-branch-content[data-branch="' + defaultBranch + '"]') || contentWrap.querySelector('.reader-branch-content');
    if (firstContent) firstContent.classList.add('open');
    var firstBtn = iconsRow.querySelector('[data-branch="' + defaultBranch + '"]');
    if (firstBtn) firstBtn.classList.add('active');
    if (firstBtn) firstBtn.setAttribute('aria-expanded', 'true');

    iconsRow.querySelectorAll('[data-branch]').forEach(function(btn) {
      btn.addEventListener('click', function() {
        var branch = btn.getAttribute('data-branch');
        contentWrap.querySelectorAll('.reader-branch-content').forEach(function(c) {
          c.classList.toggle('open', c.getAttribute('data-branch') === branch);
        });
        iconsRow.querySelectorAll('[data-branch]').forEach(function(b) {
          b.classList.toggle('active', b.getAttribute('data-branch') === branch);
          b.setAttribute('aria-expanded', b.getAttribute('data-branch') === branch);
        });
      });
    });

    while (panel.lastChild !== h4) panel.removeChild(panel.lastChild);
    panel.appendChild(tree);
  }

  // ==========================================
  // Initialize Everything
  // ==========================================
  function init() {
    initProgressBar();
    initBackToTop();
    initReaderPanel();
    initFindAndView();
    initReadingTime();
    initReadingMode();
    initSearch();
    initCommandPalette();
    initBookmarks();
    initReadingWidth();
    initSectionJump();
    initFontFamily();
    initFontSize();
    initSpacing();
    initDyslexiaFont();
    initTheme();
    initGlossaryInText();
    // TTS disabled for now (was not working reliably)
    // initTTS();
    initLineFocus();
    initHighlighting();
    initNotes();
    initPDFBuilder();
    initGlossary();
    initDictionary();
    markPanelSections();
    // Icon-tree panel disabled — flat layout with improved spacing instead
    // setTimeout(initReaderPanelTree, 100);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
