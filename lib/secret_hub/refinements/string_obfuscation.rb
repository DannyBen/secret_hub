require 'string-obfuscator'

module SecretHub
  module StringObfuscation
    refine String do
      def obfuscate
        text = dup
        trim = false

        if text.size > 40
          trim = true
          text = text[0..40]
        end

        result = StringObfuscator.obfuscate text,
          percent:               60,
          min_obfuscated_length: 5

        trim ? "#{result}..." : result
      end
    end
  end
end
