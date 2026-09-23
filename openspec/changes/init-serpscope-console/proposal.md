## Why

Demonstrate high-level mastery of modern full-stack Ruby on Rails 8 architecture without relying on client-side SPA frameworks like React. The goal is to build "SerpScope", a production-grade, developer tool / API console (inspired by Linear, Vercel, and Raycast) showcasing Hotwire (Turbo 8 + Stimulus), Tailwind CSS, ViewComponent encapsulation, and native web standards (<dialog>, <details>).

## What Changes

- Scaffold a greenfield Rails 8 web application configured with Propshaft, Tailwind CSS, Turbo 8, Stimulus, and `view_component`.
- Implement a sleek, dark-mode developer console layout with keyboard shortcuts and dense data presentation.
- Create an interactive **API Playground** allowing developers to simulate SERP queries (Google, Bing, DuckDuckGo, Baidu) with async updates via `#playground_results` Turbo Frame, formatted JSON view, and visual preview.
- Build a Stimulus controller for clipboard copying, tab switching, and code interaction.
- Create a data-dense **Request Dashboard** tracking query history, latency metrics in milliseconds, HTTP response status badges, and instant status filtering via Turbo Frame.
- Implement an **API Keys Modal** utilizing HTML5 native `<dialog>` driven by an ergonomic Stimulus controller (`dialog_controller.js`).
- Encapsulate UI elements into reusable, tested `ViewComponent` objects (BadgeComponent, StatCardComponent, CodeViewerComponent, RequestRowComponent).

## Capabilities

### New Capabilities
- `developer-console-ui`: Core application shell, layout, dark-mode theme, navigation, and ViewComponent design system.
- `api-playground`: Interactive search API query runner with Turbo Frame-based asynchronous updates, payload formatting, copy-to-clipboard, and raw/visual tabs.
- `request-dashboard`: Data-dense query log table with latency tracking, status filtering, and live Turbo Frame interactions.
- `api-keys-modal`: Secure API key preview and generation dialog powered by native HTML `<dialog>` and Stimulus.

### Modified Capabilities

*(None - greenfield project)*

## Impact

- **New Dependencies**: Ruby on Rails 8.0+, `tailwindcss-rails`, `view_component`, `sqlite3` (or solid_cache/solid_queue/solid_cable default stack in Rails 8).
- **Architecture**: Server-driven UI (Hotwire) with zero SPA overhead; native web primitives for modals and collapsible panels.
- **Portability**: Production-ready containerized or Kamal-ready Rails 8 project structure.
