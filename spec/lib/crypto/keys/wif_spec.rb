describe Wif do
  describe "#initialize" do
    it "should create a wif key object from a wif hex string" do
      wif_hex = "TTA4YWM5MzAzYjIxZWYyMjU3M2Q3ODQ0ZmFlNDI1ZjdmMGYxOTNjMzIyNjBiYzVmMzQ0MTUxMjA4ZmI1MzAzNTk0NTJiOWNi"
      expect(Wif.new(wif_hex).as_hex).to eql(wif_hex)
    end

    it "should raise an error if the private key hex string is not a valid private key" do
      expect { Wif.new("123") }.to raise_error(AxentroError, "invalid wif: 123")
    end
  end

  describe "#from hex" do
    it "should create a wif object from a private key string" do
      hex_private_key = "f92913f355539a6ec6129b744a9e1dcb4d3c8df29cccb8066d57c454cead6fe4"

      wif = PrivateKey.from_hex(hex_private_key).wif
      expect(wif.as_hex).to eql("TTBmOTI5MTNmMzU1NTM5YTZlYzYxMjliNzQ0YTllMWRjYjRkM2M4ZGYyOWNjY2I4MDY2ZDU3YzQ1NGNlYWQ2ZmU0MjdlYzNl")
    end
  end

  it "should return the public key when calling #public_key" do
    keys = KeyRing.generate
    expect(keys.wif.public_key.as_hex).to eql(keys.public_key.as_hex)
  end

  it "should return the private key when calling #private_key" do
    keys = KeyRing.generate
    expect(keys.wif.private_key.as_hex).to eql(keys.private_key.as_hex)
  end

  describe "#network" do
    it "should return the mainnet by default" do
      expect(KeyRing.generate.wif.network).to eql(MAINNET)
    end
    it "should return the supplied network" do
      expect(KeyRing.generate(TESTNET).wif.network).to eql(TESTNET)
    end
  end

  describe "#address" do
    it "should return the address" do
      hex_private_key = "4c66f13692c476c57ab685b16b697496a1aac019b2b5ab54e1e692ec2e200c57"
      private_key = PrivateKey.from_hex(hex_private_key)

      wif = private_key.wif
      expect(wif.address.as_hex).to eql("TTBhZWVkYWZmYzM4OWVkYzkxNmJlNjIxYjI1YzUxZDAwNmQyMzdjOGFlMTVjZDA3")
    end
  end

  describe "#is_valid?" do
    it "should return true if the wif is valid" do
      expect(KeyRing.generate.wif.is_valid?).to eql(true)
    end
  end
end
