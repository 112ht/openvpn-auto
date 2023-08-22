#/bin/bash
USER_NAME_START_STR="t-u-"
#ユーザー名開始index
USER_START_INDEX=1
#ユーザー名終了index
USER_END_INDEX=3
#処理モード 1:ユーザー作成 2:ユーザー削除
PROCESS_MODE="1"

create_openvpn_user()
{
  for i in `seq -f '%04g' $USER_START_INDEX $USER_END_INDEX`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "ユーザー作成:"$TEMP_USER_NAME
      export MENU_OPTION=$PROCESS_MODE
      export CLIENT=$TEMP_USER_NAME
      export PASS="1"
      ./openvpn-install.sh
#ファイル転送
aws s3 cp /home/ec2-user/$CLIENT.ovpn  s3://kk3-openvpn-work/

done
}


echo "openvpnのクライアント開始"
create_openvpn_user
echo "openvpnのクライアント終了"
