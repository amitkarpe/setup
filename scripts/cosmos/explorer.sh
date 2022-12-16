#!/bin/bash
set -e
export IP=$1

node -v
npm install yarn -g

#git clone https://github.com/ping-pub/explorer
#cd explorer
rm -rf src/chains/mainnet/*.* src/chains/testnet/*.*

cat <<EOF > src/chains/mainnet/demo.json
{
    "chain_name": "demo",
    "coingecko": "",
    "api": ["http://${IP}:1317"],
    "rpc": ["http://${IP}:26657"],
    "snapshot_provider": "",
    "sdk_version": "0.46.2",
    "coin_type": 118,
    "min_tx_fee": 1,
    "addr_prefix": "stake",
    "logo": "https://cdn.icon-icons.com/icons2/691/PNG/512/google_assistant_icon-icons.com_61478.png",
    "assets": [
        {
            "base": "stake",
            "symbol": "stake",
            "exponent": 0,
            "coingecko_id": "",
            "logo": "https://cdn.icon-icons.com/icons2/691/PNG/512/google_IO_icon-icons.com_61476.png"
        }
    ]
}
EOF

yarn && yarn build
yarn serve