#!/bin/bash
set -e
export IP=$1
export node="tcp://${IP}:26657"
export val_name=$2
export chain_id=iochain
echo $node
echo $val_name
export dbin="simd"
export dhome="${HOME}/.simapp"
# Clear old data and config
$dbin tendermint unsafe-reset-all
rm -rf $dhome || true

# Setup new node
$dbin config chain-id $chain_id
$dbin config keyring-backend test
$dbin config node $node
$dbin init $val_name
$dbin config 
# exit 

# Create new accounts
./create_accounts.sh > /dev/null 2>&1

# Confirm account is created as expected
# set -x
$dbin q bank balances $($dbin keys show $val_name -a)

export publickey=$($dbin tendermint show-validator); echo $publickey

curl -s ${IP}:26657/genesis | jq .result.genesis > $dhome/config/genesis.json
$dbin validate-genesis
# if [[ $(sha256sum $dhome/config/genesis.json | awk '{print $1}') = "58f17545056267f57a2d95f4c9c00ac1d689a580e220c5d4de96570fbbc832e1" ]]; then echo "OK"; else echo "MISMATCHED"; fi;

ID=$(curl -s http://${IP}:26657/status | jq -r .result.node_info.id);
echo "Node ID: $ID"
echo "persistent_peers = $ID@$IP:26656"
echo "\n\nCreating Validator for node $(hostname) with account $val_name.\n\n"

# curl -s http://${IP}:26657/status | jq .result.sync_info.catching_up
$dbin tx staking create-validator \
  --amount=1000000stake \
  --pubkey=$($dbin tendermint show-validator) \
  --moniker="$(hostname)" \
  --chain-id=$chain_id \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --gas="auto" \
  --gas-prices="1stake" \
  --gas-adjustment="1.2" \
  --home=$dhome \
  --from=$($dbin keys show $val_name --bech acc -a) \
  --output json \
  --yes | jq -r .txhash

echo '$dbin q tx --type=hash $hash -o json | jq .logs'

$dbin q bank balances $($dbin keys show $val_name -a)
$dbin q staking validators -o json | jq .
$dbin query staking validator $(cat $dhome/config/genesis.json | jq -r '.app_state.genutil.gen_txs[0].body.messages[0].validator_address') -o json | jq .
$dbin query tendermint-validator-set | grep $($dbin tendermint show-address)