## Purpose

Provides a cohesive, dark-mode developer console layout inspired by modern developer platforms like Linear, Raycast, and Vercel.

## ADDED Requirements

### Requirement: Application Layout Shell
The application SHALL provide a responsive, dark-mode first shell featuring top navigation, breadcrumbs, status indicators, and keyboard shortcut access.

#### Scenario: Navigating the developer console
- **WHEN** a user loads any view in the console
- **THEN** the application renders a persistent dark theme UI with standard navigation links (Playground, History, API Keys) and system status indicators.

### Requirement: ViewComponent Design Primitives
The application SHALL encapsulate UI components (badges, stat cards, metric pills, dialog wrappers) into reusable ViewComponent objects.

#### Scenario: Rendering metric and status components
- **WHEN** view components for status badges or metric cards receive parameters (e.g. latency, HTTP status)
- **THEN** they render consistent semantic HTML and Tailwind CSS utility classes without duplicating view markup.

### Requirement: Design System Tokens and Typography
The application SHALL apply a unified dark-mode design system defined via Tailwind CSS inline @theme tokens, Google Fonts, and custom scrollbar behavior.

#### Scenario: Applying theme color palette and typography
- **WHEN** any view or component renders in the application
- **THEN** it utilizes the standardized color tokens:
  - Surface & Background: `#09090b` (background), `#18181b` (surface), `#1c1c1f` (surface-2)
  - Borders: `#27272a` (border), `#1f1f22` (border-subtle)
  - Typography: `#fafafa` (text), `#a1a1aa` (text-muted), `#71717a` (text-dim)
  - Accents & Status: `#10b981` / `#064e3b` / `#022c22` (emerald), `#f59e0b` / `#1c1100` (amber), `#3b82f6` (accent)
  - Fonts: `Inter` for general UI text and `JetBrains Mono` for code, latency badges, and query parameters.

#### Scenario: Rendering customized thin scrollbars
- **WHEN** content overflows within scrollable containers marked with `.scroll-area`
- **THEN** it renders 4px thin scrollbars with `#3f3f46` thumb that smoothly reveal on hover.

