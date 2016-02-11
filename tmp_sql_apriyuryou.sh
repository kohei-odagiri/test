#/bin/bash
#入力チェック
if [[ "$1" ]]
then
continue
#echo $2"-->START============="
else
echo "parameter no good! retry"
exit
fi

#設定値####
s1date=$1
sdate=$(date +'%Y-%m-%d' -d "1 days ago `date +%Y-%m-01 -d"1 month $s1date"`")
out_file="tmp.txt"
echo -n > $out_file
echo "
select
#u.user_id,
#u.kakin_type,
#k.kakin_type,
#concat(if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) ,'-',u.kakin_type) as cont
#if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont
#left(u.aff_code,3) as affbase,
date_format(from_unixtime(u.date),'%Y-%m-1') as date,
u.aff_code as affbase,
count(distinct u.user_id)
from
user_attrib u
left join
sp_user s
on
u.user_id = s.user_id
and
s.date <= unix_timestamp('$sdate')
left join
m_sp_model m
on
s.model_name = m.model_name
where
u.date = unix_timestamp('$sdate')
and
u.avail_st > 0	
and
u.aff_code regexp '^(apk|apd|aps)'
group by affbase
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD >>$out_file
cat tmp.txt

