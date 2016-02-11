#/bin/bash
: <<'#COMMENT'
�����Ƃ̌o�H�ʂ̏��ۋ��҂��L�����A�ƃf�o�C�X�Ŕ��ʂł���
#####
01_�����A��
02_Mobage
03_�A�t�B���G�C�g
04_�X�܃A�t�B���G�C�g
05_�w���A�t�B���G�C�g
06_����
10_�F�B�Љ�
20_ggl
30_���ЃT�C�g
50_���̑�

���t�͑ΏۂɂȂ�N����1�������@2015-09-01
AF�R�[�h�́A01�Ȃǂ̌o�H�ԍ��ȊO�ɁA--apd�Ȃǂɂ���Əڍ�AFF�Ōv���\

#COMMENT

#���̓`�F�b�N
if [[ "$1" && "$2" ]]
then
continue
#echo $2"-->START============="
else
echo "parameter no good! retry: sh $0 YYYY-mm --apd or 01 or ALL or NULL"
exit
fi

chk_str=$(echo $1 | cut -d"-" -f3)
if [[ ! $chk_str ]]
then
bdate=$1"-1"
else
bdate=$1
fi

#�f�t�H���g�l
k_sdate=$(date -d"$bdate" +%Y-%m-1)
k_edate=$(date -d"1 days ago $(date -d"1 month $k_sdate" +%Y-%m-%d)" +%Y-%m-%d)
#�ŏI���t�̔���
chk_date=$(date -d"$(date +%F)" +%s)
unixtime_k_edate=$(date -d"$k_edate" +%s)
if [[ $unixtime_k_edate -lt $chk_date ]] #�����������̏ꍇ�͓����̑O���܂ł��ŏI�Ƃ���
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

##�o�H����AF���X�g���쐬
regist_root=$2
if [[ $2 == ALL ]]
then
joken_sentense=""
elif [[ $2 == NULL ]]
then
joken_sentense="and u.aff_code regexp '^$'"
elif [[ "$2" =~ "^--" ]]
then
detail_aff=$(echo $2 | tr -d "-")
joken_sentense=" and u.aff_code regexp '^$detail_aff'"
else
aff_array=($(grep ^$2 $aff_list | cut -f2))
extract_aff_list=$(echo ${aff_array[@]} | tr -s ' ' '|')
joken_sentense="and u.aff_code regexp '^($extract_aff_list)'"
fi

for ((i=0; i<$k_term; i++))
do
sdate=$(date -d"$i days $k_sdate" +%F)
###
#�w�茎�̏��ۋ��҂𒊏o
kakinuser_array=($(echo "
select distinct k.user_id
from kakin_log k
join user_attrib u
on k.user_id = u.user_id and
u.date = unix_timestamp('$k_edate') $joken_sentense
where
k.kakin_st = 3 and
k.log_type = 3 and
k.date = unix_timestamp('$sdate') and
u.user_id is not null
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD))

#�x�[�X�̉ۋ��Ґ�check 0�Ȃ�exit
all_user=${#kakinuser_array[*]}

if [ $all_user -eq 0 ]
then
echo "count zero"
continue
fi

#�x�[�X�ۋ��҂̃��[�UID���X�g�i�J���}��؂�j
user_list=$(echo ${kakinuser_array[@]} | tr -s ' ' ',')

#�L�����A���Ƃɏ��ۋ��Ґ����Z�o

echo "
select date_format(from_unixtime(u.date),'%Y-%m-%d'), if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont, count(distinct u.user_id)
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
where
u.date = unix_timestamp('$sdate') and
u.user_id in ($user_list)
group by cont
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD

done
exit

#####################
: <<'#COMMENT'
�ߋ�����W�v����ꍇ ���̗�́A2012-4����2013-12�̊�
sdate="2012-4-1"; loop=21; for aff in NUL 01 02 03 04 05 06 10 20 30 50
do
for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m month $sdate" +%Y-%m)
outfile="output/"$sdate"_"$loop"_"$aff".hatsukakin.txt"
sh hatsukakin_aff_career_device.sh $param_date $aff | tee -a $outfile
done
done
================
�o�͂����t�@�C�����s������ꂩ���ďW�v���₷������
sdate="2012-4-1"; loop=3; device_array=(1fp-A
1fp-D
1fp-V
0sp-A
0sp-D
0sp-V
NULL
0sp-X); for str in ${device_array[@]}
do
out_array=()
for ((m=0; m<$loop; m++))
do
param_date=$(date -d"$m month $sdate" +%Y-%m)
value=$(grep -e "^$param_date" 2012-4-1_3_NUL.hatsukakin.txt | cut -f2- | grep -e "^$str" | cut -f2)
if [ $value > 0 ]
then
out_array=(${out_array[@]} $value)
else
out_array=(${out_array[@]} 0)
fi
done
echo -e $str"\t"${out_array[@]}
done

#COMMENT
