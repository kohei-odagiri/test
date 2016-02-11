#/bin/bash
out_file="tmp.txt"
echo -n > $out_file
echo "
select
#u.user_id,
#u.kakin_type,
#k.kakin_type,
concat(if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) ,'-',u.kakin_type) as cont
#if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont
,count(distinct u.user_id)
from
user_attrib u
left join
sp_user s
on
u.user_id = s.user_id
and
s.date <= unix_timestamp('2015-12-31')
#and
#s.ez_chk = 0
#and
#s.sb_chk = 0
#and
#dcm_chk = 0
left join
m_sp_model m
on
s.model_name = m.model_name
#and
#m.model_name is null
#and
#m.career = 'A'
#left join
#kakin_log2 k
#on
#u.user_id = k.user_id
#and
#k.date <= unix_timestamp('2015-12-31')
where
u.date = unix_timestamp('2015-12-31')
and
u.avail_st > 0	
#and
#u.career = 'A'
group by cont
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD >>$out_file
cat tmp.txt

