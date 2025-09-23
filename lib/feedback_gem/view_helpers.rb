module FeedbackGem
  module ViewHelpers
    # Simple test method to verify helper is working
    def feedback_gem_test
      "HELPER IS WORKING!".html_safe
    end

    # Renders the feedback modal and trigger button
    def feedback_gem_modal
      render(partial: 'feedback_gem/shared/feedback_modal')
    end

    # Includes the feedback gem CSS
    def feedback_gem_css
      stylesheet_link_tag 'feedback_gem', 'data-turbo-track': 'reload', preload: false
    end

    # Includes the feedback gem JavaScript
    def feedback_gem_js
      javascript_include_tag 'feedback_gem', 'data-turbo-track': 'reload', defer: true
    end

    # Includes both CSS and JavaScript assets
    def feedback_gem_assets
      css = feedback_gem_css
      js = feedback_gem_js
      (css + js).html_safe
    end

    # All-in-one helper that includes both modal and assets
    def feedback_gem
      assets = feedback_gem_assets
      modal = feedback_gem_modal
      (assets + modal).html_safe
    end
  end
end
