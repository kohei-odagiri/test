#/bin/bash
: <<'#COMMENT'
�����Ȥη�ϩ�̤ν�ݶ�Ԥ򥭥�ꥢ�ȥǥХ�����Ƚ�̤Ǥ���
#####
01_����Ϣư
02_Mobage
03_���ե��ꥨ����
04_Ź�ޥ��ե��ꥨ����
05_�������ե��ꥨ����
06_����
10_ͧã�Ҳ�
20_ggl
30_���ҥ�����
50_����¾
#COMMENT

#���ϥ����å�
if [[ "$1" && "$2" ]]
then
continue
#echo $2"-->START============="
else
echo "parameter no good! retry"
exit
fi

#�ǥե������
k_sdate=$(echo $1"-1")
#k_edate=$2
k_edate=$(date -d"1 days ago $(date -d"1 month $k_sdate" +%Y-%m-%d)" +%Y-%m-%d)
#�ǽ����դ�Ƚ��
chk_date=$(date -d"$(date +%F)" +%s)
unixtime_k_edate=$(date -d"$k_edate" +%s)
if [[ $unixtime_k_edate -lt $chk_date ]] #������̤��ξ��������������ޤǤ�ǽ��Ȥ���
then
k_edate=$k_edate
else
k_edate=$(date -d"1 days ago" +%F)
fi

param_unixtime_a=$(date -d"$k_edate" +%s)
param_unixtime_b=$(date +%s)
param_flg=$(( $param_unixtime_a - $param_unixtime_b ))
if [[ "$param_flg" > "0" ]]
then
k_term=$( echo $(date +%d) | sed -re 's/^0+//' )
else
k_term=$( echo $(date -d"$k_edate" +%d) | sed -re 's/^0+//' )
fi
#
Path="/home/namatan/data/ltv/"
aff_list=$Path"affcode_list.txt"
##��ϩ���AF�ꥹ�Ȥ����
regist_root=$2
aff_array=($(grep "^$regist_root" $aff_list | cut -f2))

##aff�ʤ�Ƚ��
if [[ "$2" =~ "NUL" ]]
then
aff_check=$(echo "^$")
else
aff_check=$(echo "^("$(echo ${aff_array[@]} | tr -s ' ' '|' | sed -re 's/|$//')")")
fi

for ((i=0; i<1; i++))
do
#sdate=$(date -d"$i days $k_sdate" +%F)
###
#�����κƳ��Ԥ����
kyushiuser_array=($(echo "
select distinct k.user_id
from kakin_log k
join user_attrib u
on k.user_id = u.user_id and
u.date = unix_timestamp('$k_edate') and
u.aff_code regexp '$aff_check'
where
k.log_type < 3 and #��������1�ϰ��Ѥ����ݶ� 3̤���ˤ���Ƚ�ݶ�Τ߽���
k.kakin_st = 3 and
k.date >= unix_timestamp('$k_sdate') and
k.date <= unix_timestamp('$k_edate') and
u.user_id is not null
and
u.aff_code regexp '^(apk|apd|aps)'
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt))

#�١����βݶ�Կ�check 0�ʤ�exit
all_user=${#kyushiuser_array[*]}

if [ $all_user -eq 0 ]
then
echo "count zero"
continue
fi

#�١����ݶ�ԤΥ桼��ID�ꥹ�ȡʥ���޶��ڤ��
user_list=$(echo ${kyushiuser_array[@]} | tr -s ' ' ',')

#�Ƴ��Լ¿����ºݤ˲ݶ⥢��������»ܤ����桼����kakinlog2�򻲾�

saikai_uu_array=($(echo "
select distinct user_id
from
kakin_log2
where
date >= unix_timestamp('$k_sdate') and
date <= unix_timestamp('$k_edate') and
user_id in ($user_list)
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt))

#�١����ݶ�ԤΥ桼��ID�ꥹ�ȡʥ���޶��ڤ��
user_list=$(echo ${saikai_uu_array[@]} | tr -s ' ' ',')

#����ꥢ���Ȥ˽�ݶ�Կ��򻻽�
echo "
select
date_format(from_unixtime(u.date),'%Y-%m-1'),
u.aff_code,
count(distinct u.user_id)
from 
user_attrib u
left join
sp_user s
on
u.user_id = s.user_id and
s.date <= unix_timestamp('$k_edate')
left join
m_sp_model m
on
s.model_name = m.model_name
where
u.date = unix_timestamp('$k_edate') and
u.user_id in ($user_list)
group by u.aff_code
;" | mysql -s -hmd157 -uodagiri.kohei market -pDotiDiIt

done
exit

#####################
: <<'#COMMENT'


#COMMENT

