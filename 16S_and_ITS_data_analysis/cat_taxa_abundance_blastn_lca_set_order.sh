#!/bin/bash
#!/usr/bin/env bash 
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-3                                            |
#     description: cat abundance for all samples                |
#---------------------------------------------------------------+
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 blastn_lca_out_dir tag set_order
    or $0 ‐h # show this message
EXAMPLE:
    $0 blastn_lca_out -c set_order
    Tag : -a for 16S
	  -b for ITS
	  -c for 16S+ITS

HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

in=$1
pro=$(dirname $0)
tag=$2
order=$3
for n in 1 2 3 4 5 6 7
do
	if [ "$tag" = "-b" ] || [ "$tag" = "-c" ]; then
		j=1
		# ITS
		for se in `cat $order`
		#for i in $in/*$se*ITS.abundance.level$n.out
		do
			i="$in/$se*ITS.abundance.level$n.out"
			# rm empty results
			if [ ! -s $i ]
			then
				echo $i
				continue
			fi

			if [ $j == 1 ]
			then
				t=$i
				((j++));
				continue
			fi
			name=$(basename $i .out)
			echo "$i	$t"
			perl $pro/get_taxa_abundance_program/cat_taxa_abundance.pl -in $i -old $t -out tmp.out
			t="tmp.txt"
			rm $t
			cat /dev/null > $t
			cat tmp.out > $t
		done
		cat tmp.out > $in/cat_taxa_abundance.ITS.level$n.out		
		rm tmp.out
	fi
	if [ "$tag" = "-a" ] || [ "$tag" = "-c" ]; then
		# 16S
		j=1
		for se in `cat $order`
		#for i in $in/*$se*16S.abundance.level$n.out
		do
			i="$in/$se*16S.abundance.level$n.out"
			# rm empty results
			if [ ! -s $i ]
			then
				echo $i
				continue
			fi

			if [ $j == 1 ]
			then
				t=$i
				((j++));
				continue
			fi
			name=$(basename $i .out)
			echo "$i	$t"
			perl $pro/get_taxa_abundance_program/cat_taxa_abundance.pl -in $i -old $t -out tmp.out
			t="tmp.txt"
			rm $t
			cat /dev/null > $t
			cat tmp.out > $t	
		done	
		cat tmp.out > $in/cat_taxa_abundance.16S.level$n.out		
		rm tmp.out
	fi
done
rm tmp.txt
perl -i -p -e 's/(\S+).abundance.level\d.out/$1/g' $in/cat_taxa_abundance.*
