#!/bin/bash
#!/usr/bin/env bash 
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 blastn_out_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 .
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

in=$1
pro=$(dirname $0)
for n in 1 2 3 4 5 6 7
do
	j=1
	# ITS
	for i in $in/*_blastn_ITS_anno_cov_uniq.abundance.level$n.out
	do
		if [ $j == 1 ]
		then
			t=$i
			((j++));
			continue
		fi
		name=$(basename $i .out)
		echo "$i	$t"
		perl $pro/cat_taxa_abundance.pl -in $i -old $t -out tmp.out
		t="tmp.txt"
		rm $t
		cat /dev/null > $t
		cat tmp.out > $t
	done
	cat tmp.out > $in/cat_taxa_abundance.ITS.level$n.out		
	rm tmp.out
done
rm tmp.txt
