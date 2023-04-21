
### Tạo Policy Script
#We need to create a file that defines the policy verification key as a witness to sign the minting transaction. 
#There are no further constraints such as token locking or requiring specific signatures to successfully submit a transaction with this minting policy.
#Create a new `policy.script` with the following json content, replacing the required values with the data gathered in the previous steps:

echo "{" > policy.script 
echo "  \"keyHash\": \"$(cardano-cli address key-hash --payment-verification-key-file lab.payment-0.vkey)\"," >> policy.script 
echo "  \"type\": \"sig\"" >> policy.script 
echo "}" >> policy.script

cardano-cli transaction policyid --script-file policy.script > policyID

# Định nghĩa token cần tạo: tên, số lượng
#We need to defined the name for our token and the amount that we want to mint. Use the following snippet to define the values to use in following steps:
# https://www.online-toolz.com/tools/text-hex-convertor.php
MY_ADDRESS=$(cat lab.payment-0.addr) 
POLICYID=$(cat policyID)
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic 1
TX_HASH=ad9ffccec280bbfc6d3620be7f2a7c502d58b368d8c7e08fef369a92aa11056f
TX_IX=1

#https://www.online-toolz.com/tools/hex-to-text-converter.php
TOKEN_NAME=4e475559454e414e485449454e2d4c414232
TOKEN_AMOUNT=100000000  #100 tokens, viết dạng lovelace thành 100000000
 


 
#Soan thảo giao dịch
cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $TX_HASH#$TX_IX \
--tx-out $MY_ADDRESS+"1500000 + $TOKEN_AMOUNT $POLICYID.$TOKEN_NAME" \
--mint "$TOKEN_AMOUNT $POLICYID.$TOKEN_NAME" \
--mint-script-file policy.script \
--change-address $MY_ADDRESS \
--out-file mint-native-assets.raw

 
# Ký giao dịch
#Giao dịch cần được ký để tạo ra digital signature để chứng minh cho quyền chi tiêu số ADA của người chuyển
 
cardano-cli transaction sign \
--signing-key-file  lab.payment-0.skey \
--testnet-magic 1 \
--tx-body-file mint-native-assets.raw \
--out-file mint-native-assets.signed

#Gửi giao dịch lên mạng lưới blockchain
#Now we are going to submit the transaction by running the following command:
cardano-cli transaction submit \
--tx-file mint-native-assets.signed \
--testnet-magic 1 

#Chúc mừng, Bạn đã chuyển thành công ADA và thông điệp metadata . Sau một vài giây, Chúng ta có thể kiểm tra số dư tại địa chỉ người nhận
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic 1

#Các bạn hoàn thành phải gửi 1 token vào địa chỉ sau

addr_test1qpxu9meguwvxaxsfgrm0n4pdwq2qqhnhqgfm94n5s5mqpx7dht80uqnhfvvm6sjjlg3kmalrh9g7evzs7pwz8kyqh2dsgry3j2




 