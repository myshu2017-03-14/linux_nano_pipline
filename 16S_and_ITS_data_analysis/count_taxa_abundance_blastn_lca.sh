#!/bin/bash
#!/usr/bin/env bash 
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-3                                            |
#     description: count each level abundance of each samples   |
#---------------------------------------------------------------+
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 blastn_lca_out_dir
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
for i in $in/*.reads.maptaxa.txt
do
	name=$(basename $i .reads.maptaxa.txt)
	for n in 1 2 3 4 5 6 7
	do
		$pro/get_taxa_abundance_program/get_taxa_abundance_for_lca.sh $i $n $in/$name.abundance.level$n.out 2 n
	done
done
