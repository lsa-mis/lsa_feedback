require 'rails/engine'

module FeedbackGem
  class Engine < ::Rails::Engine
    isolate_namespace FeedbackGem

    # Automatically add assets to the asset pipeline
    initializer "feedback_gem.assets.precompile" do |app|
      app.config.assets.precompile += %w[feedback_gem.js feedback_gem.css]
    end

    # Add view paths for the feedback modal
    initializer "feedback_gem.view_paths" do |app|
      ActiveSupport.on_load :action_controller do
        append_view_path Engine.root.join("app", "views")
      end
    end

    # Add helper methods to ApplicationController
    initializer "feedback_gem.action_controller" do
      ActiveSupport.on_load :action_controller do
        include FeedbackGem::ApplicationControllerExtensions
      end
    end

    # Add view helpers to ActionView
    initializer "feedback_gem.action_view" do
      ActiveSupport.on_load :action_view do
        include FeedbackGem::ViewHelpers
      end
    end

    # Auto-configure if credentials are available
    config.after_initialize do
      if Rails.application.credentials.dig(:feedback_gem, :client_id) &&
         Rails.application.credentials.dig(:feedback_gem, :client_secret) &&
         Rails.application.credentials.dig(:feedback_gem, :responsible_group_id)

        FeedbackGem.configure do |config|
          config.client_id = Rails.application.credentials.dig(:feedback_gem, :client_id)
          config.client_secret = Rails.application.credentials.dig(:feedback_gem, :client_secret)
          config.default_responsible_group_id = Rails.application.credentials.dig(:feedback_gem, :responsible_group_id)

          # Optional overrides from credentials
          config.app_id = Rails.application.credentials.dig(:feedback_gem, :app_id) if Rails.application.credentials.dig(:feedback_gem, :app_id)
          config.default_service_id = Rails.application.credentials.dig(:feedback_gem, :service_id) if Rails.application.credentials.dig(:feedback_gem, :service_id)
        end
      end
    end
  end
end
