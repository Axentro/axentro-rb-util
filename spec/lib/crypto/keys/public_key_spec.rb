describe PublicKey do
  describe "#initialize" do
    it "should create a public key object from a public key string" do
      key_pair = KeyUtils.create_new_keypair
      hex_public_key = key_pair[:hex_public_key]

      public_key = PublicKey.new(hex_public_key)
      expect(public_key.as_hex).to eql(hex_public_key)
    end

    it "should raise an error if the public key hex string is not a valid public key" do
      expect { PublicKey.new("123") }.to raise_error(AxentroError, "invalid public key: 123")
    end
  end

  describe "#from hex" do
    it "should create a public key object from a public key string" do
      key_pair = KeyUtils.create_new_keypair
      hex_public_key = key_pair[:hex_public_key]

      public_key = PublicKey.from_hex(hex_public_key)
      expect(public_key.as_hex).to eql(hex_public_key)
    end
  end

  describe "#from bytes" do
    it "should create a public key object from a public key byte array" do
      key_pair = KeyUtils.create_new_keypair
      hex_public_key = key_pair[:hex_public_key]
      hexbytes = KeyUtils.to_bytes(hex_public_key)

      public_key = PublicKey.from_bytes(hexbytes)
      expect(public_key.as_bytes).to eql(hexbytes)
      expect(public_key.as_hex).to eql(hex_public_key)
    end
  end

  it "should convert a public key from hex to bytes with #as_bytes" do
    key_pair = KeyUtils.create_new_keypair
    hex_public_key = key_pair[:hex_public_key]
    hexbytes = KeyUtils.to_bytes(hex_public_key)

    public_key = PublicKey.from_hex(hex_public_key)
    expect(public_key.as_bytes).to eql(hexbytes)
  end

  it "should convert a public key from bytes to hex with #as_hex" do
    key_pair = KeyUtils.create_new_keypair
    hex_public_key = key_pair[:hex_public_key]
    hexbytes = KeyUtils.to_bytes(hex_public_key)

    public_key = PublicKey.from_bytes(hexbytes)
    expect(public_key.as_hex).to eql(hex_public_key)
  end

  describe "#network" do
    it "should return the mainnet by default" do
      expect(KeyRing.generate.public_key.network).to eql(MAINNET)
    end
    it "should return the supplied network" do
      expect(KeyRing.generate(TESTNET).public_key.network).to eql(TESTNET)
    end
  end

  describe "#address" do
    it "should return the address" do
      hex_public_key = "bf668c4c446d540452f47b4c10ff85235f5aedb088a90eba8af59cf982489373"

      public_key = PublicKey.from_hex(hex_public_key)
      expect(public_key.address.as_hex).to eql("TTA5OGFmMWM5MzEzOTg4OWVjNGMyNjVmNmY1ZWMwMzhlN2M3ZWMwZGFkZjdhYWU0")
    end

    it "should return a mainnet address" do
      keys = KeyRing.generate
      decoded_address = Base64.strict_decode64(keys.public_key.address.as_hex)
      expect(decoded_address[0..1]).to eql("M0")
    end

    it "should return a testnet address" do
      keys = KeyRing.generate(TESTNET)
      decoded_address = Base64.strict_decode64(keys.public_key.address.as_hex)
      expect(decoded_address[0..1]).to eql("T0")
    end
  end

  describe "#is_valid?" do
    it "should return true if the public key is valid" do
      expect(KeyRing.generate.public_key.is_valid?).to eql(true)
    end
  end
end
