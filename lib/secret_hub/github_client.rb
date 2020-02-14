require "base64"
require 'httparty'
require 'rbnacl'

module SecretHub
  class GitHubClient
    include HTTParty
    
    base_uri 'https://api.github.com'

    # GET /repos/:owner/:repo/actions/secrets/public-key
    def public_key(repo)
      public_keys[repo] ||= get("/repos/#{repo}/actions/secrets/public-key")
    end

    def public_keys
      @public_keys ||= {}
    end

    # GET /repos/:owner/:repo/actions/secrets
    def secrets(repo)
      response = get "/repos/#{repo}/actions/secrets"
      response['secrets'].map { |s| s['name'] }
    end

    # PUT /repos/:owner/:repo/actions/secrets/:name
    def put_secret(repo, name, value)
      secret = encrypt_for_repo repo, value
      key_id = public_key(repo)['key_id']
      put "/repos/#{repo}/actions/secrets/#{name}",
        encrypted_value: secret, 
        key_id: key_id
    end

    # DELETE /repos/:owner/:repo/actions/secrets/:name
    def delete_secret(repo, name)
      delete "/repos/#{repo}/actions/secrets/#{name}"
    end

  private

    def encrypt_for_repo(repo, secret)
      public_key = public_key(repo)['key']
      encrypt secret, public_key
    end

    def encrypt(secret, public_key)
      key = Base64.decode64 public_key
      public_key = RbNaCl::PublicKey.new key

      box = RbNaCl::Boxes::Sealed.from_public_key public_key
      encrypted_secret = box.encrypt secret

      Base64.strict_encode64 encrypted_secret
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
        "Authorization" => "token #{secret_token}",
        "User-Agent" =>    "SecretHub Gem"
      }
    end

    def secret_token
      ENV['GITHUB_ACCESS_TOKEN'] || raise(EnvironmentError, "Please set GITHUB_ACCESS_TOKEN")
    end

  end
end
