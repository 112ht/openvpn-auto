#/bin/bash
USER_NAME_START_STR="t-u-"
#ユーザー名開始index
USER_START_INDEX=101
#ユーザー名終了index
USER_END_INDEX=150
#認証ファイルベースパス
OVPN_FILE_BASE_DIR=/home/ubuntu/vpn-client-img/vpn_keys/
#転送用テストファイルサイズ
RANDOM_TEST_FILE_SIZE=1K
#転送用認証ファイルパス
SSH_KEY_FILE_PATH=/tmp/tokyo-key-file-002.pem
#転送用認証ユーザー
SSH_USER_ID=ec2-user
#転送先IP
SSH_SEND_IP=10.0.25.240
#転送先パス
SSH_SEND_PATH=/tmp/test_sed/

#コンテナー作成
create_docker_container()
{
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "container作成:"$TEMP_USER_NAME
      # コンテナー作成(バックグラウンドで起動)
      docker run -d --device=/dev/net/tun --cap-add=NET_ADMIN --name $TEMP_USER_NAME vpn-client-img-base sleep infinity
      # 認証ファイルのコピー
      docker cp $OVPN_FILE_BASE_DIR$TEMP_USER_NAME.ovpn $TEMP_USER_NAME:/tmp/$TEMP_USER_NAME.ovpn

done
}

# コンテナー起動
start_docker_container()
{
#    docker start $(docker ps -a -q)
   for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
   do
       export TEMP_USER_NAME=$USER_NAME_START_STR$i
       echo "container起動:"$TEMP_USER_NAME
       # 起動
       docker start $TEMP_USER_NAME

 done
}

# コンテナー停止
stop_docker_container()
{
    docker stop $(docker ps -q)
#   for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
#   do
#   do
#       export TEMP_USER_NAME=$USER_NAME_START_STR$i
#       echo "container停止:"$TEMP_USER_NAME
#       # コンテナーstop
#       docker stop $TEMP_USER_NAME

# done
}

# コンテナー再起動
reboot_docker_container()
{
   # docker start $(docker ps -a -q)
   # docker stop $(docker ps -q)
   for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
   do
       export TEMP_USER_NAME=$USER_NAME_START_STR$i
       echo "container再起動:"$TEMP_USER_NAME
       # 再起動
       docker restart $TEMP_USER_NAME
 done
}

# コンテナー削除
rm_docker_container()
{
#    docker rm $(docker ps -aq)
   for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
   do
       export TEMP_USER_NAME=$USER_NAME_START_STR$i
       echo "container削除:"$TEMP_USER_NAME
       # 削除
       docker stop  $TEMP_USER_NAME
       docker rm  $TEMP_USER_NAME

 done
}

# コンテナーVPN接続
con_vpn_docker_container()
{
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "containerVPN接続:"$TEMP_USER_NAME
      # vpn接続
      docker exec $TEMP_USER_NAME sh -c "/usr/sbin/openvpn --config /tmp/$TEMP_USER_NAME.ovpn &" &

done
}

# コンテナーVPN接続切断
stop_vpn_docker_container()
{
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "containerVPN切断:"$TEMP_USER_NAME
      # vpn接続切断
      docker exec $TEMP_USER_NAME sh -c "pkill -f '/usr/sbin/openvpn'" &

done
}

# テストスクリプトダウンロード&コンテナーにコピー
copy_testscript_docker_container()
{
  curl -o /home/ubuntu/vpn-client-img/test_script.sh https://112ht.github.io/openvpn-auto/test_script.sh
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "containerにテストスクリプトコピー:"$TEMP_USER_NAME
      # テストスクリプトコピー
      docker cp /home/ubuntu/vpn-client-img/test_script.sh $TEMP_USER_NAME:/tmp/test_script.sh
      docker exec $TEMP_USER_NAME chmod 777 /tmp/test_script.sh

done
}

# テストスクリプト実行する。
execute_testfile_docker_container()
{
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "containerテストスクリプト実行:"$TEMP_USER_NAME
      #テストスクリプト実行する。
      docker exec $TEMP_USER_NAME sh -c "/tmp/test_script.sh &" &

done
}
# テストスクリプト停止する。
stop_testfile_docker_container()
{
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "containerテストスクリプト停止:"$TEMP_USER_NAME
      #テストスクリプト実行する。
      docker exec $TEMP_USER_NAME sh -c "pkill -f '/bin/sh /tmp/test_script.sh' &" &

done
}
# # テストファイル作成
# edit_testfile_docker_container()
# {
#   for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
#   do
#       export TEMP_USER_NAME=$USER_NAME_START_STR$i
#       echo "containerランダムテストファイル作成:"$TEMP_USER_NAME
#       # ランダムテストファイル作成
#       docker exec $TEMP_USER_NAME sh -c "base64 /dev/urandom | head -c $RANDOM_TEST_FILE_SIZE > /tmp/${TEMP_USER_NAME}-testfile-${RANDOM_TEST_FILE_SIZE} &"

# done
# }

# # テストファイル送信
# send_testfile_docker_container()
# {
#   for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
#   do
#       export TEMP_USER_NAME=$USER_NAME_START_STR$i
#       echo "containerテストファイル送信:"$TEMP_USER_NAME
#       # ランダムテストファイル送信
#       #TODO
#       #echo "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -i $SSH_KEY_FILE_PATH /tmp/${TEMP_USER_NAME}-testfile-${RANDOM_TEST_FILE_SIZE} ${SSH_USER_ID}@${SSH_SEND_IP}:${SSH_SEND_PATH} "
#       docker exec $TEMP_USER_NAME sh -c "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -i $SSH_KEY_FILE_PATH /tmp/${TEMP_USER_NAME}-testfile-${RANDOM_TEST_FILE_SIZE} ${SSH_USER_ID}@${SSH_SEND_IP}:${SSH_SEND_PATH} &"

# done
# }

echo "openvpn接続用container操作開始"

# 引数チェック
if [ "$#" -ne 1 ]; then
    echo "引数不正"
    exit 1
fi

case "$1" in
    create_docker_container)
        create_docker_container
        ;;
    start_docker_container)
        start_docker_container
        ;;
    stop_docker_container)
        stop_docker_container
        ;;
    reboot_docker_container)
        reboot_docker_container
        ;;
    con_vpn_docker_container)
        con_vpn_docker_container
        ;;
    rm_docker_container)
        rm_docker_container
        ;;
    copy_testscript_docker_container)
        copy_testscript_docker_container
        ;;
    execute_testfile_docker_container)
        execute_testfile_docker_container
        ;;
    stop_testfile_docker_container)
        stop_testfile_docker_container
        ;;
    stop_vpn_docker_container)
        stop_vpn_docker_container
        ;;


    *)
        echo "引数不正"
        exit 1
        ;;
esac
echo "openvpn接続用container操作終了"
