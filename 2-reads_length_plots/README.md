
Before data analysis, we can analysis the raw reads length distribution by plots a bar plot as below:

![reads_bar_plots](/Images/reads_len_bar_plots_screen_shot.png)

The scripts usage :
First caculate the reads length
> `./get_fa_and_len.sh fastq_dir/`


Then plot
> `Rscript plot_bar_of_reads_length.R -i $i -n 100 -m 1700 -s 100 -o $out/$name\_reads_length_bar.pdf`
