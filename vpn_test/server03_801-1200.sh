
wait_times=300

./operation_containers-0801-0850.sh

# 5分間待ち
for i in {1.."${wait_times}"}
do
   echo "実行待ち"${i}"秒"
   sleep 1
done
./operation_containers-0851-0900.sh

# 5分間待ち
for i in {1.."${wait_times}"}
do
   echo "実行待ち"${i}"秒"
   sleep 1
done
./operation_containers-0901-0950.sh

# 5分間待ち
for i in {1.."${wait_times}"}
do
   echo "実行待ち"${i}"秒"
   sleep 1
done
./operation_containers-0951-1000.sh

# 5分間待ち
for i in {1.."${wait_times}"}
do
   echo "実行待ち"${i}"秒"
   sleep 1
done
./operation_containers-1001-1050.sh

# 5分間待ち
for i in {1.."${wait_times}"}
do
   echo "実行待ち"${i}"秒"
   sleep 1
done
./operation_containers-1051-1100.sh

# 5分間待ち
for i in {1.."${wait_times}"}
do
   echo "実行待ち"${i}"秒"
   sleep 1
done
./operation_containers-1101-1150.sh

# 5分間待ち
for i in {1.."${wait_times}"}
do
   echo "実行待ち"${i}"秒"
   sleep 1
done
./operation_containers-1151-1200.sh
