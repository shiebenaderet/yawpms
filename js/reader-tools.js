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
  // Text-to-Speech (with speed control for students)
  // ==========================================
  var ttsUtterance = null;
  var ttsBtn = null;
  var ttsRate = parseFloat(localStorage.getItem('yawp_tts_rate') || '0.9', 10);

  function getTTSRate() {
    return ttsRate;
  }

  function initTTS() {
    ttsBtn = document.querySelector('[data-tts]');
    if (!ttsBtn || !window.speechSynthesis) return;

    injectTTSSpeedControls();

    ttsBtn.addEventListener('click', function() {
      if (speechSynthesis.speaking) {
        speechSynthesis.cancel();
        ttsBtn.textContent = 'Read Aloud';
        ttsBtn.classList.remove('active');
        return;
      }

      var sel = window.getSelection();
      var text = '';
      if (sel && sel.toString().trim().length > 0) {
        text = sel.toString();
      } else {
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
        if (bestSection) text = bestSection.textContent;
      }

      if (!text.trim()) return;

      ttsUtterance = new SpeechSynthesisUtterance(text.slice(0, 5000));
      ttsUtterance.rate = getTTSRate();
      ttsUtterance.onend = function() {
        ttsBtn.textContent = 'Read Aloud';
        ttsBtn.classList.remove('active');
      };
      speechSynthesis.speak(ttsUtterance);
      ttsBtn.textContent = 'Stop Reading';
      ttsBtn.classList.add('active');
    });
  }

  function injectTTSSpeedControls() {
    var toolsLabel = Array.from(document.querySelectorAll('.reader-section label')).find(function(l) { return l.textContent.trim() === 'Tools'; });
    if (!toolsLabel) return;
    var section = toolsLabel.closest('.reader-section');
    if (!section || section.querySelector('.reader-tts-speed')) return;
    var wrap = document.createElement('div');
    wrap.className = 'reader-section';
    wrap.innerHTML = '<label>Read aloud speed</label><div class="reader-tts-speed"></div>';
    var container = wrap.querySelector('.reader-tts-speed');
    var speeds = [
      { value: 0.75, label: 'Slower' },
      { value: 0.9, label: 'Normal' },
      { value: 1.1, label: 'Faster' }
    ];
    speeds.forEach(function(s) {
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'speed-btn' + (Math.abs(ttsRate - s.value) < 0.05 ? ' active' : '');
      btn.textContent = s.label;
      btn.setAttribute('data-tts-rate', String(s.value));
      btn.addEventListener('click', function() {
        container.querySelectorAll('.speed-btn').forEach(function(b) { b.classList.remove('active'); });
        btn.classList.add('active');
        ttsRate = s.value;
        localStorage.setItem('yawp_tts_rate', String(ttsRate));
      });
      container.appendChild(btn);
    });
    section.parentNode.insertBefore(wrap, section);
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
  // Initialize Everything
  // ==========================================
  function init() {
    initProgressBar();
    initBackToTop();
    initReaderPanel();
    initReadingTime();
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
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
