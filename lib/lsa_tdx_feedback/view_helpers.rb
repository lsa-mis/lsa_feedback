module LsaTdxFeedback
  module ViewHelpers
    # Simple test method to verify helper is working
    def lsa_tdx_feedback_test
      "HELPER IS WORKING!".html_safe
    end

    # Renders the feedback modal and trigger button
    def lsa_tdx_feedback_modal
      render(partial: 'lsa_tdx_feedback/shared/feedback_modal')
    end

    # Includes the feedback gem CSS
    def lsa_tdx_feedback_css
      stylesheet_link_tag 'lsa_tdx_feedback', 'data-turbo-track': 'reload', preload: false
    end

    # Includes the feedback gem JavaScript
    def lsa_tdx_feedback_js
      javascript_include_tag 'lsa_tdx_feedback', 'data-turbo-track': 'reload', defer: true
    end

    # Includes both CSS and JavaScript assets
    def lsa_tdx_feedback_assets
      css = lsa_tdx_feedback_css
      js = lsa_tdx_feedback_js
      (css + js).html_safe
    end

    # All-in-one helper that includes both modal and assets
    def lsa_tdx_feedback
      assets = lsa_tdx_feedback_assets
      modal = lsa_tdx_feedback_modal
      (assets + modal).html_safe
    end
  end
end
