library(tidyverse)
library(Seurat)
library(DropletUtils)
library(argparser)
#add these to conda package

parser <- arg_parser("Script to run Seurat") %>%
    add_argument("--directory", help = "Gene expression CellRanger Counts results") %>%
    add_argument("--sub_directory", help = "File name corrected") 

print("test")
parsed_args <- parse_args(parser)
rep_oi <- parsed_args$directory
path_10x_mtx <- parsed_args$sub_directory

gex_mat <- Read10X(data.dir=path_10x_mtx)
  
# create separate Seurat objects
gex <- CreateSeuratObject(counts = gex_mat, project = rep_oi, min.cells = 3, min.features = 50)
#nCount = colSums(x = gex, slot = "counts")  # nCount_RNA
#nFeature = colSums(x = GetAssayData(object = gex, slot = "counts") > 0)  # nFeatureRNA
gex[["percent_mt"]] <- PercentageFeatureSet(gex, pattern = "^mt-")
  
mt_thresh <- c(1.3,12) #add to params
UMI_thresh <- 800 #add to params
fig_QC <- ggplot()+stat_bin2d(aes(x=gex$nCount_RNA,y=gex$percent_mt,fill=log(..count..),color=log(..count..)),bins=100)+
    scale_x_log10(limits=c(30,30000))+
    scale_y_log10(limits=c(0.05,100))+
    annotation_logticks()+
    geom_vline(xintercept=UMI_thresh, color="red", linetype="dashed")+
    geom_hline(yintercept=mt_thresh, color="red", linetype="dashed")
  
name <- paste(trimws(basename(rep_oi)),collapse=" ")
dir <- paste(rep_oi,"/plots/", sep="")
fig_QC_name <- paste(rep_oi,"/plots/", name, "_mt_vs_RNA_UMI_gex.pdf", sep="")
ifelse(!dir.exists(file.path(dir)), dir.create(file.path(dir)), FALSE)
  
pdf(fig_QC_name,width=4,height=4)
print(fig_QC)
dev.off()
  
  
  # subsetting on cells
gex_2 <- subset(gex, subset = (percent_mt < mt_thresh[2]) & (percent_mt > mt_thresh[1]) & (nCount_RNA >  UMI_thresh ) )
  
print(dim(gex))
print(dim(gex_2))
  
  # saving filtered output to run scrublet on
#add in params to the final output folder name
write10xCounts(paste(rep_oi, "/outs/seurat_processed", sep=""),
              gex_2@assays$RNA@counts,
              barcodes = colnames(gex_2),
              gene.id = rownames(gex_2),
              overwrite = TRUE)

