# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- **TDX API Integration Issues**: Resolved HTTP 422 errors when creating tickets
  - Fixed invalid Classification value (changed from 300 to 46)
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

## [0.1.0] - 2024-01-XX

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
