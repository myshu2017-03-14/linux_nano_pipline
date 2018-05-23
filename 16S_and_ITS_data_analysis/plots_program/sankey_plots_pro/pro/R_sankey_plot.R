#!/usr/bin/Rscript
library(getopt)
spec = matrix(c(
  'input_file', 'i', 1, "character",
  'help'  , 'h', 0, "logical",
  'output_file' , 'o' , 1, "character"
), byrow=TRUE, ncol=4);
opt = getopt(spec);

# if help was asked for print a friendly message
# and exit with a non-zero error code
if ( !is.null(opt$help) ) {
  cat(getopt(spec, usage=TRUE));
  q(status=1);
}
#-------------------------------- networkD3: 交互式桑基图 --------------------------

network <- read.table(paste(opt$input_file), sep=";", header=T, row.names=NULL, quote="", comment="")
#print(network)
network <- network[,1:3]
colnames(network) <- c("Src", "Target", "Value")

# 转换原始数据点为0起始的一系列整数表示
factor_list <- sort(unique(c(levels(network$Src), levels(network$Target))))
num_list <- 0:(length(factor_list)-1)
levels(network$Src) <- num_list[factor_list %in% levels(network$Src)]
levels(network$Target) <- num_list[factor_list %in% levels(network$Target)]

network$Src <- as.numeric(as.character(network$Src))
network$Target <- as.numeric(as.character(network$Target))

attribute <- data.frame(name=c(factor_list))
attribute$group <- substr(attribute$name,1,3)
# plots
library(networkD3)
net<-sankeyNetwork(Links = network, Nodes = attribute,
              Source = "Src", Target = "Target",
              Value = "Value", NodeID = "name",units = "reads",iterations=10,sinksRight=FALSE,NodeGroup = "group",
              fontSize= 12, nodeWidth = 30)
saveNetwork(net, paste(opt$output_file), selfcontained = TRUE)

#library(d3Network)
#d3Sankey(Links = network, Nodes = attribute, 
#         Source = "Src",Target = "Target", 
#         Value = "Value", NodeID = "name",
#         fontsize = 12, nodeWidth = 30,
#         height = 700,width = 900,file = paste(opt$output_file))#,d3Script = "http://d3js.org/d3.v3.min.js")

