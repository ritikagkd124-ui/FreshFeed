/* FreshFeed — sign in / sign up window (UI only).
 * Opening, closing, switching tabs and views, show/hide password.
 * Supabase sign-in is connected in the next step.
 */
(function () {
  'use strict';

  var overlay = document.getElementById('authOverlay');
  if (!overlay) return;
  var lastFocus = null;

  function $(sel, root) { return (root || overlay).querySelector(sel); }
  function $all(sel, root) { return (root || overlay).querySelectorAll(sel); }

  function showView(name) {
    $all('[data-view]').forEach(function (v) { v.hidden = v.getAttribute('data-view') !== name; });
    clearMessages();
  }

  function showTab(name) {
    $all('[data-tab]').forEach(function (b) {
      b.setAttribute('aria-selected', b.getAttribute('data-tab') === name ? 'true' : 'false');
    });
    $('#signinForm').hidden = name !== 'signin';
    $('#signupForm').hidden = name !== 'signup';
    clearMessages();
  }

  function clearMessages() {
    $all('[data-msg]').forEach(function (m) { m.className = ''; m.textContent = ''; });
  }

  function open(what) {
    lastFocus = document.activeElement;
    if (what === 'forgot') { showView('forgot'); }
    else { showView('auth'); showTab(what === 'signup' ? 'signup' : 'signin'); }
    overlay.hidden = false;
    document.body.style.overflow = 'hidden';
    var first = overlay.querySelector('[data-view]:not([hidden]) form:not([hidden]) input');
    if (first) first.focus();
  }

  function close() {
    overlay.hidden = true;
    document.body.style.overflow = '';
    if (lastFocus && lastFocus.focus) lastFocus.focus();
  }

  // Buttons anywhere on the page with data-open="signin" / "signup"
  document.addEventListener('click', function (e) {
    var opener = e.target.closest('[data-open]');
    if (!opener) return;
    e.preventDefault();
    var mobileNav = document.getElementById('mobileNav');
    if (mobileNav) mobileNav.classList.remove('open');
    open(opener.getAttribute('data-open'));
  });

  overlay.addEventListener('click', function (e) {
    if (e.target === overlay || e.target.closest('[data-close]')) return close();
    var tab = e.target.closest('[data-tab]');
    if (tab) return showTab(tab.getAttribute('data-tab'));
    var show = e.target.closest('[data-show]');
    if (show) return show.getAttribute('data-show') === 'auth' ? (showView('auth'), showTab('signin')) : showView(show.getAttribute('data-show'));
    var eye = e.target.closest('.pw-toggle');
    if (eye) {
      var input = eye.parentNode.querySelector('input');
      var hidden = input.type === 'password';
      input.type = hidden ? 'text' : 'password';
      eye.setAttribute('aria-label', hidden ? 'Hide password' : 'Show password');
    }
  });

  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && !overlay.hidden) close();
  });

  window.FF = window.FF || {};
  window.FF.auth = { open: open, close: close, showView: showView, showTab: showTab };
})();
