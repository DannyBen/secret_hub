require "base64"
require 'rbnacl'



  private_key = RbNaCl::PrivateKey.generate
  public_key  = private_key.public_key
end
