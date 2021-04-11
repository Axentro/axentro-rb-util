require "digest"

module Crypto::Hashes
  extend self

  def sha256(base)
    Digest::SHA256.hexdigest(base)
  end

  def ripemd160(base)
    Digest::RMD160.hexdigest(base)
  end
end
