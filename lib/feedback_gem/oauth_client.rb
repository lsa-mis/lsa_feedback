require 'httparty'
require 'base64'

module FeedbackGem
  class OAuthClient
    include HTTParty

    def initialize(configuration = FeedbackGem.configuration)
      @configuration = configuration
      @configuration.validate!
      
      self.class.base_uri(@configuration.oauth_url)
      self.class.headers({
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Accept' => 'application/json'
      })
    end

    def get_access_token
      # Check cache first
      cached_token = Rails.cache.read(cache_key)
      return cached_token if cached_token

      # Get new token
      token_response = fetch_new_token
      
      if token_response.success?
        token_data = token_response.parsed_response
        access_token = token_data['access_token']
        expires_in = token_data['expires_in'].to_i
        
        # Cache the token with some buffer time (subtract 5 minutes)
        cache_duration = [expires_in - 300, 300].max
        Rails.cache.write(cache_key, access_token, expires_in: cache_duration)
        
        access_token
      else
        handle_error_response(token_response)
      end
    end

    private

    def fetch_new_token
      auth_header = Base64.strict_encode64("#{@configuration.client_id}:#{@configuration.client_secret}")
      
      self.class.post('/token',
        headers: {
          'Authorization' => "Basic #{auth_header}"
        },
        body: {
          grant_type: @configuration.grant_type,
          scope: @configuration.oauth_scope
        }.to_query
      )
    end

    def handle_error_response(response)
      error_data = response.parsed_response
      error_message = if error_data.is_a?(Hash) && error_data['errorMessage']
                       "OAuth Error: #{error_data['errorMessage']} (Code: #{error_data['errorCode']})"
                     else
                       "OAuth Error: HTTP #{response.code} - #{response.message}"
                     end
      
      raise Error, error_message
    end

    def cache_key
      "feedback_gem:oauth_token:#{Digest::MD5.hexdigest(@configuration.client_id)}"
    end
  end
end
