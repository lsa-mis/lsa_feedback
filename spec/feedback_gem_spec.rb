require 'spec_helper'
require 'feedback_gem'

RSpec.describe FeedbackGem do
  it 'has a version number' do
    expect(FeedbackGem::VERSION).not_to be nil
  end

  describe '.configuration' do
    it 'returns a Configuration instance' do
      expect(FeedbackGem.configuration).to be_a(FeedbackGem::Configuration)
    end

    it 'returns the same instance on multiple calls' do
      config1 = FeedbackGem.configuration
      config2 = FeedbackGem.configuration
      expect(config1).to be(config2)
    end
  end

  describe '.configure' do
    it 'yields the configuration instance' do
      expect { |b| FeedbackGem.configure(&b) }.to yield_with_args(FeedbackGem.configuration)
    end

    it 'allows setting configuration values' do
      FeedbackGem.configure do |config|
        config.client_id = 'test_client_id'
        config.client_secret = 'test_client_secret'
      end

      expect(FeedbackGem.configuration.client_id).to eq('test_client_id')
      expect(FeedbackGem.configuration.client_secret).to eq('test_client_secret')
    end
  end

  describe '.reset_configuration!' do
    it 'creates a new configuration instance' do
      original_config = FeedbackGem.configuration
      FeedbackGem.reset_configuration!
      new_config = FeedbackGem.configuration

      expect(new_config).not_to be(original_config)
      expect(new_config).to be_a(FeedbackGem::Configuration)
    end
  end
end
