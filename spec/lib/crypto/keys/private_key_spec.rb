describe PrivateKey do
  describe "#initialize" do
    it "should create a private key object from a private key string" do
      key_pair = KeyUtils.create_new_keypair
      hex_private_key = key_pair[:hex_private_key]

      private_key = PrivateKey.new(hex_private_key)
      expect(private_key.as_hex).to eql(hex_private_key)
    end

    it "should raise an error if the private key hex string is not a valid private key" do
      expect { PrivateKey.new("123") }.to raise_error(AxentroError, "invalid private key: '123'")
    end
  end

  describe "#from hex" do
    it "should create a private key object from a private key string" do
      key_pair = KeyUtils.create_new_keypair
      hex_private_key = key_pair[:hex_private_key]

      private_key = PrivateKey.from_hex(hex_private_key)
      expect(private_key.as_hex).to eql(hex_private_key)
    end
  end

  describe "#from bytes" do
    it "should create a private key object from a private key byte array" do
      key_pair = KeyUtils.create_new_keypair
      hex_private_key = key_pair[:hex_private_key]
      hexbytes = KeyUtils.to_bytes(hex_private_key)

      private_key = PrivateKey.from_bytes(hexbytes)
      expect(private_key.as_bytes).to eql(hexbytes)
      expect(private_key.as_hex).to eql(hex_private_key)
    end
  end

  it "should convert a private key from hex to bytes with #as_bytes" do
    key_pair = KeyUtils.create_new_keypair
    hex_private_key = key_pair[:hex_private_key]
    hexbytes = KeyUtils.to_bytes(hex_private_key)

    private_key = PrivateKey.from_hex(hex_private_key)
    expect(private_key.as_bytes).to eql(hexbytes)
  end

  it "should convert a private key from bytes to hex with #as_hex" do
    key_pair = KeyUtils.create_new_keypair
    hex_private_key = key_pair[:hex_private_key]
    hexbytes = KeyUtils.to_bytes(hex_private_key)

    private_key = PrivateKey.from_bytes(hexbytes)
    expect(private_key.as_hex).to eql(hex_private_key)
  end

  describe "#network" do
    it "should return the mainnet by default" do
      expect(KeyRing.generate.private_key.network).to eql(MAINNET)
    end
    it "should return the supplied network" do
      expect(KeyRing.generate(TESTNET).private_key.network).to eql(TESTNET)
    end
  end

  describe "#address" do
    it "should return the address" do
      hex_private_key = "4c66f13692c476c57ab685b16b697496a1aac019b2b5ab54e1e692ec2e200c57"

      private_key = PrivateKey.from_hex(hex_private_key)
      expect(private_key.address.as_hex).to eql("TTBhZWVkYWZmYzM4OWVkYzkxNmJlNjIxYjI1YzUxZDAwNmQyMzdjOGFlMTVjZDA3")
    end

    it "should return a mainnet address" do
      keys = KeyRing.generate
      decoded_address = Base64.strict_decode64(keys.private_key.address.as_hex)
      expect(decoded_address[0..1]).to eql("M0")
    end

    it "should return a testnet address" do
      keys = KeyRing.generate(TESTNET)
      decoded_address = Base64.strict_decode64(keys.private_key.address.as_hex)
      expect(decoded_address[0..1]).to eql("T0")
    end
  end

  describe "#is_valid?" do
    it "should return true if the public key is valid" do
      expect(KeyRing.generate.private_key.is_valid?).to eql(true)
    end
  end
end
