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
      @feedback_gem_user_email = current_user_email_for_feedback if respond_to?(:current_user_email_for_feedback, true)
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
