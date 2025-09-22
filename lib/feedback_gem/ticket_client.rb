require 'httparty'

module FeedbackGem
  class TicketClient
    include HTTParty

    def initialize(configuration = FeedbackGem.configuration)
      @configuration = configuration
      @configuration.validate!
      @oauth_client = OAuthClient.new(configuration)

      self.class.base_uri(@configuration.api_base_url)
      self.class.headers({
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      })
    end

    def create_feedback_ticket(feedback_data)
      ticket_payload = build_ticket_payload(feedback_data)

      Rails.logger.debug "Making API call to: #{self.class.base_uri}/#{@configuration.app_id}/tickets"
      Rails.logger.debug "Payload: #{ticket_payload.to_json}"

      response = self.class.post("/#{@configuration.app_id}/tickets",
        headers: {
          'Authorization' => "Bearer #{@oauth_client.get_access_token}"
        },
        body: ticket_payload.to_json
      )

      if response.success?
        response.parsed_response
      else
        handle_error_response(response)
      end
    end

    private

    def build_ticket_payload(feedback_data)
      {
        TypeID: @configuration.default_type_id,
        Classification: @configuration.default_classification,
        Title: feedback_data[:title] || 'User Feedback',
        Description: build_description(feedback_data),
        RequestorEmail: feedback_data[:email],
        SourceID: @configuration.default_source_id,
        ServiceID: @configuration.default_service_id,
        ResponsibleGroupID: @configuration.default_responsible_group_id,
        AccountID: @configuration.account_id
      }.compact
    end

    def build_description(feedback_data)
      description_parts = []

      description_parts << 'User Feedback'
      description_parts << ''
      description_parts << "Feedback: #{feedback_data[:feedback]}"

      if feedback_data[:category].present?
        description_parts << "Category: #{feedback_data[:category]}"
      end

      if feedback_data[:url].present?
        description_parts << "Page URL: #{feedback_data[:url]}"
      end

      if feedback_data[:user_agent].present?
        description_parts << "Browser: #{feedback_data[:user_agent]}"
      end

      if feedback_data[:additional_info].present?
        description_parts << ''
        description_parts << 'Additional Information:'
        description_parts << feedback_data[:additional_info]
      end

      description_parts.join('\n')
    end

    def sanitize_html(text)
      return '' unless text

      # Basic HTML escaping
      text.to_s
          .gsub('&', '&amp;')
          .gsub('<', '&lt;')
          .gsub('>', '&gt;')
          .gsub('"', '&quot;')
          .gsub("'", '&#x27;')
          .gsub('/', '&#x2F;')
    end

    def handle_error_response(response)
      Rails.logger.debug "Response Code: #{response.code}"
      Rails.logger.debug "Response Headers: #{response.headers}"
      Rails.logger.debug "Response Body: #{response.body}"

      error_data = response.parsed_response
      error_message = if error_data.is_a?(Hash) && error_data['errorMessage']
                       "TDX API Error: #{error_data['errorMessage']} (Code: #{error_data['errorCode']})"
                     elsif error_data.is_a?(Hash) && error_data['Message']
                       "TDX API Error: #{error_data['Message']}"
                     else
                       "TDX API Error: HTTP #{response.code} - #{response.message} - #{response.body}"
                     end

      raise Error, error_message
    end
  end
end
