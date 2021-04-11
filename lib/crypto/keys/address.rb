require "base64"

class AxentroError < StandardError
end

module Crypto::Keys
  class Address
    attr_reader :network

    def initialize(hex_address, network = MAINNET, name = "generic")
      @hex_address = hex_address
      @network = network
      @name = name
      unless is_valid?
        raise AxentroError, "invalid '#{@name}' address checksum for: '#{@hex_address}'"
      end
    end

    def as_hex
      @hex_address
    end

    def self.from(hex_address, name = "")
      network = get_network_from_address(hex_address)
      Address.new(hex_address, network, name)
    end

    def is_valid?
      Address.is_valid?(@hex_address)
    end

    def self.is_valid?(hex_address)
      begin
        decoded_address = Base64.strict_decode64(hex_address)
        return false unless decoded_address.size == 48
        version_address = decoded_address[0..-7]
        hashed_address = Crypto::Hashes.sha256(Crypto::Hashes.sha256(version_address))
        checksum = decoded_address[-6..-1]
        checksum == hashed_address[0..5]
      rescue AxentroError => e
        false
      end
    end

    def self.get_network_from_address(hex_address)
      begin
        decoded_address = Base64.strict_decode64(hex_address)
      rescue => e
        raise AxentroError, "invalid address: #{e}"
      end

      case decoded_address[0..1]
      when MAINNET[:prefix]
        MAINNET
      when TESTNET[:prefix]
        TESTNET
      else
        raise AxentroError, "invalid network: #{decoded_address[0..1]} for address: #{hex_address}"
      end
    end

    def to_s
      as_hex
    end
  end
end
