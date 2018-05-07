#!/bin/bash   
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-3                                            |
#     description: Bascalling for nanopore data using albacore  |
#---------------------------------------------------------------+
in=$1
out=$2
if [ ! -d "$out" ]; then
  mkdir $out
fi
#echo $dir
cp $in/BC*_blastn_*_anno_cov.out $in/cat_taxa_abundance.*.level*.out $out
