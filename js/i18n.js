/* FreshFeed — English / हिंदी / मराठी
 *
 * HOW TO ADD TEXT
 *   1. Put  data-i18n="some_key"  on the element (its text is replaced).
 *   2. Add  some_key  to all three languages below (en, hi, mr).
 *   If a key is missing in hi/mr it falls back to English, so nothing breaks.
 *
 * Other scripts can use  FF.t('key')  and listen for the  "ff:lang"  event on document.
 */
(function () {
  'use strict';

  var T = {
    en: {
      nav_features: 'Features', nav_how: 'How it works', nav_about: 'About', nav_faq: 'FAQ', nav_contact: 'Contact',
      sign_in: 'Sign in', sign_up: 'Sign up', lang_label: 'Language', menu_label: 'Menu',

      hero_eyebrow: 'Packaging advice for farmers & food businesses',
      hero_t1: 'Right pack.', hero_t2: 'Longer freshness.',
      hero_lead: 'Tell FreshFeed what you are packing, where you will keep it and how it travels. Get the right bag, box or film in plain words — with a spec sheet you can send straight to your supplier.',
      cta_start: 'Get started free', cta_guest: 'Try it as a guest', cta_how: 'See how it works',
      trust1: 'Free to use', trust3: 'Works on any phone',
      mock_prod: 'Mangoes · Truck · 2 weeks', mock_sub: 'Your packing advice', mock_use: 'Use this',
      mock_pack: 'Bag with tiny holes', mock_mat: 'Micro-perforated LDPE film',
      mock_keeps: 'Keeps fresh at 13–15°C', mock_life: '2–3 weeks',
      mock_warn: 'Not for the fridge. Below 13°C mangoes get chilling damage.', mock_spec: 'Spec sheet',

      st_products: 'foods and crops covered', st_targets: 'gas-mix targets from research',
      st_materials: 'packaging materials compared', st_langs: 'languages, with voice input',

      feat_eyebrow: 'What you get', feat_title: 'Everything you need to pack it right',
      feat_sub: 'Built from published post-harvest research, explained in words a farmer or shopkeeper can act on today.',
      f1_t: 'The right pack, in plain words', f1_d: 'Mesh bag, perforated film, foil pouch or vented jar — matched to how your produce breathes and spoils.',
      f2_t: 'Speak in your language', f2_d: 'Say “aam, 2 hafte, truck” in English, Hindi or Marathi. Advice can be read aloud too.',
      f3_t: 'Warnings before losses', f3_d: 'Chilling injury, ethylene damage, too-long storage and food-safety rules flagged before they cost you.',
      f4_t: 'Spec sheet for suppliers', f4_d: 'A printable sheet with a QR code. Send it on WhatsApp so your supplier gives you exactly the right material.',
      f5_t: 'Cost and thickness estimates', f5_d: 'Know roughly what a bag, pouch or crate should cost in rupees before you talk to a supplier.',
      f6_t: 'Expert mode', f6_d: 'Respiration rates, target O₂/CO₂ and the film oxygen transmission (OTR) your bag needs — calculated live.',

      how_eyebrow: 'How it works', how_title: 'Three questions. One clear answer.',
      s1_t: 'Pick or say your produce', s1_d: 'Tap from 80 foods — fruits, vegetables, dairy, snacks and pickles — or just say its name.',
      s2_t: 'Tell us storage, time and travel', s2_d: 'Room, cold store or fridge. Three days to three months. Local market, truck, courier or export.',
      s3_t: 'Get your pack and share it', s3_d: 'See what to buy, what to avoid and how long it will last. Share the spec sheet with your supplier.',

      aud_eyebrow: 'Who it is for', aud_title: 'Made for the people who grow and sell food',
      a1_t: 'Farmers', a1_d: 'Cut losses between the field and the mandi.',
      a2_t: 'FPOs & co-operatives', a2_d: 'Standardise packing across many members.',
      a3_t: 'Traders & exporters', a3_d: 'Plan cold chain and packs for long journeys.',
      a4_t: 'Small food makers', a4_d: 'Keep snacks crisp, dairy safe and pickles sound.',

      about_eyebrow: 'About FreshFeed', about_title: 'Less food lost. More money in the farmer’s pocket.',
      about_p1: 'A large share of fruits and vegetables in India spoil after harvest — often because they are packed in the wrong bag, sealed when they need to breathe, or chilled when they cannot take the cold.',
      about_p2: 'FreshFeed turns decades of post-harvest science into simple, local-language advice. We match each food’s breathing rate, ideal temperature and humidity, and gas needs to a pack you can actually buy nearby.',
      about_src_t: 'Our data sources', about_src: 'USDA Agriculture Handbook 66 (2016), Cantwell – UC Davis (2001), Kader (2002), a produce storage technical manual, and film data from Poly Print and NatureWorks.',
      v1_t: 'Science first', v1_d: 'Every recommendation traces back to a published source.',
      v2_t: 'Simple for everyone', v2_d: 'Big buttons, pictures, voice and three languages.',
      v3_t: 'Honest about eco options', v3_d: 'We show greener packs — and their trade-offs.',
      v4_t: 'Your data stays yours', v4_d: 'Your account and saved advice are private to you.',

      faq_eyebrow: 'Questions', faq_title: 'Frequently asked questions',
      q1: 'Is FreshFeed free?', q1a: 'Yes. The advice, spec sheet and expert mode are free to use.',
      q2: 'Do I need an account?', q2a: 'No — you can use the app as a guest. With a free account your advice and feedback are saved to your profile and follow you to any phone or computer.',
      q3: 'Where does the advice come from?', q3a: 'From published storage research such as the USDA Agriculture Handbook 66 and UC Davis post-harvest data. Costs are estimates — always compare two or three local suppliers.',
      q4: 'My crop is not in the list. What should I do?', q4a: 'Send us a message below with the crop name. We add new foods regularly.',

      contact_eyebrow: 'Contact', contact_title: 'Talk to us',
      contact_sub: 'Questions about packing, a crop we should add, or a partnership? We usually reply within two working days.',
      c_email: 'Email', c_phone: 'Phone', c_wa: 'WhatsApp', c_wa_v: 'Chat with us', c_addr: 'Office', c_hours: 'Working hours',
      cf_title: 'Send a message', f_name: 'Your name', f_email: 'Email', f_phone: 'Phone', optional: '(optional)',
      f_topic: 'Topic', t_general: 'General question', t_packaging: 'Help with packing', t_partnership: 'Partnership',
      t_bug: 'Report a problem', t_other: 'Other',
      f_message: 'Message', f_msg_hint: 'At least 10 characters.', cf_send: 'Send message', cf_sending: 'Sending…',
      cf_ok: 'Thank you! Your message has been sent. We will get back to you soon.',
      e_required: 'Please fill in all required fields.', e_email: 'Please enter a valid email address.',
      e_phone: 'Phone can only have digits, spaces, + and - (6–20 characters).',
      e_msg: 'Message must be at least 10 characters.',
      e_network: 'Could not reach the server. Check your internet and try again.',
      e_generic: 'Something went wrong. Please try again.'
    },

    hi: {
      nav_features: 'सुविधाएँ', nav_how: 'कैसे काम करता है', nav_about: 'हमारे बारे में', nav_faq: 'सवाल-जवाब', nav_contact: 'संपर्क',
      sign_in: 'साइन इन', sign_up: 'साइन अप', lang_label: 'भाषा', menu_label: 'मेन्यू',

      hero_eyebrow: 'किसानों और खाद्य व्यवसायों के लिए पैकिंग सलाह',
      hero_t1: 'सही पैकिंग।', hero_t2: 'ज़्यादा दिन ताज़गी।',
      hero_lead: 'FreshFeed को बताइए आप क्या पैक कर रहे हैं, कहाँ रखेंगे और कैसे भेजेंगे। आसान शब्दों में सही बैग, डिब्बा या फिल्म जानिए — साथ में सप्लायर को भेजने के लिए स्पेक शीट।',
      cta_start: 'मुफ़्त शुरू करें', cta_guest: 'बिना खाते के आज़माएँ', cta_how: 'कैसे काम करता है देखें',
      trust1: 'मुफ़्त', trust3: 'हर फ़ोन पर चलता है',
      mock_prod: 'आम · ट्रक · 2 हफ्ते', mock_sub: 'आपकी पैकिंग सलाह', mock_use: 'यह इस्तेमाल करें',
      mock_pack: 'बारीक छेद वाला बैग', mock_mat: 'माइक्रो-छिद्रित LDPE फिल्म',
      mock_keeps: '13–15°C पर ताज़ा रहता है', mock_life: '2–3 हफ्ते',
      mock_warn: 'फ्रिज में न रखें। 13°C से कम पर आम ठंड से खराब होता है।', mock_spec: 'स्पेक शीट',

      st_products: 'फसलें और खाद्य पदार्थ', st_targets: 'शोध से गैस लक्ष्य',
      st_materials: 'पैकिंग सामग्री की तुलना', st_langs: 'भाषाएँ, आवाज़ के साथ',

      feat_eyebrow: 'आपको क्या मिलता है', feat_title: 'सही पैकिंग के लिए सब कुछ',
      feat_sub: 'प्रकाशित शोध पर आधारित, ऐसे शब्दों में जिन पर किसान या दुकानदार आज ही अमल कर सके।',
      f1_t: 'आसान शब्दों में सही पैक', f1_d: 'जाली बैग, छिद्रित फिल्म, फॉइल पाउच या वेंट वाला जार — आपकी फसल के हिसाब से।',
      f2_t: 'अपनी भाषा में बोलें', f2_d: '“आम, 2 हफ्ते, ट्रक” बोलें — हिंदी, मराठी या अंग्रेज़ी में। सलाह सुन भी सकते हैं।',
      f3_t: 'नुकसान से पहले चेतावनी', f3_d: 'ठंड से नुकसान, एथिलीन, ज़्यादा दिन भंडारण और खाद्य सुरक्षा के नियम — पहले ही बता दिए जाते हैं।',
      f4_t: 'सप्लायर के लिए स्पेक शीट', f4_d: 'QR कोड वाली प्रिंट शीट। व्हाट्सऐप पर भेजें ताकि सप्लायर सही सामग्री दे।',
      f5_t: 'मोटाई और कीमत का अनुमान', f5_d: 'सप्लायर से बात करने से पहले जानें बैग, पाउच या क्रेट की लगभग कीमत।',
      f6_t: 'विशेषज्ञ मोड', f6_d: 'श्वसन दर, O₂/CO₂ लक्ष्य और बैग के लिए ज़रूरी फिल्म OTR — तुरंत गणना।',

      how_eyebrow: 'कैसे काम करता है', how_title: 'तीन सवाल। एक साफ़ जवाब।',
      s1_t: 'फसल चुनें या बोलें', s1_d: '80 खाद्य पदार्थों में से चुनें — फल, सब्ज़ी, डेयरी, नमकीन, अचार — या बस नाम बोलें।',
      s2_t: 'भंडारण, समय और सफ़र बताएँ', s2_d: 'कमरा, कोल्ड स्टोर या फ्रिज। 3 दिन से 3 महीने। मंडी, ट्रक, कूरियर या निर्यात।',
      s3_t: 'पैक जानें और शेयर करें', s3_d: 'क्या खरीदें, क्या न करें और कितने दिन चलेगा। स्पेक शीट सप्लायर को भेजें।',

      aud_eyebrow: 'किसके लिए', aud_title: 'अन्न उगाने और बेचने वालों के लिए',
      a1_t: 'किसान', a1_d: 'खेत से मंडी तक नुकसान कम करें।',
      a2_t: 'FPO और सहकारी', a2_d: 'सभी सदस्यों की पैकिंग एक जैसी करें।',
      a3_t: 'व्यापारी और निर्यातक', a3_d: 'लंबे सफ़र के लिए कोल्ड चेन और पैक की योजना।',
      a4_t: 'छोटे खाद्य उत्पादक', a4_d: 'नमकीन कुरकुरा, डेयरी सुरक्षित, अचार सही।',

      about_eyebrow: 'FreshFeed के बारे में', about_title: 'कम बर्बादी। किसान की जेब में ज़्यादा पैसा।',
      about_p1: 'भारत में बहुत से फल और सब्ज़ियाँ कटाई के बाद खराब हो जाते हैं — अक्सर गलत बैग, साँस की ज़रूरत होने पर बंद पैक, या ठंड न सहने वाली फसल को ठंडा करने से।',
      about_p2: 'FreshFeed दशकों के शोध को आसान, अपनी भाषा की सलाह में बदलता है। हर फसल की श्वसन दर, सही तापमान, नमी और गैस की ज़रूरत के हिसाब से ऐसा पैक सुझाते हैं जो पास में मिल सके।',
      about_src_t: 'हमारे डेटा स्रोत', about_src: 'USDA कृषि हैंडबुक 66 (2016), कैंटवेल – UC डेविस (2001), कादर (2002), भंडारण तकनीकी मैनुअल, और Poly Print व NatureWorks का फिल्म डेटा।',
      v1_t: 'विज्ञान पहले', v1_d: 'हर सलाह किसी प्रकाशित स्रोत पर आधारित है।',
      v2_t: 'सबके लिए आसान', v2_d: 'बड़े बटन, चित्र, आवाज़ और तीन भाषाएँ।',
      v3_t: 'पर्यावरण विकल्प ईमानदारी से', v3_d: 'हरित पैक दिखाते हैं — उनकी कमियों के साथ।',
      v4_t: 'आपका डेटा आपका', v4_d: 'आपका खाता और सलाह सिर्फ़ आपके लिए।',

      faq_eyebrow: 'सवाल', faq_title: 'अक्सर पूछे जाने वाले सवाल',
      q1: 'क्या FreshFeed मुफ़्त है?', q1a: 'हाँ। सलाह, स्पेक शीट और विशेषज्ञ मोड मुफ़्त हैं।',
      q2: 'क्या खाता ज़रूरी है?', q2a: 'नहीं — आप बिना खाते के भी ऐप इस्तेमाल कर सकते हैं। मुफ़्त खाते से आपकी सलाह हर फ़ोन और कंप्यूटर पर सेव रहती है।',
      q3: 'सलाह कहाँ से आती है?', q3a: 'USDA कृषि हैंडबुक 66 और UC डेविस जैसे प्रकाशित शोध से। कीमतें अनुमान हैं — 2–3 स्थानीय सप्लायर से तुलना करें।',
      q4: 'मेरी फसल सूची में नहीं है?', q4a: 'नीचे फसल का नाम लिखकर संदेश भेजें। हम नई फसलें जोड़ते रहते हैं।',

      contact_eyebrow: 'संपर्क', contact_title: 'हमसे बात करें',
      contact_sub: 'पैकिंग का सवाल, कोई नई फसल, या साझेदारी? हम आमतौर पर दो कार्य-दिवस में जवाब देते हैं।',
      c_email: 'ईमेल', c_phone: 'फ़ोन', c_wa: 'व्हाट्सऐप', c_wa_v: 'हमसे चैट करें', c_addr: 'कार्यालय', c_hours: 'कार्य समय',
      cf_title: 'संदेश भेजें', f_name: 'आपका नाम', f_email: 'ईमेल', f_phone: 'फ़ोन', optional: '(वैकल्पिक)',
      f_topic: 'विषय', t_general: 'सामान्य सवाल', t_packaging: 'पैकिंग में मदद', t_partnership: 'साझेदारी',
      t_bug: 'समस्या बताएँ', t_other: 'अन्य',
      f_message: 'संदेश', f_msg_hint: 'कम से कम 10 अक्षर।', cf_send: 'संदेश भेजें', cf_sending: 'भेज रहे हैं…',
      cf_ok: 'धन्यवाद! आपका संदेश भेज दिया गया। हम जल्द जवाब देंगे।',
      e_required: 'कृपया सभी ज़रूरी जानकारी भरें।', e_email: 'कृपया सही ईमेल डालें।',
      e_phone: 'फ़ोन में केवल अंक, स्पेस, + और - (6–20 अक्षर)।',
      e_msg: 'संदेश कम से कम 10 अक्षर का हो।',
      e_network: 'सर्वर से संपर्क नहीं हुआ। इंटरनेट देखें और फिर कोशिश करें।',
      e_generic: 'कुछ गलत हुआ। फिर कोशिश करें।'
    },

    mr: {
      nav_features: 'वैशिष्ट्ये', nav_how: 'कसे काम करते', nav_about: 'आमच्याबद्दल', nav_faq: 'प्रश्नोत्तरे', nav_contact: 'संपर्क',
      sign_in: 'साइन इन', sign_up: 'साइन अप', lang_label: 'भाषा', menu_label: 'मेनू',

      hero_eyebrow: 'शेतकरी आणि अन्न व्यवसायांसाठी पॅकिंग सल्ला',
      hero_t1: 'योग्य पॅकिंग.', hero_t2: 'जास्त दिवस ताजेपणा.',
      hero_lead: 'तुम्ही काय पॅक करताय, कुठे ठेवणार आणि कसे पाठवणार ते FreshFeed ला सांगा. सोप्या शब्दांत योग्य पिशवी, खोका किंवा फिल्म जाणून घ्या — सोबत पुरवठादाराला पाठवण्यासाठी स्पेक शीट.',
      cta_start: 'मोफत सुरू करा', cta_guest: 'खात्याशिवाय वापरून पाहा', cta_how: 'कसे काम करते ते पाहा',
      trust1: 'मोफत', trust3: 'कोणत्याही फोनवर चालते',
      mock_prod: 'आंबा · ट्रक · 2 आठवडे', mock_sub: 'तुमचा पॅकिंग सल्ला', mock_use: 'हे वापरा',
      mock_pack: 'बारीक छिद्रांची पिशवी', mock_mat: 'मायक्रो-छिद्रित LDPE फिल्म',
      mock_keeps: '13–15°C वर ताजे राहते', mock_life: '2–3 आठवडे',
      mock_warn: 'फ्रिजमध्ये ठेवू नका. 13°C पेक्षा कमी तापमानात आंबा थंडीने खराब होतो.', mock_spec: 'स्पेक शीट',

      st_products: 'पिके आणि खाद्यपदार्थ', st_targets: 'संशोधनातील वायू लक्ष्ये',
      st_materials: 'पॅकिंग साहित्याची तुलना', st_langs: 'भाषा, आवाजासह',

      feat_eyebrow: 'तुम्हाला काय मिळते', feat_title: 'योग्य पॅकिंगसाठी सर्व काही',
      feat_sub: 'प्रकाशित संशोधनावर आधारित, शेतकरी किंवा दुकानदार आजच अमलात आणू शकेल अशा शब्दांत.',
      f1_t: 'सोप्या शब्दांत योग्य पॅक', f1_d: 'जाळी पिशवी, छिद्रित फिल्म, फॉइल पाउच किंवा व्हेंट बरणी — तुमच्या मालानुसार.',
      f2_t: 'तुमच्या भाषेत बोला', f2_d: '“आंबा, 2 आठवडे, ट्रक” असे मराठी, हिंदी किंवा इंग्रजीत बोला. सल्ला ऐकताही येतो.',
      f3_t: 'नुकसानापूर्वी इशारा', f3_d: 'थंडीचे नुकसान, इथिलीन, जास्त दिवस साठवण आणि अन्न सुरक्षा नियम — आधीच सांगितले जातात.',
      f4_t: 'पुरवठादारासाठी स्पेक शीट', f4_d: 'QR कोडसह प्रिंट शीट. व्हॉट्सॲपवर पाठवा म्हणजे पुरवठादार योग्य साहित्य देईल.',
      f5_t: 'जाडी आणि किंमतीचा अंदाज', f5_d: 'पुरवठादाराशी बोलण्यापूर्वी पिशवी, पाउच किंवा क्रेटची अंदाजे किंमत जाणा.',
      f6_t: 'तज्ज्ञ मोड', f6_d: 'श्वसन दर, O₂/CO₂ लक्ष्य आणि पिशवीसाठी आवश्यक फिल्म OTR — लगेच गणना.',

      how_eyebrow: 'कसे काम करते', how_title: 'तीन प्रश्न. एक स्पष्ट उत्तर.',
      s1_t: 'पीक निवडा किंवा बोला', s1_d: '80 खाद्यपदार्थांतून निवडा — फळे, भाज्या, दुग्धजन्य, फरसाण, लोणची — किंवा फक्त नाव बोला.',
      s2_t: 'साठवण, वेळ आणि प्रवास सांगा', s2_d: 'खोली, कोल्ड स्टोअर किंवा फ्रिज. 3 दिवस ते 3 महिने. बाजार, ट्रक, कुरिअर किंवा निर्यात.',
      s3_t: 'पॅक जाणा आणि शेअर करा', s3_d: 'काय घ्यावे, काय टाळावे आणि किती दिवस टिकेल. स्पेक शीट पुरवठादाराला पाठवा.',

      aud_eyebrow: 'कोणासाठी', aud_title: 'अन्न पिकवणाऱ्या आणि विकणाऱ्यांसाठी',
      a1_t: 'शेतकरी', a1_d: 'शेतापासून मंडईपर्यंत नुकसान कमी करा.',
      a2_t: 'FPO आणि सहकारी संस्था', a2_d: 'सर्व सभासदांचे पॅकिंग एकसारखे करा.',
      a3_t: 'व्यापारी आणि निर्यातदार', a3_d: 'लांबच्या प्रवासासाठी कोल्ड चेन आणि पॅकचे नियोजन.',
      a4_t: 'लघु खाद्य उत्पादक', a4_d: 'फरसाण कुरकुरीत, दूध सुरक्षित, लोणचे योग्य.',

      about_eyebrow: 'FreshFeed बद्दल', about_title: 'कमी नासाडी. शेतकऱ्याच्या खिशात जास्त पैसे.',
      about_p1: 'भारतात अनेक फळे आणि भाज्या काढणीनंतर खराब होतात — अनेकदा चुकीच्या पिशवीमुळे, श्वास घेण्याची गरज असताना बंद पॅकमुळे, किंवा थंडी न सोसणाऱ्या पिकाला थंड केल्यामुळे.',
      about_p2: 'FreshFeed अनेक दशकांचे संशोधन सोप्या, स्थानिक भाषेतील सल्ल्यात बदलते. प्रत्येक पिकाचा श्वसन दर, योग्य तापमान, आर्द्रता आणि वायूची गरज पाहून जवळ मिळणारा पॅक सुचवतो.',
      about_src_t: 'आमचे डेटा स्रोत', about_src: 'USDA कृषी हँडबुक 66 (2016), कॅंटवेल – UC डेव्हिस (2001), कादर (2002), साठवण तांत्रिक मॅन्युअल, आणि Poly Print व NatureWorks चा फिल्म डेटा.',
      v1_t: 'विज्ञान आधी', v1_d: 'प्रत्येक सल्ला प्रकाशित स्रोतावर आधारित.',
      v2_t: 'सर्वांसाठी सोपे', v2_d: 'मोठी बटणे, चित्रे, आवाज आणि तीन भाषा.',
      v3_t: 'पर्यावरण पर्याय प्रामाणिकपणे', v3_d: 'हरित पॅक दाखवतो — त्यांच्या मर्यादांसह.',
      v4_t: 'तुमचा डेटा तुमचाच', v4_d: 'तुमचे खाते आणि सल्ले फक्त तुमच्यासाठी.',

      faq_eyebrow: 'प्रश्न', faq_title: 'नेहमी विचारले जाणारे प्रश्न',
      q1: 'FreshFeed मोफत आहे का?', q1a: 'हो. सल्ला, स्पेक शीट आणि तज्ज्ञ मोड मोफत आहेत.',
      q2: 'खाते आवश्यक आहे का?', q2a: 'नाही — खात्याशिवायही ॲप वापरता येते. मोफत खात्याने तुमचे सल्ले प्रत्येक फोन आणि संगणकावर सेव्ह राहतात.',
      q3: 'सल्ला कुठून येतो?', q3a: 'USDA कृषी हँडबुक 66 आणि UC डेव्हिस सारख्या प्रकाशित संशोधनातून. किंमती अंदाजे आहेत — 2–3 स्थानिक पुरवठादारांशी तुलना करा.',
      q4: 'माझे पीक यादीत नाही?', q4a: 'खाली पिकाचे नाव लिहून संदेश पाठवा. आम्ही नवीन पिके जोडत असतो.',

      contact_eyebrow: 'संपर्क', contact_title: 'आमच्याशी बोला',
      contact_sub: 'पॅकिंगबद्दल प्रश्न, नवीन पीक, किंवा भागीदारी? आम्ही साधारण दोन कामकाजाच्या दिवसांत उत्तर देतो.',
      c_email: 'ईमेल', c_phone: 'फोन', c_wa: 'व्हॉट्सॲप', c_wa_v: 'आमच्याशी चॅट करा', c_addr: 'कार्यालय', c_hours: 'कामाची वेळ',
      cf_title: 'संदेश पाठवा', f_name: 'तुमचे नाव', f_email: 'ईमेल', f_phone: 'फोन', optional: '(ऐच्छिक)',
      f_topic: 'विषय', t_general: 'सामान्य प्रश्न', t_packaging: 'पॅकिंगसाठी मदत', t_partnership: 'भागीदारी',
      t_bug: 'समस्या कळवा', t_other: 'इतर',
      f_message: 'संदेश', f_msg_hint: 'किमान 10 अक्षरे.', cf_send: 'संदेश पाठवा', cf_sending: 'पाठवत आहे…',
      cf_ok: 'धन्यवाद! तुमचा संदेश पाठवला. आम्ही लवकरच उत्तर देऊ.',
      e_required: 'कृपया सर्व आवश्यक माहिती भरा.', e_email: 'कृपया योग्य ईमेल टाका.',
      e_phone: 'फोनमध्ये फक्त अंक, स्पेस, + आणि - (6–20 अक्षरे).',
      e_msg: 'संदेश किमान 10 अक्षरांचा हवा.',
      e_network: 'सर्व्हरशी संपर्क झाला नाही. इंटरनेट तपासा आणि पुन्हा प्रयत्न करा.',
      e_generic: 'काहीतरी चुकले. पुन्हा प्रयत्न करा.'
    }
  };

  var STORAGE_KEY = 'pm_lang';           // same key the FreshFeed app uses, so the choice carries over
  var LANGS = ['en', 'hi', 'mr'];

  function readSaved() {
    try {
      var v = localStorage.getItem(STORAGE_KEY);
      if (!v) return null;
      try { v = JSON.parse(v); } catch (e) { /* stored as a bare string */ }
      return LANGS.indexOf(v) > -1 ? v : null;
    } catch (e) { return null; }
  }

  var lang = readSaved() || 'en';

  function t(key) {
    return (T[lang] && T[lang][key]) || T.en[key] || key;
  }

  function applyLang() {
    document.documentElement.lang = lang;
    var nodes = document.querySelectorAll('[data-i18n]');
    for (var i = 0; i < nodes.length; i++) nodes[i].textContent = t(nodes[i].getAttribute('data-i18n'));
    var labels = document.querySelectorAll('[data-i18n-aria]');
    for (var j = 0; j < labels.length; j++) labels[j].setAttribute('aria-label', t(labels[j].getAttribute('data-i18n-aria')));
    var btns = document.querySelectorAll('.lang button[data-lang]');
    for (var k = 0; k < btns.length; k++) btns[k].setAttribute('aria-pressed', String(btns[k].getAttribute('data-lang') === lang));
    document.dispatchEvent(new CustomEvent('ff:lang', { detail: { lang: lang } }));
  }

  function setLang(l) {
    if (LANGS.indexOf(l) === -1) return;
    lang = l;
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(l)); } catch (e) { /* private mode: still works for this visit */ }
    applyLang();
  }

  document.addEventListener('click', function (e) {
    var b = e.target.closest && e.target.closest('.lang button[data-lang]');
    if (b) setLang(b.getAttribute('data-lang'));
  });

  window.FF = window.FF || {};
  window.FF.t = t;
  window.FF.getLang = function () { return lang; };
  window.FF.setLang = setLang;
  window.FF.applyLang = applyLang;
  window.FF.translations = T;
})();
