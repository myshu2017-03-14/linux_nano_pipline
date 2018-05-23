#!/bin/bash
#!/usr/bin/env bash 
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-21                                           |
#     description: lca for blast results                        |
#---------------------------------------------------------------+
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 <input_blastn_results_dir> <fasta_dir> <output_dir> <Tag>
    or $0 ‐h # show this message
EXAMPLE:
    $0 blastn_out/ fasta/ blastn_out_lca/ -a
    Tag : a for 16S
	  b for ITS
	  c for 16S+ITS
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

in=$1
fa=$2
out=$3
tag=$4

if [ ! -d "$out" ]; then
  mkdir $out
fi
# for 16S
if [ "$tag" = "-a" ] || [ "$tag" = "-c" ]; then
	for i in $in/*_blastn_16S_anno_cov.filter.raw.out
	#$in/BC*_blastn_16S.out 
	do
		#name=$(basename $i _blastn_16S.out)
		name=$(basename $i _blastn_16S_anno_cov.filter.raw.out)
#		echo $name
		blast2rma -i $i -f BlastTab -bm BlastN -r $fa/$name.fasta -o $out/$name.16S.rma -a2t /analysis/software_han/software/metagenome-analysis-software/MEGAN_v6/map_for_db_myshu/nucl_acc2tax-Mar2018.abin
		rma2info --in $out/$name.16S.rma --read2class Taxonomy --paths --majorRanksOnly > $out/$name.16S.reads.maptaxa.txt
		rma2info --in $out/$name.16S.rma --class2count Taxonomy -r -p -mro > $out/$name.16S.sumtaxa.txt
	done
fi
# for ITS
if [ "$tag" = "-b" ] || [ "$tag" = "-c" ]; then
	for i in $in/*_blastn_ITS_anno_cov.filter.raw.out
	#$in/BC*_blastn_ITS.out 
	do
		#name=$(basename $i _blastn_ITS.out)
		name=$(basename $i _blastn_ITS_anno_cov.filter.raw.out)
#		echo $name
		blast2rma -i $i -f BlastTab -bm BlastN -r $fa/$name.fasta -o $out/$name.ITS.rma -a2t /analysis/software_han/software/metagenome-analysis-software/MEGAN_v6/map_for_db_myshu/nucl_acc2tax-Mar2018.abin
		rma2info --in $out/$name.ITS.rma --read2class Taxonomy --paths --majorRanksOnly > $out/$name.ITS.reads.maptaxa.txt
		rma2info --in $out/$name.ITS.rma --class2count Taxonomy -r -p -mro > $out/$name.ITS.sumtaxa.txt
	done
fi
