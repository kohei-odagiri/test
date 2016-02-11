#/bin/bash
out_file="tmp.txt"
echo -n > $out_file
echo "
select
date_format(from_unixtime(u.reg_date), '%Y-%m-%d'),
u.user_id,
u.user_st,
u.serv_st,
u.avail_st,
u.aff_code,
m.mmgok_flg,
u.sex_type
from
user_attrib u
left join
mmgok_flg m
on
u.user_id = m.user_id
where
u.date = unix_timestamp('2016-2-5')
and
u.reg_date >= unix_timestamp('2016-2-5')
and
u.reg_date <= unix_timestamp('2016-2-6')
group by user_id
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt >>$out_file
cat tmp.txt

