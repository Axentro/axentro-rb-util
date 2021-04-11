module Crypto::Keys
    class Wif
        def initialize(wif_hex)
            @wif_hex = wif_hex
            raise AxentroError, "invalid wif: #{@wif_hex}" unless is_valid?
        end

        def as_hex
            @wif_hex
        end

        def self.from(private_key, network = MAINNET)
            wif = KeyUtils.to_wif(private_key, network)
            raise AxentroError, "invalid wif: #{wif.as_hex}" unless wif.is_valid?
            wif
        end

        def private_key
            KeyUtils.from_wif(self)[:private_key]
        end

        def public_key
            KeyUtils.from_wif(self)[:private_key].public_key
        end

        def network
            KeyUtils.from_wif(self)[:network]
        end

        def address 
            res = KeyUtils.from_wif(self)
            public_key = res[:private_key].public_key
            network = res[:network]
            Address.new(KeyUtils.get_address_from_public_key(public_key), network)
        end

        def is_valid?
            begin
            decoded_wif = Base64.strict_decode64(@wif_hex)
            network_key = decoded_wif[0..-7]
            hashed_key = Crypto::Hashes.sha256(Crypto::Hashes.sha256(network_key))
            checksum = hashed_key[0..5]
            checksum == decoded_wif[-6..-1]
            rescue 
                false
            end
        end
    end
end