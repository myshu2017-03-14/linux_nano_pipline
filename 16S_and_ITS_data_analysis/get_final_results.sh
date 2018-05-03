#!/bin/bash   
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-3                                            |
#     description: Bascalling for nanopore data using albacore  |
#---------------------------------------------------------------+
out=$1
dir=$(dirname $out)
if [ ! -d "$out" ]; then
  mkdir $out
fi
#echo $dir
cp $dir/blastn_out/BC*_blastn_*_anno_cov.out $dir/blastn_out/cat_taxa_abundance.*.level*.out $out
