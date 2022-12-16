#!/bin/bash
set -e
export IP=$1
export node="tcp://${IP}:26657"
export val_name=$2
export chain_id=iochain
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

# Create new accounts
# export val1m="spin fine pulse benefit repair legend lion hospital crumble chicken turn toward accuse style wine staff speed sniff vivid agree borrow primary hotel wine"
export val2m="upon chicken word garlic palm useless machine tribe ahead extend reunion dumb resist switch rhythm steak name aerobic render burger improve autumn spread dust"
# echo $val1m | $dbin keys add val1 --recover
echo $val2m | $dbin keys add val2 --recover

# Confirm account is created as expected
set -x
$dbin q bank balances $($dbin keys show $val_name -a)

export publickey=$($dbin tendermint show-validator); echo $publickey

curl -s ${IP}:26657/genesis | jq .result.genesis > $dhome/config/genesis.json
$dbin validate-genesis

ID=$(curl -s http://${IP}:26657/status | jq -r .result.node_info.id);
#echo $ID
echo "persistent_peers"
echo $ID@$IP:26656
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
  --min-self-delegation="1" \
  --gas="auto" \
  --fees="2000000stake" \
  --home=$dhome \
  --from=$($dbin keys show $val_name --bech acc -a) \
  --output json \
  --yes | jq .

echo '$dbin q tx --type=hash $hash -o json | jq .logs'

$dbin q bank balances $($dbin keys show $val_name -a)
$dbin q staking validators -o json | jq .
$dbin query staking validator $(cat $dhome/config/genesis.json | jq -r '.app_state.genutil.gen_txs[0].body.messages[0].validator_address') -o json | jq .
$dbin query tendermint-validator-set | grep $($dbin tendermint show-address)