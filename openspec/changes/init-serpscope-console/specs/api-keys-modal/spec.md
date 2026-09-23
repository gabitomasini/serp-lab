## Purpose

Allows developers to view, inspect, and manage simulated API keys using native browser modal primitives.

## ADDED Requirements

### Requirement: Native Dialog Modal
The system SHALL use the HTML5 `<dialog>` element to render an API key inspection modal, controlled via Stimulus.

#### Scenario: Opening and closing the API key modal
- **WHEN** the user clicks "API Keys" in the navigation or trigger button
- **THEN** the Stimulus controller calls `this.element.showModal()` to display the native dialog, and allows closing via backdrop click or ESC key.

### Requirement: Secret Key Masking and Copy
The system SHALL display API tokens with masking toggles and one-click copy capability.

#### Scenario: Revealing and copying key
- **WHEN** the user toggles the reveal button or copies the API key
- **THEN** the token is either shown unmasked or copied to clipboard with visual confirmation.
