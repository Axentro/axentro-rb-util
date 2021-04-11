module Crypto::Transaction
  extend self
  SCALE_DECIMAL = 100000000

  def create_signed_send_transaction(from_address, from_public_key, wif, to_address, amount, fee = "0.0001", speed = "FAST")
    from_private_key = __get_private_key_from_wif(wif)
    __create_signed_send_token_transaction(from_address, from_public_key, from_private_key, to_address, amount, fee, speed)
  end

  def post_transaction(transaction_json, url = "https://mainnet.axentro.io")
    begin
      response = Faraday.post("#{url}/api/v1/transaction", transaction_json, "Content-Type" => "application/json")
      raise "status code was: #{response.status}" if response.status != 200
      json_response = JSON.parse(response.body)
      json_response["result"]["id"].to_s
    rescue => e
      puts "Error sending transaction: #{e}"
    end
  end

  def __create_signed_send_token_transaction(from_address, from_public_key, from_private_key, to_address, amount, fee = "0.0001", speed = "FAST")
    transaction_id = __create_id
    timestamp = __timestamp
    scaled_amount = __scale_i64(amount)
    scaled_fee = __scale_i64(fee)

    unsigned_transaction = %Q{{"id":"#{transaction_id}","action":"send","senders":[{"address":"#{from_address}","public_key":"#{from_public_key}","amount":#{scaled_amount},"fee":#{scaled_fee},"signature":"0"}],"recipients":[{"address":"#{to_address}","amount":#{scaled_amount}}],"message":"","token":"AXNT","prev_hash":"0","timestamp":#{timestamp},"scaled":1,"kind":"#{speed}","version":"V1"}}

    payload_hash = Hashes.sha256(unsigned_transaction)
    signature = KeyUtils.sign(from_private_key, payload_hash)
    signed_transaction = __to_signed(unsigned_transaction, signature)

    %Q{{"transaction": #{signed_transaction}}}
  end

  def __create_id
    tmp_id = SecureRandom.hex(32)
    return __create_id if tmp_id[0] == "0"
    tmp_id
  end

  def __timestamp
    Time.now.to_i * 1000
  end

  def __to_signed(unsigned_transaction, signature)
    unsigned_transaction.gsub(%Q{"signature":"0"}, %Q{"signature":"#{signature}"})
  end

  def __get_private_key_from_wif(wif)
    Base64.strict_decode64(wif)[2..-7]
  end

  def __scale_i64(value)
    BigDecimal(value) * SCALE_DECIMAL
  end
end
