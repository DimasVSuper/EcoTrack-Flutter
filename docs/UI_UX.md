Step 1: Analyze Requirements
Product type: Personal Carbon Footprint Monitoring System (SDG 13)

Style keywords: clean, modern, eco-friendly, eco-green, data-driven

Industry: Environment / Green Technology / Mobile App

Stack: flutter-laravel (API-driven)

Step 2: Generate Design System (REQUIRED)
Bash
python .github/prompts/ui-ux-pro-max/scripts/search.py "carbon footprint tracker eco green data-driven modern" --design-system -p "EcoTrack"
Output: Sistem desain lengkap untuk EcoTrack. Menggunakan palet warna alam (emerald/mint green mewakili status ramah lingkungan, charcoal untuk teks kontras tinggi, dan soft gray/white untuk latar belakang). Tipografi menggunakan sans-serif bersih (seperti Inter atau Roboto). Efek elevasi kartu (cards) dibuat halus untuk menampilkan data log, serta panduan anti-pattern (menghindari warna merah dominan kecuali untuk indikator emisi kritis).

Step 3: Supplement with Detailed Searches (As Needed)
Bash
# Ambil panduan UX untuk visualisasi grafik data emisi yang interaktif
python .github/prompts/ui-ux-pro-max/scripts/search.py "data visualization chart micro-interaction" --domain chart

# Ambil referensi komponen UI form input & dropdown yang bersih untuk mobile (input kWh & KM)
python .github/prompts/ui-ux-pro-max/scripts/search.py "clean mobile form input fields dropdown" --domain ux

Step 4: Stack Guidelines
Bash
# Panduan arsitektur layout responsif form & komponen UI khusus di Flutter
python .github/prompts/ui-ux-pro-max/scripts/search.py "layout responsive form design" --stack flutter







## Design System EcoTrack

+-----------------------------------------------------------------------------------------+
|  TARGET: EcoTrack - RECOMMENDED DESIGN SYSTEM                                           |
+-----------------------------------------------------------------------------------------+
|                                                                                          |
|  PATTERN: Horizontal Scroll Journey                                                     |
|     Conversion: Immersive product discovery. High engagement. Keep navigation visible.
28,Bento Grid Showcase,bento,  grid,  features,  modular,  apple-style,  showcase", 1. Hero, 2. Bento Grid (Key Features), 3. Detail Cards, 4. Tech Specs, 5. CTA, Floating Action Button or Bottom of Grid, Card backgrounds: #F5F5F7 or Glass. Icons: Vibrant brand colors. Text: Dark., Hover card scale (1.02), video inside cards, tilt effect, staggered reveal, Scannable value props. High information density without clutter. Mobile stack.
29,Interactive 3D Configurator,3d,  configurator,  customizer,  interactive,  product", 1. Hero (Configurator), 2. Feature Highlight (synced), 3. Price/Specs, 4. Purchase, Inside Configurator UI + Sticky Bottom Bar, Neutral studio background. Product: Realistic materials. UI: Minimal overlay., Real-time rendering, material swap animation, camera rotate/zoom, light reflection, Increases ownership feeling. 360 view reduces return rates. Direct add-to-cart.
30,AI-Driven Dynamic Landing,ai,  dynamic,  personalized,  adaptive,  generative", 1. Prompt/Input Hero, 2. Generated Result Preview, 3. How it Works, 4. Value Prop, Input Field (Hero) + 'Try it' Buttons, Adaptive to user input. Dark mode for compute feel. Neon accents., Typing text effects, shimmering generation loaders, morphing layouts, Immediate value demonstration. 'Show, don't tell'. Low friction start.|
|     CTA: Floating Sticky CTA or End of Horizontal Track                                 |
|     Sections:                                                                           |
|       1. 1. Intro (Vertical), 2. The Journey (Horizontal Track), 3. Detail Reveal, 4. Vertical Footer|
|                                                                                          |
|  STYLE: Vibrant & Block-based                                                           |
|     Keywords: Bold, energetic, playful, block layout, geometric shapes, high color      |
|     contrast, duotone, modern, energetic                                                |
|     Best For: Startups, creative agencies, gaming, social media, youth-focused,         |
|     entertainment, consumer                                                             |
|     Performance: ⚡ Good | Accessibility: ◐ Ensure WCAG                                  |
|                                                                                          |
|  COLORS:                                                                                |
|     Primary:    #0891B2                                                                 |
|     Secondary:  #22D3EE                                                                 |
|     CTA:        #22C55E                                                                 |
|     Background: #ECFEFF                                                                 |
|     Text:       #164E63                                                                 |
|     Notes: Electric cyan + eco green                                                    |
|                                                                                          |
|  TYPOGRAPHY: Fira Code / Fira Sans                                                      |
|     Mood: dashboard, data, analytics, code, technical, precise                          |
|     Best For: Dashboards, analytics, data visualization, admin panels                   |
|     Google Fonts: https://fonts.google.com/share?selection.family=Fira+Code:wght@400;500;600;700|Fira+Sans:wght@300;400;500;600;700|
|     CSS Import: @import url('https://fonts.googleapis.com/css2?family=Fira+Code:wght@4...|
|                                                                                          |
|  KEY EFFECTS:                                                                           |
|     Large sections (48px+ gaps), animated patterns, bold hover (color shift),           |
|     scroll-snap, large type (32px+), 200-300ms                                          |
|                                                                                          |
|  AVOID (Anti-patterns):                                                                 |
|     Flat design without depth + Text-heavy pages                                        |
|                                                                                          |
|  PRE-DELIVERY CHECKLIST:                                                                |
|     [ ] No emojis as icons (use SVG: Heroicons/Lucide)                                  |
|     [ ] cursor-pointer on all clickable elements                                        |
|     [ ] Hover states with smooth transitions (150-300ms)                                |
|     [ ] Light mode: text contrast 4.5:1 minimum                                         |
|     [ ] Focus states visible for keyboard nav                                           |
|     [ ] prefers-reduced-motion respected                                                |
|     [ ] Responsive: 375px, 768px, 1024px, 1440px                                        |
|                                                                                          |
+-----------------------------------------------------------------------------------------+


## Panduan UX untuk Visualisasi Grafik data Emisi yang Interaktif

## UI Pro Max Search Results
**Domain:** ux | **Query:** data visualization chart micro-interaction
**Source:** ux-guidelines.csv | **Found:** 3 results

### Result 1
- **Category:** Data Entry
- **Issue:** Bulk Actions
- **Platform:** Web
- **Description:** Editing one by one is tedious
- **Do:** Allow multi-select and bulk edit
- **Don't:** Single row actions only
- **Code Example Good:** Checkbox column + Action bar
- **Code Example Bad:** Repeated actions per row
- **Severity:** Low

### Result 2
- **Category:** Sustainability
- **Issue:** Auto-Play Video
- **Platform:** Web
- **Description:** Video consumes massive data and energy
- **Do:** Click-to-play or pause when off-screen
- **Don't:** Auto-play high-res video loops
- **Code Example Good:** playsInline muted preload='none'
- **Code Example Bad:** autoplay loop
- **Severity:** Medium

### Result 3
- **Category:** Interaction
- **Issue:** Hover States
- **Platform:** Web
- **Description:** Visual feedback on interactive elements
- **Do:** Change cursor and add subtle visual change
- **Don't:** No hover feedback on clickable elements
- **Code Example Good:** hover:bg-gray-100 cursor-pointer
- **Code Example Bad:** No hover style
- **Severity:** Medium

# Ambil referensi komponen UI form input & dropdown yang bersih untuk mobile (input kWh & KM)
## UI Pro Max Search Results
**Domain:** ux | **Query:** clean mobile form input fields dropdown
**Source:** ux-guidelines.csv | **Found:** 3 results

### Result 1
- **Category:** Forms
- **Issue:** Mobile Keyboards
- **Platform:** Mobile
- **Description:** Show appropriate keyboard for input type
- **Do:** Use inputmode attribute
- **Don't:** Default keyboard for all inputs
- **Code Example Good:** inputmode='numeric'
- **Code Example Bad:** Text keyboard for numbers
- **Severity:** Medium

### Result 2
- **Category:** Forms
- **Issue:** Input Types
- **Platform:** All
- **Description:** Use appropriate input types
- **Do:** Use email tel number url etc
- **Don't:** Text input for everything
- **Code Example Good:** type='email'
- **Code Example Bad:** type='text' for email
- **Severity:** Medium

### Result 3
- **Category:** Forms
- **Issue:** Input Labels
- **Platform:** All
- **Description:** Every input needs a visible label
- **Do:** Always show label above or beside input
- **Don't:** Placeholder as only label
- **Code Example Good:** <label>Email</label><input>
- **Code Example Bad:** placeholder='Email' only
- **Severity:** High

# Panduan arsitektur layout responsif form & komponen UI khusus di Flutter

## UI Pro Max Stack Guidelines
**Stack:** flutter | **Query:** layout responsive form design
**Source:** stacks/flutter.csv | **Found:** 3 results

### Result 1
- **Category:** Layout
- **Guideline:** Use LayoutBuilder for responsive
- **Description:** Respond to constraints
- **Do:** LayoutBuilder for adaptive layouts
- **Don't:** Fixed sizes for responsive
- **Code Good:** LayoutBuilder(builder: (context constraints) {})
- **Code Bad:** Container(width: 375)
- **Severity:** Medium
- **Docs URL:** https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html

### Result 2
- **Category:** Forms
- **Guideline:** Use Form widget
- **Description:** Form validation
- **Do:** Form with GlobalKey
- **Don't:** Individual validation
- **Code Good:** Form(key: _formKey child: ...)
- **Code Bad:** TextField without Form
- **Severity:** Medium
- **Docs URL:** https://api.flutter.dev/flutter/widgets/Form-class.html

### Result 3
- **Category:** Forms
- **Guideline:** Validate on submit
- **Description:** Form validation flow
- **Do:** _formKey.currentState!.validate()
- **Don't:** Skip validation
- **Code Good:** if (_formKey.currentState!.validate())
- **Code Bad:** Submit without validation
- **Severity:** High
- **Docs URL:** 
