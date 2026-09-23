## 1. Project Initialization & Dependencies

- [x] 1.1 Initialize Rails 8 application with Tailwind CSS and Propshaft in the current directory and verify `bin/rails --version` and `Gemfile` are configured.
- [x] 1.2 Add `view_component` gem to `Gemfile`, run `bundle install`, and verify component autoloading configuration.
- [x] 1.3 Configure Tailwind CSS dark mode palette (slate/zinc darks, emerald/violet accents, monospace metrics) in `config/tailwind.config.js` and `app/assets/stylesheets/application.tailwind.css`.

## 2. Models & SERP Simulation Engine

- [x] 2.1 Generate `ApiRequest` model and database migration (fields: `query`, `engine`, `country`, `status_code`, `latency_ms`, `response_payload`) and verify migration executes via `bin/rails db:migrate`.
- [x] 2.2 Create `SerpSimulatorService` to generate realistic mock SERP data (organic results, knowledge graph, timing) and simulate realistic latencies (80ms - 320ms) and status codes (200, 429).
- [x] 2.3 Add seed data in `db/seeds.rb` with realistic past queries across engines (Google, Bing, DuckDuckGo) and verify records populate via `bin/rails db:seed`.

## 3. ViewComponent Design System

- [x] 3.1 Implement `Ui::BadgeComponent` with semantic variants for HTTP status codes (200 OK, 429 Rate Limit, 500 Error) and search engines.
- [x] 3.2 Implement `Ui::StatCardComponent` to display aggregate metrics (Average Latency, Total Requests, Success Rate).
- [x] 3.3 Implement `Ui::CodeViewerComponent` rendering syntax-styled JSON with line numbers and dark-mode tokens.
- [x] 3.4 Implement `Ui::RequestRowComponent` rendering dense, accessible table rows for historical query logs.

## 4. Hotwire Stimulus Controllers

- [x] 4.1 Implement `clipboard_controller.js` to copy target content to `navigator.clipboard` with transient visual feedback.
- [x] 4.2 Implement `tabs_controller.js` to switch visibility between "JSON Raw" and "Visual Preview" panels without page reloads.
- [x] 4.3 Implement `dialog_controller.js` managing HTML5 native `<dialog>` opening (`showModal()`), closing, and backdrop click dismissals.

## 5. API Playground Feature (Turbo Frame)

- [x] 5.1 Implement `PlaygroundController` with `index` and `create` actions returning responses targeting `<turbo-frame id="playground_results">`.
- [x] 5.2 Build playground query form with inputs for Query, Engine, and Country, submitting asynchronously to the Turbo Frame.
- [x] 5.3 Build playground response panel with raw JSON viewer, visual search results cards, and copy payload action.

## 6. Request Dashboard Feature (Filtering & Hotwire)

- [x] 6.1 Implement `RequestsController#index` with query status filters (`all`, `200`, `429`) rendered inside `<turbo-frame id="requests_table">`.
- [x] 6.2 Build high-density request history table and filter button pills with instant Turbo Frame updates.

## 7. Developer Console Layout, API Keys Modal & Polish

- [x] 7.1 Assemble `application.html.erb` with dark developer console shell, navigation headers, active status indicator, and keyboard shortcut hints.
- [x] 7.2 Implement the API Keys modal using native `<dialog>` and `dialog_controller.js` with simulated key generation and copy-to-clipboard.
- [x] 7.3 Verify end-to-end user workflows in the browser (Playground query execution, tab switching, JSON copy, status filtering, and modal interaction).
