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

# Ǥ�դ�UID���ѿ��˳�Ǽ����Ÿ��
kakin_uu_array=$(cat user_id.txt)
user_list=$(echo ${kakin_uu_array[@]} | tr -s ' ' ',')
#echo $user_list

# Ǥ�դ�sql��з�̤��out_file�˳�Ǽ����Ÿ��
echo "
select
u.user_id,
u.pref_id
from
user_attrib u
where
u.date = unix_timestamp('$sdate')
and
u.user_id in ($user_list)
#and
#u.reg_date >= unix_timestamp('$sdate')
#and
#u.reg_date <= unix_timestamp('2015-6-5')
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD >>$out_file
cat tmp.txt

