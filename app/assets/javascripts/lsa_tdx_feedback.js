/**
 * LsaTdxFeedback JavaScript - Self-contained feedback modal functionality
 * Turbo Drive compatible
 */
(function() {
  'use strict';

  var LsaTdxFeedback = {
    initialized: false,
    modal: null,
    form: null,
    handlers: {
      triggerClick: null,
      closeClick: null,
      cancelClick: null,
      backdropClick: null,
      formSubmit: null,
      escapeKey: null
    },

    init: function() {
      // Clean up existing listeners if already initialized (for Turbo navigation)
      if (this.initialized) {
        this.cleanup();
      }

      // Reset state for re-initialization
      this.initialized = false;
      this.modal = null;
      this.form = null;

      // Wait for DOM to be ready
      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', this.init.bind(this));
        return;
      }

      this.bindEvents();
      this.initialized = true;
    },

    cleanup: function() {
      // Remove all event listeners before re-initializing
      var self = this;

      if (this.handlers.triggerClick) {
        var triggerBtn = document.getElementById('lsa-tdx-feedback-trigger');
        if (triggerBtn) {
          triggerBtn.removeEventListener('click', this.handlers.triggerClick);
        }
      }

      if (this.modal) {
        var closeBtn = this.modal.querySelector('.lsa-tdx-feedback-close-btn');
        var cancelBtn = this.modal.querySelector('.lsa-tdx-feedback-cancel-btn');
        var backdrop = this.modal.querySelector('.lsa-tdx-feedback-modal-backdrop');

        if (closeBtn && this.handlers.closeClick) {
          closeBtn.removeEventListener('click', this.handlers.closeClick);
        }
        if (cancelBtn && this.handlers.cancelClick) {
          cancelBtn.removeEventListener('click', this.handlers.cancelClick);
        }
        if (backdrop && this.handlers.backdropClick) {
          backdrop.removeEventListener('click', this.handlers.backdropClick);
        }
      }

      if (this.form && this.handlers.formSubmit) {
        this.form.removeEventListener('submit', this.handlers.formSubmit);
      }

      if (this.handlers.escapeKey) {
        document.removeEventListener('keydown', this.handlers.escapeKey);
      }

      // Clear handler references
      this.handlers = {
        triggerClick: null,
        closeClick: null,
        cancelClick: null,
        backdropClick: null,
        formSubmit: null,
        escapeKey: null
      };
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
        this.handlers.triggerClick = function(e) {
          e.preventDefault();
          self.showModal();
        };
        triggerBtn.addEventListener('click', this.handlers.triggerClick);
      }

      // Close buttons
      var closeBtn = this.modal.querySelector('.lsa-tdx-feedback-close-btn');
      var cancelBtn = this.modal.querySelector('.lsa-tdx-feedback-cancel-btn');
      var backdrop = this.modal.querySelector('.lsa-tdx-feedback-modal-backdrop');

      if (closeBtn) {
        this.handlers.closeClick = function(e) {
          e.preventDefault();
          self.hideModal();
        };
        closeBtn.addEventListener('click', this.handlers.closeClick);
      }

      if (cancelBtn) {
        this.handlers.cancelClick = function(e) {
          e.preventDefault();
          self.hideModal();
        };
        cancelBtn.addEventListener('click', this.handlers.cancelClick);
      }

      if (backdrop) {
        this.handlers.backdropClick = function(e) {
          if (e.target === backdrop) {
            self.hideModal();
          }
        };
        backdrop.addEventListener('click', this.handlers.backdropClick);
      }

      // Form submission
      this.handlers.formSubmit = function(e) {
        e.preventDefault();
        self.submitFeedback();
      };
      this.form.addEventListener('submit', this.handlers.formSubmit);

      // Escape key to close modal
      this.handlers.escapeKey = function(e) {
        if (e.key === 'Escape' && self.modal && self.modal.style.display !== 'none') {
          self.hideModal();
        }
      };
      document.addEventListener('keydown', this.handlers.escapeKey);
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

  // Initialize on DOM ready (for traditional page loads)
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      LsaTdxFeedback.init();
    });
  } else {
    // DOM already loaded
    LsaTdxFeedback.init();
  }

  // Initialize on Turbo navigation (for Turbo Drive)
  document.addEventListener('turbo:load', function() {
    LsaTdxFeedback.init();
  });

  // Also handle turbo:frame-load for Turbo Frames (optional)
  document.addEventListener('turbo:frame-load', function(e) {
    // Only re-initialize if the frame contains our elements
    if (e.target.querySelector && e.target.querySelector('#lsa-tdx-feedback-trigger')) {
      LsaTdxFeedback.init();
    }
  });
})();
