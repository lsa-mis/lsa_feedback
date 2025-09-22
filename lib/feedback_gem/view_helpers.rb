module FeedbackGem
  module ViewHelpers
    # Renders the feedback modal and trigger button
    def feedback_gem_modal
      render partial: 'feedback_gem/shared/feedback_modal'
    end

    # Includes the feedback gem assets
    def feedback_gem_assets
      content_for :head do
        stylesheet_link_tag 'feedback_gem', 'data-turbo-track': 'reload'
      end +
      content_for :body do
        javascript_include_tag 'feedback_gem', 'data-turbo-track': 'reload'
      end
    end

    # All-in-one helper that includes both modal and assets
    def feedback_gem
      feedback_gem_assets + feedback_gem_modal
    end
  end
end
