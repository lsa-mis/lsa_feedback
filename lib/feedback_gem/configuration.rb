module FeedbackGem
  class Configuration
    attr_accessor :client_id, :client_secret, :oauth_url, :api_base_url, :app_id,
                  :default_type_id, :default_form_id, :default_classification,
                  :default_status_id, :default_priority_id, :default_responsible_group_id,
                  :default_service_id, :default_source_id, :cache_store, :cache_expiry

    def initialize
      # TDX API Configuration - Based on the YAML documentation
      @oauth_url = "https://gw-test.api.it.umich.edu/um/oauth2"
      @api_base_url = "https://gw-test.api.it.umich.edu/um/it"

      # Default TDX ticket values from API documentation
      @default_type_id = 28 # TeamDynamix type from example
      @default_form_id = 20 # Request Form from example
      @default_classification = "46" # Request classification
      @default_status_id = 77 # New status
      @default_priority_id = 20 # Medium priority
      @default_source_id = 8 # Systems source

      # These should be configured by the application
      @client_id = nil
      @client_secret = nil
      @app_id = 31 # Default from examples
      @default_responsible_group_id = nil # Must be set by application
      @default_service_id = 67 # ITS-TeamDynamix Support from example

      # Cache configuration
      @cache_store = :redis_cache_store
      @cache_expiry = 3600 # 1 hour for OAuth tokens
    end

    def oauth_scope
      "https://gw-test.api.it.umich.edu/um/it"
    end

    def grant_type
      "client_credentials"
    end

    def valid?
      client_id.present? && client_secret.present? && default_responsible_group_id.present?
    end

    def validate!
      raise Error, "client_id is required" unless client_id.present?
      raise Error, "client_secret is required" unless client_secret.present?
      raise Error, "default_responsible_group_id is required" unless default_responsible_group_id.present?
    end
  end
end
