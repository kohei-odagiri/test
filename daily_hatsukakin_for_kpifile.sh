#/bin/bash
: <<'#COMMENT'
KPIシート用に整形して出力するscritpt
抽出にはdaily_hatsukakin_aff_career_defice.shを利用
#COMMENT
#入力チェック
if [[ "$1" ]]
then
continue
#echo $2"-->START============="
else
echo "parameter no good! retry: sh $0 YYYY-mm-d"
exit
fi
# sdate="2015-11-5"
echo -e "$1"
sdate=$1
loop=1; for aff in NULL 01 02 03 04 05 06 10 20 30 50
do
for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m month $sdate" +%Y-%m)
outfile="output/daily_"$sdate"_"$loop"_"$aff".hatsukakin.txt"
echo -n "" > $outfile
# sh daily_kyushi_aff_career_device.sh $param_date $aff | tee -a $outfile
sh daily_hatsukakin_aff_career_device.sh $param_date $aff > $outfile
done
done
for aff in NULL 01 02 03 04 05 06 10 20 30 50
do
# sdate="2015-11-5"
sdate=$1
loop=$(( ($(date +%s) - $(date -d"$sdate" +%s)) / 86400 ))
device_array=(1fp-A
1fp-D
1fp-V
0sp-A
0sp-D
0sp-V
PC
0sp-X)
for str in ${device_array[@]}
do
out_array=()
for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m days $sdate" +%Y-%m-%d)
value=$(grep -e "^$param_date" output/daily_$1_1_$aff.hatsukakin.txt | cut -f2- | grep -e "^$str" | cut -f2)
if [ $value  ]
then
out_array=(${out_array[@]} $value)
else
out_array=(${out_array[@]} 0)
fi
done
str1=$(echo ${out_array[@]} | tr -s ' ' ',')
echo -e "$str1"
#echo -e $aff","$str","$str1
done
echo ""
done

