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
     Date: 2018-5-23                 
     Description: copy results to one file dir
---------------------------------------------------------------
USAGE: $0 output_blastn_dir output_blastn_lca_dir output_reads_length_barplots_dir raw_barcode_reads_length_barplots_dir output_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 blastn_out/ blastn_lca_out/ 16S_and_ITS_reads_length_barplots/ raw_reads_length_bar_plots/ final_out/
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

blast_out=$1
lca_out=$2
barplots=$3
raw=$4
out=$5
if [ ! -d "$out" ]; then
  mkdir $out
fi
#echo $dir
# cp raw blastn results
mkdir $out/blastn_out
cp $blast_out/BC*_blastn_16S.out $blast_out/BC*_blastn_ITS.out $blast_out/BC*_blastn_*_anno_cov.out $out/blastn_out
# cp blastn_lca results
mkdir $out/blastn_lca_out
cp $lca_out/*.reads.maptaxa.txt $lca_out/cat_taxa_abundance.*.level*.out $out/blastn_lca_out
mkdir $out/sankey_plots
cp -r $lca_out/cat_sankey_plots $out/sankey_plots
mkdir $out/reads_length_barplots
cp -r $barplots/*_reads_len_barplots $out/reads_length_barplots
cp -r $raw $out/reads_length_barplots

