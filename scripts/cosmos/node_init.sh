#!/bin/bash
# set -x
set -e
export dbin="simd"
export dhome="${HOME}/.simapp"
export chain_id=iochain
# Clear old data and config
$dbin tendermint unsafe-reset-all
rm -rf $dhome || true

# Setup new node
$dbin config chain-id $chain_id
$dbin config keyring-backend test
$dbin init masternode 
$dbin config 

./create_accounts.sh

#$dbin add-genesis-account bob 100000mini --keyring-backend test
#dasel put string -f ~/.minid/config/genesis.json '.app_state.staking.params.bond_denom' 'mini'
#dasel put string -f ~/.minid/config/genesis.json '.app_state.mint.params.mint_denom' "mini"
# create default validator
$dbin gentx alice 1000000stake 
#$dbin gentx bob   1000000stake --chain-id demo
$dbin collect-gentxs

echo "Setup following parameters in config.toml"
echo '
create_empty_blocks = false
create_empty_blocks_interval = "30s"
timeout_commit = "30s"
'

cat $dhome/config/config.toml | grep -E 'create_empty_blocks_interval|create_empty_blocks|timeout_commit'

echo $(curl -s ifconfig.io)
echo "$dbin start --rpc.laddr tcp://0.0.0.0:26657 \
--api.enable \
--api.enabled-unsafe-cors \
--api.address tcp://0.0.0.0:1317 \
--grpc.enable \
--grpc-web.enable \
--proxy_app tcp://0.0.0.0:26658 \
--minimum-gas-prices  10stake"
