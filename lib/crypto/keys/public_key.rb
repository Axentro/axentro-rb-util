module Crypto::Keys
    class PublicKey
        attr_reader :network

        def initialize(public_key_hex, network = MAINNET)
            @public_key_hex = public_key_hex
            @network = network
            raise AxentroError, "invalid public key: #{@public_key_hex}" unless is_valid?
        end

        def self.from_hex(hex, network = MAINNET)
            PublicKey.new(hex, network)
        end

        def self.from_bytes(bytes, network = MAINNET)
            PublicKey.new(KeyUtils.to_hex(bytes), network)
        end

        def as_hex
            @public_key_hex
        end

        def as_bytes
         KeyUtils.to_bytes(@public_key_hex)
        end

        def address
            Address.new(KeyUtils.get_address_from_public_key(self), @network)
        end

        def is_valid?
            !@public_key_hex.nil? && @public_key_hex.size == 64
        end
    end
end