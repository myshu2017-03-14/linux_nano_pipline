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
     Date: 2018-5-3                                            
     Description: filter blast results by identity and coverage
---------------------------------------------------------------
USAGE: $0 input_blastn_dir identity_cutoff coverga_cutoff output_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 blastn_out/ 77 30 blastn_out_filter_i77_c30
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help
in=$1
identity=$2
cov=$3
out=$4
if [ ! -d "$out" ]; then
  mkdir $out
fi
for i in $in/*_anno_cov.out
do
	name=$(basename $i .out)
	awk -F '\t' -v iden="$identity" -v cov="$cov" '$4>=iden && $14>=cov{print}' $i >$out/$name.filter.out
	cut -f 1,2,4,5,6,7,8,9,10,11,12,13 $out/$name.filter.out > $out/$name.filter.raw.out
done
