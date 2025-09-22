module FeedbackGem
  class Configuration
    attr_accessor :client_id, :client_secret, :oauth_url, :api_base_url, :app_id,
                  :default_type_id, :default_form_id, :default_classification,
                  :default_status_id, :default_priority_id, :default_responsible_group_id,
                  :default_service_id, :default_source_id, :service_offering_id, :account_id,
                  :cache_store, :cache_expiry

    def initialize
      # All values must be configured by the application for security
      @oauth_url = nil
      @api_base_url = nil
      @client_id = nil
      @client_secret = nil
      @app_id = nil
      @default_type_id = nil
      @default_form_id = nil
      @default_classification = nil
      @default_status_id = nil
      @default_priority_id = nil
      @default_source_id = nil
      @default_responsible_group_id = nil
      @default_service_id = nil
      @service_offering_id = nil
      @account_id = nil

      # Cache configuration
      @cache_store = :redis_cache_store
      @cache_expiry = 3600 # 1 hour for OAuth tokens
    end

    def oauth_scope
      'https://gw-test.api.it.umich.edu/um/it tdxticket'
    end

    def grant_type
      'client_credentials'
    end

    def valid?
      !oauth_url.nil? && !oauth_url.empty? &&
      !api_base_url.nil? && !api_base_url.empty? &&
      !client_id.nil? && !client_id.empty? &&
      !client_secret.nil? && !client_secret.empty? &&
      !app_id.nil? &&
      !default_type_id.nil? &&
      !default_form_id.nil? &&
      !default_classification.nil? && (default_classification.is_a?(String) ? !default_classification.empty? : true) &&
      !default_status_id.nil? &&
      !default_priority_id.nil? &&
      !default_source_id.nil? &&
      !default_responsible_group_id.nil? &&
      !default_service_id.nil? &&
      !service_offering_id.nil? &&
      !account_id.nil?
    end

    def validate!
      raise Error, 'oauth_url is required' unless oauth_url && !oauth_url.empty?
      raise Error, 'api_base_url is required' unless api_base_url && !api_base_url.empty?
      raise Error, 'client_id is required' unless client_id && !client_id.empty?
      raise Error, 'client_secret is required' unless client_secret && !client_secret.empty?
      raise Error, 'app_id is required' unless app_id
      raise Error, 'default_type_id is required' unless default_type_id
      raise Error, 'default_form_id is required' unless default_form_id
      raise Error, 'default_classification is required' unless default_classification && (default_classification.is_a?(String) ? !default_classification.empty? : true)
      raise Error, 'default_status_id is required' unless default_status_id
      raise Error, 'default_priority_id is required' unless default_priority_id
      raise Error, 'default_source_id is required' unless default_source_id
      raise Error, 'default_responsible_group_id is required' unless default_responsible_group_id
      raise Error, 'default_service_id is required' unless default_service_id
      raise Error, 'service_offering_id is required' unless service_offering_id
      raise Error, 'account_id is required' unless account_id
    end

    def debug_info
      {
        oauth_url: oauth_url,
        api_base_url: api_base_url,
        client_id: client_id ? "#{client_id[0..4]}..." : nil,
        client_secret: client_secret ? "#{client_secret[0..4]}..." : nil,
        app_id: app_id,
        grant_type: grant_type,
        oauth_scope: oauth_scope,
        valid: valid?
      }
    end
  end
end
