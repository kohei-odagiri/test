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

######�ٻߥ桼����������̤˥����Ȥ��ƽ���

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
###
#�����ν�ݶ�Ԥ����
kyushiuser_array=($(echo "
select k.user_id
from kakin_log2 k
join user_attrib u
on k.user_id = u.user_id and
u.date = unix_timestamp('$k_edate') and
u.aff_code regexp '$aff_check'
where
k.kakin_st = 1 and
k.date >= unix_timestamp('$k_sdate') and
k.date <= unix_timestamp('$k_edate') and
u.user_id is not null
#and
#u.aff_code regexp '^(aps|apk|apd)'
#u.aff_code regexp '^(apk|apd)'
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD))

#�١����βݶ�Կ�check 0�ʤ�exit
all_user=${#kyushiuser_array[*]}

if [ $all_user -eq 0 ]
then
echo "count zero"
continue
fi

#�١����ݶ�ԤΥ桼��ID�ꥹ�ȡʥ���޶��ڤ��
user_list=$(echo ${kyushiuser_array[@]} | tr -s ' ' ',')

#����ꥢ���Ȥ˽�ݶ�Կ��򻻽�
echo "
select
date_format(from_unixtime(u.date),'%Y-%m-1'),
#date_format(from_unixtime(s.date),'%Y-%m-1'),
#date_format(from_unixtime(u.reg_date),'%Y-%m') as sdate,
#if(s.date < u.reg_date ,if(s.date = 'NULL',0 ,1),0)  as usdate,
#if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont,
concat( if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) , if(s.date < u.reg_date ,if(s.date = 'NULL',0 ,1),0) ) as us2date,
#u.aff_code,
#count(distinct u.user_id)
u.user_id
from user_attrib u
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
group by u.user_id
#group by us2date
#order by sdate desc
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD

done
exit

#####################
: <<'#COMMENT'
���齸�פ����� ������ϡ�2012-4����2013-12�δ�
/home/namatan/data/ltv

bash ������

============

sdate="2014-9-1"; loop=1; for aff in NUL 01 02 03 04 05 06 10 20 30 50
do
for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m month $sdate" +%Y-%m)
outfile="output/daily_"$sdate"_"$loop"_"$aff".kyushi.txt"
echo -n "" > $outfile
sh daily_kyushi_aff_career_device.sh $param_date $aff | tee -a $outfile
done
done


================���Ϥ����ե���������򤤤줫���ƽ��פ��䤹������ǽ�Τ������դ�2014-1-31�ϡ��ե�����κǽ��Ԥ����դˤ��뤳��
for aff in NUL 01 02 03 04 05 06 10 20 30 50
do
sdate="2014-9-1"
loop=$(( ($(date +%s) - $(date -d"$sdate" +%s)) / 86400 ))
device_array=(1fp-A
1fp-D
1fp-V
0sp-A
0sp-D
0sp-V
PC
0sp-X)
for str in ${device_array[@]}
do
out_array=()
for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m days $sdate" +%Y-%m-%d)
value=$(grep -e "^$param_date" output/daily_2014-9-1_1_$aff.kyushi.txt | cut -f2- | grep -e "^$str" | cut -f2)
if [ $value  ]
then
out_array=(${out_array[@]} $value)
else
out_array=(${out_array[@]} 0)
fi
done
str1=$(echo ${out_array[@]} | tr -s ' ' ',')
echo -e $aff","$str","$str1
done
echo ""
done


#COMMENT

