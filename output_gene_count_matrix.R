library(tximportData)
library(rhdf5)
library(tximport)
common_path = "/u/project/zarlab/yiwen99/quant/results/"
samples = list.files(common_path)


files <- file.path(common_path,samples,"abundance.h5")

names(files)<-paste0(samples)

to_gene <- read.delim(file.path("/u/project/zarlab/hjp/geuvadis_data/annotation", "transcripts_to_genes.txt"),header=FALSE)
#to_gene is now a 3-col matrix, need to make tx2gene a 2-column matrix

#make a 2-col transcript to gene matrix
#the second column is the ensembl gene name
tx2gene<-to_gene[,c(1,2)]
tx2gene$V2<-tx2gene$V2[1:11]
head(tx2gene)

txi.kallisto <- tximport(files, type = "kallisto",countsFromAbundance = "scaledTPM", tx2gene=tx2gene, txOut = FALSE)
count_matrix <- txi.kallisto$counts
head(count_matrix)

write.table(count_matrix, file="COUNTS.txt", append = FALSE, sep = "\t", dec = ".", row.names = TRUE, col.names = TRUE)
#write.table(count_matrix, file="COUNTS.tsv",row.names=TRUE,col.names=TRUE, sep='\t')


