require 'yaml'

module SecretHub
  class Config
    attr_reader :data

    def self.load(config_file)
      raise ConfigurationError, "Config file not found #{config_file}" unless File.exist? config_file

      new YAML.load_file config_file, aliases: true
    rescue ArgumentError
      # :nocov:
      new YAML.load_file config_file
      # :nocov:
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
      data.each do |repo, config|
        next unless repo.include? '/'

        # Handle old format where all items were secrets
        if config.is_a?(Array) || (config.is_a?(Hash) && !config.key?('secrets') && !config.key?('variables'))
          result[repo] = resolve_secrets(config)
          next
        end

        result[repo] = {}
        config['secrets'] ||= []
        config['variables'] ||= []

        result[repo].merge!(resolve_secrets(config['secrets']))
        result[repo].merge!(resolve_secrets(config['variables']))
      end
      result
    end

    def resolve_secrets(secrets)
      secrets ||= []

      case secrets
      when Hash
        secrets.to_h { |key, value| [key, (value || ENV[key])&.to_s] }
      when Array
        secrets.to_h { |key| [key, ENV[key]] }
      end
    end
  end
end
