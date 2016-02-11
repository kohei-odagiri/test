#!/bin/bash
out_file="tmp.txt"
echo -n > $out_file
echo " 
select
date_format(from_unixtime(u.reg_date),'%Y-%m-%d') as regdate,
#date_format(from_unixtime(u.reg_date),'%Y') as regdate,
u.user_id,
#count(distinct u.user_id),
#if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont,
u.sex_type,
(YEAR(from_unixtime(u.reg_date))-YEAR(u.birthday)) - (RIGHT(from_unixtime(u.reg_date),5)<RIGHT(u.birthday,5)),
u.birthday,
u.a_eval_sum,
u.exhibit_cnt,
u.s_tran_num,
u.b_tran_num,
left(u.aff_code,3) as affbase,
u.user_st,
u.serv_st,
r.item_id,
i.categ_id,
c.categ_name,
c.categ_name_1,
c.categ_name_2,
c.categ_name_3,
c.categ_name_4,
c.categ_name_5,
c.categ_name_6,
c.categ_name_7
from
user_attrib u
left join
tran_data r
on
r.buyer_id = u.user_id
left join
new_item_data i
on
r.item_id = i.item_id
left join
m_categ_path c
on
i.categ_id = c.categ_id
#left join
#sp_user s
#on
#u.user_id = s.user_id
#and
#s.date <= unix_timestamp('2016-1-8')
#left join
#m_sp_model m
#on
#s.model_name = m.model_name
#left join
#tmp_last_access t
#on
#u.user_id = t.user_id
where
#入会日時を指定
u.reg_date >= unix_timestamp('2015-7-1')
and
u.reg_date < unix_timestamp('2015-8-1')
and
#抽出日を指定
u.date = unix_timestamp('2016-1-8')
and
u.user_st = 3 #user_stを指定
and
u.serv_st = 0 #serv_stを指定
and
u.aff_code regexp '^(apk|apd|aps|^$)'
and
r.item_id > 0
group by u.user_id
#limit 5
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt >>$out_file
cat tmp.txt
