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
        FormID: @configuration.default_form_id,
        Classification: @configuration.default_classification,
        Title: feedback_data[:title] || "User Feedback",
        Description: build_description(feedback_data),
        StatusID: @configuration.default_status_id,
        PriorityID: feedback_data[:priority_id] || @configuration.default_priority_id,
        RequestorEmail: feedback_data[:email],
        ResponsibleGroupID: @configuration.default_responsible_group_id,
        ServiceID: @configuration.default_service_id,
        SourceID: @configuration.default_source_id
      }.compact
    end

    def build_description(feedback_data)
      description_parts = []
      
      description_parts << "<h3>User Feedback</h3>"
      description_parts << "<p><strong>Feedback:</strong></p>"
      description_parts << "<p>#{sanitize_html(feedback_data[:feedback])}</p>"
      
      if feedback_data[:category].present?
        description_parts << "<p><strong>Category:</strong> #{sanitize_html(feedback_data[:category])}</p>"
      end
      
      if feedback_data[:url].present?
        description_parts << "<p><strong>Page URL:</strong> #{sanitize_html(feedback_data[:url])}</p>"
      end
      
      if feedback_data[:user_agent].present?
        description_parts << "<p><strong>Browser:</strong> #{sanitize_html(feedback_data[:user_agent])}</p>"
      end
      
      if feedback_data[:additional_info].present?
        description_parts << "<p><strong>Additional Information:</strong></p>"
        description_parts << "<p>#{sanitize_html(feedback_data[:additional_info])}</p>"
      end
      
      description_parts.join("\n")
    end

    def sanitize_html(text)
      return "" unless text
      
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
      error_data = response.parsed_response
      error_message = if error_data.is_a?(Hash) && error_data['errorMessage']
                       "TDX API Error: #{error_data['errorMessage']} (Code: #{error_data['errorCode']})"
                     else
                       "TDX API Error: HTTP #{response.code} - #{response.message}"
                     end
      
      raise Error, error_message
    end
  end
end
