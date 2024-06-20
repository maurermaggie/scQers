rule seurat:
    input:
        input_file = config["output_directory"] + "/" + "{ID}" + "/outs/raw_feature_bc_matrix/barcodes.tsv.gz"
    resources:
        mem = "128G", 
        time = "4:00:00"
    params:
        sub_directory = config["output_directory"] + "/" + "{ID}" + "/outs/raw_feature_bc_matrix",
        directory = config["output_directory"] + "/" + "{ID}"
    output:
        output_file = config["output_directory"] + "/" + "{ID}" + "/outs/seurat_processed/barcodes.tsv"
    shell:"""
        Rscript scripts/seurat.R --directory {params.directory} --sub_directory {params.sub_directory}

        #Snakemake will error out if you do not do something with the output file in the rule. 
        #To get around this, I ls the output file
        ls {output.output_file}
    """