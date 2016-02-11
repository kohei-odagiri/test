#!/bin/bash
out_file="tmp.txt"
echo -n > $out_file
echo " 
select
r.buyer_id,
u.aff_code
from
tran_data r
left join
user_attrib u
on
u.user_id = r.buyer_id
where
r.date >= unix_timestamp('2015-12-1')
and
r.date <= unix_timestamp('2015-12-31')
order by r.buyer_id
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt >>$out_file
cat tmp.txt
