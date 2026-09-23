# SERP Lab — Developer Console & Search API Playground

<div align="center">

![Ruby](https://img.shields.io/badge/Ruby-3.3+-CC342D?style=flat-square&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-8.1-D30001?style=flat-square&logo=rubyonrails&logoColor=white)
![Hotwire](https://img.shields.io/badge/Hotwire-Turbo_8_%2B_Stimulus-FF5722?style=flat-square)
![ViewComponent](https://img.shields.io/badge/ViewComponent-GitHub-2088FF?style=flat-square)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-v4-38B2AC?style=flat-square&logo=tailwind-css&logoColor=white)
![Render](https://img.shields.io/badge/Deployed-Render-46E3B7?style=flat-square&logo=render&logoColor=white)

**A high-performance developer console and interactive search engine API playground built with Ruby on Rails 8, Hotwire (Turbo 8 + Stimulus), GitHub ViewComponent, and Tailwind CSS.**

[Live Playground](https://serp-lab.onrender.com/playground) • [Request Log](https://serp-lab.onrender.com/requests) • [Repository](https://github.com/gabitomasini/serp-lab)

</div>

---

## 📌 Overview

**SERP Lab** is an end-to-end personal project designed to showcase mastery of modern, server-driven web architecture. Inspired by the dense, keyboard-friendly developer experiences of tools like **Linear**, **Vercel**, and **Raycast**, it delivers an interactive API console for querying, inspecting, and benchmarking Search Engine Results Pages (SERP) without relying on heavy client-side Single Page Application (SPA) frameworks.

By leveraging **Hotwire (Turbo 8 + Stimulus)** and **GitHub ViewComponent**, SERP Lab achieves sub-second reactive updates, seamless async frame replacements, and modular UI encapsulation with **zero virtual DOM overhead** and **zero node_modules asset build chains**.

---

## 🚀 Key Features

### 1. Interactive SERP Playground (`/playground`)
- **Multi-Engine Support**: Query across Google, Google Shopping, YouTube, Bing, DuckDuckGo, and Baidu.
- **Geotargeting Parameters**: Filter search results by target region (`us`, `br`, `gb`, `de`, `fr`, `jp`, `ca`).
- **Asynchronous Turbo Frame Replacement**: Submitting a query updates the `#playground_results` frame instantaneously without full-page reloads.
- **Dual Results Presentation**:
  - **Visual Preview**: Rich search engine results with organic snippets, sitelinks, knowledge graph cards, and pricing/video metadata.
  - **Raw JSON Inspector**: Prettified, syntax-colored JSON payload with 1-click clipboard copying (`data-controller="clipboard"`).
- **Error Simulation**: Toggle simulated `429 Too Many Requests` responses to test client error handling, rate limiting alerts, and retry telemetry.

### 2. Live & Simulated Search Engine Engine
- **Hybrid API Service (`SearchApiService` & `SerpSimulatorService`)**:
  - If a `SEARCHAPI_API_KEY` environment variable is configured, requests stream real-time data from SearchApi.io.
  - If unconfigured or offline, an intelligent built-in simulator dynamically synthesizes realistic organic results, Knowledge Graph panels, sitelinks, and monotonic-clock latency simulations (95ms – 280ms).

### 3. Request Telemetry & Audit Log (`/requests`)
- **Real-Time Request History**: Persists every executed search query with method, endpoint, HTTP status code (`200 OK`, `429 Rate Limited`), latency in milliseconds, engine, and timestamp.
- **Turbo Frame Filtering**: Instant tab filtering (`All`, `200 OK`, `429 Rate Limited`) driven by `<turbo-frame id="requests_table">`.
- **Top-Level Telemetry Cards**: Encapsulated ViewComponents displaying average response latency, total queries executed, and overall success rate.

### 4. Native Web Standards & Modern UX
- **Native HTML5 `<dialog>` for API Keys**: Ergonomic modal with backdrop blur, focus trapping, and ESC-key dismissal managed cleanly with a lightweight Stimulus controller (`dialog_controller.js`).
- **Native HTML5 `<details>` for Menus**: Zero-JS user dropdown menu and profile settings.
- **Dark Mode Native Theme**: Handcrafted palette (`#09090b`, `#18181b`, `#27272a`) paired with JetBrains Mono for code blocks and Inter for typography.

---

## 🏗️ Architecture & Technical Decisions

```
serp-lab/
├── app/
│   ├── components/
│   │   └── ui/                     # GitHub ViewComponents (Encapsulated UI tokens)
│   │       ├── badge_component.*         # Status codes (200, 429), engines, countries
│   │       ├── code_viewer_component.*   # Dark-mode JSON payload viewer with copy action
│   │       ├── request_row_component.*   # Data-dense request log table row
│   │       └── stat_card_component.*     # Telemetry metric cards (Latency, Volume, Rates)
│   ├── controllers/
│   │   ├── playground_controller.rb      # Search execution & Turbo Frame responses
│   │   └── requests_controller.rb        # History filtering & telemetry aggregation
│   ├── javascript/
│   │   └── controllers/            # Modest Stimulus controllers
│   │       ├── clipboard_controller.js   # 1-click copy with tooltip feedback
│   │       ├── dialog_controller.js      # Native HTML5 <dialog> showModal / click-outside
│   │       ├── request_builder_controller.js # Preset query pills & parameter binding
│   │       └── tabs_controller.js        # Visual vs Raw JSON toggle
│   ├── models/
│   │   └── api_request.rb                # Active Record model with latency & scopes
│   ├── services/
│   │   ├── search_api_service.rb         # Live SearchApi.io integration with fallback
│   │   └── serp_simulator_service.rb     # Offline simulated SERP generator
│   └── views/
│       ├── layouts/application.html.erb  # Developer shell, header, and <dialog> modals
│       ├── playground/                   # Search console & results partials
│       └── requests/                     # Query audit table & metrics dashboard
```

### Why Rails 8 + Hotwire over SPA (React/Vue)?
1. **Server-Driven Reactivity**: Instead of duplicating state management in Redux or Zustand, Rails renders server-side HTML partials swapped directly into the DOM via Turbo Frames.
2. **Minimal JavaScript Footprint**: Client-side JavaScript is restricted to lightweight, declarative Stimulus controllers (clipboard copy, tabs, dialogs) amounting to less than 10KB of JS.
3. **Propshaft Asset Pipeline**: Zero Node.js build dependencies, zero Webpack/Vite compilation overhead, and native ES modules via importmaps.
4. **ViewComponent Isolation**: Views are isolated into testable Ruby objects (`ViewComponent`), ensuring reusable design tokens and strict separation of presentation logic from ERB templates.

---

## 🛠️ Tech Stack

| Layer | Technology | Rationale |
|---|---|---|
| **Backend Framework** | **Ruby on Rails 8.1** | Latest Rails release utilizing modern defaults (Propshaft, Solid Cache/Queue). |
| **Frontend Architecture** | **Hotwire (Turbo 8 + Stimulus)** | Fast, reactive, server-driven UI with declarative HTML frames and minimal JS. |
| **Component System** | **GitHub ViewComponent** | Encapsulated, testable Ruby view objects for consistent design system tokens. |
| **Styling** | **Tailwind CSS (tailwindcss-rails)** | Utility-first, dense developer UI styling with zero external CSS build overhead. |
| **Asset Pipeline** | **Propshaft & Importmap Rails** | Modern browser ESM import maps without Node/npm runtime dependencies. |
| **Database** | **SQLite 3 (WAL Mode)** | Production-ready SQLite concurrency with fast read/write throughput for logs. |
| **Deployment** | **Docker + Render** | Containerized Rails production deployment with SSL and health checks. |

---

## 💻 Getting Started Locally

### Prerequisites
- **Ruby**: `3.3+` (or `4.0+`)
- **SQLite3**: `sqlite3 >= 2.1`
- **Bundler**: `gem install bundler`

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/gabitomasini/serp-lab.git
   cd serp-lab
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Setup Database**:
   ```bash
   bin/rails db:prepare
   ```

4. **Start Development Server**:
   ```bash
   bin/dev
   ```
   *(Or run standard Rails server with `bin/rails server -p 3000`)*

5. **Open in browser**:
   Visit [http://localhost:3000](http://localhost:3000) or [http://localhost:3000/playground](http://localhost:3000/playground).

---

## ⚙️ Environment Variables (Optional)

Create a `.env` file in the root directory if you want live SearchApi.io integration:

```env
# Optional: Live search engine queries. If omitted, SERP Lab runs on the built-in simulator.
SEARCHAPI_API_KEY=your_searchapi_io_key_here
```

---

## 🧪 Production Deployment

The project is preconfigured with:
- **`Dockerfile`**: Multi-stage production build using jemalloc, bootsnap pre-compilation, and asset pre-compilation.
- **Render Deployment**: Automatically builds and serves via Puma with Thruster asset acceleration.

---

## 👤 Author

**Gabriela Tomasini**
- Portfolio: [abrielatomasini.dev/](https://gabrielatomasini.dev/)
- LinkedIn: [linkedin.com/in/gabriela-tomasini-88276553](https://www.linkedin.com/in/gabriela-tomasini-88276553/)
- GitHub: [@gabitomasini](https://github.com/gabitomasini)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
