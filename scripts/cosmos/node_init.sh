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

# Create new accounts
./create_accounts.sh > /dev/null 2>&1

#$dbin add-genesis-account bob 100000mini --keyring-backend test
#dasel put string -f ~/.minid/config/genesis.json '.app_state.staking.params.bond_denom' 'mini'
#dasel put string -f ~/.minid/config/genesis.json '.app_state.mint.params.mint_denom' "mini"
# create default validator
$dbin gentx alice 1000000stake 
#$dbin gentx bob   1000000stake --chain-id demo
$dbin collect-gentxs

sha256sum $dhome/config/genesis.json

external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $dhome/config/config.toml

# $ sed -i.bak -E 's#^(seeds[[:space:]]+=[[:space:]]+).*$#\1"0d5cf1394a1cfde28dc8f023567222abc0f47534@cronos-seed-0.crypto.org:26656,3032073adc06d710dd512240281637c1bd0c8a7b@cronos-seed-1.crypto.org:26656,04f43116b4c6c70054d9c2b7485383df5b1ed1da@cronos-seed-2.crypto.org:26656,337377dcda43d79c537d2c4d93ad3b698ce9452e@bd-cronos-mainnet-seed-node-01.bdnodes.net:26656"#' $dhome/config/config.toml
sed -i.bak -E 's#^(create_empty_blocks_interval[[:space:]]+=[[:space:]]+).*$#\1"35s"#' $dhome/config/config.toml
sed -i.bak -E 's#^(timeout_commit[[:space:]]+=[[:space:]]+).*$#\1"35s"#' $dhome/config/config.toml

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
