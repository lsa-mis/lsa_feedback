require 'spec_helper'
require 'active_support/core_ext/string/output_safety' # String#html_safe
require 'lsa_tdx_feedback'

RSpec.describe LsaTdxFeedback::ViewHelpers do
  # A minimal includer standing in for the ActionView context. `render` is
  # defined here so `verify_partial_doubles` can verify the stub (it is provided
  # by ActionView at runtime, not by the module under test).
  let(:view) do
    Class.new do
      include LsaTdxFeedback::ViewHelpers
      def render(*); end
    end.new
  end

  describe '#lsa_tdx_feedback_modal' do
    it 'renders the trigger by default (trigger: true local)' do
      expect(view).to receive(:render).with(
        partial: 'lsa_tdx_feedback/shared/feedback_modal',
        locals: { trigger: true }
      )
      view.lsa_tdx_feedback_modal
    end

    it 'omits the trigger when trigger: false' do
      expect(view).to receive(:render).with(
        partial: 'lsa_tdx_feedback/shared/feedback_modal',
        locals: { trigger: false }
      )
      view.lsa_tdx_feedback_modal(trigger: false)
    end
  end

  describe '#lsa_tdx_feedback' do
    it 'threads trigger: through to the modal' do
      allow(view).to receive(:lsa_tdx_feedback_assets).and_return('')
      expect(view).to receive(:render).with(
        partial: 'lsa_tdx_feedback/shared/feedback_modal',
        locals: { trigger: false }
      ).and_return('')
      view.lsa_tdx_feedback(trigger: false)
    end
  end
end
