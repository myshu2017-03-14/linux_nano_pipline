#!/bin/bash
#!/usr/bin/env bash 
#---------------------------------------------------------------+
#     author: Myshu                                             |
#			mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-3                                            |
#     description: count each level abundance of each samples   |
#---------------------------------------------------------------+
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
# 16S
for i in $in/*16S_anno_cov_uniq.out
do
	name=$(basename $i .out)
	cut -f 2 $i|grep -v 'Subject'|grep -v 'No hits found'|sort|uniq > $name.taxa.ref.ids
	perl $pro/get_taxa_abundance_program/get_subset_matrix.pl -list $name.taxa.ref.ids -i /database/16S_db/NCBI-16S/NCBI-16S-18998.taxa.tab -n 1 -o $name.taxa.ref.txt
	perl $pro/get_taxa_abundance_program/get_taxa_for_blastTab.pl -i $i -id $name.taxa.ref.txt -o $name.taxa.out
	for n in 1 2 3 4 5 6 7
	do
		$pro/get_taxa_abundance_program/get_taxa_abundace.sh $name.taxa.out $n $name.abundance.level$n.out 16 n
	done
done
# ITS
for i in $in/*ITS_anno_cov_uniq.out
do
	name=$(basename $i .out)
	cut -f 2 $i|grep -v 'Subject'|grep -v 'No hits found'|sort|uniq > $name.taxa.ref.ids
	perl $pro/get_taxa_abundance_program/get_subset_matrix.pl -list $name.taxa.ref.ids -i /database/ITS_db/NCBI-refseq-targetedloci/fungi.ITS.taxa.tab -n 1 -o $name.taxa.ref.txt
	perl $pro/get_taxa_abundance_program/get_taxa_for_blastTab.pl -i $i -id $name.taxa.ref.txt -o $name.taxa.out
	for n in 1 2 3 4 5 6 7
	do
		$pro/get_taxa_abundance_program/get_taxa_abundace.sh $name.taxa.out $n $name.abundance.level$n.out 16 n
	done
done

rm *_blastn*.taxa.ref.* 
mv *_blastn*.abundance* *blastn*.taxa.out $in/
