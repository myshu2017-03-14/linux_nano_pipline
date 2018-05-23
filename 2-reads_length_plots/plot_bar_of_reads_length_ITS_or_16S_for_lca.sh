#!/bin/bash
#!/usr/bin/env bash 
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-23                                           |
#     description: Plot reads length bar plot for 16S and ITS   |
#---------------------------------------------------------------+
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 input_blastn_lca_dir reads_len_dir output_dir tag
    or $0 ‐h # show this message
EXAMPLE:
    $0 blastn_out/ data/ read_len_bar_of_16S_and_ITS/ -c
    Tag : -a for 16S
	  -b for ITS
	  -c for 16S+ITS
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help


in=$1
len=$2
out=$3
tag=$4
pro=$(dirname $0)

if [ ! -d "$out" ]; then
  mkdir $out
fi
# for 16S
if [ "$tag" = "-a" ] || [ "$tag" = "-c" ]; then
	for i in $in/*.16S.reads.maptaxa.txt
	do
		name=$(basename $i .16S.reads.maptaxa.txt)
		cut -f 1 $i > $out/$name.map.tmp
		grep -f $out/$name.map.tmp $len/$name.len > $out/$name.16S.len
		if [ ! -s $out/$name.16S.len ];then
			rm $out/$name.16S.len 
		fi
	done
	rm $out/*.map.tmp
	if [ ! -d "$out/16S_reads_len" ]; then
	  mkdir $out/16S_reads_len
	fi
	mv $out/*16S.len $out/16S_reads_len
fi
# for ITS
if [ "$tag" = "-b" ] || [ "$tag" = "-c" ]; then
	for i in $in/*.ITS.reads.maptaxa.txt
	do
		name=$(basename $i .ITS.reads.maptaxa.txt)
		cut -f 1 $i > $out/$name.map.tmp
		grep -f $out/$name.map.tmp $len/$name.len > $out/$name.ITS.len
		if [ ! -s $out/$name.ITS.len ];then
			rm $out/$name.ITS.len 
		fi
	done
	rm $out/*.map.tmp
	if [ ! -d "$out/ITS_reads_len" ]; then
	  mkdir $out/ITS_reads_len
	fi
	mv $out/*ITS.len $out/ITS_reads_len
fi

# for plots
if [ "$tag" = "-b" ]; then
	$pro/plot_bar_of_reads_length.sh $out/ITS_reads_len $out/ITS_reads_len_barplots
elif [ "$tag" = "-a" ];then
	$pro/plot_bar_of_reads_length.sh $out/16S_reads_len $out/16S_reads_len_barplots
else	
	# mv no-empty 16S and ITS to one directory
	ls $out/16S_reads_len | cut -f 1 -d "." > $out/16S.ids
	ls $out/ITS_reads_len | cut -f 1 -d "." > $out/ITS.ids
	grep -F -f $out/16S.ids $out/ITS.ids | sort | uniq > $out/ids
	if [ ! -d "$out/16S_and_ITS_reads_len" ]; then
		mkdir $out/16S_and_ITS_reads_len
	fi
	for id in `cat $out/ids`
	do
		cp $out/16S_reads_len/$id.16S.len $out/16S_and_ITS_reads_len
		cp $out/ITS_reads_len/$id.ITS.len $out/16S_and_ITS_reads_len
	done
	rm $out/ids $out/16S.ids $out/ITS.ids
	# mk output_dir plots
	if [ ! -d "$out/16S_and_ITS_reads_len_barplots" ] ; then
		mkdir $out/16S_and_ITS_reads_len_barplots
	fi	
	# bar plots for 16S and ITS
	Rscript $pro/plot_bar_of_reads_length_ITS_or_16S_for_lca.R -i $out/16S_and_ITS_reads_len -n 100 -m 2000 -s 100 -o $out/16S_and_ITS_reads_len_barplots
	# plots for only 16S or ITS
	$pro/plot_bar_of_reads_length.sh $out/16S_reads_len $out/16S_reads_len_barplots
	$pro/plot_bar_of_reads_length.sh $out/ITS_reads_len $out/ITS_reads_len_barplots

fi

