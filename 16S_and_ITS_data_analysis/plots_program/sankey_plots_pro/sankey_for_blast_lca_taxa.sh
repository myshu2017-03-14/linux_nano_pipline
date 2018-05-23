
data=$1 # BC01.sumtaxa.txt
pro=$(dirname $0)
name=$(basename $data .sumtaxa.txt)
out=$(dirname $data)
IFS_old=$IFS
IFS=$'\n'
cut -f 2,3 $data > tmp_$name
# S	[SK] Bacteria; [P] Bacteroidetes; [C] Cytophagia; [O] Cytophagales; [F] Cytophagaceae; [G] Spirosoma; [S] Spirosoma luteolum;
perl -i -p -e 's/\[SK\] /k__/g' tmp_$name
perl -i -p -e 's/ \[P\] /p__/g' tmp_$name
perl -i -p -e 's/ \[C\] /c__/g' tmp_$name
perl -i -p -e 's/ \[O\] /o__/g' tmp_$name
perl -i -p -e 's/ \[F\] /f__/g' tmp_$name
perl -i -p -e 's/ \[G\] /g__/g' tmp_$name
perl -i -p -e 's/ \[S\] /s__/g' tmp_$name
perl -i -p -e 's/^(\S+);(\t\S+)$/$1$2/g' tmp_$name

echo "Src;Target	Value" > $name.tmp
cat tmp_$name >>$name.tmp

perl $pro/pro/convert_biom_csv_to_sankey_data_for_blast_lca_taxa.pl -in $name.tmp -out $name.sankey.tmp
Rscript $pro/pro/sum_taxa_from_biom_tsv_for_sankey.R -i $name.sankey.tmp -o $name.sankey.txt
perl -i -p -e 's/\t/;/g' $name.sankey.txt
perl -i -p -e 's/ /_/g' $name.sankey.txt
rm $name.sankey.tmp tmp_$name $name.tmp

# plot 
Rscript $pro/pro/R_sankey_plot.R -i $name.sankey.txt -o $name\_sankey_plot.html
mv $name.sankey.txt $name\_sankey_plot.html $out
$pro/pro/cat_16S_and_ITS_sankey_plots.sh $out $out/cat_sankey_plots
IFS=$IFS_old
