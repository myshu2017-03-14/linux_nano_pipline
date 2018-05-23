#!/usr/bin/env bash 
#!/bin/bash
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-3                                            |
#     description: run blast for 16S and ITS                    |
#---------------------------------------------------------------+
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 fasta_dir fasta_len_dir tag out_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 test/ test/ -c blastn_out
    Tag : -a for 16S
	  -b for ITS
	  -c for 16S+ITS

HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

IN_DIR=$1 # input fasta file
IN_LEN=$2 # input length file of fasta
pro=$(dirname $0)
tag=$3
out=$4
if [ ! -d $out ]; then
	mkdir $out
fi
# for 16S
if [ "$tag" = "-a" ] || [ "$tag" = "-c" ]; then
	for i in $IN_DIR/BC*.fasta
	do
		name=$(basename $i .fasta)
		# 16S
		blastn -query $i -db $pro/database/16S_db/NCBI-16S-19088 -out $out/$name\_blastn_16S.out -outfmt 6 -evalue 1e-5 -num_threads 6 -max_target_seqs 5
		perl $pro/db_program/result2anno.pl -in $out/$name\_blastn_16S.out -tab $pro/database/16S_db/NCBI-16S-19088.tab -out $out/$name\_blastn_16S_anno.out
		perl $pro/db_program/calculate_coverage_for_blast_results.pl -in $out/$name\_blastn_16S_anno.out -len $IN_LEN/$name.len -out $out/$name\_blastn_16S_anno_cov.out
		perl $pro/db_program/get_one_results_of_each.pl -in $out/$name\_blastn_16S_anno_cov.out -out $out/$name\_blastn_16S_anno_cov_uniq.out
	done
fi
# for ITS
if [ "$tag" = "-b" ] || [ "$tag" = "-c" ]; then
	for i in $IN_DIR/BC*.fasta
	do
		# ITS
		name=$(basename $i .fasta)
		blastn -query $i -db $pro/database/ITS_db/fungi.ITS.fna -out $out/$name\_blastn_ITS.out -outfmt 6 -evalue 1e-5 -num_threads 6 -max_target_seqs 5
		perl $pro/db_program/result2anno.pl -in $out/$name\_blastn_ITS.out -tab $pro/database/ITS_db/fungi.ITS.tab -out $out/$name\_blastn_ITS_anno.out
		perl $pro/db_program/calculate_coverage_for_blast_results.pl -in $out/$name\_blastn_ITS_anno.out -len $IN_LEN/$name.len -out $out/$name\_blastn_ITS_anno_cov.out
		perl $pro/db_program/get_one_results_of_each.pl -in $out/$name\_blastn_ITS_anno_cov.out -out $out/$name\_blastn_ITS_anno_cov_uniq.out
	
	
	done
fi	
