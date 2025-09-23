require_relative 'lsa_tdx_feedback/version'
require_relative 'lsa_tdx_feedback/configuration'
require_relative 'lsa_tdx_feedback/oauth_client'
require_relative 'lsa_tdx_feedback/ticket_client'
require_relative 'lsa_tdx_feedback/application_controller_extensions'
require_relative 'lsa_tdx_feedback/view_helpers'

# Only require the engine when Rails is available
if defined?(Rails)
  require_relative 'lsa_tdx_feedback/engine'
end

module LsaTdxFeedback
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
