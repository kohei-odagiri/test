#/bin/bash
#param_date="2015-9-30"
param_date=$1
term=$(( $(date -d"0 days ago $param_date" +%e) - 1 )); 
# term=4
tdate=$(date -d"0 days ago $param_date" +%Y-%m-%d); sdate=$(date -d"$tdate" +%Y-%m-01);echo "$sdate"" ""$kdate"" ""$tdate"; array=($(echo "
select substr(u.aff_code,1,6) as aff
from kakin_log k
join user_attrib u
on k.user_id = u.user_id and
u.date = unix_timestamp('$tdate') 
#u.date = unix_timestamp('2014-12-31')
where
k.kakin_st = 3 and
k.log_type = 3 and
k.date >= unix_timestamp('$sdate') and
k.date <= unix_timestamp('$tdate') 
#and
# u.aff_code regexp '^(rnw|apk|apd|aps|apc|au0|au2|aua|auc|auf|aum|aun|auo|aup|aus|aut|cpc|duo|ezc|ezw|swc|tal|v00|vbm|aul|aad|acf|acr|act|afm|aka|ame|ans|ant|apa|apt|bds|bga|epk|fca|fcb|fcg|fcm|gba|ggm|aug|ggm|jan|jip|jiq|kyo|lmp|lpl|m8n|m8p|m8s|mad|mfa|mla|mlm|moa|mon|mop|mra|mrq|mrz|naa|nag|nis|oik|pfa|pka|pkc|pkd|pke|pkf|pkg|pkh|pki|pkj|pkk|pkm|pkn|pkp|pku|pky|pkz|pra|prb|rsu|sat|sbe|sma|smc|smd|spf|sta|stm|stu|tra|vnm|waz|xmx|tga001|tga101|tga201|tga301|tga401|tga501|tnp001|tnp101|tnp201|tnp301|tnp401|tnp501|tnp601|tnp701|tnp801|smb002|mti001|tfp101|tfp201)'
#u.aff_code regexp '^(apk|apd|aps)' 
#u.aff_code regexp '^(apc|au0|au2|aua|auc|auf|aum|aun|auo|aup|aus|aut|cpc|duo|ezc|ezw|swc|tal|v00|vbm|aul)' 
# u.aff_code regexp '^(aad|acf|acr|act|afm|aka|ame|ans|ant|apa|apt|bds|bga|epk|fca|fcb|fcg|fcm|gba|jan|jip|jiq|kyo|lmp|lpl|m8n|m8p|m8s|mad|mfa|mla|mlm|moa|mon|mop|mra|mrq|mrz|naa|nag|nis|oik|pfa|pka|pkc|pkd|pke|pkf|pkg|pkh|pki|pkj|pkk|pkm|pkn|pkp|pku|pky|pkz|pra|prb|rsu|sat|sbe|sma|smc|smd|spf|sta|stm|stu|tra|vnm|waz|xmx)' 
#u.aff_code regexp '^(tga001|tga101|tga201|tga301|tga401|tga501|tnp001|tnp101|tnp201|tnp301|tnp401|tnp501|tnp601|tnp701|tnp801|smb002|mti001|tfp101|tfp201)'
# u.aff_code regexp '^(acc|ace|adn|aeo|age|aid|ais|akb|amx|ana|aou|apd|apk|aps|app|atp|avx|ba1|ba2|ba3|ba4|ba5|ba6|ba7|ba8|bbm|bdn|bdt|bea|big|bld|bra|brd|btm|bus|cav|cco|cdd|cir|cnc|cok|crw|cut|cwi|dap|dco|dct|dcv|den|dio|dna|egg|ern|etm|evo|evs|evt|exc|fbk|fbp|fda|fid|fkt|fmd|fro|gcc|gdb|get|gnd|gok|gon|gra|gsj|guh|gui|han|hjk|hkr|hkt|hne|hnt|hot|hug|hys|iap|ibu|idy|iie|ild|ill|ilm|imb|ime|ind|inf|iza|jbn|jer|jey|jid|jiv|jkm|jkp|jof|kgk|kjk|kns|kob|kod|kra|kty|kyb|liv|lka|lot|lov|ma6|ma7|maa|mab|mam|map|mau|mb1|mb2|mb3|mb4|mb5|mb6|mb8|mb9|mbb|mbd|mbe|mbf|mbg|mbk|mbl|mbm|mbr|mda|mdp|med|meg|mel|mem|mg0|mga|mgd|mgj|mgn|mgr|mgt|mh|min|mix|mjg|mju|mlg|mob|moh|msf|mxt|nad|nba|nec|nik|nnc|non|nov|nra|nrb|nss|ntc|oer|ohd|ohv|pak|pcb|pep|pig|plf|pnk|pop|pp|pre|prk|psa|pub|r25|ray|ren|rev|rnw|rzk|sam|sap|sbi|sby|scc|scw|sed|sho|sia|sjc|sky|sm4|snf|sok|sop|spo|spr|ssz|std|stf|stk|sub|swb|swe|sya|syu|tfb|tbs|tim|trm|trn|trw|ttw|ttv|tvl|tvn|twi|ubc|ubd|ube|ubv|v00|ven|vnl|vpr|vtr|wed|wet|wrp|www|yah|ydb|you|zip)'
group by aff 
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD)); array=(${array[@]} NUL); for values in ${array[@]}
do
if [ $values == NUL ]
then
affinf=""
else
affinf=$values"%"
fi
result_array=()
for add in $(seq 0 $term)
do
kdate=$(date -d"$add days $sdate" +%Y-%m-%d)
result=$(echo "
select count(distinct u.user_id)
from user_attrib u
join kakin_log k
on u.user_id = k.user_id and
k.kakin_st = 3 and
k.log_type = 3 and
k.date = unix_timestamp('$kdate')
where
u.date = unix_timestamp('$tdate') and
u.avail_st = 0 and
u.aff_code like '$affinf'
;" | mysql -s -hmd157 -unamatame.tomoyuk market -pCW3b9DMD)
if [ $result ]
then
result_array=(${result_array[@]} $result)
else
result_array=(${result_array[@]} 0)
fi
done
sums=0
for sum in ${result_array[@]}
do
sums=$(($sums+$sum))
done
echo -e $sums" "$values" "${result_array[@]}
done


