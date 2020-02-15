# Simplecov
require 'simplecov'
SimpleCov.start

# Dependencies
require 'rubygems'
require 'bundler'
Bundler.require :default, :development

# Our gem
require 'secret_hub'
require 'secret_hub/cli'
include SecretHub

# Our spec helpers
require_relative 'fake_public_key'
require_relative 'spec_mixin'
include SpecMixin

# Use our mock server instead of the actual GitHub API
ENV['SECRET_HUB_API_BASE'] = 'http://localhost:3000'
begin
  HTTParty.get 'http://localhost:3000'
rescue Errno::ECONNREFUSED
  abort "\n==> ERROR: Please start the mock server using `run mockserver`\n\n"
end

# Dummy secrets for testing
ENV['GITHUB_ACCESS_TOKEN'] = 'who took my token?'
ENV['SECRET'] = 'there is no spoon'
ENV['PASSWORD'] = 'p4ssw0rd'
ENV['SECRET_KEY'] = '7h15-15-50m3-24nd0m-54mp13-k3y'

# Make some place for testing
system 'mkdir tmp' unless Dir.exist? 'tmp'

# Ensure terminal width consistency across tests
ENV['COLUMNS'] = '80'
ENV['LINES'] = '30'

# Configure rspec
RSpec.configure do |c|
  c.fixtures_path = 'spec/approvals'
  c.include SpecMixin
end
