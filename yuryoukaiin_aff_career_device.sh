#/bin/bash
: <<'#COMMENT'

ͭ������γ�����ϩ�̤��ĥ���ꥢ�ǥХ����̤ν���
���
[namatan@mbokw02 sh_script]$ sh yuryoukaiin_aff_career_device.sh 2014-9-30 01
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

#������#####
sdate=$1
basedate=$3
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
###
#�����ν�ݶ�Ԥ����

out_file="aff_betsu_yuryou.txt"
echo -n > $out_file

echo "
select date_format(from_unixtime(u.date),'%Y-%m-%d'), if(s.ez_chk,'0sp-A',if(s.dcm_chk,'0sp-D',if(s.sb_chk,'0sp-V',if(m.model_name is null, if(u.career='A' or u.career='D' or u.career='V', concat('1fp-',u.career),'PC'), concat('0sp-',m.career)) ))) as cont, count(u.user_id)
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
user_attrib uu
on
u.user_id = uu.user_id and
uu.date = unix_timestamp('$sdate')
where
u.date = unix_timestamp('$sdate') and
u.avail_st > 0 and
u.aff_code regexp '$aff_check' and
uu.user_id is not null
group by cont
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD >> $out_file

device_array=(1fp-A
1fp-D
1fp-V
0sp-A
0sp-D
0sp-V
0sp-X
PC)

for str in ${device_array[@]}
do
d_format=$(date -d"$sdate" +%F)
result_array=($(grep "^$d_format" $out_file | grep "$str"))
if [[ ${result_array[2]} ]]
then
count=${result_array[2]}
else
count=0
fi

# echo -e $sdate"\t"$2"\t"$str"\t"$count
echo -e $count
done

exit

: <<'#COMMENT'
ss="2014-3-31"; array=(NUL
01
02
03
04
05
06
10
20
30
50); for i in ${array[@]}
do
sh yuryoukaiin_aff_career_device.sh $ss $i $ss
done

#COMMENT


