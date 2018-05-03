#!/bin/bash
#!/usr/bin/env bash 
#------------------------------------------------------------------+
#     author: Myshu                                                |
#			mail:1291016966@qq.com                                       |
#     version:1.0                                                  |
#     date :2018-5-3                                               |
#     description: Split barcode for nanopore data using porechop  |
#------------------------------------------------------------------+

# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 input_fastq
    or $0 ©\h # show this message
EXAMPLE:
    $0 FAH09535_test_all_reads.fastq
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

date
in=$1  # FAH09535_test_all_reads.fastq
# test1
#porechop-runner.py -i fastq_runid_4a7087c5b17141c19008f2f2ace24dca27462351.fastq -b porechop_output_test1 --format fastq -t 5 

# test2
#porechop-runner.py -i $in -b porechop_output_85_two_barcodes --format fastq -t 5 --barcode_threshold 85 --require_two_barcodes
name=$(basename $in .fastq)
porechop-runner.py -i $in -b porechop_output_85 --format fastq -t 5 --barcode_threshold 85 > porechop_$name.log

# test3
#porechop-runner.py -i fastq_runid_4a7087c5b17141c19008f2f2ace24dca27462351.fastq -b porechop_output_test3 --format fastq -t 5 --barcode_threshold 60 --barcode_diff 1

date
