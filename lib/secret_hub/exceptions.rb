module SecretHub
  class SecretHubError < StandardError
  end

  class ConfigurationError < SecretHubError
  end

  class InvalidInput < SecretHubError
  end

  class APIError < SecretHubError
    attr_reader :response

    def initialize(response)
      @response = response
      super "[#{response.code}] #{response.body}"
    end
  end
end
