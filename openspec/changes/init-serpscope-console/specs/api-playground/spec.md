## Purpose

Enables developers to test live or simulated search engine queries with real-time response rendering, raw JSON viewing, and interactive clipboard tools.

## ADDED Requirements

### Requirement: Interactive Search Form with Turbo Frame
The system SHALL provide an interactive search form with inputs for Query, Engine, and Country that submits asynchronously targeting a Turbo Frame.

#### Scenario: Submitting search query
- **WHEN** the user inputs a query (e.g., "ruby on rails 8"), selects an engine and country, and clicks "Execute Request"
- **THEN** the form submits via Turbo and replaces only the `#playground_results` Turbo Frame content without reloading the whole page.

### Requirement: Formatted JSON and Visual Preview Switcher
The system SHALL present response payloads with options for formatted syntax view and rendered card view using native HTML elements and Stimulus.

#### Scenario: Switching tabs between JSON and visual preview
- **WHEN** the user toggles between "JSON Raw" and "Visual Preview"
- **THEN** the active tab updates instantaneously without network roundtrips.

### Requirement: Copy Response Payload
The system SHALL provide a one-click copy button that copies the JSON response payload to the developer's clipboard.

#### Scenario: Copying JSON payload
- **WHEN** the user clicks the "Copy JSON" button
- **THEN** the Stimulus controller writes the raw JSON string to navigator.clipboard and provides brief visual feedback (e.g., "Copied!").
