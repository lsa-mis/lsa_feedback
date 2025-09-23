module LsaTdxFeedback
  class FeedbackController < ::ApplicationController
    protect_from_forgery with: :exception
    before_action :set_lsa_tdx_feedback_data

    def create
      ticket_client = TicketClient.new

      # Build the title and include the app name if available
      title = feedback_params[:title].presence || "User Feedback - #{feedback_params[:category]}"

      if defined?(@lsa_tdx_feedback_app_name) && @lsa_tdx_feedback_app_name.present?
        title = "[#{@lsa_tdx_feedback_app_name}]: #{title}"
      end

      feedback_data = {
        title: title,
        feedback: feedback_params[:feedback],
        category: feedback_params[:category],
        email: feedback_params[:email],
        url: feedback_params[:url],
        user_agent: feedback_params[:user_agent],
        additional_info: feedback_params[:additional_info],
        priority_id: priority_from_category(feedback_params[:category])
      }

      begin
        ticket_response = ticket_client.create_feedback_ticket(feedback_data)

        render json: {
          success: true,
          message: 'Thank you for your feedback! Your ticket has been created.',
          ticket_id: ticket_response['ID']
        }, status: :created
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
    end

    private

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
