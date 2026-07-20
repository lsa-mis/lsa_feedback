module LsaTdxFeedback
  module ViewHelpers
    # Simple test method to verify helper is working
    def lsa_tdx_feedback_test
      "HELPER IS WORKING!".html_safe
    end

    # Renders the feedback modal and, by default, the floating trigger button.
    #
    # Pass trigger: false to render the modal WITHOUT the built-in floating
    # button, and open it yourself from your own control (a nav link, a footer
    # button, etc.) via `window.LsaTdxFeedback.showModal()`. Useful when the
    # fixed bottom-right button collides with other fixed page chrome, or when
    # you want feedback reachable from a specific place in your own UI.
    def lsa_tdx_feedback_modal(trigger: true)
      render(partial: 'lsa_tdx_feedback/shared/feedback_modal', locals: { trigger: trigger })
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

    # All-in-one helper that includes both modal and assets.
    # Passes trigger: through to lsa_tdx_feedback_modal (see there).
    def lsa_tdx_feedback(trigger: true)
      assets = lsa_tdx_feedback_assets
      modal = lsa_tdx_feedback_modal(trigger: trigger)
      (assets + modal).html_safe
    end
  end
end
