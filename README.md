# LsaTdxFeedback

A self-contained Rails gem for collecting user feedback via TeamDynamix (TDX) API for LSA applications. LsaTdxFeedback provides a secure, configurable solution that integrates seamlessly with any Rails application.

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
gem 'lsa_tdx_feedback'
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
lsa_tdx_feedback:
  # Required OAuth Configuration
  oauth_url: 'https://your-tdx-instance.com/oauth2'  # Note: Do NOT include /token
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
# config/initializers/lsa_tdx_feedback.rb
LsaTdxFeedback.configure do |config|
  # Required OAuth Configuration
  config.oauth_url = ENV['TDX_OAUTH_URL']  # Note: Do NOT include /token
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
  mount LsaTdxFeedback::Engine => "/lsa_tdx_feedback", as: "lsa_tdx_feedback"
end
```

### Step 2: Add the Feedback Modal and Assets (optimal placement)

For best performance and predictable ordering, include CSS in `<head>`, render the modal markup in the body, and place JS just before `</body>`:

```erb
<!-- app/views/layouts/application.html.erb -->

<head>
  <%= lsa_tdx_feedback_css %>
  <!-- your other tags ... -->
  ...
  ...
  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>
  <!-- etc. -->
  ...
  ...
  ...
  ...
</head>

<body>
  ...
  <%= lsa_tdx_feedback_modal %>
  <%= lsa_tdx_feedback_js %>
</body>
```

This avoids FOUC (flash of unstyled content) and ensures the script loads after the DOM.

### Advanced Usage

#### Performance vs convenience

- **Optimal loading (recommended)**: Use the separate helpers so CSS loads in `<head>` and JS loads just before `</body>`. This avoids FOUC and keeps asset order predictable.
- **Convenience**: Use `lsa_tdx_feedback` (all‑in‑one) for quick setup. It injects CSS/JS plus the modal where it’s called, which can delay CSS and is less ideal for performance.

#### Recommended placement (optimal)

```erb
<!-- app/views/layouts/application.html.erb -->

<head>
  <%= lsa_tdx_feedback_css %>
  <!-- your other tags ... -->
  ...
  ...
</head>

<body>
  ...
  <%= lsa_tdx_feedback_modal %>
  <%= lsa_tdx_feedback_js %>
</body>
```

You can also include components separately for more control over placement:

```erb
<!-- In your layout head section -->
<%= lsa_tdx_feedback_css %>

<!-- In your layout body section (before closing </body> tag) -->
<%= lsa_tdx_feedback_js %>

<!-- Include just the modal (assets must be included separately) -->
<%= lsa_tdx_feedback_modal %>
```

Or use the combined assets helper:

```erb
<!-- Include both CSS and JavaScript together -->
<%= lsa_tdx_feedback_assets %>

<!-- Include just the modal (assets must be included separately) -->
<%= lsa_tdx_feedback_modal %>
```

#### When to use explicit Rails asset tags

If you prefer explicit control, you can use Rails helpers directly:

```erb
<head>
  <%= stylesheet_link_tag 'lsa_tdx_feedback', media: 'all', 'data-turbo-track': 'reload' %>
</head>

<body>
  ...
  <%= lsa_tdx_feedback_modal %>
  <%= javascript_include_tag 'lsa_tdx_feedback', defer: true, 'data-turbo-track': 'reload' %>
</body>
```

Use explicit tags when you need to:

- Set attributes like `defer`, `async`, `nonce` (CSP), `integrity`, `crossorigin`, `media`, or `preload`
- Control exact ordering relative to Bootstrap or your packs
- Swap delivery (CDN vs pipeline) or pin versions independently of the gem
- Integrate precisely with your asset setup (Importmap, Propshaft, Sprockets, etc.)

#### Convenience (all‑in‑one)

If you want a single helper that injects CSS, JS, and the modal where it’s called (good for quick trials or prototypes):

```erb
<!-- In your application layout (e.g., app/views/layouts/application.html.erb) -->
<%= lsa_tdx_feedback %>
```

Note: This may load CSS later than ideal and is less optimal for performance.

### Customizing User Email

By default, LsaTdxFeedback tries to automatically detect the current user's email. You can customize this by overriding the `current_user_email_for_feedback` method in your ApplicationController:

```ruby
class ApplicationController < ActionController::Base
  private

  def current_user_email_for_feedback
    current_user&.email_address # or however you access user email
  end
end
```

## Rails 8 Authentication Setup

If you're using Rails 8.1.1's built-in authentication system, here's how to set it up and create a `current_user` helper method similar to Devise.

### Step 1: Generate the Authentication System

Run the Rails generator:

```bash
bin/rails generate authentication
```

This creates:

- User model
- Session model
- Current class (for per-request attributes)
- Controllers (SessionsController, PasswordsController)
- Views for login/password reset
- Migrations

### Step 2: Run Migrations

```bash
bin/rails db:migrate
```

### Step 3: Add current_user Helper Method

Rails 8 uses `Current.user` instead of `current_user`. Add this to your `ApplicationController` to match Devise's pattern:

```ruby
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user

  private

  def current_user
    Current.user
  end
end
```

The `helper_method :current_user` makes it available in views and controllers.

### Step 4: Protect Actions (Optional)

To require authentication for specific actions:

```ruby
class SomeController < ApplicationController
  before_action :require_authentication

  private

  def require_authentication
    redirect_to new_session_path unless current_user
  end
end
```

### Excluding Authentication for Specific Controllers

If you need to exclude authentication for specific controllers or actions (e.g., a public home page), use the `allow_unauthenticated_access` method provided by the Authentication concern:

```ruby
class HomeController < ApplicationController
  allow_unauthenticated_access only: [:index]

  def index
  end
end
```

This skips authentication only for the `index` action. The Authentication concern uses `skip_before_action :require_authentication` under the hood.

**Alternative options:**

If you want to skip authentication for all actions in the HomeController:

```ruby
class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
  end
end
```

Or if you want to skip for multiple specific actions:

```ruby
class HomeController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  def index
  end
end
```

The `only:` option limits it to specific actions, while omitting it skips authentication for all actions in that controller.

### How It Works

- `Current` is an `ActiveSupport::CurrentAttributes` class that stores per-request attributes
- After login, `Current.user` is set to the authenticated user
- `current_user` wraps `Current.user` for Devise-like usage
- Works with authorization libraries like Pundit that expect `current_user`

### Routes

The generator adds routes like:

- `new_session_path` - login page
- `session_path` - create/destroy session
- `new_password_path` - password reset request
- etc.

After running the generator, you can use `current_user` in controllers and views just like with Devise.

## TDX API Configuration

### Required TDX Settings

1. **Client Credentials**: You need OAuth client credentials from your TDX administrator
2. **Responsible Group ID**: The TDX group that will receive feedback tickets
3. **App ID**: Your TDX ticketing application ID (usually provided by your TDX admin)

### Default TDX Values

The gem uses these default values based on University of Michigan's TDX setup:

- **OAuth URL**: *see API documentation*
- **API Base URL**: *see API documentation*
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
LsaTdxFeedback.configure do |config|
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

- `lsa_tdx_feedback` - Includes both assets and modal (all-in-one)
- `lsa_tdx_feedback_assets` - Includes both CSS and JavaScript
- `lsa_tdx_feedback_css` - Includes only the CSS stylesheet
- `lsa_tdx_feedback_js` - Includes only the JavaScript file
- `lsa_tdx_feedback_modal` - Includes only the modal HTML

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lsa-mis/lsa_feedback.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Troubleshooting

### Common Issues

1. **"client_id is required" error**
   - Make sure you've configured your TDX credentials properly
   - Check that your Rails credentials are accessible

2. **Modal doesn't appear or form submission fails**
   - Ensure you've included `<%= lsa_tdx_feedback %>` in your layout
   - **Check that you've mounted the engine routes** in your `config/routes.rb`
   - Check browser console for JavaScript errors
   - Verify the `/lsa_tdx_feedback/feedback` endpoint is accessible
   - If using separate helpers, ensure CSS is in `<head>` and JS is before `</body>`

3. **Styling conflicts**
   - All LsaTdxFeedback styles are prefixed with `feedback-gem-`
   - Use browser dev tools to check for CSS conflicts

4. **OAuth/API errors**
   - Verify your TDX credentials are correct
   - Check that your TDX instance URLs are correct
   - **Ensure oauth_url does NOT include /token** (e.g., use `https://your-tdx.com/oauth2` not `https://your-tdx.com/oauth2/token`)
   - Ensure your responsible group ID exists in TDX

### Debug Mode

Enable debug logging by setting the Rails log level:

```ruby
# In development.rb or production.rb
config.log_level = :debug
```

This will log OAuth token requests and API calls for troubleshooting.
