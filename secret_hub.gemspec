lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'secret_hub/version'

Gem::Specification.new do |s|
  s.name        = 'secret_hub'
  s.version     = SecretHub::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Manage GitHub secrets over multiple repositories"
  s.description = "Command line interface for managing GitHub secrets in bulk"
  s.authors     = ["Danny Ben Shitrit"]
  s.email       = 'db@dannyben.com'
  s.files       = Dir['README.md', 'lib/**/*.*']
  s.executables = ['secrethub']
  s.homepage    = 'https://github.com/dannyben/secret_hub'
  s.license     = 'MIT'
  s.required_ruby_version = ">= 2.4.0"

  s.add_runtime_dependency 'mister_bin', '~> 0.7'
  s.add_runtime_dependency 'colsole', '~> 0.7'
  s.add_runtime_dependency 'httparty', '~> 0.17'
  s.add_runtime_dependency 'lp', '~> 0.2'
  s.add_runtime_dependency 'rbnacl', '~> 7.1'
  s.add_runtime_dependency 'string-obfuscator', '~> 0.1'
end
