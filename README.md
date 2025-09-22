# FeedbackGem

A self-contained Rails gem for collecting user feedback via TeamDynamix (TDX) API. FeedbackGem provides a secure, configurable solution that integrates seamlessly with any Rails application.

## Features

- **Secure Configuration**: All values must be provided by your application for maximum security
- **Self-Contained UI**: Beautiful, responsive feedback modal with its own CSS and JavaScript
- **TDX Integration**: Direct integration with TeamDynamix API for ticket creation
- **OAuth Authentication**: Secure client credentials flow authentication with tdxticket scope
- **Mobile Responsive**: Works perfectly on desktop and mobile devices
- **Framework Agnostic**: CSS and JavaScript work independently of your app's styling
- **Automatic Context**: Captures page URL, user agent, and user email automatically
- **Caching**: Smart token caching for optimal performance

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'feedback_gem'
```

And then execute:

```bash
$ bundle install
```

## Configuration

### Rails Credentials (Required)

**Security Note**: All configuration values must be provided by your application. No default values are stored in the gem for security reasons.

Add your TDX API credentials to your Rails credentials:

```bash
$ rails credentials:edit
```

```yaml
feedback_gem:
  # Required OAuth Configuration
  oauth_url: 'https://your-tdx-instance.com/oauth2'
  api_base_url: 'https://your-tdx-instance.com/api'
  client_id: your_tdx_client_id
  client_secret: your_tdx_client_secret

  # Required TDX Configuration
  app_id: 123
  account_id: 456
  service_offering_id: 789

  # Required Ticket Configuration
  default_type_id: 100
  default_form_id: 200
  default_classification: '300'
  default_status_id: 400
  default_priority_id: 500
  default_source_id: 600
  default_responsible_group_id: 700
  default_service_id: 800
```

### Manual Configuration

If you prefer not to use Rails credentials, you can configure the gem manually in an initializer:

```ruby
# config/initializers/feedback_gem.rb
FeedbackGem.configure do |config|
  # Required OAuth Configuration
  config.oauth_url = ENV['TDX_OAUTH_URL']
  config.api_base_url = ENV['TDX_API_BASE_URL']
  config.client_id = ENV['TDX_CLIENT_ID']
  config.client_secret = ENV['TDX_CLIENT_SECRET']

  # Required TDX Configuration
  config.app_id = ENV['TDX_APP_ID'].to_i
  config.account_id = ENV['TDX_ACCOUNT_ID'].to_i
  config.service_offering_id = ENV['TDX_SERVICE_OFFERING_ID'].to_i

  # Required Ticket Configuration
  config.default_type_id = ENV['TDX_TYPE_ID'].to_i
  config.default_form_id = ENV['TDX_FORM_ID'].to_i
  config.default_classification = ENV['TDX_CLASSIFICATION']
  config.default_status_id = ENV['TDX_STATUS_ID'].to_i
  config.default_priority_id = ENV['TDX_PRIORITY_ID'].to_i
  config.default_source_id = ENV['TDX_SOURCE_ID'].to_i
  config.default_responsible_group_id = ENV['TDX_RESPONSIBLE_GROUP_ID'].to_i
  config.default_service_id = ENV['TDX_SERVICE_ID'].to_i
end
```

**Note**: If you use Rails credentials (recommended), the gem will automatically configure itself and you don't need to create this initializer file.

## Usage

### Step 1: Mount the Engine Routes

Add the feedback gem routes to your application's `config/routes.rb`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # Your existing routes...

  # Mount the feedback gem engine
  mount FeedbackGem::Engine => "/feedback_gem", as: "feedback_gem"
end
```

### Step 2: Add the Feedback Modal

Add the feedback modal to your layout:

```erb
<!-- In your application layout (e.g., app/views/layouts/application.html.erb) -->
<%= feedback_gem %>
```

That's it! The feedback button will appear in the bottom-right corner of your application.

### Advanced Usage

You can also include components separately for more control over placement:

```erb
<!-- In your layout head section -->
<%= feedback_gem_css %>

<!-- In your layout body section (before closing </body> tag) -->
<%= feedback_gem_js %>

<!-- Include just the modal (assets must be included separately) -->
<%= feedback_gem_modal %>
```

Or use the combined assets helper:

```erb
<!-- Include both CSS and JavaScript together -->
<%= feedback_gem_assets %>

<!-- Include just the modal (assets must be included separately) -->
<%= feedback_gem_modal %>
```

### Customizing User Email

By default, FeedbackGem tries to automatically detect the current user's email. You can customize this by overriding the `current_user_email_for_feedback` method in your ApplicationController:

```ruby
class ApplicationController < ActionController::Base
  private

  def current_user_email_for_feedback
    current_user&.email_address # or however you access user email
  end
end
```

## TDX API Configuration

### Required TDX Settings

1. **Client Credentials**: You need OAuth client credentials from your TDX administrator
2. **Responsible Group ID**: The TDX group that will receive feedback tickets
3. **App ID**: Your TDX ticketing application ID (usually provided by your TDX admin)

### Default TDX Values

The gem uses these default values based on University of Michigan's TDX setup:

- **OAuth URL**: `https://gw-test.api.it.umich.edu/um/oauth2`
- **API Base URL**: `https://gw-test.api.it.umich.edu/um/it`
- **Type ID**: 28 (TeamDynamix)
- **Form ID**: 20 (Request Form)
- **Classification**: "46" (Request)
- **Status ID**: 77 (New)
- **Priority ID**: 20 (Medium)
- **Source ID**: 8 (Systems)
- **Service ID**: 67 (ITS-TeamDynamix Support)

You can override any of these in your configuration.

## Feedback Categories

The modal includes predefined categories that automatically set ticket priorities:

- **Bug Report** → High Priority
- **Urgent/Critical** → Emergency Priority
- **Suggestion/Enhancement/Feature** → Low Priority
- **General/Other** → Medium Priority (default)

## Styling

The gem includes completely self-contained CSS that won't interfere with your application's styles. All CSS classes are prefixed with `feedback-gem-` to avoid conflicts.

If you need to customize the appearance, you can override the styles in your application:

```css
/* Customize the trigger button */
.feedback-gem-trigger-btn {
  background: #custom-color !important;
}

/* Customize the modal */
.feedback-gem-modal-content {
  border-radius: 8px !important;
}
```

## JavaScript

The gem includes self-contained JavaScript that initializes automatically. It handles:

- Modal show/hide functionality
- Form submission via AJAX
- Loading states and error handling
- Keyboard navigation (ESC to close)
- Mobile responsive behavior

## Development

After checking out the repo, run:

```bash
$ bundle install
$ bundle exec rake spec  # Run tests
$ bundle exec rubocop    # Run linter
```

## API Reference

### Configuration Options

```ruby
FeedbackGem.configure do |config|
  # Required
  config.client_id = "your_client_id"
  config.client_secret = "your_client_secret"
  config.default_responsible_group_id = 123

  # Optional TDX settings
  config.oauth_url = "https://your-tdx-oauth-url"
  config.api_base_url = "https://your-tdx-api-url"
  config.app_id = 31
  config.default_service_id = 67
  config.default_type_id = 28
  config.default_form_id = 20
  config.default_classification = "46"
  config.default_status_id = 77
  config.default_priority_id = 20
  config.default_source_id = 8

  # Caching
  config.cache_store = :redis_cache_store
  config.cache_expiry = 3600  # Token cache expiry in seconds
end
```

### View Helpers

- `feedback_gem` - Includes both assets and modal (all-in-one)
- `feedback_gem_assets` - Includes both CSS and JavaScript
- `feedback_gem_css` - Includes only the CSS stylesheet
- `feedback_gem_js` - Includes only the JavaScript file
- `feedback_gem_modal` - Includes only the modal HTML

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yourusername/feedback_gem.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Troubleshooting

### Common Issues

1. **"client_id is required" error**
   - Make sure you've configured your TDX credentials properly
   - Check that your Rails credentials are accessible

2. **Modal doesn't appear or form submission fails**
   - Ensure you've included `<%= feedback_gem %>` in your layout
   - **Check that you've mounted the engine routes** in your `config/routes.rb`
   - Check browser console for JavaScript errors
   - Verify the `/feedback_gem/feedback` endpoint is accessible
   - If using separate helpers, ensure CSS is in `<head>` and JS is before `</body>`

3. **Styling conflicts**
   - All FeedbackGem styles are prefixed with `feedback-gem-`
   - Use browser dev tools to check for CSS conflicts

4. **OAuth/API errors**
   - Verify your TDX credentials are correct
   - Check that your TDX instance URLs are correct
   - Ensure your responsible group ID exists in TDX

### Debug Mode

Enable debug logging by setting the Rails log level:

```ruby
# In development.rb or production.rb
config.log_level = :debug
```

This will log OAuth token requests and API calls for troubleshooting.
