require_relative "../../../spec_helper"

describe Address do
  it "should create an address object from a hex string" do
    address_hex = "TTBkYzI1OGY3MWY5YTNjZTU5Zjg4ZGJlNjI1ODUxNmU3OTY3MDg4NGE1MDU2YzE0"
    address = Address.new(address_hex)
    expect(address.as_hex).to eql(address_hex)
  end

  it "should raise an error if address checksum is not valid" do
    expect { Address.new("VU9lYzI4NWFjYTI4MmNkZTJjNWJmNzI0M2ZiNjUzMzI4MGE0ZTUwYjFiODE0OTdjOTlkZDQ0NTE2YjdkMjVmMGMx") }.to raise_error(AxentroError, "invalid 'generic' address checksum for: 'VU9lYzI4NWFjYTI4MmNkZTJjNWJmNzI0M2ZiNjUzMzI4MGE0ZTUwYjFiODE0OTdjOTlkZDQ0NTE2YjdkMjVmMGMx'")
  end

  it "should return the network when calling #network" do
    expect(KeyRing.generate.address.network).to eql(MAINNET)
  end

  it "should return true for #is_valid?" do
    expect(KeyRing.generate.address.is_valid?).to eql(true)
  end

  describe "Address.from(hex)" do
    it "should create an Address from an address hex" do
      address_hex = "TTBkYzI1OGY3MWY5YTNjZTU5Zjg4ZGJlNjI1ODUxNmU3OTY3MDg4NGE1MDU2YzE0"
      address = Address.from(address_hex)
      expect(address.network).to eql(MAINNET)
      expect(address.as_hex).to eql(address_hex)
    end

    it "should raise an error if network is invalid" do
      address_hex = Base64.strict_encode64("UOec285aca282cde2c5bf7243fb6533280a4e50b1b81497c99dd44516b7d25f0c1")
      expect { Address.from(address_hex) }.to raise_error(AxentroError, "invalid network: UO for address: VU9lYzI4NWFjYTI4MmNkZTJjNWJmNzI0M2ZiNjUzMzI4MGE0ZTUwYjFiODE0OTdjOTlkZDQ0NTE2YjdkMjVmMGMx")
    end

    it "should raise an error using supplied name" do
      address_hex = Base64.strict_encode64("T0ec285aca282cde2c5bf7243fb6533280a4e50b1b81497c99dd44516b7d25f0c1")
      expect { Address.from(address_hex, "supplied name") }.to raise_error("invalid 'supplied name' address checksum for: 'VDBlYzI4NWFjYTI4MmNkZTJjNWJmNzI0M2ZiNjUzMzI4MGE0ZTUwYjFiODE0OTdjOTlkZDQ0NTE2YjdkMjVmMGMx'")
    end
  end
end
