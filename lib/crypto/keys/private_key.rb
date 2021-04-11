module Crypto::Keys
    class PrivateKey
        attr_reader :network

        def initialize(private_key_hex, network = MAINNET)
            @private_key_hex = private_key_hex
            @network = network
            raise AxentroError, "invalid private key: '#{@private_key_hex}'" unless is_valid?
        end

        def self.from_hex(hex, network = MAINNET)
            PrivateKey.new(hex, network)
        end

        def self.from_bytes(bytes, network = MAINNET)
            PrivateKey.new(KeyUtils.to_hex(bytes), network)
        end

        def as_hex
            @private_key_hex
        end

        def as_bytes
            KeyUtils.to_bytes(@private_key_hex)
        end

        def wif 
            Wif.from(self, @network)
        end

        def public_key
            signing_key = Ed25519::SigningKey.new([@private_key_hex].pack("H*"))
            hex_public_key = signing_key.keypair.unpack("H*").first[64..-1]
            PublicKey.new(hex_public_key, @network)
        end

        def address 
            Address.new(KeyUtils.get_address_from_public_key(self.public_key), @network)
        end

        def is_valid?
            !@private_key_hex.nil? && @private_key_hex.size == 64
        end
    end
end