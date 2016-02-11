#/bin/bash
#param_date="2015-9-30"
param_date=$1
term=$(( $(date -d"0 days ago $param_date" +%e) - 1 )); 
# term=4
sdate=$(echo $1"-1")
#k_edate=$2
tdate=$(date -d"1 days ago $(date -d"1 month $sdate" +%Y-%m-%d)" +%Y-%m-%d)
#tdate=$(date -d"0 days ago $param_date" +%Y-%m-%d) 
#sdate=$(date -d"$tdate" +%Y-%m-01)
echo "$sdate"" "" ""$tdate"
array=($(echo "
select substr(u.aff_code,1,6) as aff
from kakin_log2 k
join user_attrib u
on k.user_id = u.user_id and
u.date = unix_timestamp('$tdate') 
#u.date = unix_timestamp('2014-12-31')
where
k.kakin_st = 1 and
# k.log_type = 3 and
k.date >= unix_timestamp('$sdate') and
k.date <= unix_timestamp('$tdate') 
and
u.aff_code regexp '^(apk|apd|aps)' 
group by aff 
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD)); array=(${array[@]} NUL); for values in ${array[@]}
do
if [ $values == NUL ]
then
affinf=""
else
affinf=$values"%"
fi
result_array=()
for add in $(seq 0 $term)
do
kdate=$(date -d"$add days $sdate" +%Y-%m-%d)
result=$(echo "
select count(distinct u.user_id)
date_format(from_unixtime(k.date),'%Y-%m') as sdate,
from user_attrib u
join kakin_log2 k
on u.user_id = k.user_id and
k.kakin_st = 1 and
# k.log_type = 3 and
k.date = unix_timestamp('$kdate')
where
u.date = unix_timestamp('$tdate') and
#u.date = unix_timestamp('2014-12-31') and
u.aff_code like '$affinf'
and
u.aff_code regexp '^(apk|apd|aps)' 
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD)
if [ $result ]
then
result_array=(${result_array[@]} $result)
else
result_array=(${result_array[@]} 0)
fi
done
sums=0
for sum in ${result_array[@]}
do
sums=$(($sums+$sum))
done
#echo -e $sums" "$values" "${result_array[@]}
echo -e $values" "$sums
done


