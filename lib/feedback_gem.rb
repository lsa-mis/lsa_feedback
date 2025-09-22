require_relative 'feedback_gem/version'
require_relative 'feedback_gem/engine'
require_relative 'feedback_gem/configuration'
require_relative 'feedback_gem/oauth_client'
require_relative 'feedback_gem/ticket_client'
require_relative 'feedback_gem/application_controller_extensions'
require_relative 'feedback_gem/view_helpers'

module FeedbackGem
  class Error < StandardError; end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
