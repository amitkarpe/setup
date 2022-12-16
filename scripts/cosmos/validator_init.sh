#!/bin/bash

set -x
set -e

IP="18.141.3.24"
export val_name=val1
export chain_id="demo"
export dbin="simd"
export dhome="${HOME}/.simapp"
#$dbin config
export node="tcp://${IP}:26657"
#$dbin config chain-id demo
#$dbin config keyring-backend test
$dbin config node $node

$dbin q bank balances $($dbin keys show $val_name -a)

export publickey=$($dbin tendermint show-validator); echo $publickey

curl -s ${IP}:26657/genesis | jq .result.genesis > $dhome/config/genesis.json
$dbin validate-genesis

ID=$(curl -s http://${IP}:26657/status | jq -r .result.node_info.id);
#echo $ID
echo "persistent_peers"
echo $ID@$node
#seeds=$(echo $ID@$node); echo $seeds

# curl -s http://${IP}:26657/status | jq .result.sync_info.catching_up

$dbin tx staking create-validator \
  --amount=1000000stake \
  --pubkey=$($dbin tendermint show-validator) \
  --moniker="$val_name" \
  --chain-id=$chain_id \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas="auto" \
  --gas-prices="100stake" \
  --home=$dhome\
  --from=$val_name \
  --node=${node}