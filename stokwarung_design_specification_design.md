# Design Specification: StokWarung

## Design System: Pro-Micro Merchant

### Brand Identity
- **Name:** StokWarung
- **Visual Style:** Modern minimalist with a clean, professional SMB SaaS aesthetic.
- **Primary Color:** #28a745 (Green) - used for primary actions, success states, and brand accents.
- **Typography:** Plus Jakarta Sans.
- **Components:** Rounded corners (Round 8), soft shadows, and backdrop blur effects for navigation elements.

### Color Palette
- **Surface:** #f8f9ff
- **Primary:** #28a745
- **Secondary:** #6c757d (Neutral grays for secondary text)
- **Error:** #dc3545 (Red for "Hampir Habis" or "Belum Lunas" alerts)

---

## Screen List & Architecture

### 1. Dashboard (Main)
- **ID:** {{DATA:SCREEN:SCREEN_6}}
- **Role:** Central hub for inventory overview and daily performance.
- **Key Features:**
    - Daily Profit Card (Green, high contrast).
    - Customer Debt Summary Card (Rp 452.000, 8 customers).
    - Alerts: "Stok Hampir Habis" and "Barang Kadaluwarsa".
    - Inventory Search & List (Indomie, Beras Rojo Lele, Aqua).
    - Floating Action Button (FAB) for Barcode Scanning.

### 2. Kasir (POS)
- **ID:** {{DATA:SCREEN:SCREEN_9}}
- **Role:** Transaction entry and checkout.
- **Key Features:**
    - Product search and category filters (Minuman, Sembako, Rokok).
    - Shopping cart with quantity adjusters (+/-).
    - Payment method selection (Transfer, QRIS, Tunai).
    - Checkout button with total amount (Rp 100.000).

### 3. Laporan & Laba (Analytics)
- **ID:** {{DATA:SCREEN:SCREEN_14}}
- **Role:** Financial tracking and historical data.
- **Key Features:**
    - Daily Profit chart (Bar graph).
    - Debt summary card with "Lihat Detail" link.
    - Key metrics: Total Omzet, Transactions count, Low stock SKU, Outgoing capital.
    - Recent transactions feed with color-coded status (+/- amounts).

### 4. Buku Utang Pelanggan (Debt Ledger)
- **ID:** {{DATA:SCREEN:SCREEN_10}}
- **Role:** Managing customer credit.
- **Key Features:**
    - Global search for customer names.
    - Total Accounts Receivable header (Rp 452.000).
    - Customer cards showing debt amount and invoice count (e.g., Budi Warteg: Rp 150.000).
    - Status badges (Belum Lunas / Lunas).

### 5. Detail Stok Barang (Inventory Management)
- **ID:** {{DATA:SCREEN:SCREEN_4}}
- **Role:** CRUD for individual items.
- **Key Features:**
    - Product image upload/display.
    - Barcode/SKU input with scanner trigger.
    - Price management (Purchase price vs. Selling price).
    - Margin calculation & Percentage display.
    - Stock quantity and Expiry date tracking.

### 6. Profil Pengguna (Account)
- **ID:** {{DATA:SCREEN:SCREEN_11}}
- **Role:** User and Store management portal.
- **Key Features:**
    - User profile header with "PRO" badge.
    - Monthly transaction and Active customer statistics.
    - Navigation to Store Settings, Employee Management, and Payment Methods.
    - Logout button.

### 7. Pengaturan Toko (Store Settings)
- **ID:** {{DATA:SCREEN:SCREEN_8}}
- **Role:** Business identity configuration.
- **Key Features:**
    - Store logo upload (1:1 ratio).
    - Core info: Store Name, Phone, Address.
    - Operational hours (Open/Close times).
    - Status indicator (Buka/Tutup).

### 8. Kelola Karyawan (Staff Management)
- **ID:** {{DATA:SCREEN:SCREEN_13}}
- **Role:** Access control.
- **Key Features:**
    - List of staff members with roles (Admin, Kasir).
    - Status indicators (Aktif / Nonaktif).
    - FAB to add new employees.

### 9. Metode Pembayaran (Payment Settings)
- **ID:** {{DATA:SCREEN:SCREEN_2}}
- **Role:** Configuration of accepted payment channels.
- **Key Features:**
    - Toggles for Tunai, Bank Transfer, and QRIS.

### 10. Bantuan & Dukungan (Support)
- **ID:** {{DATA:SCREEN:SCREEN_12}}
- **Role:** User education and helpdesk.
- **Key Features:**
    - Help topic search.
    - Popular FAQs list.
    - Direct contact channels: WhatsApp, Email, Call Center.
    - Video tutorials and Digital manuals.

---

## Shared Components

### TopAppBar
- **Style:** Sticky top, bg-surface with shadow-sm.
- **Content:** Left (Menu/Back), Center (StokWarung Logo), Right (Search/Notifications).

### BottomNavBar
- **Style:** Fixed bottom, backdrop-blur-md.
- **Destinations:**
    1. Stok (Inventory)
    2. Kasir (POS)
    3. Laporan (Reports)
    4. Profil (Settings)

---

## Technical Implementation Notes (for Codex)
- Use **Tailwind CSS** for all styling.
- Ensure all screens are **Responsive Mobile-First**.
- Map ID references to specific DataStore assets for images.
- Maintain consistent spacing (padding/margins) as defined in the layout components.