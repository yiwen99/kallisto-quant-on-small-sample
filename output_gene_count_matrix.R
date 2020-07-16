library(tximportData)
library(rhdf5)
library(tximport)
common_path = "/u/project/zarlab/yiwen99/quant/results/"
samples = list.files(common_path)


files <- file.path(common_path,samples,"abundance.h5")

names(files)<-paste0("sample",1:87)

to_gene <- read.delim(file.path("/u/project/zarlab/hjp/geuvadis_data/annotation", "transcripts_to_genes.txt"),header=FALSE)
#to_gene is now a 3-col matrix, need to make tx2gene a 2-column matrix

#make a 2-col transcript to gene matrix
first<-to_gene[,c(1,3)]
second<-to_gene[,c(2,3)]

#change the column names of the two so that they can be bind together using rbind
colnames(first)<-c("V1","V2")
colnames(second)<-c("V1","V2")

tx2gene <- rbind(first,second)
head(tx2gene)

txi.kallisto <- tximport(files, type = "kallisto", tx2gene=tx2gene, txOut = FALSE)
count_matrix <- txi.kallisto$counts
head(count_matrix)
write.table(count_matrix, file="COUNTS.txt", append = FALSE, sep = "\t", dec = ".", row.names = TRUE, col.names = TRUE)

