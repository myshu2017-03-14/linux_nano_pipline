
This is main for blastn method, used for 16S and ITS analysis.

The steps of the analysis are as follows ：
 
# run blast
You mush get each sample's seq length before running the script.(Using the `2-reads_length_plots/get_fa_and_len.sh`)
`blastn.sh <input_fasta_dir> <input_fasta_len_dir>`

nohup ./blastn.sh /analysis/software_han/3-finaldata/nanopore-data-out/20180318_add_7_samples_and_1_samples/all_data_out/data/ /analysis/software_han/3-finaldata/nanopore-data-out/20180318_add_7_samples_and_1_samples/all_data_out/data/ &
>*Note that the results is in the current directory.

# count each level abundance 
`count_taxa_abundance_blastn.sh <blastn_out_dir>`

./count_taxa_abundance_blastn.sh blastn_out/

# cat all samples taxa abundance of each level
./cat_taxa_abundance.sh blastn_out

