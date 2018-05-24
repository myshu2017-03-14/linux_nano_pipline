
# nanopore data analysis
myshu
2018-05-23

可以直接在github 上下载访问：https://github.com/myshu2017-03-14/linux_nano_pipline
> git clone https://github.com/myshu2017-03-14/linux_nano_pipline.git

# 1 数据拷贝：
新建一个文件夹,并建立data文件夹：
（建议以`日期+flowcellID+样本数目`命名）

> mkdir 20180428-FAH08967-12-samples
>
> mkdir 20180428-FAH08967-12-samples/data

拷贝数据到新文件夹(可以拷贝fast5文件夹中的多个文件夹！`如果已测序完成可以忽略这一步，并且之后代码的data文件夹全部为fast5文件夹`)：

> cp -r fast5/0/ 20180428-FAH08967-12-samples/data

# 2 数据准备：
首先 ，进入分析目录：

> cd 20180428-FAH08967-12-samples

### basecalling
basecalling命令如下：

> nohup ./0-basecalling/Albacore/albacore_myshu_for_skip.sh data/ albacore_out/ &

最后，basecalling好的数据会在`albacore_out/workspace/pass/`文件夹，这个文件夹的数据可以直接用于提交epi2me，进行数据分析


### split barcode
在拆分之前需要合并数据到一个fastq文件中，命令如下：

> cat albacore_out/workspace/pass/*.fastq > 20180428-FAH08967-12-samples.fastq

porechop拆分命令如下：

> nohup ./1-split_barcode/porechop_test.sh 20180428-FAH08967-12-samples.fastq > porechop.nohup.out &

最后会生成`porechop_output_85/`这个文件夹，文件夹下会有以barcode命名的的fasta数据文件。

# 3 数据分析
### 16S+ITS analysis
- 在做blast之前，需要将数据转换格式(fastq -> fasta)以及计算reads长度，命令如下：

> ./2-reads_length_plots/get_fa_and_len.sh porechop_output_85/
 
- 注：可以根据生成的.len文件绘制reads长度分布bar图，代码如下

> ./2-reads_length_plots/plot_bar_of_reads_length.sh porechop_output_85/ raw_reads_length_barplots/

在 `raw_reads_length_barplots/`目录下会生成拆分后每个样本的reads分布柱状图，相关的bar图间隔参数设置，详见`./2-reads_length_plots/plot_bar_of_reads_length.sh`脚本

- 接着，运行blast，命令如下：

> nohup /linux_nano_pipline/16S_and_ITS_data_analysis/blastn.sh /analysis/20180428-FAH08967-12-samples/porechop_output_85/ /analysis/20180428-FAH08967-12-samples/porechop_output_85/ &

前后两个文件夹分别表示fasta格式的数据文件夹，以及包含有reads长度信息的len格式文件，通常为同一个文件夹。

运行完成之后会生成一个`blastn_out/`文件夹。
 
- 接着，需要对blast的结果进行过滤处理：（分别采用identity和coverage 进行过滤，并使用megan软件的相关命令进行处理，最终得到每条reads的准确分类信息以及丰度信息

  1. blastn 结果过滤：(如下过滤标准identity≥70，coverage≥30)

> ./16S_and_ITS_data_analysis/filter_program/filter_blastn_myshu.sh blastn_out/ 70 30 blastn_out_filter_i70_c30

  2. megan软件处理:（输入参数分别为blastn过滤结果；原始数据文件夹；结果文件夹；及`Tag：-a for 16S,-b for ITS,-c for 16S+ITS`；表示输入数据类型）

>./16S_and_ITS_data_analysis/filter_program/lca_test.sh blastn_out_filter_i70_c30/ /analysis/20180428-FAH08967-12-samples/porechop_output_85/ blastn_out_lca/ -a

- 对每个样本的每个分类层级数据进行统计，并合并多个样本

> ./16S_and_ITS_data_analysis/count_taxa_abundance_blastn_lca.sh blastn_out_lca/
> ./16S_and_ITS_data_analysis/cat_taxa_abundance_blastn_lca.sh blastn_lca_out/ -c
>
> 注，最后一位参数为tag，同上megan软件处理参数

- 绘制sankey plots（需要安装R networkD3包）

> ./16S_and_ITS_data_analysis/plots_program/sankey_plots_pro/command.sh blastn_lca_out/

- 对blastn比对结果中的reads绘制reads长度分布图（可选）

> ./2-reads_length_plots/plot_bar_of_reads_length_ITS_or_16S_for_lca.sh blastn_out/ /analysis/20180428-FAH08967-12-samples/porechop_output_85/ 16S_and_ITS_reads_length_barplots/ -c
>
> 注，最后一位参数为tag，同上megan软件处理参数;当选择-c时，也会单独绘制比对上16S数据库以及ITS数据库的reads长度分布bar图


- 最后，将结果导出到结果文件夹：

> ./16S_and_ITS_data_analysis/get_final_results.sh blastn_out/ blastn_lca_out/ 16S_and_ITS_reads_length_barplots/ raw_reads_length_bar_plots/ final_out/

- 最后`final_out/`文件夹会包含如下文件：

> —— blastn_lca_out/  # blastn过滤后结果（包含过滤后每条reads的注释信息以及物种丰度表）
>
> —— blastn_out/  # blastn结果（包含原始比对结果以及注释信息）
>
> —— reads_length_barplots/  # reads长度分布bar图，原始拆分reads长度分布信息以及比对到数据库的reads长度分布Bar图信息
>
> —— sankey_plots/   # sankey plots
>
