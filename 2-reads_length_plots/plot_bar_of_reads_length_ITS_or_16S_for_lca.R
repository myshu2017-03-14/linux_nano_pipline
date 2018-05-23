#!/usr/bin/Rscript
library(getopt)
# get options, using the spec as defined by the enclosed list.
# we read the options from the default: commandArgs(TRUE).
# character logical integer double
spec = matrix(c(
  'input_dir', 'i', 1, "character",
  'help'  , 'h', 0, "logical",
  'min' , 'n', 1, "integer",
  'max' , 'm', 1, "integer",
  'step' , 's', 1 ,"integer",
  'output_dir' , 'o' , 1, "character"
), byrow=TRUE, ncol=4);
opt = getopt(spec);

# if help was asked for print a friendly message
# and exit with a non-zero error code
if ( !is.null(opt$help) ) {
  cat(getopt(spec, usage=TRUE));
  q(status=1);
}

library("Rmisc")
library("plyr")
require(ggplot2)
library(grid)
a1 <- list.files(paste(opt$input_dir))
n <- length(a1)/2
#print(a1)
for(i in 1:n){
      # 16S data
      data1 <- read.table(paste(paste(opt$input_dir),"/",a1[i*2-1], sep=""),sep='\t',header=F)
      #nrow(data)
      row=nrow(data1)
      
      min_raw <- opt$min
      max_raw <- opt$max
      step <- opt$step
      
      m<-seq(0,min_raw,by=min_raw)   
      min <-data.frame(table(cut(data1$V2,m,dig.lab = 4)) )
      min$Var1 <- paste("<=",min_raw,sep = "")
      
      m<-seq(min_raw,max_raw,by=step) 
      med<-data.frame(table(cut(data1$V2,m,dig.lab = 4)) )  #??????????????Ƶ??
      
      max <- max(data1$V2)
      len <- max-max_raw
      m<-seq(max_raw,max,by=len)   
      max <-data.frame(table(cut(data1$V2,m,dig.lab = 6)) )
      max$Var1<- paste(">",max_raw,sep = "")

      #?ϲ????????ݿ?
      t1 <- rbind(min,med,max)
      num <- (max_raw-min_raw)/step+2
      t1$tag <- c(rep("16S",num))
      
      
      # ITS data
      data2 <- read.table(paste(paste(opt$input_dir),"/",a1[i*2], sep=""),sep='\t',header=F)
      #nrow(data)
      row=nrow(data2)
      min_raw <- opt$min
      max_raw <- opt$max
      step <- opt$step
      
      m<-seq(0,min_raw,by=min_raw)   
      min <-data.frame(table(cut(data2$V2,m,dig.lab = 4)) )
      min$Var1 <- paste("<=",min_raw,sep = "")
      
      m<-seq(min_raw,max_raw,by=step) 
      med<-data.frame(table(cut(data2$V2,m,dig.lab = 4)) )  #??????????????Ƶ??
      
      max <- max(data2$V2)
      len <- max-max_raw
      m<-seq(max_raw,max,by=len)   
      max <-data.frame(table(cut(data2$V2,m,dig.lab = 6)) )
      max$Var1<- paste(">",max_raw,sep = "")

      #?ϲ????????ݿ?
      t2 <- rbind(min,med,max)
      num <- (max_raw-min_raw)/step+2
      t2$tag <- c(rep("ITS",num))
      

      
      t12 <-rbind(t1,t2)
      
      ggplot(t12,aes(x = Var1,y = Freq )) + geom_bar(stat = "identity",fill="skyblue") + facet_grid(tag ~ ., scales = "free_y")+ #, scales = "free_y"
        #theme(axis.text.x = element_blank(),axis.ticks.x = element_blank())+  
        theme(axis.text.x = element_text(angle = 30,hjust = .5, vjust = .5))+
        scale_x_discrete(limits=t1$Var1) + 
        xlab("Read Length") + ylab("Read count")

      barcode_name=substring(a1[i*2],1,4) # if the filename is BC01_blastn_16S_anno_cov_uniq.len, note we should change the value if the name is change
      filename=paste(paste(opt$output_dir),"/",barcode_name,"_16S_ITS.length.png", sep="")
      ggsave(filename)
} 
