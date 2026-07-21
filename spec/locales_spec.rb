require 'spec_helper'
require 'lsa_tdx_feedback' # load the full module so the shared reset hook is defined
require 'yaml'

RSpec.describe 'lsa_tdx_feedback locales' do
  let(:root) { File.expand_path('..', __dir__) }
  let(:data) { YAML.safe_load_file(File.join(root, 'config/locales/en.yml')) }

  def flatten_keys(hash, prefix = nil)
    hash.flat_map do |key, value|
      path = [prefix, key].compact.join('.')
      value.is_a?(Hash) ? flatten_keys(value, path) : [path]
    end
  end

  it 'is valid YAML rooted at "en"' do
    expect(data).to be_a(Hash)
    expect(data.keys).to eq(['en'])
  end

  it 'scopes everything under lsa_tdx_feedback (no host-colliding top-level keys)' do
    expect(data['en'].keys).to eq(['lsa_tdx_feedback'])
  end

  it 'defines every lsa_tdx_feedback.* key the modal partial references' do
    view = File.read(File.join(root, 'app/views/lsa_tdx_feedback/shared/_feedback_modal.html.erb'))
    referenced = view.scan(/t\('(lsa_tdx_feedback\.[a-z_.]+)'\)/).flatten.uniq
    defined_keys = flatten_keys(data['en'])

    expect(referenced).not_to be_empty
    referenced.each do |key|
      expect(defined_keys).to include(key), "view references undefined locale key: #{key}"
    end
  end

  it 'declares the floating trigger id only once (avoids a dead stacked duplicate button)' do
    view = File.read(File.join(root, 'app/views/lsa_tdx_feedback/shared/_feedback_modal.html.erb'))
    expect(view.scan(/id="lsa-tdx-feedback-trigger"/).size).to eq(1)
  end
end
