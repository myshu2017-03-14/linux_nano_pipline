#!/bin/bash
#!/usr/bin/env bash 
# echo the help if not input all the options
help()
{
cat <<HELP
---------------------------------------------------------------
     Author: Myshu                                            
     Mail: 1291016966@qq.com                                   
     Version: 1.0                                              
     Date: 2018-5-16                                         
     Description: cat 16S and ITS sankey plots of one sample to a html
---------------------------------------------------------------
USAGE: $0 input_sankey_dir output_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 blastn_lca_out cat_sankey_plots
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help
in=$1 
out=$2
if [ ! -d "$out" ]; then
  mkdir $out
fi
mkdir $out/.raw_plots
pro=$(dirname $0)
#ls $in/*_sankey_plot.html  | awk '{print $NF}'| awk -F '/' '{print $NF}'| cut -f 1 -d "." | sort | uniq > $pro/t
for i in `ls $in/*_sankey_plot.html  | awk '{print $NF}'| awk -F '/' '{print $NF}'| cut -f 1 -d "." | sort | uniq`
#$in/BC03.16S_sankey_plot.html
do
	echo $i
	if [ ! -s $in/$i.16S_sankey_plot.html ];then
		if [ ! -s $in/$i.ITS_sankey_plot.html ] ; then
			continue
		else
			# cp ITS 
			cp $in/$i.ITS_sankey_plot.html $out/.raw_plots
		fi
	else
		if [ ! -s $in/$i.ITS_sankey_plot.html ] ; then
			# cp 16S
			cp $in/$i.16S_sankey_plot.html $out/.raw_plots
		else
			# cp 16S ITS
			cp $in/$i.16S_sankey_plot.html $in/$i.ITS_sankey_plot.html $out/.raw_plots
		fi
	fi
#	cp $in/$i.16S_sankey_plot.html $in/$i.ITS_sankey_plot.html $out/.raw_plots
	export x=$i
	perl -p -e 's/BC01/$ENV{"x"}/g' $pro/templete.html > $out/$i.html
done
