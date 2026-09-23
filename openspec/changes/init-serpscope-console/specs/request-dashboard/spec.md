## Purpose

Provides a high-density, real-time observability log of recent API requests with execution metrics, engine details, and filterable status categories.

## ADDED Requirements

### Requirement: Tabular History Display
The system SHALL present a data-dense table showing past API requests including status code badge, latency in milliseconds, timestamp, engine name, and query string.

#### Scenario: Viewing request history
- **WHEN** a user visits the requests dashboard
- **THEN** a table renders the historical log records with color-coded status badges and formatted latency numbers.

### Requirement: Turbo Frame Status Filtering
The system SHALL support instant filtering of requests by HTTP status (All, 200 OK, 429 Rate Limited) via a dedicated Turbo Frame.

#### Scenario: Filtering by status code
- **WHEN** the user clicks on a status filter button (e.g., "429 Error")
- **THEN** the request table updates asynchronously inside the Turbo Frame showing only matching records without full page navigation.
