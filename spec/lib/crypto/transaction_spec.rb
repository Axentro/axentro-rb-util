require_relative "../../spec_helper"

describe Transaction do
  it "should create a valid signed transaction" do
    from_address = "VDAwZTdkZGNjYjg1NDA1ZjdhYzk1M2ExMDAzNmY5MjUyYjI0MmMwNGJjZWY4NjA3"
    from_public_key = "3a133bb891f14aa755af119907bd20c7fcfd126fa187288cc2b9d626552f6802"
    wif = "VDAwYjIxODI2NDg3MDE3YjA2YTYxOTJiYjUzMjg0MDAzZWNkZGRhZDJlYmUwNjMxYWM3NmIwMzFlYTg4MjlkMTBhMzBkZmNk"
    to_address = "VDBjY2NmOGMyZmQ0MDc4NTIyNDBmYzNmOWQ3M2NlMzljODExOTBjYTQ0ZjMxMGFl"
    amount = "1"

    transaction = Transaction.create_signed_send_transaction(from_address, from_public_key, wif, to_address, amount)
    json = JSON.parse(transaction)["transaction"]

    sender = json["senders"].to_a.first
    expect(sender["address"].to_s).to eql(from_address)
    expect(sender["public_key"].to_s).to eql(from_public_key)
    expect(sender["amount"].to_i).to eql(100000000)
    expect(sender["fee"].to_i).to eql(10000)
    expect(sender["signature"].to_s.size).to be > 30

    recipient = json["recipients"].to_a.first
    expect(recipient["address"].to_s).to eql(to_address)
    expect(recipient["amount"].to_i).to eql(100000000)
  end
end
