/* FreshFeed — shared Supabase Auth client for home.html and signin.html.
 * Uses the project's publishable key (meant to be public in the browser);
 * access is controlled by the row-level security rules in supabase/migrations/.
 * Load https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4 before this file.
 */
(function () {
  'use strict';

  var SUPABASE_URL = 'https://sulkxblynmqjtmbsxajd.supabase.co';
  var SUPABASE_KEY = 'sb_publishable_yGwUM0RSgAYJi6X6AaALLQ_2rXO_Vqh';

  var sb = null;
  try {
    sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY, {
      auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
    });
  } catch (e) {
    console.warn('[FreshFeed] Supabase not available', e);
  }

  function displayName(user) {
    if (!user) return '';
    var meta = user.user_metadata || {};
    return (meta.full_name || '').trim() || (user.email || '').split('@')[0];
  }

  // Show [data-when="in"] / [data-when="out"] elements and fill name / initial.
  function paint(user) {
    document.querySelectorAll('[data-when]').forEach(function (el) {
      el.hidden = el.getAttribute('data-when') !== (user ? 'in' : 'out');
    });
    var name = displayName(user);
    document.querySelectorAll('[data-name]').forEach(function (el) { el.textContent = name; });
    document.querySelectorAll('[data-initial]').forEach(function (el) {
      el.textContent = (name.charAt(0) || 'U').toUpperCase();
    });
  }

  function bindSignOut() {
    document.addEventListener('click', function (e) {
      if (!e.target.closest('[data-signout]') || !sb) return;
      e.preventDefault();
      sb.auth.signOut().finally(function () { paint(null); });
    });
  }

  window.FFAuth = { sb: sb, paint: paint, displayName: displayName };

  if (sb) {
    bindSignOut();
    sb.auth.getSession().then(function (r) { paint(r.data.session && r.data.session.user); });
    sb.auth.onAuthStateChange(function (_evt, session) { paint(session && session.user); });
  }
})();
