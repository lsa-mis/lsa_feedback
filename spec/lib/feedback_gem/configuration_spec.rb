RSpec.describe FeedbackGem::Configuration do
  let(:config) { described_class.new }

  describe "#initialize" do
    it "sets default values" do
      expect(config.oauth_url).to eq("https://gw-test.api.it.umich.edu/um/oauth2")
      expect(config.api_base_url).to eq("https://gw-test.api.it.umich.edu/um/it")
      expect(config.default_type_id).to eq(28)
      expect(config.default_form_id).to eq(20)
      expect(config.default_classification).to eq("46")
      expect(config.default_status_id).to eq(77)
      expect(config.default_priority_id).to eq(20)
      expect(config.default_source_id).to eq(8)
      expect(config.app_id).to eq(31)
      expect(config.default_service_id).to eq(67)
      expect(config.cache_expiry).to eq(3600)
    end

    it "sets required values to nil" do
      expect(config.client_id).to be_nil
      expect(config.client_secret).to be_nil
      expect(config.default_responsible_group_id).to be_nil
    end
  end

  describe "#oauth_scope" do
    it "returns the correct scope" do
      expect(config.oauth_scope).to eq("https://gw-test.api.it.umich.edu/um/it")
    end
  end

  describe "#grant_type" do
    it "returns client_credentials" do
      expect(config.grant_type).to eq("client_credentials")
    end
  end

  describe "#valid?" do
    context "when all required values are present" do
      before do
        config.client_id = "test_id"
        config.client_secret = "test_secret"
        config.default_responsible_group_id = 123
      end

      it "returns true" do
        expect(config.valid?).to be true
      end
    end

    context "when required values are missing" do
      it "returns false when client_id is missing" do
        config.client_secret = "test_secret"
        config.default_responsible_group_id = 123
        expect(config.valid?).to be false
      end

      it "returns false when client_secret is missing" do
        config.client_id = "test_id"
        config.default_responsible_group_id = 123
        expect(config.valid?).to be false
      end

      it "returns false when default_responsible_group_id is missing" do
        config.client_id = "test_id"
        config.client_secret = "test_secret"
        expect(config.valid?).to be false
      end
    end
  end

  describe "#validate!" do
    context "when all required values are present" do
      before do
        config.client_id = "test_id"
        config.client_secret = "test_secret"
        config.default_responsible_group_id = 123
      end

      it "does not raise an error" do
        expect { config.validate! }.not_to raise_error
      end
    end

    context "when required values are missing" do
      it "raises an error when client_id is missing" do
        config.client_secret = "test_secret"
        config.default_responsible_group_id = 123
        expect { config.validate! }.to raise_error(FeedbackGem::Error, "client_id is required")
      end

      it "raises an error when client_secret is missing" do
        config.client_id = "test_id"
        config.default_responsible_group_id = 123
        expect { config.validate! }.to raise_error(FeedbackGem::Error, "client_secret is required")
      end

      it "raises an error when default_responsible_group_id is missing" do
        config.client_id = "test_id"
        config.client_secret = "test_secret"
        expect { config.validate! }.to raise_error(FeedbackGem::Error, "default_responsible_group_id is required")
      end
    end
  end
end
