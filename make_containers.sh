#/bin/bash
USER_NAME_START_STR="t-u-"
#ユーザー名開始index
USER_START_INDEX=1
#ユーザー名終了index
USER_END_INDEX=3


create_docker_container()
{
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "container:"$TEMP_USER_NAME
      # コンテナー作成(バックグラウンドで起動)
      docker run -d --device=/dev/net/tun --cap-add=NET_ADMIN --name $TEMP_USER_NAME vpn-client-img-base sleep infinity
      # 認証ファイルのコピー
      docker cp /home/ubuntu/vpn-client-img/vpn_keys/$TEMP_USER_NAME.ovpn $TEMP_USER_NAME:/tmp/$TEMP_USER_NAME.ovpn

done
}


echo "openvpn接続用containerクライアントの作成開始"
create_docker_container
echo "openvpn接続用containerクライアントの作成終了"
