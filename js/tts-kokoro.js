/**
 * Optional Kokoro TTS — high-quality in-browser speech.
 * Loaded as module; registers window.yawpKokoroTTS for reader-tools.js.
 */
(function register() {
  'use strict';

  var tts = null;
  var playing = false;
  var stopRequested = false;
  var defaultVoice = 'af_bella';

  function isReady() {
    return tts !== null;
  }

  function isPlaying() {
    return playing;
  }

  function stop() {
    stopRequested = true;
  }

  function playAudioBlob(blob) {
    return new Promise(function(resolve, reject) {
      var url = URL.createObjectURL(blob);
      var audio = new Audio(url);
      audio.onended = function() {
        URL.revokeObjectURL(url);
        resolve();
      };
      audio.onerror = function() {
        URL.revokeObjectURL(url);
        reject(new Error('Playback failed'));
      };
      audio.play().then(resolve).catch(reject);
    });
  }

  function load() {
    if (tts) return Promise.resolve();
    return import('https://esm.sh/kokoro-js@1.2.1')
      .then(function(mod) {
        var KokoroTTS = mod.KokoroTTS || (mod.default && mod.default.KokoroTTS) || mod.default;
        if (!KokoroTTS) throw new Error('KokoroTTS not found');
        var device = typeof navigator !== 'undefined' && navigator.gpu ? 'webgpu' : 'wasm';
        return KokoroTTS.from_pretrained('onnx-community/Kokoro-82M-v1.0-ONNX', {
          dtype: 'q8',
          device: device
        });
      })
      .then(function(instance) {
        tts = instance;
        return tts;
      });
  }

  function sentenceSplit(text) {
    var trimmed = text.replace(/\s+/g, ' ').trim();
    if (!trimmed) return [];
    var parts = trimmed.match(/[^.!?]+[.!?]*\s*/g) || [trimmed];
    return parts.map(function(p) { return p.trim(); }).filter(Boolean);
  }

  function speak(text, opts) {
    opts = opts || {};
    var rate = Math.max(0.5, Math.min(2, opts.rate || 1));
    var onSentence = opts.onSentence || function() {};
    var onEnd = opts.onEnd || function() {};
    if (!tts) {
        onEnd();
        return;
    }
    stopRequested = false;
    playing = true;
    var sentences = sentenceSplit(text);
    var voice = opts.voice || defaultVoice;

    function next(i) {
      if (stopRequested || i >= sentences.length) {
        playing = false;
        onEnd();
        return;
      }
      var sentence = sentences[i];
      onSentence(sentence);
      tts.generate(sentence, { voice: voice })
        .then(function(audio) {
          if (stopRequested) {
            playing = false;
            onEnd();
            return;
          }
          var blob = null;
          if (audio && typeof audio.toBlob === 'function') {
            blob = audio.toBlob();
          } else if (audio && audio.data) {
            var wav = audioToWav(audio.data, audio.sampleRate || 24000);
            blob = new Blob([wav], { type: 'audio/wav' });
          } else if (audio && audio._data) {
            var wav = audioToWav(audio._data, audio.sampleRate || 24000);
            blob = new Blob([wav], { type: 'audio/wav' });
          }
          if (blob) {
            playAudioBlob(blob).then(function() { next(i + 1); }).catch(function() { next(i + 1); });
          } else {
            next(i + 1);
          }
        })
        .catch(function() {
          next(i + 1);
        });
    }

    next(0);
  }

  function audioToWav(samples, sampleRate) {
    var numChannels = 1;
    var bitsPerSample = 16;
    var bytesPerSample = bitsPerSample / 8;
    var blockAlign = numChannels * bytesPerSample;
    var byteRate = sampleRate * blockAlign;
    var dataSize = samples.length * bytesPerSample;
    var buffer = new ArrayBuffer(44 + dataSize);
    var view = new DataView(buffer);
    var offset = 0;
    function writeStr(s) {
      for (var i = 0; i < s.length; i++) view.setUint8(offset++, s.charCodeAt(i));
    }
    writeStr('RIFF');
    view.setUint32(offset, 36 + dataSize, true); offset += 4;
    writeStr('WAVE');
    writeStr('fmt ');
    view.setUint32(offset, 16, true); offset += 4;
    view.setUint16(offset, 1, true); offset += 2;
    view.setUint16(offset, numChannels, true); offset += 2;
    view.setUint32(offset, sampleRate, true); offset += 4;
    view.setUint32(offset, byteRate, true); offset += 4;
    view.setUint16(offset, blockAlign, true); offset += 2;
    view.setUint16(offset, bitsPerSample, true); offset += 2;
    writeStr('data');
    view.setUint32(offset, dataSize, true); offset += 4;
    for (var j = 0; j < samples.length; j++) {
      var s = Math.max(-1, Math.min(1, samples[j]));
      view.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
      offset += 2;
    }
    return buffer;
  }

  window.yawpKokoroTTS = {
    load: load,
    isReady: isReady,
    isPlaying: isPlaying,
    stop: stop,
    speak: speak
  };
})();
