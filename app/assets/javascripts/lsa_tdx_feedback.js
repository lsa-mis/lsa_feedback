/**
 * LsaTdxFeedback JavaScript - Self-contained feedback modal functionality
 */
(function() {
  'use strict';

  // Ensure we don't initialize multiple times
  if (window.LsaTdxFeedback && window.LsaTdxFeedback.initialized) {
    return;
  }

  var LsaTdxFeedback = {
    initialized: false,
    modal: null,
    form: null,

    init: function() {
      if (this.initialized) return;

      // Wait for DOM to be ready
      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', this.init.bind(this));
        return;
      }

      this.bindEvents();
      this.initialized = true;
    },

    bindEvents: function() {
      var self = this;

      // Get modal and form elements
      this.modal = document.getElementById('lsa-tdx-feedback-modal');
      this.form = document.getElementById('lsa-tdx-feedback-form');

      if (!this.modal || !this.form) {
        console.warn('LsaTdxFeedback: Modal or form not found. Make sure to include the feedback modal partial.');
        return;
      }

      // Trigger button
      var triggerBtn = document.getElementById('lsa-tdx-feedback-trigger');
      if (triggerBtn) {
        triggerBtn.addEventListener('click', function(e) {
          e.preventDefault();
          self.showModal();
        });
      }

      // Close buttons
      var closeBtn = this.modal.querySelector('.lsa-tdx-feedback-close-btn');
      var cancelBtn = this.modal.querySelector('.lsa-tdx-feedback-cancel-btn');
      var backdrop = this.modal.querySelector('.lsa-tdx-feedback-modal-backdrop');

      if (closeBtn) {
        closeBtn.addEventListener('click', function(e) {
          e.preventDefault();
          self.hideModal();
        });
      }

      if (cancelBtn) {
        cancelBtn.addEventListener('click', function(e) {
          e.preventDefault();
          self.hideModal();
        });
      }

      if (backdrop) {
        backdrop.addEventListener('click', function(e) {
          if (e.target === backdrop) {
            self.hideModal();
          }
        });
      }

      // Form submission
      this.form.addEventListener('submit', function(e) {
        e.preventDefault();
        self.submitFeedback();
      });

      // Escape key to close modal
      document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && self.modal.style.display !== 'none') {
          self.hideModal();
        }
      });
    },

    showModal: function() {
      if (!this.modal) return;

      this.modal.style.display = 'block';
      document.body.style.overflow = 'hidden';

      // Focus on first input
      var firstInput = this.modal.querySelector('select, input, textarea');
      if (firstInput) {
        setTimeout(function() {
          firstInput.focus();
        }, 100);
      }

      this.hideMessage();
    },

    hideModal: function() {
      if (!this.modal) return;

      this.modal.style.display = 'none';
      document.body.style.overflow = '';
      this.resetForm();
      this.hideMessage();
    },

    resetForm: function() {
      if (!this.form) return;

      this.form.reset();
      this.setSubmitButtonState(false);
    },

    submitFeedback: function() {
      var self = this;
      var formData = new FormData(this.form);

      // Basic validation
      var feedback = formData.get('feedback');
      if (!feedback || feedback.trim().length === 0) {
        this.showMessage('Please enter your feedback.', 'error');
        return;
      }

      this.setSubmitButtonState(true);
      this.hideMessage();

      // Get CSRF token
      var csrfToken = this.getCSRFToken();

      // Prepare data
      var data = {
        feedback: {
          category: formData.get('category'),
          feedback: feedback,
          email: formData.get('email'),
          url: formData.get('url'),
          user_agent: formData.get('user_agent'),
          additional_info: formData.get('additional_info')
        }
      };

      // Submit via fetch
      fetch('/lsa_tdx_feedback/feedback', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify(data)
      })
      .then(function(response) {
        return response.json().then(function(data) {
          return { response: response, data: data };
        });
      })
      .then(function(result) {
        self.setSubmitButtonState(false);

        if (result.response.ok && result.data.success) {
          self.showMessage(result.data.message || 'Thank you for your feedback!', 'success');
          setTimeout(function() {
            self.hideModal();
          }, 2000);
        } else {
          self.showMessage(result.data.message || 'There was an error submitting your feedback.', 'error');
        }
      })
      .catch(function(error) {
        console.error('LsaTdxFeedback submission error:', error);
        self.setSubmitButtonState(false);
        self.showMessage('There was an error submitting your feedback. Please try again.', 'error');
      });
    },

    setSubmitButtonState: function(loading) {
      var submitBtn = this.modal.querySelector('.lsa-tdx-feedback-submit-btn');
      var btnText = submitBtn.querySelector('.lsa-tdx-feedback-btn-text');
      var spinner = submitBtn.querySelector('.lsa-tdx-feedback-loading-spinner');

      if (loading) {
        submitBtn.disabled = true;
        btnText.style.display = 'none';
        spinner.style.display = 'inline-flex';
      } else {
        submitBtn.disabled = false;
        btnText.style.display = 'inline';
        spinner.style.display = 'none';
      }
    },

    showMessage: function(message, type) {
      var messageEl = document.getElementById('lsa-tdx-feedback-message');
      var contentEl = messageEl.querySelector('.lsa-tdx-feedback-message-content');

      contentEl.textContent = message;
      messageEl.className = 'lsa-tdx-feedback-message ' + (type || 'info');
      messageEl.style.display = 'block';
    },

    hideMessage: function() {
      var messageEl = document.getElementById('lsa-tdx-feedback-message');
      if (messageEl) {
        messageEl.style.display = 'none';
      }
    },

    getCSRFToken: function() {
      var token = document.querySelector('meta[name="csrf-token"]');
      return token ? token.getAttribute('content') : '';
    }
  };

  // Export to global scope
  window.LsaTdxFeedback = LsaTdxFeedback;

  // Auto-initialize
  LsaTdxFeedback.init();
})();
