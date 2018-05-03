# nanopore_data_analysis
myshu's program of nanopore data analysis
 
1. 首先，需要将测序的结果的fast5/文件夹中的部分数据拷贝出来，具体方法如下：
新建一个文件夹,并建立data文件夹：
（建议以`日期+flowcellID+样本数目`命名）
 
> mkdir 20180428-FAH08967-12-samples

> mkdir 20180428-FAH08967-12-samples/data


拷贝数据到新文件夹(可以拷贝fast5文件夹中的多个文件夹！)：
 
> cp fast5/0/ 20180428-FAH08967-12-samples/data

2. 接下来进行数据分析：
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

> ./1-split_barcode/porechop_test.sh 20180428-FAH08967-12-samples.fastq
 
 
