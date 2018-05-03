#!/bin/bash   
#---------------------------------------------------------------+
#     author: Myshu                                             |
#	  mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-3                                            |
#     description: Bascalling for nanopore data using albacore  |
#---------------------------------------------------------------+

# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 input_dir output_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 fast5/ albacore_out/
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help
in=$1
out=$2

read_fast5_basecaller.py --flowcell FLO-MIN107 --kit SQK-LSK108 --input $in --save_path $out --worker_threads 4 -o fastq -r


