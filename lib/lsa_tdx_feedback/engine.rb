module LsaTdxFeedback
  class Engine < ::Rails::Engine
    isolate_namespace LsaTdxFeedback

    # Automatically add assets to the asset pipeline
    initializer 'lsa_tdx_feedback.assets.precompile' do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.precompile += %w[lsa_tdx_feedback.js lsa_tdx_feedback.css]
      end
    end

    # Add view paths for the feedback modal
    initializer 'lsa_tdx_feedback.view_paths' do |app|
      ActiveSupport.on_load :action_controller do
        append_view_path Engine.root.join('app', 'views')
      end
    end

    # Add helper methods to ApplicationController
    initializer 'lsa_tdx_feedback.action_controller' do
      ActiveSupport.on_load :action_controller do
        include LsaTdxFeedback::ApplicationControllerExtensions
      end
    end

    # Add view helpers to ActionView
    initializer 'lsa_tdx_feedback.action_view' do
      ActiveSupport.on_load :action_view do
        include LsaTdxFeedback::ViewHelpers
      end
    end

    # Auto-configure if credentials are available
    config.after_initialize do
      credentials = Rails.application.credentials.lsa_tdx_feedback

      if credentials&.dig(:client_id) && credentials&.dig(:client_secret) && credentials&.dig(:default_responsible_group_id)
        LsaTdxFeedback.configure do |config|
          # Load configuration from Rails credentials

          # Required OAuth Configuration
          config.oauth_url = credentials[:oauth_url]
          config.api_base_url = credentials[:api_base_url]
          config.client_id = credentials[:client_id]
          config.client_secret = credentials[:client_secret]

          # Required TDX Configuration
          config.app_id = credentials[:app_id]
          config.account_id = credentials[:account_id]
          config.service_offering_id = credentials[:service_offering_id]

          # Required Ticket Configuration
          config.default_type_id = credentials[:default_type_id]
          config.default_form_id = credentials[:default_form_id]
          config.default_classification = credentials[:default_classification]
          config.default_status_id = credentials[:default_status_id]
          config.default_priority_id = credentials[:default_priority_id]
          config.default_source_id = credentials[:default_source_id]
          config.default_responsible_group_id = credentials[:default_responsible_group_id]
          config.default_service_id = credentials[:default_service_id]
        end
      end
    end
  end
end
