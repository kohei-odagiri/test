#/bin/bash
: <<'#COMMENT'
#COMMENT
if [[ "$1" ]]
then
continue
else
echo "parameter no good! retry"
exit
fi
out_file="tmp.txt"
echo -n > $out_file
# sdate="2015-10-27"
sdate="$1"
s2date=$(date +'%Y-%m-%d' -d "1 days ago $sdate")

# 任意のUIDを変数に格納して展開
kakin_uu_array=$(cat user_id.txt)
user_list=$(echo ${kakin_uu_array[@]} | tr -s ' ' ',')
#echo $user_list

# 任意のsql抽出結果ををout_fileに格納して展開
echo "
select
u.user_id,
from_unixtime(u.reg_date, '%Y/%m/%d') as regdate,
from_unixtime(k.date, '%Y/%m/%d') as rogdate,
u.avail_st,
u.pref_id,
(
select
avail_st
from
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$sdate')
and
user_id = u.user_id
group by date
)as avail2,
u.aff_code,
left(u.aff_code,3) as affabse
from
user_attrib u
left join
kakin_log k
on
k.log_type = 3
and
k.user_id = u.user_id
where
u.date = unix_timestamp('$sdate')
and
u.user_id in ($user_list)
and
u.avail_st = 2
#and
#u.reg_date >= unix_timestamp('$sdate')
#and
#u.reg_date <= unix_timestamp('2015-6-5')
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD >>$out_file
cat tmp.txt

