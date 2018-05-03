# nanopore_data_analysis
myshu's program of nanopore data analysis

 
## basecalling
`nohup ./0-basecalling/Albacore/albacore_myshu_for_skip.sh fast5/ albacore_out/ &`

Next cat all the data to one file or `fastqs to another directory and run EPI2ME analysis`

`cat albacore_out/workspace/pass/*.fastq > <runid>.fastq (runid can be named by yourselve)`

## split barcode

`./1-split_barcode/porechop_test.sh <runid>.fastq`
 
 
