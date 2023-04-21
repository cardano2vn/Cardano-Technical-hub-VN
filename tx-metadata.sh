#Tạo thông điệp trong giao dịch
nano metadata.json
{
     "1337": {
        "Name": "Nguyen Anh Tien",
        "Class": "Web3",
        "Excercise": "01",
        "Completed": "YES"
    }
}

#Gán biến địa chỉ ví gửi đến - mặc định để ví của Thầy để kiểm tra các bạn đã hoàn thành bài tập chưa nhé
TO_ADDRESS=addr_test1qz40t3pvn5x7xxah7zvkn0ay30twems9g8l09tg5dnj70vwdht80uqnhfvvm6sjjlg3kmalrh9g7evzs7pwz8kyqh2dstcr9lu
MY_ADDRESS=$(cat lab.payment-0.addr) # lưu ý đổi tên file cho phù hợp với file địa chỉ bạn đã tạo 


# Tra UTXO hiện có của địa chỉ
cardano-cli query utxo --address $MY_ADDRESS --testnet-magic 1


# Soạn thảo giao dịch
MY_TX_HASH=23a75c19f16e48c268cf1f782450189a246b515da39b05ecbbc3a300487609b3
MY_TX_IX=7
TRANSFER_AMOUNT=2000000
cardano-cli transaction build \
 --testnet-magic 1 \
 --tx-in $MY_TX_HASH#$MY_TX_IX \
 --tx-out $TO_ADDRESS+$TRANSFER_AMOUNT \
 --change-address $MY_ADDRESS \
 --metadata-json-file metadata.json \
 --out-file transfer.raw


# Ký giao dịch
#Giao dịch cần được ký để tạo ra digital signature để chứng minh cho quyền chi tiêu số ADA của người chuyển
cardano-cli transaction sign  \
    --signing-key-file lab.payment-0.skey \
    --testnet-magic 1 \
    --tx-body-file transfer.raw  \
    --out-file transfer.signed

#Submit the Transaction
#Now we are going to submit the transaction by running the following command:
cardano-cli transaction submit --tx-file transfer.signed --testnet-magic 1

#Chúc mừng, Bạn đã chuyển thành công ADA và thông điệp metadata . Sau một vài giây, Chúng ta có thể kiểm tra số dư tại địa chỉ người nhận
cardano-cli query utxo --address $TO_ADDRESS --testnet-magic 1

