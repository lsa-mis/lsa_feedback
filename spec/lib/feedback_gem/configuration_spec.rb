require 'spec_helper'
require 'feedback_gem'

RSpec.describe FeedbackGem::Configuration do
  let(:config) { described_class.new }

  describe '#initialize' do
    it 'sets all values to nil for security' do
      expect(config.oauth_url).to be_nil
      expect(config.api_base_url).to be_nil
      expect(config.client_id).to be_nil
      expect(config.client_secret).to be_nil
      expect(config.app_id).to be_nil
      expect(config.default_type_id).to be_nil
      expect(config.default_form_id).to be_nil
      expect(config.default_classification).to be_nil
      expect(config.default_status_id).to be_nil
      expect(config.default_priority_id).to be_nil
      expect(config.default_source_id).to be_nil
      expect(config.default_responsible_group_id).to be_nil
      expect(config.default_service_id).to be_nil
      expect(config.service_offering_id).to be_nil
      expect(config.account_id).to be_nil
      expect(config.cache_expiry).to eq(3600)
    end
  end

  describe '#oauth_scope' do
    it 'returns the correct scope' do
      expect(config.oauth_scope).to eq('https://gw-test.api.it.umich.edu/um/it tdxticket')
    end
  end

  describe '#grant_type' do
    it 'returns client_credentials' do
      expect(config.grant_type).to eq('client_credentials')
    end
  end

  describe '#valid?' do
    context 'when all required values are present' do
      before do
        config.oauth_url = 'https://gw-test.api.it.umich.edu/um/oauth2'
        config.api_base_url = 'https://gw-test.api.it.umich.edu/um/it'
        config.client_id = 'test_id'
        config.client_secret = 'test_secret'
        config.app_id = 46
        config.default_type_id = 644
        config.default_form_id = 107
        config.default_classification = '46'
        config.default_status_id = 115
        config.default_priority_id = 20
        config.default_source_id = 8
        config.default_responsible_group_id = 388
        config.default_service_id = 2314
        config.service_offering_id = 289
        config.account_id = 21
      end

      it 'returns true' do
        expect(config.valid?).to be true
      end
    end

    context 'when required values are missing' do
      let(:all_required_values) do
        {
          oauth_url: 'https://gw-test.api.it.umich.edu/um/oauth2',
          api_base_url: 'https://gw-test.api.it.umich.edu/um/it',
          client_id: 'test_id',
          client_secret: 'test_secret',
          app_id: 46,
          default_type_id: 644,
          default_form_id: 107,
          default_classification: '46',
          default_status_id: 115,
          default_priority_id: 20,
          default_source_id: 8,
          default_responsible_group_id: 388,
          default_service_id: 2314,
          service_offering_id: 289,
          account_id: 21
        }
      end

      it 'returns false when oauth_url is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.oauth_url = nil
        expect(config.valid?).to be false
      end

      it 'returns false when api_base_url is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.api_base_url = nil
        expect(config.valid?).to be false
      end

      it 'returns false when client_id is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.client_id = nil
        expect(config.valid?).to be false
      end

      it 'returns false when client_secret is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.client_secret = nil
        expect(config.valid?).to be false
      end

      it 'returns false when app_id is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.app_id = nil
        expect(config.valid?).to be false
      end

      it 'returns false when service_offering_id is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.service_offering_id = nil
        expect(config.valid?).to be false
      end

      it 'returns false when account_id is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.account_id = nil
        expect(config.valid?).to be false
      end
    end
  end

  describe '#validate!' do
    context 'when all required values are present' do
      before do
        config.oauth_url = 'https://gw-test.api.it.umich.edu/um/oauth2'
        config.api_base_url = 'https://gw-test.api.it.umich.edu/um/it'
        config.client_id = 'test_id'
        config.client_secret = 'test_secret'
        config.app_id = 46
        config.default_type_id = 644
        config.default_form_id = 107
        config.default_classification = '46'
        config.default_status_id = 115
        config.default_priority_id = 20
        config.default_source_id = 8
        config.default_responsible_group_id = 388
        config.default_service_id = 2314
        config.service_offering_id = 289
        config.account_id = 21
      end

      it 'does not raise an error' do
        expect { config.validate! }.not_to raise_error
      end
    end

    context 'when required values are missing' do
      let(:all_required_values) do
        {
          oauth_url: 'https://gw-test.api.it.umich.edu/um/oauth2',
          api_base_url: 'https://gw-test.api.it.umich.edu/um/it',
          client_id: 'test_id',
          client_secret: 'test_secret',
          app_id: 46,
          default_type_id: 644,
          default_form_id: 107,
          default_classification: '46',
          default_status_id: 115,
          default_priority_id: 20,
          default_source_id: 8,
          default_responsible_group_id: 388,
          default_service_id: 2314,
          service_offering_id: 289,
          account_id: 21
        }
      end

      it 'raises an error when oauth_url is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.oauth_url = nil
        expect { config.validate! }.to raise_error(FeedbackGem::Error, 'oauth_url is required')
      end

      it 'raises an error when client_id is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.client_id = nil
        expect { config.validate! }.to raise_error(FeedbackGem::Error, 'client_id is required')
      end

      it 'raises an error when service_offering_id is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.service_offering_id = nil
        expect { config.validate! }.to raise_error(FeedbackGem::Error, 'service_offering_id is required')
      end

      it 'raises an error when account_id is missing' do
        all_required_values.each { |key, value| config.send("#{key}=", value) }
        config.account_id = nil
        expect { config.validate! }.to raise_error(FeedbackGem::Error, 'account_id is required')
      end
    end
  end
end
