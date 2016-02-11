#/bin/bash
out_file="tmp.txt"
echo -n > $out_file
echo "
select
user_id,
sum(price) as price,
count(item_id) as count
from
tran_data
where
date >= unix_timestamp('2015-11-1')
and
date <= unix_timestamp('2015-11-30')
group by user_id
order by price desc
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD >>$out_file
cat tmp.txt

