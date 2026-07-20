require 'spec_helper'
require 'rails' # the module under test calls Rails.logger / Rails.application
require 'lsa_tdx_feedback'

RSpec.describe LsaTdxFeedback::ApplicationControllerExtensions do
  # The engine includes this module into ActionController::Base via
  # `on_load :action_controller`, so it runs on EVERY controller — including
  # ones that never define `current_user`: ViewComponent's preview controller,
  # Rails::HealthController, ActiveStorage's controllers, and so on.
  let(:controller_class) do
    Class.new do
      # ActiveSupport::Concern's `included` block calls this on the includer.
      def self.before_action(*); end

      include LsaTdxFeedback::ApplicationControllerExtensions

      def request
        Struct.new(:original_url, :user_agent).new('http://test.host/page', 'RSpec/1.0')
      end
    end
  end

  let(:controller) { controller_class.new }

  before { Rails.logger ||= Logger.new(IO::NULL) }

  describe '#set_lsa_tdx_feedback_data' do
    context 'on a controller that does not define current_user' do
      it 'does not raise' do
        expect { controller.send(:set_lsa_tdx_feedback_data) }.not_to raise_error
      end

      it 'still captures the request context for the modal' do
        controller.send(:set_lsa_tdx_feedback_data)

        expect(controller.instance_variable_get(:@lsa_tdx_feedback_current_url))
          .to eq('http://test.host/page')
        expect(controller.instance_variable_get(:@lsa_tdx_feedback_user_agent))
          .to eq('RSpec/1.0')
      end

      it 'leaves the user email unset rather than guessing' do
        controller.send(:set_lsa_tdx_feedback_data)

        expect(controller.instance_variable_get(:@lsa_tdx_feedback_user_email)).to be_nil
      end
    end

    context 'on a controller that does define current_user' do
      let(:controller_class) do
        Class.new do
          def self.before_action(*); end

          include LsaTdxFeedback::ApplicationControllerExtensions

          def request
            Struct.new(:original_url, :user_agent).new('http://test.host/page', 'RSpec/1.0')
          end

          def current_user
            Struct.new(:email).new('user@example.com')
          end
        end
      end

      it 'prefills the email from current_user' do
        controller.send(:set_lsa_tdx_feedback_data)

        expect(controller.instance_variable_get(:@lsa_tdx_feedback_user_email))
          .to eq('user@example.com')
      end
    end
  end
end
