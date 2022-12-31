##############1. Check so du vi #####################
cd ~
address=$(cat payment.addr)
cardano-cli query utxo --address $address --testnet-magic $CARDANO_NODE_MAGIC

##############2. Export cau hinh #####################
cardano-cli query protocol-parameters --testnet-magic $CARDANO_NODE_MAGIC --out-file protocol.json

##############3. Post picture to IPFS  #####################
### sign up an account at https://app.pinata.cloud/ 
ipfs_hash="QmZtoHySkNPrtWDwoXBySZTeujaDA9Uaz5VhggMB4CdK4M"

##############4.tao Policy key pair #####################
mkdir policy
cardano-cli address key-gen \
    --verification-key-file policy/policy.vkey \
    --signing-key-file policy/policy.skey


##############5.tao file policy/policy.script #####################

>policy/policy.script
echo "{" >> policy/policy.script
echo "  \"type\": \"all\"," >> policy/policy.script 
echo "  \"scripts\":" >> policy/policy.script 
echo "  [" >> policy/policy.script 
echo "   {" >> policy/policy.script 
echo "     \"type\": \"before\"," >> policy/policy.script 
echo "     \"slot\": $(expr $(cardano-cli query tip --testnet-magic $CARDANO_NODE_MAGIC | jq .slot?) + 10000)" >> policy/policy.script
echo "   }," >> policy/policy.script 
echo "   {" >> policy/policy.script
echo "     \"type\": \"sig\"," >> policy/policy.script 
echo "     \"keyHash\": \"$(cardano-cli address key-hash --payment-verification-key-file policy/policy.vkey)\"" >> policy/policy.script 
echo "   }" >> policy/policy.script
echo "  ]" >> policy/policy.script 
echo "}" >> policy/policy.script


cardano-cli transaction policyid --script-file ./policy/policy.script > policy/policyID

##############6. khai bao bien NFT ###########
## chuyen ten token sang Hexadecimal at  https://www.online-toolz.com/tools/text-hex-convertor.php 

tokenname1=4445475245453031
tokenname2=4445475245453032


 


##############7. gan cac bien can thiet  ###########
cardano-cli query utxo --address $address --testnet-magic $CARDANO_NODE_MAGIC
txhash="6970b65532bc39492f4358963386f728c8a84ce6133a9fae80fb5bbdb012d795"
txix="0"
funds="7633358"
policyid=$(cat policy/policyID)
output=3551440
slotnumber=80479354
script="policy/policy.script"


##############8. Soan giao dich ###########
cardano-cli transaction build \
--testnet-magic $CARDANO_NODE_MAGIC \
--tx-in $txhash#$txix \
--tx-out $address+$output+"1 $policyid.$tokenname1"+"1 $policyid.$tokenname2"+"10000000 c26c547048e95a3ebe5db788967def771fc69025c03e63459a06d905.48414e4f49" \
--change-address $address \
--mint="1 $policyid.$tokenname1"+"1 $policyid.$tokenname2" \
--minting-script-file $script \
--metadata-json-file metadata.json  \
--invalid-hereafter $slotnumber \
--witness-override 2 \
--out-file matx.raw


#############9  Ky giao dich ###################
cardano-cli transaction sign  \
--signing-key-file my_address.skey  \
--signing-key-file policy/policy.skey  \
--testnet-magic $CARDANO_NODE_MAGIC \
--tx-body-file matx.raw  \
--out-file matx.signed

#############10. submit giao dich ###################
cardano-cli transaction submit --tx-file matx.signed --testnet-magic $CARDANO_NODE_MAGIC

 
 
#############11 check NFT  ###################
Congratulations, we have now successfully minted your NFT. After a couple of seconds, we can check the output address

```sh
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic $CARDANO_NODE_MAGIC
```
View online at
https://preprod.cexplorer.io/address/addr_test1vqhxegj29uxvx6gw6yy5ljsf3ly6kss7fs4jjsynpynyvfs5sd6sv/asset#data







 
 
