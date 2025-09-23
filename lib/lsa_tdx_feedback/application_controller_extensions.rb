module LsaTdxFeedback
  module ApplicationControllerExtensions
    if defined?(ActiveSupport::Concern)
      extend ActiveSupport::Concern

      included do |base|
        base.before_action :set_lsa_tdx_feedback_data
      end
    end

    private

    def set_lsa_tdx_feedback_data
      @lsa_tdx_feedback_current_url = request.original_url
      @lsa_tdx_feedback_user_agent = request.user_agent
      @lsa_tdx_feedback_app_name = begin
        # Prefer Rails 6+ API, fallback for older Rails
        if Rails.application.class.respond_to?(:module_parent_name)
          Rails.application.class.module_parent_name
        else
          Rails.application.class.parent_name
        end
      rescue
        nil
      end

      # Logging
      Rails.logger.info "set_lsa_tdx_feedback_data called"
      Rails.logger.info "  respond_to? current_user_email_for_feedback: #{respond_to?(:current_user_email_for_feedback, true)}"
      Rails.logger.info "  current_user available: #{respond_to?(:current_user, true)}"
      Rails.logger.info "  current_user: #{current_user&.email || 'nil'}"

      if respond_to?(:current_user_email_for_feedback, true)
        @lsa_tdx_feedback_user_email = current_user_email_for_feedback
        Rails.logger.info "  @lsa_tdx_feedback_user_email set to: #{@lsa_tdx_feedback_user_email}"
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
