#!/usr/bin/Rscript
library(getopt)
# get options, using the spec as defined by the enclosed list.
# we read the options from the default: commandArgs(TRUE).
# 一般就是4列，第一列为字符串，第二列为简写，第三列值分别为0（无参数后面可以不跟参数）、1（后面需要跟参数）、2（可选可不选），第四列为数据类型
# character logical integer double
spec = matrix(c(
  'input_table_file', 'i', 1, "character",
  'output_file' , 'o' , 1, "character",
  'help'  , 'h', 0, "logical"
#  ''
), byrow=TRUE, ncol=4);
opt = getopt(spec);

# if help was asked for print a friendly message
# and exit with a non-zero error code
if ( !is.null(opt$help) ) {
  cat(getopt(spec, usage=TRUE));
  q(status=1);
}

#file <- "D:/work/菌群分析/4-项目/妊娠糖尿病-16S-pacbio-103/myshu测试结果整理/new_test/even_1707/"
#data<- read.table(paste(file,"otu_table_even_1707.tsv",sep = ""),sep='\t',header=T,check.names=F)
data<- read.table(paste(opt$input_table_file),sep='\t',header=T,check.names=F)
nrow <- nrow(data)
ncol <-ncol(data)
#data
tmp=c()
data_new=c()
data_final=c()
taxa <- levels(data$"Src;Target")
#taxa
#as.character(data[2,1])
#class(as.character(data[2,1]))
#nrow
for(i in taxa){
#   print(i)
  for(line in 1:nrow){
    if(as.character(data[line,1])==i){
	#print(1)
      # save to one table
      data_tmp <- data[line,]
      #print(data_tmp)
      if(is.null(tmp)){
        tmp <- data_tmp
    #    print("no")
      }else{
        tmp <- rbind(tmp,data_tmp)
      }
      # # refresh data
      # data <- data[-line,]
      # # refresh data row number
      # nrow <- nrow(data)
    }
  }
  # cat the taxa
#  print(tmp)
# print(nrow(tmp))
  tmp <-tmp[,-1]
  tmp_new<- sum(tmp)
  tmp_new<- cbind("Src;Target"=i,Value=tmp_new)
  tmp=c()
  
  if(is.null(data_final)){
    data_final <- tmp_new
  }else{
#    print(data_final)
#    print(tmp_new)
    data_new <-rbind(data_final,tmp_new)
    data_final <- data_new
  }
}

# save the table
table<-data_final
#table
write.table(table, file = paste(opt$output_file),quote = FALSE ,row.names = FALSE, col.names = T,sep = "\t")



