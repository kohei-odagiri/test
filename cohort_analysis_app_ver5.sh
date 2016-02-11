#/bin/bash
for ((i=0; i<1; i++))
do
out_file="tmp.txt"
echo -n > $out_file
s1date=$1

# term=$(( ($(date -d"1 days ago" +%s) - $(date -ds1date" +%s))/86400 ))
term=$2-1
for ((i=0; i<=$term; i++))
do
sdate=$(date -d"$i days $s1date" +%F)
smdate=$(date +'%Y-%m-%d-%r' -d " `date +%Y-%m-%d-%r -d"$s1date"`") 

s2date=$(date +'%Y-%m-%d' -d "1 days $sdate")
s3date=$(date +'%Y-%m-%d' -d "3 days $sdate")
s7date=$(date +'%Y-%m-%d' -d "7 days $sdate")
s14date=$(date +'%Y-%m-%d' -d "14 days $sdate")
s21date=$(date +'%Y-%m-%d' -d "21 days $sdate")
s30date=$(date +'%Y-%m-%d' -d "30 days $sdate")
s45date=$(date +'%Y-%m-%d' -d "45 days $sdate")
s60date=$(date +'%Y-%m-%d' -d "60 days $sdate")
s90date=$(date +'%Y-%m-%d' -d "90 days $sdate")
s180date=$(date +'%Y-%m-%d' -d "180 days $sdate")
mdate=$(date +'%Y-%m-%d' -d "1 days ago `date +%Y-%m-01 -d"1 month $s1date"`") 
m1date=$(date +'%Y-%m-%d' -d "1 days ago `date +%Y-%m-01 -d"2 month $s1date"`")
m2date=$(date +'%Y-%m-%d' -d "1 days ago `date +%Y-%m-01 -d"3 month $s1date"`")
#N+3
m3date=$(date +'%Y-%m-%d' -d "1 days ago `date +%Y-%m-01 -d"4 month $s1date"`")
#N+4
m3date=$(date +'%Y-%m-%d' -d "1 days ago `date +%Y-%m-01 -d"4 month $s1date"`")

echo $sdate,$s1date,$s2date,$s7date,$s30date,$m1date,$m2date
# sdate="2015-2-23"

kakin_uu_array=($(echo "
select 
u.user_id
from 
user_attrib u
where
u.reg_date >= unix_timestamp('$sdate')
and
u.reg_date <= unix_timestamp('$s2date')
and
u.date = unix_timestamp('$sdate') 
and
#u.aff_code regexp '^(^$|apk|apd|aps)'
#u.aff_code regexp '^(apk|apd|aps)'
u.aff_code regexp '^(aad|acf|acr|act|afm|aka|ame|ans|ant|apa|apt|bds|bga|epk|fca|fcb|fcg|fcm|gba|jan|jip|jiq|kyo|lmp|lpl|m8n|m8p|m8s|mad|mfa|mla|mlm|moa|mon|mop|mra|mrq|mrz|naa|nag|nis|oik|pfa|pka|pkc|pkd|pke|pkf|pkg|pkh|pki|pkj|pkk|pkm|pkn|pkp|pku|pky|pkz|pra|prb|rsu|sat|sbe|sma|smc|smd|spf|sta|stm|stu|tra|vnm|waz|xmx)'
#u.aff_code regexp '^(spp)'
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt))
user_list=$(echo ${kakin_uu_array[@]} | tr -s ' ' ',')
echo $user_list

echo "
select
date_format(from_unixtime(u.reg_date), '%Y-%m-%d'),
date_format(from_unixtime(k.date), '%Y-%m-%d'),
u.user_id,
if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont,
# date_format(from_unixtime(t.date), '%Y-%m-%d'),
u.avail_st,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s2date') 
and
user_id = u.user_id
group by date
) as avail_1,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s3date') 
and
user_id = u.user_id
group by date
) as avail_3,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s7date') 
and
user_id = u.user_id
group by date
) as avail_7,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s14date') 
and
user_id = u.user_id
group by date
) as avail_14,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s21date') 
and
user_id = u.user_id
group by date
) as avail_21,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$mdate') 
and
user_id = u.user_id
group by date
) as avail_30,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$m1date') 
and
user_id = u.user_id
group by date
) as avail_60,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$m2date') 
and
user_id = u.user_id
group by date
) as avail_90,

(
select
avail_st
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$m3date') 
and
user_id = u.user_id
group by date
) as avail_180,

u.user_st,
g.mmgok_flg,
k.kakin_type,

(
select
count(f.f_user_id)
from 
my_favor_data f
where
f.user_id in ($user_list)
and
f.date = unix_timestamp('$sdate') 
and
f.user_id = u.user_id
group by f.user_id
) as fuser,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date >= unix_timestamp('$s2date') 
and 
t.date <= unix_timestamp('$s2date') 
and
t.user_id = u.user_id
) as acccess2,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s2date') 
and 
t.date <= unix_timestamp('$s3date') 
and
t.user_id = u.user_id
) as acccess3,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s3date') 
and 
t.date <= unix_timestamp('$s7date') 
and
t.user_id = u.user_id
) as acccess7,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s7date') 
and 
t.date <= unix_timestamp('$s14date') 
and
t.user_id = u.user_id
) as acccess14,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s14date') 
and 
t.date <= unix_timestamp('$s21date') 
and
t.user_id = u.user_id
) as acccess21,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s21date') 
and 
t.date <= unix_timestamp('$s30date') 
and
t.user_id = u.user_id
) as acccess30,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s30date') 
and 
t.date <= unix_timestamp('$s45date') 
and
t.user_id = u.user_id
) as acccess45,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s45date') 
and 
t.date <= unix_timestamp('$s60date') 
and
t.user_id = u.user_id
) as acccess60,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s60date') 
and 
t.date <= unix_timestamp('$s90date') 
and
t.user_id = u.user_id
) as acccess90,

(
select 
count(t.date) 
from 
tmp_last_access t
where  
t.date > unix_timestamp('$s90date') 
and 
t.date <= unix_timestamp('$s180date') 
and
t.user_id = u.user_id
) as acccess180,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date >= unix_timestamp('$sdate') 
and
b.date <= unix_timestamp('$sdate') 
group by b.user_id
) as biditem,

####################ここを見直す##########################
(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date >= unix_timestamp('$s2date') 
and
b.date <= unix_timestamp('$s2date') 
group by b.user_id
) as bid1item,
####################ここを見直す##########################

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s2date') 
and
b.date <= unix_timestamp('$s3date') 
group by b.user_id
) as bid3item,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s3date') 
and
b.date <= unix_timestamp('$s7date') 
group by b.user_id
) as bid7item,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s7date') 
and
b.date <= unix_timestamp('$s14date') 
group by b.user_id
) as bid14item,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s14date') 
and
b.date <= unix_timestamp('$s21date') 
group by b.user_id
) as bid21item,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s21date') 
and
b.date <= unix_timestamp('$s30date') 
group by b.user_id
) as bid30item,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s30date') 
and
b.date <= unix_timestamp('$s45date') 
group by b.user_id
) as bid45item,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s45date') 
and
b.date <= unix_timestamp('$s60date') 
group by b.user_id
) as bid60item,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s60date') 
and
b.date <= unix_timestamp('$s90date') 
group by b.user_id
) as bid90item,

(
select
count(b.item_id)
from 
bid_log_data b
where
b.user_id = u.user_id
and
b.date > unix_timestamp('$s90date') 
and
b.date <= unix_timestamp('$s180date') 
group by b.user_id
) as bid180item,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$sdate') 
and
user_id = u.user_id
group by date
) as exthibit_0,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s2date') 
and
user_id = u.user_id
group by date
) as exthibit_1,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s3date') 
and
user_id = u.user_id
group by date
) as exthibit_3,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s7date') 
and
user_id = u.user_id
group by date
) as exthibit_7,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s14date') 
and
user_id = u.user_id
group by date
) as exthibit_14,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s21date') 
and
user_id = u.user_id
group by date
) as exthibit_21,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s30date') 
and
user_id = u.user_id
group by date
) as exthibit_30,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s45date') 
and
user_id = u.user_id
group by date
) as exthibit_45,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s60date') 
and
user_id = u.user_id
group by date
) as exthibit_60,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s90date') 
and
user_id = u.user_id
group by date
) as exthibit_90,

(
select
exhibit_cnt
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s180date') 
and
user_id = u.user_id
group by date
) as exthibit_180,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$sdate') 
and
user_id = u.user_id
group by date
) as s_tran_num_0,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s2date') 
and
user_id = u.user_id
group by date
) as s_tran_num_1,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s3date') 
and
user_id = u.user_id
group by date
) as s_tran_num_3,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s7date') 
and
user_id = u.user_id
group by date
) as s_tran_num_7,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s14date') 
and
user_id = u.user_id
group by date
) as s_tran_num_14,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s21date') 
and
user_id = u.user_id
group by date
) as s_tran_num_21,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s30date') 
and
user_id = u.user_id
group by date
) as s_tran_num_30,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s45date') 
and
user_id = u.user_id
group by date
) as s_tran_num_45,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s60date') 
and
user_id = u.user_id
group by date
) as s_tran_num_60,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s90date') 
and
user_id = u.user_id
group by date
) as s_tran_num_90,

(
select
s_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s180date') 
and
user_id = u.user_id
group by date
) as s_tran_num_180,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$sdate') 
and
user_id = u.user_id
group by date
) as b_tran_num_0,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s2date') 
and
user_id = u.user_id
group by date
) as b_tran_num_1,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s3date') 
and
user_id = u.user_id
group by date
) as b_tran_num_3,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s7date') 
and
user_id = u.user_id
group by date
) as b_tran_num_7,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s14date') 
and
user_id = u.user_id
group by date
) as b_tran_num_14,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s21date') 
and
user_id = u.user_id
group by date
) as b_tran_num_21,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s30date') 
and
user_id = u.user_id
group by date
) as b_tran_num_30,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s45date') 
and
user_id = u.user_id
group by date
) as b_tran_num_45,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s60date') 
and
user_id = u.user_id
group by date
) as b_tran_num_60,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s90date') 
and
user_id = u.user_id
group by date
) as b_tran_num_90,

(
select
b_tran_num
from 
user_attrib
where
user_id in ($user_list)
and
date = unix_timestamp('$s180date') 
and
user_id = u.user_id
group by date
) as b_tran_num_180,

u.sex_type,
u.birthday,
(YEAR(from_unixtime(u.reg_date))-YEAR(u.birthday)) - (RIGHT(from_unixtime(u.reg_date),5)<RIGHT(u.birthday,5)),

left(u.aff_code,3) as affabse,
u.aff_code,

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
c.categ_name_7

from
user_attrib u
left join
sp_user s
on
u.user_id = s.user_id and
# 当日
s.date <= unix_timestamp('$sdate') 
# 翌日
# s.date <= unix_timestamp('$s2date') 
# 3日後
# s.date <= unix_timestamp('$s3date') 
# 7日後
# s.date <= unix_timestamp('$s7date') 
left join
m_sp_model m
on
s.model_name = m.model_name
left join
tmp_last_access t
on
u.user_id = t.user_id 
left join
kakin_log k
on
u.user_id = k.user_id
left join
mmgok_flg g
on
u.user_id = g.user_id
left join
my_favor_data f
on
f.user_id = u.user_id
# and
# g.date = unix_timestamp('sdate')
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
u.date = unix_timestamp('$sdate')
and
u.user_id in ($user_list)
group by u.user_id
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt >> $out_file
done
done
cat tmp.txt

