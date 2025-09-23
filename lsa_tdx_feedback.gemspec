require_relative 'lib/lsa_tdx_feedback/version'

Gem::Specification.new do |spec|
  spec.name        = 'lsa_tdx_feedback'
  spec.version     = LsaTdxFeedback::VERSION
  spec.authors     = ['LSA Rails Team']
  spec.email       = ['lsa-was-rails-admins@umich.edu']
  spec.homepage    = 'https://github.com/lsa-mis/lsa_feedback'
  spec.summary     = 'A self-contained Rails gem for collecting user feedback via TDX API for LSA applications'
  spec.description = 'LsaTdxFeedback provides a zero-configuration solution for collecting user feedback in Rails applications. It includes a modal interface that integrates with TeamDynamix (TDX) API for ticket creation, requiring no additional setup or configuration from the host application.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'rails', '>= 6.0'
  spec.add_dependency 'httparty', '~> 0.22'
  spec.add_dependency 'redis', '>= 4.0'

  # Development dependencies
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-rails', '~> 5.0'
  spec.add_development_dependency 'factory_bot_rails', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency 'rubocop-rails', '~> 2.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
