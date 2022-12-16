#!/bin/bash
# set -x
set -e
export dbin="simd"
export dhome="${HOME}/.simapp"
rm -rf $dhome || true
$dbin config chain-id demo
$dbin config keyring-backend test
$dbin keys add alice
$dbin keys add bob
export val1m="spin fine pulse benefit repair legend lion hospital crumble chicken turn toward accuse style wine staff speed sniff vivid agree borrow primary hotel wine"
export val2m="upon chicken word garlic palm useless machine tribe ahead extend reunion dumb resist switch rhythm steak name aerobic render burger improve autumn spread dust"
echo $val1m | $dbin keys add val1 --recover
echo $val2m | $dbin keys add val2 --recover
$dbin init test --chain-id demo
# update genesis
$dbin add-genesis-account alice 1000000000stake
$dbin add-genesis-account bob   1000000000stake
$dbin add-genesis-account val1  1000000000stake
$dbin add-genesis-account val2  1000000000stake
#$dbin add-genesis-account bob 100000mini --keyring-backend test
#dasel put string -f ~/.minid/config/genesis.json '.app_state.staking.params.bond_denom' 'mini'
#dasel put string -f ~/.minid/config/genesis.json '.app_state.mint.params.mint_denom' "mini"
# create default validator
$dbin gentx alice 1000000stake --chain-id demo
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
