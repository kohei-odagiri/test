#/bin/bash
: <<'#COMMENT'
#COMMENT
if [[ "$1" && "$2" ]]
then
continue
else
echo "parameter no good! retry"
exit
fi
# outfile1="kpi/hatsukakin_"$1".txt"
outfile1="kpi/1.hatsukakin.txt"
echo -n "" > $outfile1
sh daily_hatsukakin_for_kpifile.sh $1 $2 > $outfile1
echo "1.daily_hatsukakin_for_kpifile.sh done!"
# outfile2="kpi/kyushi_"$1".txt"
outfile2="kpi/2.kyushi.txt"
echo -n "" > $outfile2
sh daily_kyushi_for_kpifile.sh $1 $2 > $outfile2
echo "2.daily_kyushi_for_kpifile.sh done!"
# outfile3="kpi/saikai_"$1".txt"
outfile3="kpi/3.saikai.txt"
echo -n "" > $outfile3
sh daily_saikai_for_kpifile.sh $1 $2 > $outfile3
echo "3.daily_saikai_for_kpifile.sh done!"
# outfile4="kpi/yuryoukaiin_"$1".txt"
outfile4="kpi/4.yuryoukaiin.txt"
echo -n "" > $outfile4
sh yuryoukaiin_aff_career_device_for_kpifile.sh $1 $2 > $outfile4
echo "4.yuryoukaiin_aff_career_device_for_kpifile.sh done!"
# outfile5="kpi/detailed_hatsukakin_"$1".txt"
outfile5="kpi/5.detailed_hatsukakin.txt"
echo -n "" > $outfile5
sh detailed_hatsukakin_for_kpifile.sh $1 $2 > $outfile5
echo "5.detailed_hatsukakin_for_kpifile.sh done!"
# outfile6="kpi/detailed_hatsukakin_kyushi_"$1".txt"
outfile6="kpi/6.detailed_hatsukakin_kyushi.txt"
echo -n "" > $outfile6
sh detailed_hatsukakin_kyushi_for_kpifile.sh $1 $2 > $outfile6
echo "6.detailed_hatsukakin_kyushi_for_kpifile.sh done!"

