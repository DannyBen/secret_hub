require 'httparty'
require 'secret_hub/sodium'

module SecretHub
  class GitHubClient
    include Sodium
    include HTTParty

    def initialize
      self.class.base_uri ENV['SECRET_HUB_API_BASE'] || 'https://api.github.com'
    end

    # GET /repos/:owner/:repo/actions/secrets/public-key
    # GET /orgs/:org/actions/secrets/public-key
    def public_key(repo_or_org)
      if repo_or_org.include? '/'
        repo = repo_or_org
        public_keys[repo_or_org] ||= get("/repos/#{repo}/actions/secrets/public-key")
      else
        org = repo_or_org
        public_keys[repo_or_org] ||= get("/orgs/#{org}/actions/secrets/public-key")
      end
    end

    # GET /repos/:owner/:repo/actions/secrets
    def secrets(repo)
      response = get "/repos/#{repo}/actions/secrets"
      response['secrets'].map { |s| s['name'] }
    end

    # GET /orgs/:org/actions/secrets
    def org_secrets(org)
      response = get "/orgs/#{org}/actions/secrets"
      response['secrets'].map { |s| s['name'] }
    end

    # PUT /repos/:owner/:repo/actions/secrets/:name
    def put_secret(repo, name, value)
      secret = encrypt_for repo, value
      key_id = public_key(repo)['key_id']
      put "/repos/#{repo}/actions/secrets/#{name}",
        encrypted_value: secret,
        key_id:          key_id
    end

    # PUT /orgs/:org/actions/secrets/:secret_name
    def put_org_secret(org, name, value)
      secret = encrypt_for org, value
      key_id = public_key(org)['key_id']
      put "/orgs/#{org}/actions/secrets/#{name}",
        encrypted_value: secret,
        key_id:          key_id,
        visibility:      'private'
    end

    # DELETE /repos/:owner/:repo/actions/secrets/:name
    def delete_secret(repo, name)
      delete "/repos/#{repo}/actions/secrets/#{name}"
    end

    # DELETE /orgs/:org/actions/secrets/:secret_name
    def delete_org_secret(org, name)
      delete "/orgs/#{org}/actions/secrets/#{name}"
    end

  private

    def public_keys
      @public_keys ||= {}
    end

    def encrypt_for(repo_or_org, secret)
      public_key = public_key(repo_or_org)['key']
      encrypt secret, public_key
    end

    def get(url)
      response = self.class.get(url, request_options)
      response.success? or raise APIError, response
      response.parsed_response
    end

    def put(url, args = {})
      options = { body: args.to_json }
      all_options = request_options.merge options
      response = self.class.put url, all_options
      response.success? or raise APIError, response
    end

    def delete(url)
      response = self.class.delete url, request_options
      response.success? or raise APIError, response
    end

    def request_options
      { headers: headers }
    end

    def headers
      {
        'Authorization' => "token #{secret_token}",
        'User-Agent'    => 'SecretHub Gem',
      }
    end

    def secret_token
      ENV['GITHUB_ACCESS_TOKEN'] || raise(ConfigurationError, 'Please set GITHUB_ACCESS_TOKEN')
    end
  end
end
