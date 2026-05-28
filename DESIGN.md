---
name: Pro-Micro Merchant
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#3e4a3c'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#6e7b6b'
  outline-variant: '#bdcab9'
  surface-tint: '#006e25'
  primary: '#006e25'
  on-primary: '#ffffff'
  primary-container: '#28a745'
  on-primary-container: '#00330d'
  inverse-primary: '#66df75'
  secondary: '#5f5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e5e2e1'
  on-secondary-container: '#656464'
  tertiary: '#55615a'
  on-tertiary: '#ffffff'
  tertiary-container: '#88958d'
  on-tertiary-container: '#222d28'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#83fc8e'
  primary-fixed-dim: '#66df75'
  on-primary-fixed: '#002106'
  on-primary-fixed-variant: '#00531a'
  secondary-fixed: '#e5e2e1'
  secondary-fixed-dim: '#c8c6c5'
  on-secondary-fixed: '#1c1b1b'
  on-secondary-fixed-variant: '#474646'
  tertiary-fixed: '#d9e6dd'
  tertiary-fixed-dim: '#bdcac1'
  on-tertiary-fixed: '#131e19'
  on-tertiary-fixed-variant: '#3e4943'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  container-margin: 16px
  gutter: 12px
  card-padding: 20px
  section-gap: 24px
---

## Brand & Style

The brand personality is **dependable, refreshing, and efficient**. It is designed specifically for small business owners who require high utility without the steep learning curve of enterprise software. 

The design style follows **Modern Minimalism** with a focus on high legibility and physical comfort. By utilizing generous whitespace and a "Mobile-First" card-based architecture, the UI reduces cognitive load, allowing users to manage stock and finances quickly between customer interactions. The visual mood is professional yet approachable, using a vibrant "Growth Green" to signify prosperity and health for the user's business.

## Colors

The palette is anchored by a **Vibrant Green**, sampled from the core brand identity, representing fresh inventory and financial growth. 

- **Primary**: Used for key actions, progress indicators, and brand touchpoints.
- **Surface & Background**: A soft off-white (#FAFAFA) is used for the main background to reduce eye strain, while pure white (#FFFFFF) is reserved for elevated cards.
- **Success/Warning/Error**: Standard utility colors are slightly desaturated to maintain the professional minimalist aesthetic.
- **Typography**: A deep charcoal (#1E293B) is used for high-contrast readability, avoiding pure black to keep the interface feeling modern and soft.

## Typography

This design system utilizes **Plus Jakarta Sans** for its friendly, open counters and modern geometric structure. It provides a perfect balance between a clean "tech" look and the warmth required for a local business tool.

- **Headlines**: Use heavy weights (600-700) to create a clear information hierarchy.
- **Body Text**: Maintain 16px for primary information to ensure accessibility for all age groups.
- **Labels**: Small caps are used sparingly for category headers (e.g., "FITUR UTAMA") to provide structure without cluttering the view.

## Layout & Spacing

The layout employs a **Fluid Grid** system based on an 8px rhythm. On mobile devices, a 4-column grid with 16px side margins is standard.

- **Stacking**: Vertical spacing between cards should be consistent (16px or 24px) to suggest a clear logical flow of data.
- **Safe Areas**: Ensure all interactive elements are at least 44px in height/width to accommodate touch input in busy environments.
- **Responsive Reflow**: On tablets, the layout transitions to a 12-column grid, allowing inventory lists to sit side-by-side with detail panels.

## Elevation & Depth

Hierarchy is established through **Ambient Shadows** and **Tonal Layering**. 

- **Level 0 (Background)**: The base surface (#FAFAFA).
- **Level 1 (Cards)**: White surfaces with a soft, highly diffused shadow (Offset: 0px 4px, Blur: 12px, Opacity: 4% Black). 
- **Level 2 (Active/Floating)**: Used for the Floating Action Button and Bottom Navigation. These use a more pronounced shadow (Offset: 0px 8px, Blur: 20px, Opacity: 8% Black) to indicate they sit above the content.
- **Accents**: Minimal use of primary-colored borders (2px) on the left side of cards can be used to highlight specific status changes or "Potensi" sections.

## Shapes

The design system uses **Rounded** geometry (Level 2) to evoke friendliness and safety. 

- **Cards**: Use 16px (1rem) corner radius for a soft, modern container look.
- **Buttons & Inputs**: Use 12px (0.75rem) to maintain a cohesive language with the cards while appearing slightly more "contained."
- **FAB**: A fully circular/pill shape is used to distinguish the primary action from static content containers.

## Components

### Bottom Navigation
A fixed persistent bar at the base of the screen. Icons should be "Outline" style when inactive and "Solid + Primary Color" when active. Use a backdrop-blur (10px) on a semi-transparent white background to maintain a sense of depth.

### Floating Action Button (FAB)
The FAB is the "Add Item" or "New Transaction" shortcut. It must be the Primary Green with a white icon. Position it at the bottom right, 16px away from the screen edge and navigation bar.

### Inventory Cards
Cards should contain a title (Headline-MD), a sub-label for quantity/price, and a subtle status chip. If an item is low on stock, the status chip background should change to a soft peach/red, but the card remains white.

### Input Fields
Inputs should feature a subtle 1px border (#E2E8F0) that turns Primary Green on focus. Labels should always be visible (never placeholder-only) to assist users during high-speed data entry.

### Chips/Tags
Used for categories like "SaaS" or "Mikro." These should have a very light grey background with medium-grey text to remain secondary to the main card content.