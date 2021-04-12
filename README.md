# axentro-rb-util

A Ruby utility to create and post a signed transaction for sending AXNT tokens on [Axentro Blockchain](https://axentro.io)

## Installation

Add this line to your application's Gemfile:

    gem 'axentro-rb-util'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install axentro-rb-util


## Usage

### Wallets

```ruby
require "axentro-rb-util"

# basic wallet
basic_wallet = KeyRing.generate(MAINNET)

# auto generate a seed and create a master wallet from the seed
KeyRing.generate_hd(nil, nil, MAINNET)

# provide a seed and create a derivation wallet from the seed
seed = SecureRandom.hex(64)
derivation = "m/0'/1'"
KeyRing.generate_hd(seed, derivation, MAINNET)
```

### Transactions

```ruby
require "axentro-rb-util"

from_address = "VDAwZTdkZGNjYjg1NDA1ZjdhYzk1M2ExMDAzNmY5MjUyYjI0MmMwNGJjZWY4NjA3"
from_public_key = "3a133bb891f14aa755af119907bd20c7fcfd126fa187288cc2b9d626552f6802"
wif = "VDAwYjIxODI2NDg3MDE3YjA2YTYxOTJiYjUzMjg0MDAzZWNkZGRhZDJlYmUwNjMxYWM3NmIwMzFlYTg4MjlkMTBhMzBkZmNk"
to_address = "VDBjY2NmOGMyZmQ0MDc4NTIyNDBmYzNmOWQ3M2NlMzljODExOTBjYTQ0ZjMxMGFl"
amount = "1"

# generate a signed transaction from the supplied data    
transaction = Transaction.create_signed_send_transaction(from_address, from_public_key, wif, to_address, amount)

# post the transaction to the desired server
transaction_id = Transaction.post_transaction(transaction, "https://testnet.axentro.io")
```

## Contributing

1. Fork it (<https://github.com/Axentro/axentro-rb-util/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Kingsley Hendrickse](https://github.com/kingsleyh) - creator and maintainer
