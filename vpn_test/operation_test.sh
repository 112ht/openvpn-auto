#/bin/bash
USER_NAME_START_STR="t-u-"
#ユーザー名開始index
USER_START_INDEX=401
#ユーザー名終了index
USER_END_INDEX=800

create_ebi_file(){
date > /tmp/"$1"-"$2".txt
}

execute_testfile_docker_container()
{
  for i in `seq -f '%04g' "$1" "$2"`
  do
      export TEMP_USER_NAME=$USER_NAME_START_STR$i
      echo "containerテストスクリプト実行:"$TEMP_USER_NAME
      #テストスクリプト実行する。
      docker exec $TEMP_USER_NAME sh -c "/tmp/test_script.sh &" &

  done
create_ebi_file "$1" "$2"
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

wait_some_times()
{
  for i in {1.."$1"}
  do
      echo "実行待ち"${i}"秒"
      sleep 1
  done
}


last_wait_some_times()
{
  for i in {1.."$1"}
  do
     echo "最後実行待ち"${i}"秒"
     sleep 1
  done
}


execute_testfile_docker_container 401 500
wait_some_times 60
execute_testfile_docker_container 501 600
wait_some_times 60
execute_testfile_docker_container 601 700
wait_some_times 60
execute_testfile_docker_container 701 800
last_wait_some_times 60
