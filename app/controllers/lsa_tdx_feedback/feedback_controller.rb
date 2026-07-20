module LsaTdxFeedback
  class FeedbackController < ::ApplicationController
    protect_from_forgery with: :exception
    before_action :set_lsa_tdx_feedback_data

    def create
      feedback_data = build_feedback_data

      # No fallback configured: preserve the original behavior exactly.
      return create_via_tdx(feedback_data) if LsaTdxFeedback.configuration.fallback.nil?

      # Fallback configured: file a TDX ticket when TDX is configured and the
      # call succeeds; otherwise hand the feedback to the fallback so it's never
      # lost (e.g. TDX creds absent, OAuth/API failure).
      if LsaTdxFeedback.configuration.valid?
        begin
          ticket = TicketClient.new.create_feedback_ticket(feedback_data)
          return render_ticket_created(ticket)
        rescue StandardError => e
          Rails.logger.error "LsaTdxFeedback: ticket failed (#{e.class}: #{e.message}); using fallback"
        end
      end

      deliver_via_fallback(feedback_data)
    end

    private

    def build_feedback_data
      # Build the title and include the app name if available
      title = feedback_params[:title].presence || "User Feedback - #{feedback_params[:category]}"

      if defined?(@lsa_tdx_feedback_app_name) && @lsa_tdx_feedback_app_name.present?
        title = "[#{@lsa_tdx_feedback_app_name}]: #{title}"
      end

      {
        title: title,
        feedback: feedback_params[:feedback],
        category: feedback_params[:category],
        email: feedback_params[:email],
        url: feedback_params[:url],
        user_agent: feedback_params[:user_agent],
        additional_info: feedback_params[:additional_info],
        priority_id: priority_from_category(feedback_params[:category])
      }
    end

    # The original create path, unchanged — used when no fallback is configured.
    def create_via_tdx(feedback_data)
      render_ticket_created(TicketClient.new.create_feedback_ticket(feedback_data))
    rescue LsaTdxFeedback::Error => e
      Rails.logger.error "LsaTdxFeedback Error: #{e.message}"

      render json: {
        success: false,
        message: 'Sorry, there was an error submitting your feedback. Please try again later.'
      }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Unexpected error in LsaTdxFeedback: #{e.message}\n#{e.backtrace.join("\n")}"

      render json: {
        success: false,
        message: 'Sorry, there was an unexpected error. Please try again later.'
      }, status: :internal_server_error
    end

    def render_ticket_created(ticket_response)
      render json: {
        success: true,
        message: 'Thank you for your feedback! Your ticket has been created.',
        ticket_id: ticket_response['ID']
      }, status: :created
    end

    def deliver_via_fallback(feedback_data)
      LsaTdxFeedback.configuration.fallback.call(feedback_data)

      render json: {
        success: true,
        message: 'Thank you for your feedback!'
      }, status: :created
    rescue StandardError => e
      # A failing fallback must not surface as a 500 — report a retryable error.
      Rails.logger.error "LsaTdxFeedback: fallback delivery failed (#{e.class}: #{e.message})"

      render json: {
        success: false,
        message: 'Sorry, there was an error submitting your feedback. Please try again later.'
      }, status: :unprocessable_entity
    end

    def feedback_params
      params.require(:feedback).permit(:title, :feedback, :category, :email, :url, :user_agent, :additional_info)
    end

    def priority_from_category(category)
      case category&.downcase
      when 'bug', 'error', 'broken'
        21 # High priority
      when 'urgent', 'critical'
        22 # Emergency priority
      when 'suggestion', 'enhancement', 'feature'
        19 # Low priority
      else
        20 # Medium priority (default)
      end
    end
  end
end
