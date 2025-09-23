# Installation and Setup Guide

This guide will walk you through setting up LsaTdxFeedback in your Rails application.

## Prerequisites

- Rails 6.0 or higher
- Redis (for token caching)
- TDX API credentials from your administrator

## Step 1: Add the Gem

Add LsaTdxFeedback to your Gemfile:

```ruby
gem 'lsa_tdx_feedback'
```

Run bundle install:

```bash
bundle install
```

## Step 2: Configure TDX Credentials

### Option A: Rails Credentials (Recommended)

Edit your Rails credentials:

```bash
rails credentials:edit
```

Add your TDX configuration:

```yaml
lsa_tdx_feedback:
  # Required OAuth Configuration
  oauth_url: 'https://your-tdx-instance.com/oauth2'  # Note: Do NOT include /token
  api_base_url: 'https://your-tdx-instance.com/api'
  client_id: your_tdx_client_id_here
  client_secret: your_tdx_client_secret_here

  # Required TDX Configuration
  app_id: 31
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

**Note**: The gem will automatically configure itself from these credentials - no additional setup required!

### Option B: Environment Variables

Create an initializer file:

```ruby
# config/initializers/lsa_tdx_feedback.rb
LsaTdxFeedback.configure do |config|
  config.client_id = ENV['TDX_CLIENT_ID']
  config.client_secret = ENV['TDX_CLIENT_SECRET']
  config.default_responsible_group_id = ENV['TDX_RESPONSIBLE_GROUP_ID'].to_i
end
```

Then set your environment variables:

```bash
export TDX_CLIENT_ID="your_client_id"
export TDX_CLIENT_SECRET="your_client_secret"
export TDX_RESPONSIBLE_GROUP_ID="123"
```

## Step 3: Mount the Engine Routes

Add the feedback gem routes to your application's `config/routes.rb`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # Your existing routes...

  # Mount the feedback gem engine
  mount LsaTdxFeedback::Engine => "/lsa_tdx_feedback", as: "lsa_tdx_feedback"
end
```

## Step 4: Add to Your Layout

Add the feedback modal to your application layout:

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <!-- Your existing head content -->
    <%= lsa_tdx_feedback_css %>
  </head>

  <body>
    <!-- Your existing body content -->

    <!-- Add the feedback modal -->
    <%= lsa_tdx_feedback_modal %>

    <!-- Add the JavaScript before closing body tag -->
    <%= lsa_tdx_feedback_js %>
  </body>
</html>
```

Or use the all-in-one helper:

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <!-- Your existing head content -->
  </head>

  <body>
    <!-- Your existing body content -->

    <!-- Add feedback gem (includes both assets and modal) -->
    <%= lsa_tdx_feedback %>
  </body>
</html>
```

## Step 5: Customize User Email (Optional)

Override the user email detection in your ApplicationController:

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  private

  def current_user_email_for_feedback
    current_user&.email # Adjust based on your user model
  end
end
```

## Step 6: Test the Installation

1. Start your Rails server:
   ```bash
   rails server
   ```

2. Navigate to any page in your application

3. Look for the blue "Feedback" button in the bottom-right corner

4. Click it to open the feedback modal

5. Submit a test feedback to verify it creates a ticket in TDX

## Troubleshooting

### Common Issues

**1. Modal doesn't appear or form submission fails**
- Check that you've included the gem in your layout
- **Verify you've mounted the engine routes** in your `config/routes.rb`
- Check browser console for JavaScript errors
- Ensure CSS is loading properly
- Verify the `/lsa_tdx_feedback/feedback` endpoint is accessible

**2. "client_id is required" error**
- Verify your credentials are configured correctly
- Check Rails credentials with `rails credentials:show`
- Ensure environment variables are set if using that approach

**3. OAuth/API errors**
- Verify your TDX credentials are correct
- **Ensure oauth_url does NOT include /token** (e.g., use `https://your-tdx.com/oauth2` not `https://your-tdx.com/oauth2/token`)
- Check that your responsible group ID exists in TDX
- Ensure your TDX instance URLs are correct (default is UMich test environment)

**4. Styling conflicts**
- All LsaTdxFeedback styles are prefixed with `feedback-gem-`
- Use browser dev tools to identify conflicts
- Override styles in your application CSS if needed

### Debug Mode

Enable debug logging in your Rails environment:

```ruby
# config/environments/development.rb
config.log_level = :debug
```

This will log OAuth requests and API calls for troubleshooting.

## Advanced Configuration

### Custom TDX Instance

If you're using a different TDX instance than University of Michigan:

```ruby
LsaTdxFeedback.configure do |config|
  config.oauth_url = "https://your-tdx-oauth-url"
  config.api_base_url = "https://your-tdx-api-url"
  # ... other config
end
```

### Custom Ticket Defaults

Override default ticket values:

```ruby
LsaTdxFeedback.configure do |config|
  config.default_type_id = 28
  config.default_priority_id = 20
  config.default_status_id = 77
  # ... other defaults
end
```

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review the main README.md for detailed documentation
3. Check the GitHub issues page
4. Contact your TDX administrator for API-related questions
