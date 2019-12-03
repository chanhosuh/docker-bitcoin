[![chanhosuh/bitcoin][docker-pulls-image]][docker-hub-url] [![chanhosuh/bitcoin][docker-stars-image]][docker-hub-url] [![chanhosuh/bitcoin][docker-size-image]][docker-hub-url] [![chanhosuh/bitcoin][docker-layers-image]][docker-hub-url]

# docker-bitcoin
Docker setup to run a full node for Bitcoin

## Quickstart guide
- install Docker: [Mac](https://www.docker.com/docker-mac) | [Ubuntu](https://www.docker.com/docker-ubuntu)
- clone the repo
- build the Docker image:
  - `make build`
  - only needs to be done the first time or when docker-related files change
- start the container:
  - `make up` 
  - ctrl-c will detach you from the logging output; container will still be running in the background
  - `make logs` will re-attach you to logging
- stop the container:
  - `make down`
- check everything works:
  - start the containers if they aren't running (`make up`)
  - `make status` (should show local blockchain info)
  - `make bash` (will drop you in a bash shell inside the `bitcoind` container)
  - `bitcoin-cli getbestblockhash` (should return a hash)
  - `bitcoin-cli help` (shows more commands)
- `make help` will show more `make` commands

## A bit of fun
Let's take a look inside the very first block in the Bitcoin blockchain, the *genesis block*.

```console
$ bitcoin-cli getblockhash 0
000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f

$ bitcoin-cli getblock 000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f 2
{
  "hash": "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f",
  "confirmations": 431615,
  "strippedsize": 285,
  "size": 285,
  "weight": 1140,
  "height": 0,
  "version": 1,
  "versionHex": "00000001",
  "merkleroot": "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b",
  "tx": [
    {
      "txid": "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b",
      "hash": "4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b",
      "version": 1,
      "size": 204,
      "vsize": 204,
      "weight": 816,
      "locktime": 0,
      "vin": [
        {
          "coinbase": "04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73",
          "sequence": 4294967295
        }
      ],
      "vout": [
        {
          "value": 50.00000000,
          "n": 0,
          "scriptPubKey": {
            "asm": "04678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5f OP_CHECKSIG",
            "hex": "4104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac",
            "reqSigs": 1,
            "type": "pubkey",
            "addresses": [
              "1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa"
            ]
          }
        }
      ],
      "hex": "01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff4d04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73ffffffff0100f2052a01000000434104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb649f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac00000000"
    }
  ],
  "time": 1231006505,
  "mediantime": 1231006505,
  "nonce": 2083236893,
  "bits": "1d00ffff",
  "difficulty": 1,
  "chainwork": "0000000000000000000000000000000000000000000000000000000100010001",
  "nTx": 1,
  "nextblockhash": "00000000839a8e6886ab5951d76f411475428afc90947ee320161bbf18eb6048"
}

$ bitcoin-cli getblock 000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f 2 | grep coinbase
          "coinbase": "04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73",

$ python3 -c "print(bytes.fromhex('04ffff001d0104455468652054696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f757420666f722062616e6b73'))"
b'\x04\xff\xff\x00\x1d\x01\x04EThe Times 03/Jan/2009 Chancellor on brink of second bailout for banks'
```

This is the famous coinbase message left by Satoshi Nakamoto when he created the blockchain.  Its meaning is up to interpretation, although it has usually been understood to be a concise way of irrefutably dating the genesis block and at the same time a commentary on the financial system.


## References
* [Mastering Bitcoin, chapter 3](https://github.com/bitcoinbook/bitcoinbook/blob/develop/ch03.asciidoc): intro to `bitcoind`
* [ChainQuery](http://chainquery.com/bitcoin-api): useful web interface to learn about `bitcoin-cli`
