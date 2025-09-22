module FeedbackGem
  module ApplicationControllerExtensions
    if defined?(ActiveSupport::Concern)
      extend ActiveSupport::Concern

      included do |base|
        base.before_action :set_feedback_gem_data
      end
    end

    private

    def set_feedback_gem_data
      @feedback_gem_current_url = request.original_url
      @feedback_gem_user_agent = request.user_agent

      # Logging
      Rails.logger.info "set_feedback_gem_data called"
      Rails.logger.info "  respond_to? current_user_email_for_feedback: #{respond_to?(:current_user_email_for_feedback, true)}"
      Rails.logger.info "  current_user available: #{respond_to?(:current_user, true)}"
      Rails.logger.info "  current_user: #{current_user&.email || 'nil'}"

      if respond_to?(:current_user_email_for_feedback, true)
        @feedback_gem_user_email = current_user_email_for_feedback
        Rails.logger.info "  @feedback_gem_user_email set to: #{@feedback_gem_user_email}"
      else
        Rails.logger.info "  current_user_email_for_feedback method not available"
      end
    end

    # Override this method in your ApplicationController to provide user email
    def current_user_email_for_feedback
      if defined?(current_user) && current_user.respond_to?(:email)
        current_user.email
      elsif defined?(current_user) && current_user.respond_to?(:email_address)
        current_user.email_address
      else
        nil
      end
    end
  end
end
