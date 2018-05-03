#!/bin/bash
#!/usr/bin/env bash  
#------------------------------------------------------------------+
#     author: Myshu                                                |
#			mail:1291016966@qq.com                                       |
#     version:1.0                                                  |
#     date :2018-5-3                                               |
#     description: Get all fastq file length and convert to fasta  |
#------------------------------------------------------------------+

# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 fastq_dir
    or $0 ©\h # show this message
EXAMPLE:
    $0 fastq_dir
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help
pro=$(dirname $0)

in=$1 # fastq dir
for i in $in/*.fastq
do
	name=$(basename $i .fastq)
	cat $i | paste - - - - | sed 's/^@/>/g'| cut -f1-2 | tr '\t' '\n' > $in/$name.fasta
	perl $pro/get_all_seq_legth.pl -in $in/$name.fasta -out $in/$name.len
done
