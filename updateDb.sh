#! /bin/bash
###環境変数定義###
#対象ディレクトリ
targetDir=/tmp/tmp_exce
#DB接続先情報定義
DATABASE_NAME="VAL"
USER_NAME="postgres"
SERVER_ADDRESS="localhost"
SERVER_PORT="5551" 
export PGPASSWORD="postgres"

###定数定義###
#カンマ
strComma=","
#システム日時
systemDate=$(date '+%Y-%m-%d %H:%M:%S.%3N')
#シングルクォーテーション
singleQuotation="'"
#括弧左
bracketsLeft='('
#括弧右
bracketsRight=')'
#SQLテンプテート
sqlTemplate='INSERT INTO  sk_downloadfile (dataname,fileextended,filename,filesize,filetype,koushinnichiji,sakuseihizuke,torihikisakicode) values '

###グローバル変数定義###
#中間配列
declare -a sqlValueArrays

#do
while read -r line; do
    ###項目編集start####
    #対象データ名
    dataName="${singleQuotation}""取引先商品台帳""${singleQuotation}"

    #ファイル名
    fileFullPath=$(echo "$line" | awk '{print $1}')
    fileName="${fileFullPath##*/}"
    ouputFileName="${singleQuotation}""${fileFullPath##*/}""${singleQuotation}"

    #ファイルサイズ
    fileSize=$(echo "$line" | awk '{print $3}')

    #ファイル種類
    fileType="2"

    #更新日時
    koushinNichiji='TO_TIMESTAMP'"$bracketsLeft""$singleQuotation""$systemDate""$singleQuotation""$strComma""$singleQuotation""YYYY-MM-DD HH24:MI:SS.MS""$singleQuotation""$bracketsRight"

    #作成年月日
    createDateTime=$(echo "$line" | awk '{print $2}')
    sakuseiHizuke='TO_DATE'"$bracketsLeft""$singleQuotation""$(date -d "@$createDateTime" '+%Y-%m-%d')""$singleQuotation""$strComma""$singleQuotation""YYYY-MM-DD""$singleQuotation""$bracketsRight"

    #取引先コード
    IFS=_ read -ra parts <<< "$fileName"
    torihikisakiCode="${parts[0]}"

    #ファイル拡張子
    fileExtended="2"
    ####項目編集end####


    #各項目を配列に格納
    lineArray=("$dataName" "$fileExtended" "$ouputFileName" "$fileSize" "$fileType" "$koushinNichiji" "$sakuseiHizuke" "$torihikisakiCode")

    #配列の要素をカンマで連結
    outputRecode=$(IFS=$strComma; echo "${lineArray[*]}")
    
    #insertのvalueを前後に括弧で囲む
    sqlValueArrays+=("$bracketsLeft""$outputRecode""$bracketsRight")
    

#done
done < <(ls -lh $targetDir | awk 'NR>1 {printf "%s %s %s\n", $9, $6, $7}')

#カンマで各レコードを連結
sqlValueArraysString=$(IFS=$strComma; echo "${sqlValueArrays[*]}")

#SQL文の前後にダブルクォーテーションで囲む
sqlValueArraysString="${sqlTemplate}""${sqlValueArraysString}"";"
echo $sqlValueArraysString

#DBサーバーに接続し、SQL文実行
psql -h "$SERVER_ADDRESS" -p "$SERVER_PORT" -d "$DATABASE_NAME" -U "$USER_NAME" -c "${sqlValueArraysString}"
