/* FreshFeed — Contact section.
 * - Draws the contact list (phones, WhatsApp, optional email/address, hours) from FF.SITE.
 * - Sends the form to the Supabase table  contact_messages  (see supabase/migrations/).
 * Needs: site.js and i18n.js loaded first.
 */
(function () {
  'use strict';
  var FF = window.FF, SITE = FF.SITE, t = FF.t;

  var EMAIL_RE = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
  var PHONE_RE = /^[0-9+ -]{6,20}$/;

  var list = document.getElementById('contactList');
  var form = document.getElementById('contactForm');
  var box = document.getElementById('contactMsg');
  if (!list || !form) return;

  function renderContact() {
    var lang = FF.getLang();
    var items = [];
    SITE.phones.forEach(function (p, i) {
      items.push({
        icon: 'i-phone',
        label: t('c_phone') + (SITE.phones.length > 1 ? ' ' + (i + 1) : ''),
        value: p,
        href: 'tel:' + p.replace(/[^\d+]/g, '')
      });
    });
    if (SITE.whatsapp) items.push({ icon: 'i-chat', label: t('c_wa'), value: t('c_wa_v'), href: 'https://wa.me/' + SITE.whatsapp });
    if (SITE.email)    items.push({ icon: 'i-mail', label: t('c_email'), value: SITE.email, href: 'mailto:' + SITE.email });
    if (SITE.address)  items.push({ icon: 'i-pin', label: t('c_addr'), value: SITE.address });
    items.push({ icon: 'i-clock', label: t('c_hours'), value: SITE.hours[lang] || SITE.hours.en });

    list.textContent = '';
    items.forEach(function (it) {
      var el = document.createElement(it.href ? 'a' : 'div');
      el.className = 'c-item';
      if (it.href) {
        el.href = it.href;
        if (it.href.indexOf('http') === 0) { el.target = '_blank'; el.rel = 'noopener noreferrer'; }
      }
      // icon is a fixed string from this file; text goes in via textContent (never innerHTML)
      var ci = document.createElement('span');
      ci.className = 'ci';
      ci.innerHTML = '<svg class="icon" aria-hidden="true"><use href="#' + it.icon + '"/></svg>';
      var wrap = document.createElement('span');
      var small = document.createElement('small');
      var b = document.createElement('b');
      small.textContent = it.label;
      b.textContent = it.value;
      wrap.appendChild(small);
      wrap.appendChild(b);
      el.appendChild(ci);
      el.appendChild(wrap);
      list.appendChild(el);
    });
  }

  function showMsg(kind, text) {
    box.textContent = '';
    if (!text) return;
    var d = document.createElement('div');
    d.className = 'msg ' + kind;
    d.textContent = text;
    box.appendChild(d);
  }

  var submitBtn = form.querySelector('button[type="submit"]');
  var submitLabel = submitBtn.querySelector('[data-i18n]');
  function busy(on) {
    submitBtn.disabled = on;
    submitBtn.setAttribute('aria-busy', String(on));
    submitLabel.setAttribute('data-i18n', on ? 'cf_sending' : 'cf_send');
    submitLabel.textContent = t(on ? 'cf_sending' : 'cf_send');
  }

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    if (submitBtn.disabled) return;

    // Hidden "website" field: people never see it, bots fill it. Pretend success and drop the message.
    if (form.elements.website && form.elements.website.value) { form.reset(); showMsg('ok', t('cf_ok')); return; }

    var row = {
      name: form.elements.name.value.trim(),
      email: form.elements.email.value.trim(),
      phone: form.elements.phone.value.trim() || null,
      topic: form.elements.topic.value,
      message: form.elements.message.value.trim()
    };
    if (row.name.length < 2) return showMsg('err', t('e_required'));
    if (!EMAIL_RE.test(row.email)) return showMsg('err', t('e_email'));
    if (row.phone && !PHONE_RE.test(row.phone)) return showMsg('err', t('e_phone'));
    if (row.message.length < 10) return showMsg('err', t('e_msg'));
    if (!FF.sb) return showMsg('err', t('e_network'));

    showMsg();
    busy(true);
    FF.sb.from('contact_messages').insert(row).then(function (res) {
      busy(false);
      if (res.error) return showMsg('err', navigator.onLine ? t('e_generic') : t('e_network'));
      form.reset();
      showMsg('ok', t('cf_ok'));
    }, function () {
      busy(false);
      showMsg('err', t('e_network'));
    });
  });

  document.addEventListener('ff:lang', function () { renderContact(); if (box.firstChild && box.firstChild.className === 'msg err') showMsg(); });
  renderContact();
})();
