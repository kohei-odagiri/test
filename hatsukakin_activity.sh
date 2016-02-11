#/bin/bash
if [[ "$1" && "$2" ]]
then
continue
#echo $2"-->START============="
else
echo "parameter no good! retry"
exit
fi
for ((i=0; i<1; i++))
do
out_file="output/hatsukakin_activity.txt"
echo -n > $out_file
s1date="$1"
# term=$(( ($(date -d"1 days ago" +%s) - $(date -ds1date" +%s))/86400 ))
term="$2"
for ((i=0; i<=$term; i++))
do
sdate=$(date -d"$i days $s1date" +%F)
# sdate="2015-2-23"
kakin_uu_array=($(echo "
select k.user_id
from
kakin_log k
inner join
user_attrib u
on
k.user_id = u.user_id
where
k.kakin_st = 3 and
k.log_type = 3 and
k.date = unix_timestamp('$sdate') and
k.date = u.date 
and
# u.aff_code = ''
u.aff_code regexp '^(apd|aps|apk|^$|aup|aua|brc)'
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt))
#ベース課金者のユーザIDリスト（カンマ区切り）
user_list=$(echo ${kakin_uu_array[@]} | tr -s ' ' ',')
#echo $user_list

echo "
select 
from_unixtime(u.date,'%Y/%m/%d') as kdate, 
u.user_id,
if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont, 
m.model_name,
u.sex_type,
u.birthday,
(YEAR(from_unixtime(u.reg_date))-YEAR(u.birthday)) - (RIGHT(from_unixtime(u.reg_date),5)<RIGHT(u.birthday,5)),
from_unixtime(u.reg_date,'%Y/%m/%d') as regdate,

(
select
i.item_id
from 
new_item_data i
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as sitem,

(
select
i.categ_id
from 
new_item_data i
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_id,

(
select
c.categ_name
from 
new_item_data i
left join
m_categ_path c
on
i.categ_id = c.categ_id
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_name,

(
select
c.categ_name_1
from 
new_item_data i
left join
m_categ_path c
on
i.categ_id = c.categ_id
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_name_1,

(
select
c.categ_name_2
from 
new_item_data i
left join
m_categ_path c
on
i.categ_id = c.categ_id
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_name_2,

(
select
c.categ_name_3
from 
new_item_data i
left join
m_categ_path c
on
i.categ_id = c.categ_id
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_name_3,

(
select
c.categ_name_4
from 
new_item_data i
left join
m_categ_path c
on
i.categ_id = c.categ_id
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_name_4,

(
select
c.categ_name_5
from 
new_item_data i
left join
m_categ_path c
on
i.categ_id = c.categ_id
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_name_5,

(
select
c.categ_name_6
from 
new_item_data i
left join
m_categ_path c
on
i.categ_id = c.categ_id
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_name_6,

(
select
c.categ_name_7
from 
new_item_data i
left join
m_categ_path c
on
i.categ_id = c.categ_id
where
i.user_id in ($user_list)
and
i.date = unix_timestamp('$sdate') 
and
i.user_id = u.user_id
group by i.user_id
) as scateg_name_7,

b.item_id,
i.categ_id,
c.categ_name,
c.categ_name_1,
c.categ_name_2,
c.categ_name_3,
c.categ_name_4,
c.categ_name_5,
c.categ_name_6,
c.categ_name_7,

u.aff_code,
left(u.aff_code,3) as aff_base

from user_attrib u
left join
sp_user s
on
u.user_id = s.user_id and
s.date <= unix_timestamp('$sdate') 
left join
m_sp_model m
on
s.model_name = m.model_name
left join
bid_log_data b
on
b.user_id = u.user_id
and
b.date = u.date
left join
new_item_data i
on
b.item_id = i.item_id
left join
m_categ_path c
on
i.categ_id = c.categ_id

where
u.date = unix_timestamp('$sdate') and
u.user_id in ($user_list)
group by u.user_id
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt >> $out_file
done
done
