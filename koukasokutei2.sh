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

# C?!eO?IUID?oEN?o?E3EC??!|?AA!?3¡ña
kakin_uu_array=$(cat user_id.txt)
user_list=$(echo ${kakin_uu_array[@]} | tr -s ' ' ',')
#echo $user_list

# C?!eO?IsqlAe?D!|e2I?o?oout_file?E3EC??!|?AA!?3¡ña
echo "
select 
u.user_id,
date_format(from_unixtime(k.date),'%Y-%m-%d'), 
# date_format(from_unixtime(u.date),'%Y-%m-%d'), 
# if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont, 
count(distinct u.user_id)
from user_attrib u
left join
sp_user s
on
u.user_id = s.user_id and
s.date <= unix_timestamp('$sdate')
left join
kakin_log2 k
on
u.user_id = k.user_id and
k.date >= unix_timestamp('2015-12-1')
#and
#k.log_type < 3 and
#k.kakin_st = 3 
left join
m_sp_model m
on
s.model_name = m.model_name
where
u.date = unix_timestamp('$sdate') and
u.user_id in ($user_list)
group by u.user_id
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD >>$out_file
cat tmp.txt


