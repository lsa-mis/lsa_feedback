module FeedbackGem
  module ViewHelpers
    # Simple test method to verify helper is working
    def feedback_gem_test
      "HELPER IS WORKING!".html_safe
    end

    # Renders the feedback modal and trigger button
    def feedback_gem_modal
      html_content = <<~HTML
        <!-- FeedbackGem Modal -->
        <div id="feedback-gem-modal" class="feedback-gem-modal" style="display: none;">
          <div class="feedback-gem-modal-backdrop"></div>
          <div class="feedback-gem-modal-content">
            <div class="feedback-gem-modal-header">
              <h2>Send Feedback</h2>
              <button type="button" class="feedback-gem-close-btn" aria-label="Close">&times;</button>
            </div>

            <div class="feedback-gem-modal-body">
              <form id="feedback-gem-form">
                <div class="feedback-gem-form-group">
                  <label for="feedback-gem-category">Category</label>
                  <select id="feedback-gem-category" name="category" required>
                    <option value="">Select a category</option>
                    <option value="bug">Bug Report</option>
                    <option value="suggestion">Suggestion</option>
                    <option value="feature">Feature Request</option>
                    <option value="general">General Feedback</option>
                    <option value="other">Other</option>
                  </select>
                </div>

                <div class="feedback-gem-form-group">
                  <label for="feedback-gem-feedback">Your Feedback *</label>
                  <textarea
                    id="feedback-gem-feedback"
                    name="feedback"
                    required
                    rows="5"
                    placeholder="Please describe your feedback in detail..."
                  ></textarea>
                </div>

                <div class="feedback-gem-form-group">
                  <label for="feedback-gem-email">Your Email</label>
                  <input
                    type="email"
                    id="feedback-gem-email"
                    name="email"
                    placeholder="your.email@example.com"
                  >
                  <small class="feedback-gem-help-text">Optional - We'll only use this to follow up if needed</small>
                </div>

                <div class="feedback-gem-form-group">
                  <label for="feedback-gem-additional-info">Additional Information</label>
                  <textarea
                    id="feedback-gem-additional-info"
                    name="additional_info"
                    rows="3"
                    placeholder="Any additional context or information..."
                  ></textarea>
                </div>

                <!-- Hidden fields for context -->
                <input type="hidden" name="url" value="">
                <input type="hidden" name="user_agent" value="">
              </form>
            </div>

            <div class="feedback-gem-modal-footer">
              <button type="button" class="feedback-gem-btn feedback-gem-btn-secondary feedback-gem-cancel-btn">
                Cancel
              </button>
              <button type="submit" form="feedback-gem-form" class="feedback-gem-btn feedback-gem-btn-primary feedback-gem-submit-btn">
                <span class="feedback-gem-btn-text">Send Feedback</span>
                <span class="feedback-gem-loading-spinner" style="display: none;">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
                    <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" opacity="0.25"/>
                    <path d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" fill="currentColor"/>
                  </svg>
                  Sending...
                </span>
              </button>
            </div>

            <!-- Success/Error Messages -->
            <div id="feedback-gem-message" class="feedback-gem-message" style="display: none;">
              <div class="feedback-gem-message-content"></div>
            </div>
          </div>
        </div>

        <!-- Feedback Button -->
        <button id="feedback-gem-trigger" class="feedback-gem-trigger-btn" title="Send Feedback">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M20 2H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h4l4 4 4-4h4c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-2 12H6v-2h12v2zm0-3H6V9h12v2zm0-3H6V6h12v2z"/>
          </svg>
          <span class="feedback-gem-trigger-text">Feedback</span>
        </button>
      HTML

      html_content.html_safe
    end

    # Includes the feedback gem assets
    def feedback_gem_assets
      head_content = content_for(:head) do
        stylesheet_link_tag 'feedback_gem', 'data-turbo-track': 'reload', preload: false
      end

      body_content = content_for(:body) do
        javascript_include_tag 'feedback_gem', 'data-turbo-track': 'reload', defer: true
      end

      # Ensure we return a string, not nil
      (head_content || '') + (body_content || '')
    end

    # All-in-one helper that includes both modal and assets
    def feedback_gem
      assets = feedback_gem_assets || ''
      modal = feedback_gem_modal || ''
      (assets + modal).html_safe
    end
  end
end
