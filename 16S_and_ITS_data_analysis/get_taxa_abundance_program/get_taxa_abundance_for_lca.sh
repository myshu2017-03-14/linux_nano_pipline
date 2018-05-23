#!/bin/bash
#!/usr/bin/env bash 
#---------------------------------------------------------------+
#     author: Myshu                                             |
#     mail:1291016966@qq.com                                    |
#     version:1.0                                               |
#     date :2018-5-3                                            |
#     description: get taxa abundance                           |
#---------------------------------------------------------------+
# echo the help if not input all the options
help()
{
cat <<HELP
USAGE: $0 input level output select_rank_col if_Calculate_relative_abundance(y or n)
    or $0 ‐h # show this message
EXAMPLE:
    $0 test.tab 7 test.out 16 y
level : 1(Kingdom), 2(Phylum), 3(Class), 4(Order), 5(Family), 6(Genus), 7(Species)
HELP
exit 0
}
[ -z "$1" ] && help
[ "$1" = "-h" ] && help

i=$1
level=$2
o=$3
col=$4
flag=$5

# deal with the raw blastn lca data
name=$(basename $i .reads.maptaxa.txt)
cp $i $name.tmp
perl -i -p -e 's/\[SK\] //g' $name.tmp 
perl -i -p -e 's/ \[P\] //g' $name.tmp 
perl -i -p -e 's/ \[C\] //g' $name.tmp 
perl -i -p -e 's/ \[O\] //g' $name.tmp 
perl -i -p -e 's/ \[F\] //g' $name.tmp 
perl -i -p -e 's/ \[G\] //g' $name.tmp 
perl -i -p -e 's/ \[S\] //g' $name.tmp
# get the abundance table of each level
cut -f $col $name.tmp | cut -f $level -d ";"|sort | uniq -c | sort -rn > $o #$name.taxa.count.txt
# change the format
perl -p -i -e 's/^\s+(\d{1,}) /$1\t/g' $o #$name.taxa.count.txt
perl -p -i -e 's/^(\d{1,})\t(.*)$/$2\t$1/g' $o
perl -p -i -e 's/^\t(\d{1,})$/NO_rank\t$1/g' $o
rm $name.tmp

IFS_old=$IFS
IFS=$'\n'
if [ $flag = "y" ]
then
#	rm tmp
	total=`cut -f 2 $o  | awk '{print $1}' | awk '{sum+=$1}END{print sum}'`
	n=0
	a=($(cut -f2 $o))
	
	for line in  `cat $o`
	do
		c=${a[$n]}
#		ab=`expr ($c / $total)*100`
		ab=$(printf "%.2f" `echo "scale=2;100*$c/$total" | bc`)
#		echo $ab
		((n++))
		echo "$line	$ab" >> tmp
	done
	mv tmp $o
fi
IFS=$IFS_old
