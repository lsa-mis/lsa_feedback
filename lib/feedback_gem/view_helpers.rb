module FeedbackGem
  module ViewHelpers
    # Renders the feedback modal and trigger button
    def feedback_gem_modal
      # Use raw to ensure HTML is properly rendered, not escaped
      raw(render partial: 'feedback_gem/shared/feedback_modal')
    end

    # Includes the feedback gem assets
    def feedback_gem_assets
      head_content = content_for(:head) do
        stylesheet_link_tag 'feedback_gem', 'data-turbo-track': 'reload'
      end

      body_content = content_for(:body) do
        javascript_include_tag 'feedback_gem', 'data-turbo-track': 'reload'
      end

      # Ensure we return a string, not nil
      (head_content || '') + (body_content || '')
    end

    # All-in-one helper that includes both modal and assets
    def feedback_gem
      feedback_gem_assets + feedback_gem_modal
    end
  end
end
