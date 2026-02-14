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
  // Reader Panel Toggle
  // ==========================================
  function initReaderPanel() {
    var toggle = document.querySelector('.reader-toggle');
    var panel = document.querySelector('.reader-panel');
    if (!toggle || !panel) return;

    toggle.addEventListener('click', function(e) {
      e.stopPropagation();
      panel.classList.toggle('open');
    });

    document.addEventListener('click', function(e) {
      if (!panel.contains(e.target) && e.target !== toggle) {
        panel.classList.remove('open');
      }
    });
  }

  // ==========================================
  // Font Size Control
  // ==========================================
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

  function initHighlighting() {
    // Load saved highlights
    var saved = localStorage.getItem('yawp_highlights_' + pageKey);
    if (saved) {
      try { highlights = JSON.parse(saved); } catch(e) { highlights = []; }
      restoreHighlights();
    }

    // Color picker buttons
    var colorBtns = document.querySelectorAll('[data-highlight-color]');
    colorBtns.forEach(function(btn) {
      if (btn.getAttribute('data-highlight-color') === highlightColor) btn.classList.add('active');
      btn.addEventListener('click', function() {
        colorBtns.forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        highlightColor = btn.getAttribute('data-highlight-color');
      });
    });

    // Highlight button
    var highlightBtn = document.querySelector('[data-action="highlight"]');
    if (highlightBtn) {
      highlightBtn.addEventListener('click', function() {
        highlightSelection();
      });
    }

    // Clear highlights button
    var clearBtn = document.querySelector('[data-action="clear-highlights"]');
    if (clearBtn) {
      clearBtn.addEventListener('click', function() {
        clearAllHighlights();
      });
    }
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
  // Glossary Panel
  // ==========================================
  function initGlossary() {
    var glossaryBtn = document.querySelector('[data-action="glossary"]');
    var panel = document.querySelector('.glossary-panel');
    var closeBtn = panel ? panel.querySelector('.glossary-close') : null;
    if (!glossaryBtn || !panel) return;

    // Build glossary from vocab boxes
    var terms = [];
    document.querySelectorAll('.vocab-box').forEach(function(box) {
      box.querySelectorAll('p').forEach(function(p) {
        var strong = p.querySelector('strong');
        if (strong) {
          var termText = strong.textContent.replace(/:$/, '').trim();
          var defText = p.textContent.replace(strong.textContent, '').trim();
          if (defText.charAt(0) === ':') defText = defText.substring(1).trim();
          terms.push({ term: termText, definition: defText });
        }
      });
    });

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
            popup.innerHTML = html;
          } else {
            popup.innerHTML = '<div class="dict-error">No definition found for \u201c' + escapeHtml(word) + '\u201d</div>';
          }
        })
        .catch(function() {
          popup.innerHTML = '<div class="dict-error">Could not look up this word. Check your connection.</div>';
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
    if (!panel || panel.querySelector('.reader-reading-width')) return;
    var saved = localStorage.getItem('yawp_reading_width') || 'normal';
    if (saved === 'narrow') document.body.classList.add('reading-width-narrow');

    var wrap = document.createElement('div');
    wrap.className = 'reader-section reader-reading-width';
    wrap.innerHTML = '<label>Reading width</label><div class="reader-btn-row"></div>';
    var row = wrap.querySelector('.reader-btn-row');
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
    initReadingTime();
    initReadingWidth();
    initSectionJump();
    initFontSize();
    initSpacing();
    initDyslexiaFont();
    initTheme();
    initTTS();
    initLineFocus();
    initHighlighting();
    initNotes();
    initPDFBuilder();
    initGlossary();
    initDictionary();
    setTimeout(initReaderPanelTree, 100);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
