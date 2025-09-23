require 'spec_helper'
require 'lsa_tdx_feedback'

RSpec.describe LsaTdxFeedback do
  it 'has a version number' do
    expect(LsaTdxFeedback::VERSION).not_to be nil
  end

  describe '.configuration' do
    it 'returns a Configuration instance' do
      expect(LsaTdxFeedback.configuration).to be_a(LsaTdxFeedback::Configuration)
    end

    it 'returns the same instance on multiple calls' do
      config1 = LsaTdxFeedback.configuration
      config2 = LsaTdxFeedback.configuration
      expect(config1).to be(config2)
    end
  end

  describe '.configure' do
    it 'yields the configuration instance' do
      expect { |b| LsaTdxFeedback.configure(&b) }.to yield_with_args(LsaTdxFeedback.configuration)
    end

    it 'allows setting configuration values' do
      LsaTdxFeedback.configure do |config|
        config.client_id = 'test_client_id'
        config.client_secret = 'test_client_secret'
      end

      expect(LsaTdxFeedback.configuration.client_id).to eq('test_client_id')
      expect(LsaTdxFeedback.configuration.client_secret).to eq('test_client_secret')
    end
  end

  describe '.reset_configuration!' do
    it 'creates a new configuration instance' do
      original_config = LsaTdxFeedback.configuration
      LsaTdxFeedback.reset_configuration!
      new_config = LsaTdxFeedback.configuration

      expect(new_config).not_to be(original_config)
      expect(new_config).to be_a(LsaTdxFeedback::Configuration)
    end
  end
end
