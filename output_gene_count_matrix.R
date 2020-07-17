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
tx2gene<-to_gene[,c(1,2)]
head(tx2gene)

#report simply counts, write to a rds file
txi.kallisto.counts <- tximport(files, type = "kallisto", tx2gene=tx2gene, txOut = FALSE)
#counts <- txi.kallisto$counts
#head(counts)
saveRDS(txi.kallisto.counts, file = "counts.rds")



#report scaled TPM, write to a txt and tsv
txi.kallisto <- tximport(files, type = "kallisto",countsFromAbundance = "scaledTPM", tx2gene=tx2gene, txOut = FALSE)
saveRDS(txi.kallisto, file = "counts_TPM.rds")

count_matrix_TPM <- txi.kallisto$counts
head(count_matrix_TPM)
write.table(count_matrix_TPM, file="COUNTS_TPM.txt", append = FALSE, sep = "\t", dec = ".", row.names = TRUE, col.names = TRUE)
write.table(count_matrix_TPM, file="COUNTS_TPM.tsv",row.names=TRUE,col.names=TRUE, sep='\t')

