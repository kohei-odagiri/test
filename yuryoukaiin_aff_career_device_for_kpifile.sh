#/bin/bash
: <<'#COMMENT'
日別有料会員数
KPIシート用に整形して出力するscript
指定日付より未来へ最大3日間抽出できる
#COMMENT
if [[ "$1" && "$2" ]]
then
continue
#echo $2"-->START============="
else
echo "parameter no good! retry"
exit
fi
# loop=$(( ($(date +%s) - $(date -d"$1" +%s)) / 86400 ))
loop1=$(( ($(date +%s) - $(date -d"$1" +%s)) / 86400 ))
if [[ $loop1 = 1 ]]
then
loop=$loop1
#echo $loop
elif
[[ $loop1 = 2 ]]
then
loop=$loop1
#echo $loop
elif
[[ $loop1 = 3 ]]
then
loop=$loop1
#echo $loop
else
loop=3
fi

for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m days $1" +%Y-%m-%d)
outfile="output/daily_"$param_date"_"$2"_.yuryoukaiin.txt"
echo -n "" > $outfile
# sh yuryoukaiin_aff_career_device_for_kpi.sh $param_date $2 | tee -a $outfile
sh yuryoukaiin_aff_career_device.sh $param_date $2 > $outfile
done
if [[ $m = 3 ]]
then
param_date1=$(date -d"0 days $1" +%Y-%m-%d)
param_date2=$(date -d"1 days $1" +%Y-%m-%d)
param_date3=$(date -d"2 days $1" +%Y-%m-%d)
echo $param_date1 $param_date2 $param_date3
paste -d, output/daily_"$param_date1"_"$2"_.yuryoukaiin.txt output/daily_"$param_date2"_"$2"_.yuryoukaiin.txt output/daily_"$param_date2"_"$2"_.yuryoukaiin.txt
elif [[ $m = 2 ]]
then
param_date1=$(date -d"0 days $1" +%Y-%m-%d)
param_date2=$(date -d"1 days $1" +%Y-%m-%d)
echo $param_date1 $param_date2 $param_date3
paste -d, output/daily_"$param_date1"_"$2"_.yuryoukaiin.txt output/daily_"$param_date2"_"$2"_.yuryoukaiin.txt
elif [[ $m = 1 ]]
then
param_date1=$(date -d"0 days $1" +%Y-%m-%d)
echo $param_date1 $param_date2 $param_date3
paste -d, output/daily_"$param_date1"_"$2"_.yuryoukaiin.txt
else
echo "no"
fi

