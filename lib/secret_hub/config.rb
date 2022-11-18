require 'yaml'

module SecretHub
  class Config
    attr_reader :data

    def self.load(config_file)
      raise ConfigurationError, "Config file not found #{config_file}" unless File.exist? config_file

      new YAML.load_file config_file, aliases: true
    rescue ArgumentError
      new YAML.load_file config_file
    end

    def initialize(data)
      @data = data
    end

    def to_h
      @to_h ||= to_h!
    end

    def each(&block)
      to_h.each(&block)
    end

    def each_repo(&block)
      to_h.keys.each(&block)
    end

  private

    def to_h!
      result = {}
      data.each do |repo, secrets|
        next unless repo.include? '/'

        result[repo] = resolve_secrets secrets
      end
      result
    end

    def resolve_secrets(secrets)
      secrets ||= []

      case secrets
      when Hash
        secrets.to_h { |key, value| [key, value || ENV[key]] }
      when Array
        secrets.to_h { |key| [key, ENV[key]] }
      end
    end
  end
end
