#!/bin/bash
#!/usr/bin/env bash 
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-23                                           |
#     description: plots reads bar plots for raw data           |
#---------------------------------------------------------------+
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 input_len_dir output_dir
    or $0 ‐h # show this message
EXAMPLE:
    $0 data read_len_bar_of_each_sample
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help


in=$1
out=$2
pro=$(dirname $0)

if [ ! -d "$out" ]; then
  mkdir $out
fi
for i in $in/*.len
do
	name=$(basename $i .len)
	Rscript $pro/plot_bar_of_reads_length.R -i $i -n 100 -m 2000 -s 100 -o $out/$name\_reads_length_bar.png
done

