# nanopore_data_analysis
myshu's program of nanopore data analysis
 
1. 数据拷贝：
首先，需要将测序的结果的fast5/文件夹中的部分数据拷贝出来，具体方法如下：
新建一个文件夹,并建立data文件夹：
（建议以`日期+flowcellID+样本数目`命名）
 
> mkdir 20180428-FAH08967-12-samples
>
> mkdir 20180428-FAH08967-12-samples/data


拷贝数据到新文件夹(可以拷贝fast5文件夹中的多个文件夹！)：
 
> cp -r fast5/0/ 20180428-FAH08967-12-samples/data

2. 数据准备：
首先 ，进入分析目录：

> cd 20180428-FAH08967-12-samples

## basecalling
basecalling命令如下：

> nohup ./0-basecalling/Albacore/albacore_myshu_for_skip.sh data/ albacore_out/ &

最后，basecalling好的数据会在`albacore_out/workspace/pass/`文件夹，这个文件夹的数据可以直接用于提交epi2me，进行数据分析


## split barcode
在拆分之前需要合并数据到一个fastq文件中，命令如下：

> cat albacore_out/workspace/pass/*.fastq > 20180428-FAH08967-12-samples.fastq

porechop拆分命令如下：

> nohup ./1-split_barcode/porechop_test.sh 20180428-FAH08967-12-samples.fastq > porechop.nohup.out &
 
最后会生成porechop_output_85/这个文件夹，文件夹下会有以barcode命名的的fasta数据文件。
 
3. 数据分析
## 16S+ITS analysis
在做blast之前，需要将数据转换下格式以及计算reads长度，命令如下：

> ./2-reads_length_plots/get_fa_and_len.sh porechop_output_85/

接着，运行blast，命令如下：
 
> nohup blastn.sh porechop_output_85/ porechop_output_85/ &

前后两个文件夹分别表示fasta格式的数据文件夹，以及包含有reads长度信息的len格式文件。
 
运行完成之后会生成一个`blastn_out/`文件夹。
 
最后，需要对blast的结果进行处理：
 
> ./count_taxa_abundance_blastn.sh blastn_out/
>
> ./cat_taxa_abundance_blastn.sh blastn_out/
 

最后，将结果导出到结果文件夹：
 
> ./get_final_results.sh final_out/


最后`final_out/`文件夹会包含如下文件：

> —— BC*_blastn_16S_anno_cov.out   # blastn结果（包含注释信息）
>
> —— cat_taxa_abundance.ITS.level*.out  # 物种丰度表
