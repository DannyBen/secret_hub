module SecretHub
  SecretHubError = Class.new StandardError
  ConfigurationError = Class.new SecretHubError
  MissingSecretError = Class.new SecretHubError
  
  class APIError < SecretHubError
    attr_reader :response

    def initialize(response)
      @response = response
      super "[#{response.code}] #{response.body}"
    end
  end
end