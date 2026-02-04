lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secret_hub/version'

Gem::Specification.new do |s|
  s.name        = 'secret_hub'
  s.version     = SecretHub::VERSION
  s.summary     = 'Manage GitHub secrets over multiple repositories'
  s.description = 'Command line interface for managing GitHub secrets in bulk'
  s.authors     = ['Danny Ben Shitrit']
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['secrethub']
  s.homepage    = 'https://github.com/dannyben/secret_hub'
  s.license     = 'MIT'
  s.required_ruby_version = '>= 3.2'

  s.add_dependency 'colsole', '~> 1.0'
  s.add_dependency 'httparty', '~> 0.21'
  s.add_dependency 'lp', '~> 0.2'
  s.add_dependency 'mister_bin', '~> 0.9.0'
  s.add_dependency 'rackup', '~> 2.1'
  s.add_dependency 'rbnacl', '~> 7.1'
  s.add_dependency 'string-obfuscator', '~> 0.1'

  s.metadata = {
    'bug_tracker_uri'       => 'https://github.com/dannyben/secret_hub/issues',
    'changelog_uri'         => 'https://github.com/dannyben/secret_hub/blob/master/CHANGELOG.md',
    'source_code_uri'       => 'https://github.com/dannyben/secret_hub',
    'rubygems_mfa_required' => 'true',
  }
end
