
#!/bin/bash
# set -x
# set -e
# export dbin="simd"
# export dhome="${HOME}/.simapp"

# Create new accounts
$dbin keys add alice
$dbin keys add bob
export val1="spin fine pulse benefit repair legend lion hospital crumble chicken turn toward accuse style wine staff speed sniff vivid agree borrow primary hotel wine"
export val2="upon chicken word garlic palm useless machine tribe ahead extend reunion dumb resist switch rhythm steak name aerobic render burger improve autumn spread dust"
export val3="cabbage level prevent ensure debate milk project quarter organ critic dinner tonight roast please calm butter alcohol settle truck tornado card nice magnet ticket"
export val4="oil between habit link apology cash apple glare coral wine adult earth muscle polar scatter thought hint dust lecture crew law scrub wrist defy"
export val5="shaft salmon excess page nuclear stone huge brief jaguar neutral forget gold balance old still eyebrow various distance stable manual below year goat pizza"

echo $val1 | $dbin keys add val1 --recover
echo $val2 | $dbin keys add val2 --recover
echo $val3 | $dbin keys add val3 --recover
echo $val4 | $dbin keys add val4 --recover
echo $val5 | $dbin keys add val5 --recover

# update genesis
$dbin add-genesis-account alice 1000000000stake
$dbin add-genesis-account bob   1000000000stake
$dbin add-genesis-account val1  1000000000stake
$dbin add-genesis-account val2  1000000000stake
$dbin add-genesis-account val3  1000000000stake
$dbin add-genesis-account val4  1000000000stake
$dbin add-genesis-account val5  1000000000stake