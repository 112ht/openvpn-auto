#/bin/bash
USER_NAME_START_STR="t-u-"
#ユーザー名開始index
USER_START_INDEX=1
#ユーザー名終了index
USER_END_INDEX=3

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
      docker cp $TEMP_USER_NAME.ovpn $TEMP_USER_NAME:/tmp/$TEMP_USER_NAME.ovpn

done
}

# コンテナー起動
start_docker_container()
{
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
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "container停止:"$TEMP_USER_NAME
      # コンテナーstop
      docker stop $TEMP_USER_NAME

done
}

# コンテナー再起動
reboot_docker_container()
{
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "container再起動:"$TEMP_USER_NAME
      # 再起動
      docker restart $TEMP_USER_NAME

done
}
# コンテナー再起動
rm_docker_container()
{
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
      docker exec $TEMP_USER_NAME sh -c "/usr/sbin/openvpn --config /tmp/$TEMP_USER_NAME.ovpn &"

done
}

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
        
    *)
        echo "引数不正"
        exit 1
        ;;
esac
echo "openvpn接続用container操作正常終了"
