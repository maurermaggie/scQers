# Pipeline Overview

The pipeline to process MPRA data consists of the two following folders: 
1. get_barcode_counts
2. gene_expression_processing
 
Both will require you to install micromamba and follow the instructions in their corresponding READMes. 

![Pipeline_Overview](https://github.com/maurermaggie/scQers/blob/main/images/Pipeline_Overview.png?raw=true)

## get_barcode_counts Pipeline

### Inputs:
1. 4 fastqs: the forward and reverse reads of the oBC and mBC. 

### Steps:
1. CellRanger Count
   1. Output: error-corrected cell barcodes
2. Get_barcodes script
   1.  Count UMIs observed for each oBC/ mBC
   2.  Filter our chimeric UMIs
3. Clean_umi script
   1. QC UMIs (remove all composed only of G's, filter on Hamming distance) 

### Output
1. Text files within the "outs" folder:
   1. oBC_get_bc_v3_no_G_cleaned_UMI.txt
   2. mBC_get_bc_v3_no_G_cleaned_UMI.txt
   
## gene_expression_processing Pipeline

### Inputs
1. 2 fastqs: the forward and revere reads of the 10x gene expression output

### Steps
1. CellRanger Count
   1. Output: Gene expression matrix in 3 files within the "raw_feature_bc_matrix" and "filtered_feature_bc_matrix" folders
    1. Barcodes.tsv.gz
    2. Matrix.mtx.gz
    3. Features.tsv.gz
2. Seurat script
   1. Filter results by removing all cells with more than 800 RNA counts or an mt value < 1.3 or  > 12
3. Scrublet script
   1. Coumpute 10x doublet scores for each cell barcode
  
### Output
Found within the "outs/seurat_processed" folder
1. Barcodes.tsv, which contains all of the cell barcodes
2. Genes.tsv, which contains all of the genes with expression found
3. Matrix.mtx, which contains a matrix where the:
   1. First row: # of RNA reads
   2. Second row: Corresponding barcode row in Barcodes.tsv
   3. Third row: Corresponding gene row in Genes.tsv
![Output](https://github.com/maurermaggie/scQers/blob/main/images/Gene_expression_pipeline_output.png?raw=true)
