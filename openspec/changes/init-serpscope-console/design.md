## Context

See `proposal.md` for motivation. The project is created greenfield in the `/Users/gabriela.tomasini/Documents/Gabi/serp-lab` directory as a demonstration of Rails 8, Hotwire (Turbo 8 + Stimulus), Tailwind CSS, and ViewComponent. The architecture intentionally avoids heavy JavaScript SPA frameworks (React/Vue) in favor of semantic HTML, native browser capabilities (<dialog>, <details>), and server-driven Turbo Frame interactions.

## Goals / Non-Goals

**Goals:**
- Deliver a fast, responsive, dark-mode developer UI inspired by modern tooling (Linear, Raycast, Vercel).
- Use Turbo Frames to achieve instant updates for search execution and table filtering with zero full-page reloads.
- Encapsulate reusable UI elements into testable Ruby ViewComponents (`BadgeComponent`, `StatCardComponent`, `CodeViewerComponent`, `RequestRowComponent`).
- Employ lightweight Stimulus controllers for client-side behaviors: clipboard operations, tab toggles, and `<dialog>` lifecycle management.
- Provide simulated SERP responses (Google, Bing, DuckDuckGo) with realistic JSON schemas, organic rankings, knowledge graph snippets, and response latencies.

**Non-Goals:**
- Actual paid third-party SERP API calls (the console provides realistic built-in mocks and extensible engine adapters).
- User authentication, OAuth, or multi-tenant billing systems (focus is strictly developer console UI/UX, Hotwire reactivity, and ViewComponents).

## Decisions

### 1. Rails 8 + Tailwind CSS + Propshaft
- **Decision**: Initialize with Rails 8 standard asset pipeline (`propshaft`) and `tailwindcss-rails`.
- **Rationale**: Minimal setup, instant asset compilation, native modern CSS support without Webpack/Node overhead.
- **Alternatives considered**: Vite Ruby / esbuild (rejected to keep Rails 8 vanilla simplicity and reduce external node_modules bloat).

### 2. ViewComponent for UI Design System
- **Decision**: Install GitHub's `view_component` gem.
- **Rationale**: Keeps view logic encapsulated, highly testable in Ruby unit tests, avoids messy ERB helpers, and enforces design consistency across components.
- **Components**:
  - `Ui::BadgeComponent`: Handles HTTP status codes (200, 429, 500), engine badges, and country tags.
  - `Ui::StatCardComponent`: Displays top-level metrics (Average Latency, Total Calls, Success Rate).
  - `Ui::CodeViewerComponent`: Formats JSON payload with syntax color tokens in dark mode.
  - `Ui::RequestRowComponent`: Renders individual table rows in the request dashboard.

### 3. Hotwire Turbo Frames for API Playground & Filtering
- **Decision**: Wrap the results panel in `<turbo-frame id="playground_results">` and the request history in `<turbo-frame id="requests_table">`.
- **Rationale**: The search form submits directly to the Playground controller, which responds with a partial inside the same frame. Instantaneous feedback, automatic browser history handling if needed, zero React virtual DOM overhead.
- **Alternatives considered**: Turbo Streams or Stimulus `fetch()` (Turbo Frames provide simpler declarative HTML ergonomics for synchronous request/response replacements).

### 4. Native `<dialog>` + Stimulus Controller for Modals
- **Decision**: Implement the API Keys modal using standard HTML5 `<dialog data-controller="dialog">` and `this.element.showModal()`.
- **Rationale**: Native accessibility, focus trapping, backdrop styling (`::backdrop`), ESC key dismissal without bloated JS libraries.

### 5. Mock SERP Engine Service
- **Decision**: Build `SerpSimulatorService` that generates realistic SERP payloads (organic results, featured snippets, knowledge graph, query metrics, latency simulation between 80ms and 350ms).
- **Rationale**: Allows immediate offline and portfolio-ready testing with diverse payloads, search engines, and simulated error states (200 OK vs 429 Rate Limit).

## Risks / Trade-offs

- **[Risk] Styling native `<dialog>` across browsers** → *Mitigation*: Use Tailwind utility classes for dialog container and explicit `backdrop:bg-black/60 backdrop:backdrop-blur-sm`.
- **[Risk] JSON syntax highlighting without large JS libraries** → *Mitigation*: Format JSON server-side with structured color tokens or use a lightweight 2KB CSS/JS snippet in `CodeViewerComponent`.
- **[Risk] SQLite concurrency in dev** → *Mitigation*: Rails 8 enables SQLite WAL mode by default, supporting fast concurrent reads and writes for request logs.
