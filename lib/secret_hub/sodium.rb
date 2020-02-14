require "base64"
require 'rbnacl'

module SecretHub
  module Sodium
    def encrypt(secret, public_key)
      key = Base64.decode64 public_key
      public_key = RbNaCl::PublicKey.new key

      box = RbNaCl::Boxes::Sealed.from_public_key public_key
      encrypted_secret = box.encrypt secret

      Base64.strict_encode64 encrypted_secret
    end
  end
end
