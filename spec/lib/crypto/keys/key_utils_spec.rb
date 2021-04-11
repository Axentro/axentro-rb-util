require_relative "../../../spec_helper"

describe KeyUtils do
  it "should sign and verify" do
    hex_private_key = "56a647e7c817b5cbee64bc2f7a371415441dd1503f004ef12c50f0a6f17093e9"
    hex_public_key = "fd94245aeddf19464ffa1b667dea401ed0952ec5a9b4dbf9d652e81c67336c4f"

    message = Crypto::Hashes.sha256("axentro")
    signature_hex = KeyUtils.sign(hex_private_key, message)

    expect(KeyUtils.verify_signature(message, signature_hex, hex_public_key)).to eql(true)
  end

  it "should verify signature made in javascript (elliptic eddsa)" do
    hex_public_key = "fd94245aeddf19464ffa1b667dea401ed0952ec5a9b4dbf9d652e81c67336c4f"
    signature_hex = "442F42E88B483EBD8E3F2897918A013A3B6370906F67311FBEF6B120DAD835CDF4064CDC8EE15E87E86998BF0CBADD653CADBBC6D1F0A5856FF0230A3D437008".downcase
    message = Crypto::Hashes.sha256("axentro")

    expect(KeyUtils.verify_signature(message, signature_hex, hex_public_key)).to eql(true)
  end
end
