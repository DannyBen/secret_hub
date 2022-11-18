require 'spec_helper'

describe Sodium do
  subject { Class.new { include Sodium }.new }
  let(:secret) { 'there is no spoon' }

  describe '#encrypt' do
    before do
      # Prepare a public/private key pair
      @private_key = RbNaCl::PrivateKey.generate
      @public_key  = @private_key.public_key

      # Base64 encode the public key - this is how GitHub API returns it
      @base64_encoded_public_key = Base64.encode64 @public_key
    end

    it 'returns an encrypted and base64-encoded string' do
      # Encrypt, using the method under test
      babse64_encrypted = subject.encrypt secret, @base64_encoded_public_key

      # Base64 decode it, since the method encodes it before transport to
      # GitHub
      encrypted = Base64.strict_decode64 babse64_encrypted

      # Decrypt it using our matching private key
      box = RbNaCl::Boxes::Sealed.from_private_key @private_key
      plain = box.decrypt encrypted

      # Compare it to the original plain secret. Boom.
      expect(plain).to eq secret
    end
  end
end
