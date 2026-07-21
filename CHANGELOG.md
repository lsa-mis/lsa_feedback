# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.1] - 2026-07-21

### Fixed
- **Duplicate floating trigger button**: the modal partial rendered two
  `#lsa-tdx-feedback-trigger` buttons (an i18n button outside the `trigger:`
  guard, plus the old hardcoded button inside it). The JS click handler bound
  only to the first; the second sat on top and swallowed clicks, so the modal
  never opened and produced no console or server errors. Also meant
  `trigger: false` still left a button on the page. There is now a single
  i18n button inside the `trigger:` guard.

## [2.0.0] - 2026-07-20

### Fixed
- **`NameError` on controllers that don't define `current_user`**: `set_lsa_tdx_feedback_data`
  referenced `current_user` unconditionally inside a debug log line, so it raised on any
  controller without that method — ViewComponent's preview controller,
  `Rails::HealthController`, ActiveStorage's controllers, and so on. Because the extension is
  mixed into `ActionController::Base` via `on_load :action_controller`, this broke those
  requests in every host application.
  - Removed the leftover per-request debug logging, which also drops six `Rails.logger.info`
    calls emitted on every request of every controller.
  - The documented `current_user_email_for_feedback` override point is unchanged, and it was
    already guarded — email prefill still works exactly as before.
  - Added specs covering both cases (controller with and without `current_user`).

### Added
- **I18n for the modal**: every visible string in the modal now comes from I18n,
  scoped under `lsa_tdx_feedback.*` (English defaults ship in
  `config/locales/en.yml`, auto-loaded by the engine). Host apps can translate to
  other locales — or reword any string — by defining the same scoped keys in
  their own locale files, which load after the gem's and win. Keys are namespaced
  so they never collide with a host app's own I18n. (The JavaScript's runtime
  status/validation messages are not yet localized — a follow-up.)
- **Opt-out for the floating trigger button**: `lsa_tdx_feedback_modal(trigger: false)`
  (and `lsa_tdx_feedback(trigger: false)`) render the modal WITHOUT the built-in
  fixed bottom-right button, so a host can open it from its own control via
  `window.LsaTdxFeedback.showModal()` — e.g. when the fixed button collides with
  other fixed page chrome (cookie banners, toasts). Defaults to `true`; callers
  that don't pass `trigger:` are unaffected.
- **Delivery fallback (`config.fallback`)**: an optional callable invoked with the
  feedback data when a ticket can't be filed — TDX not configured, or the API call
  raises — so feedback is never lost. The controller files a TDX ticket when TDX is
  configured and the call succeeds, otherwise hands the data to your fallback (e.g.
  emailing an admin, enqueuing a job). Defaults to `nil`, which preserves the
  original behavior exactly: no fallback, error response on failure.
- **Documentation**: Added Rails 8 authentication setup instructions to README
  - Step-by-step guide for generating Rails 8.1.1's built-in authentication system
  - Instructions for creating `current_user` helper method to match Devise pattern
  - Examples for protecting actions and excluding authentication for specific controllers
  - Documentation on using `allow_unauthenticated_access` for public pages

### Changed
- **Modal is now a native `<dialog>`**: it renders in the browser's top layer
  (above all page content, no z-index needed) with a built-in focus trap and
  native Escape handling, so it no longer competes with host page chrome or
  relies on a hand-rolled backdrop/focus/escape. The JS now saves and restores
  the host's `document.body` overflow on open/close instead of clearing it
  (which could clobber another component's scroll lock).
- **WCAG 2.2 AAA defaults + themeable tokens**: the stylesheet now targets AAA
  (7:1 text contrast, 44px minimum touch targets) in light and dark, and its
  colors/sizes are exposed as `--lsa-tdx-feedback-*` CSS custom properties for
  rebranding without copying the stylesheet. A `prefers-color-scheme: dark`
  variant is included, and the modal's field colors are pinned so a theme-aware
  host app can't bleed low-contrast text into them. This changes the modal's
  default appearance (notably a darker, AAA-contrast accent).

### Breaking
- The modal's outer element changed from `<div>` to `<dialog>`, and the
  `.lsa-tdx-feedback-modal-backdrop` div was removed (the backdrop is now the
  `::backdrop` pseudo-element). If you override the modal partial, or style the
  old backdrop div, update accordingly. Custom colors/sizes previously set by
  editing the stylesheet should move to the `--lsa-tdx-feedback-*` properties.

## [1.0.4] - 2026-02-09

### Changed
- Updated `httparty` dependency (see gemspec for version constraint)

## [1.0.3] - 2025-12-08

### Fixed
- **Turbo Drive Compatibility**: Fixed feedback button not working after Turbo navigation
  - Added proper event listener cleanup to prevent duplicate handlers
  - Added support for `turbo:load` and `turbo:frame-load` events
  - Re-initializes feedback functionality on each Turbo navigation
  - Prevents memory leaks by properly removing old event listeners before attaching new ones
  - Maintains backward compatibility with traditional page loads

## [1.0.2] - 2025-01-27

### Fixed
- **Accessibility Improvement**: Updated button background color for better accessibility in lsa-tdx-feedback-trigger-btn

## [1.0.1] - 2025-09-23

### Fixed
- **TDX API Integration Issues**: Resolved HTTP 422 errors when creating tickets
  - Fixed invalid Classification value
  - Updated configuration validation to handle both string and integer values for `default_classification`
  - Simplified ticket payload structure to include only essential fields
  - Fixed string interpolation in `build_description` method
  - Changed description format from HTML to plain text to avoid parsing issues
  - Removed unnecessary fields that were causing 500 errors

### Technical Improvements
- Enhanced configuration validation for better error handling
- Streamlined ticket payload to include only required TDX API fields:
  - TypeID, Classification, Title, Description
  - RequestorEmail, SourceID, ServiceID
  - ResponsibleGroupID, AccountID
- Improved error handling and debugging capabilities

## [1.0.0] - 2025-09-23

### Added
- Initial release of FeedbackGem
- Self-contained feedback modal with responsive design
- TDX API integration for ticket creation
- OAuth client credentials flow authentication
- Zero-configuration setup with Rails credentials support
- Automatic context capture (URL, user agent, user email)
- Smart token caching for optimal performance
- Mobile-responsive design
- Framework-agnostic CSS and JavaScript
- Comprehensive documentation and examples

### Features
- Beautiful, accessible feedback modal
- Multiple feedback categories with automatic priority mapping
- Real-time form validation and submission
- Loading states and error handling
- Keyboard navigation support (ESC to close)
- CSRF protection for secure form submission
- Automatic asset pipeline integration
- View helpers for easy integration
