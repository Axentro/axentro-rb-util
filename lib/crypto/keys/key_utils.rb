module Crypto::Keys
    class KeyUtils
        def self.verify_signature(message, signature_hex, hex_public_key)
            begin
            verify_key = Ed25519::VerifyKey.new([hex_public_key].pack("H*"))
            verify_key.verify([signature_hex].pack("H*"), message)
            rescue => e
                raise AxentroError, "Verify fail: #{e.message}"
            end
        end

        def self.sign(hex_private_key, message)
            signing_key = Ed25519::SigningKey.new([hex_private_key].pack("H*"))
            signing_key.sign(message).unpack("H*").first
        end

        def self.create_new_keypair
            signing_key = Ed25519::SigningKey.generate
            private_key = signing_key.keypair.unpack("H*").first[0..63]
            public_key = signing_key.keypair.unpack("H*").first[64..-1]
            {
                hex_private_key: private_key,
                hex_public_key: public_key
            }
        end

        def self.to_hex(bytes)
            bytes.pack("c*").unpack("H*").first
        end

        def self.to_bytes(hex)
            [hex].pack('H*').bytes.to_a
        end

        def self.get_address_from_public_key(public_key)
            hashed_address = Crypto::Hashes.ripemd160(Crypto::Hashes.sha256(public_key.as_hex))
            network_address = public_key.network[:prefix] + hashed_address
            hashed_address_again = Crypto::Hashes.sha256(Crypto::Hashes.sha256(network_address))
            checksum = hashed_address_again[0..5]
            Base64.strict_encode64(network_address + checksum)
        end

        def self.to_wif(key, network)
            private_key = key.as_hex
            network_key = network[:prefix] + private_key
            hashed_key = Crypto::Hashes.sha256(Crypto::Hashes.sha256(network_key))
            checksum = hashed_key[0..5]
            encoded_key = Base64.strict_encode64(network_key + checksum)
            Wif.new(encoded_key)
        end

        def self.from_wif(wif)
            decoded_wif = Base64.strict_decode64(wif.as_hex)
            network_prefix = decoded_wif[0..1]
            network = network_prefix == "M0" ? MAINNET : TESTNET
            private_key_hex = decoded_wif[2..-7]
            private_key = PrivateKey.from_hex(private_key_hex)
            {private_key: private_key, network: network}
        end
    end
end