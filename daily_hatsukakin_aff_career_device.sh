#/bin/bash
: <<'#COMMENT'
日ごとの経路別の初課金者をキャリアとデバイスで判別できる
#####
01_検索連動
02_Mobage
03_アフィリエイト
04_店舗アフィリエイト
05_購入アフィリエイト
06_公式
10_友達紹介
20_ggl
30_自社サイト
50_その他

日付は対象になる年月の1日を代入　2015-09-01
AFコードは、01などの経路番号以外に、--apdなどにすると詳細AFFで計測可能

#COMMENT

#入力チェック
if [[ "$1" && "$2" ]]
then
continue
#echo $2"-->START============="
else
echo "parameter no good! retry: sh $0 YYYY-mm --apd or 01 or ALL or NULL"
exit
fi

chk_str=$(echo $1 | cut -d"-" -f3)
if [[ ! $chk_str ]]
then
bdate=$1"-1"
else
bdate=$1
fi

#デフォルト値
k_sdate=$(date -d"$bdate" +%Y-%m-1)
k_edate=$(date -d"1 days ago $(date -d"1 month $k_sdate" +%Y-%m-%d)" +%Y-%m-%d)
#最終日付の判定
chk_date=$(date -d"$(date +%F)" +%s)
unixtime_k_edate=$(date -d"$k_edate" +%s)
if [[ $unixtime_k_edate -lt $chk_date ]] #月末が未来の場合は当日の前日までを最終とする
then
k_edate=$k_edate
else
k_edate=$(date -d"1 days ago" +%F)
fi

param_unixtime_a=$(date -d"$k_edate" +%s)
param_unixtime_b=$(date +%s)
param_flg=$(( $param_unixtime_a - $param_unixtime_b ))
if [[ "$param_flg" > "0" ]]
then
k_term=$( echo $(date +%d) | sed -re 's/^0+//' )
else
k_term=$( echo $(date -d"$k_edate" +%d) | sed -re 's/^0+//' )
fi
#
Path="/home/namatan/data/ltv/"
aff_list=$Path"affcode_list.txt"

##経路毎のAFリストを作成
regist_root=$2
if [[ $2 == ALL ]]
then
joken_sentense=""
elif [[ $2 == NULL ]]
then
joken_sentense="and u.aff_code regexp '^$'"
elif [[ "$2" =~ "^--" ]]
then
detail_aff=$(echo $2 | tr -d "-")
joken_sentense=" and u.aff_code regexp '^$detail_aff'"
else
aff_array=($(grep ^$2 $aff_list | cut -f2))
extract_aff_list=$(echo ${aff_array[@]} | tr -s ' ' '|')
joken_sentense="and u.aff_code regexp '^($extract_aff_list)'"
fi

for ((i=0; i<$k_term; i++))
do
sdate=$(date -d"$i days $k_sdate" +%F)
###
#指定月の初課金者を抽出
kakinuser_array=($(echo "
select distinct k.user_id
from kakin_log k
join user_attrib u
on k.user_id = u.user_id and
u.date = unix_timestamp('$k_edate') $joken_sentense
where
k.kakin_st = 3 and
k.log_type = 3 and
k.date = unix_timestamp('$sdate') and
u.user_id is not null
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD))

#ベースの課金者数check 0ならexit
all_user=${#kakinuser_array[*]}

if [ $all_user -eq 0 ]
then
echo "count zero"
continue
fi

#ベース課金者のユーザIDリスト（カンマ区切り）
user_list=$(echo ${kakinuser_array[@]} | tr -s ' ' ',')

#キャリアごとに初課金者数を算出

echo "
select date_format(from_unixtime(u.date),'%Y-%m-%d'), if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont, count(distinct u.user_id)
from user_attrib u
left join
sp_user s
on
u.user_id = s.user_id and
s.date <= unix_timestamp('$sdate')
left join
m_sp_model m
on
s.model_name = m.model_name
where
u.date = unix_timestamp('$sdate') and
u.user_id in ($user_list)
group by cont
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD

done
exit

#####################
: <<'#COMMENT'
過去から集計する場合 下の例は、2012-4から2013-12の間
sdate="2012-4-1"; loop=21; for aff in NUL 01 02 03 04 05 06 10 20 30 50
do
for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m month $sdate" +%Y-%m)
outfile="output/"$sdate"_"$loop"_"$aff".hatsukakin.txt"
sh hatsukakin_aff_career_device.sh $param_date $aff | tee -a $outfile
done
done
================
出力したファイルを行列をいれかえて集計しやすくする
sdate="2012-4-1"; loop=3; device_array=(1fp-A
1fp-D
1fp-V
0sp-A
0sp-D
0sp-V
NULL
0sp-X); for str in ${device_array[@]}
do
out_array=()
for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m month $sdate" +%Y-%m)
value=$(grep -e "^$param_date" 2012-4-1_3_NUL.hatsukakin.txt | cut -f2- | grep -e "^$str" | cut -f2)
if [ $value > 0 ]
then
out_array=(${out_array[@]} $value)
else
out_array=(${out_array[@]} 0)
fi
done
echo -e $str"\t"${out_array[@]}
done

#COMMENT
