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
     Date: 2018-5-15      
     Description: plot sankey plots for blast lca results
---------------------------------------------------------------
USAGE: $0 input_blast_lca_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 blastn_lca_out
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

in=$1
pro=$(dirname $0) 
for i in $in/*.sumtaxa.txt
do
	$pro/sankey_for_blast_lca_taxa.sh $i
done
