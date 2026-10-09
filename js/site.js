/* FreshFeed — site settings + Supabase client.
 *
 * Change contact details HERE (nowhere else). Empty email / address are hidden on the page.
 * The Supabase key below is the *publishable* key: it is meant to be public in the browser.
 * Real protection comes from the row-level-security rules in supabase/migrations/.
 * NEVER put the service_role key in this file.
 */
window.FF = window.FF || {};

window.FF.SITE = {
  supabaseUrl: 'https://sulkxblynmqjtmbsxajd.supabase.co',
  supabaseKey: 'sb_publishable_yGwUM0RSgAYJi6X6AaALLQ_2rXO_Vqh',
  phones: ['+91 77987 57788', '+91 98909 06508'],
  whatsapp: '917798757788',            // digits only, with country code (goes to the first phone)
  email: '',                           // optional
  address: '',                         // optional
  hours: {
    en: 'Mon–Sat, 10 am – 6 pm IST',
    hi: 'सोम–शनि, सुबह 10 – शाम 6',
    mr: 'सोम–शनि, सकाळी 10 – संध्या. 6'
  }
};

// One shared client for the whole site (contact form now, sign-in later).
window.FF.sb = null;
try {
  if (window.supabase && window.supabase.createClient) {
    window.FF.sb = window.supabase.createClient(window.FF.SITE.supabaseUrl, window.FF.SITE.supabaseKey, {
      auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
    });
  }
} catch (err) {
  console.error('Supabase failed to start', err);
}
