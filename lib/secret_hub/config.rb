require 'yaml'

module SecretHub
  class Config
    attr_reader :data

    def self.load(config_file)
      raise ConfigurationError, "Config file not found #{config_file}" unless File.exist? config_file
      new YAML.load_file config_file
    end

    def initialize(data)
      @data = data
    end

    def to_h
      @to_h ||= to_h!
    end

    def each(&block)
      to_h.each &block
    end

    def each_repo(&block)
      to_h.keys.each &block
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
      secrets = [] unless secrets
      
      if secrets.is_a? Hash
        secrets.map { |key, value| [key, value || ENV[key]] }.to_h
      elsif secrets.is_a? Array
        secrets.map { |key| [key, ENV[key]] }.to_h
      end
    end
  end
end
