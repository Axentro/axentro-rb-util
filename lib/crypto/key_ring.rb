require "securerandom"

module Crypto::Keys
  include Crypto::Hashes

  MAINNET = { prefix: "M0", name: "mainnet" }
  TESTNET = { prefix: "T0", name: "testnet" }

  class KeyRing
    attr_reader :private_key
    attr_reader :public_key
    attr_reader :wif
    attr_reader :address
    attr_reader :address
    attr_reader :seed

    def initialize(private_key, public_key, wif, address, seed = nil)
      @private_key = private_key
      @public_key = public_key
      @wif = wif
      @address = address
      @seed = seed
    end

    def self.generate(network = MAINNET)
      key_pair = KeyUtils.create_new_keypair
      private_key = PrivateKey.new(key_pair[:hex_private_key], network)
      public_key = PublicKey.new(key_pair[:hex_public_key], network)
      KeyRing.new(private_key, public_key, private_key.wif, public_key.address)
    end

    def self.generate_hd(seed = nil, derivation = nil, network = MAINNET)
      _seed = seed.nil? ? SecureRandom.hex(64) : seed
      keys = (derivation.nil? || derivation.nil? && derivation == "m") ?
        HDKEY::KeyRing.get_master_key_from_seed(_seed) : HDKEY::KeyRing.derive_path(derivation, _seed, HDKEY::HARDENED_AXENTRO)

      private_key = PrivateKey.new(keys.private_key, network)
      _public_key = HDKEY::KeyRing.get_public_key(keys.private_key)
      public_key = KeyUtils.to_hex(KeyUtils.to_bytes(PublicKey.new(_public_key, network))[1..-1])
      KeyRing.new(private_key, public_key, private_key.wif, public_key.address, _seed)
    end

    def self.is_valid?(public_key, wif, address)
      address = Address.from(address)
      wif = Wif.new(wif)

      raise AxentroError, "network mismatch between address and wif" if address.network != wif.network

      public_key = PublicKey.from_hex(public_key, address.network)
      raise AxentroError, "public key mismatch between public key and wif" if public_key.as_hex != wif.public_key.as_hex

      true
    end
  end
end
