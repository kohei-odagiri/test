#/bin/bash
: <<'#COMMENT'
#COMMENT
if [[ "$1" && "$2" && "$3" ]]
then
continue
else
echo "parameter no good! retry"
exit
fi

#初期設定値
sdate=$(echo $1"-1")
aff=$2
loop=$3

for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m month $sdate" +%Y-%m)
sh monthly_kyushi_aff_career_device4.sh $param_date $2 
# sh yuryoukaiin_aff_career_device_monthly2.sh $param_date $2 
# sh monthly_saikai_aff_career_device5.sh $param_date $2
# sh monthly_hatsukakin_aff_career_device.sh $param_date $2
done

