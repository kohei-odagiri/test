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
#COMMENT

#���̓`�F�b�N
if [[ "$1" && "$2" ]]
then
continue
#echo $2"-->START============="
else
echo "parameter no good! retry"
exit
fi

#�f�t�H���g�l
k_sdate=$(echo $1"-1")
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
aff_array=($(grep "^$regist_root" $aff_list | cut -f2))

##aff�Ȃ�����
if [[ "$2" =~ "NUL" ]]
then
aff_check=$(echo "^$")
else
aff_check=$(echo "^("$(echo ${aff_array[@]} | tr -s ' ' '|' | sed -re 's/|$//')")")
fi

for ((i=0; i<$k_term; i++))
do
sdate=$(date -d"$i days $k_sdate" +%F)
###
#�w�茎�̏��ۋ��҂𒊏o
kyushiuser_array=($(echo "
select distinct k.user_id
from kakin_log2 k
join user_attrib u
on k.user_id = u.user_id and
u.date = unix_timestamp('$k_edate') and
u.aff_code regexp '$aff_check'
where
k.kakin_st = 1 and
k.date = unix_timestamp('$sdate') and
u.user_id is not null
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD))

#�x�[�X�̉ۋ��Ґ�check 0�Ȃ�exit
all_user=${#kyushiuser_array[*]}

if [ $all_user -eq 0 ]
then
echo "count zero"
continue
fi

#�x�[�X�ۋ��҂̃��[�UID���X�g�i�J���}��؂�j
user_list=$(echo ${kyushiuser_array[@]} | tr -s ' ' ',')

#�L�����A���Ƃɏ��ۋ��Ґ����Z�o
echo "
select if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont, count(distinct u.user_id)
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
u.date = unix_timestamp('$k_edate') and
u.user_id in ($user_list)
group by cont
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD | while read line
do
echo $sdate" "$line | tr -s ' ' '\t'
done

done
exit

#####################
: <<'#COMMENT'
�ߋ�����W�v����ꍇ ���̗�́A2012-4����2013-12�̊�
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


================�o�͂����t�@�C�����s������ꂩ���ďW�v���₷������ŏ��̂��̓��t��2014-1-31�́A�t�@�C���̍ŏI�s�̓��t�ɂ��邱��
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
