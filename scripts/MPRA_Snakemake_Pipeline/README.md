# Set-up Instructions

If you have not already installed micromamba, follow instructions [here](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html)

You will need two environment to run the preprocessing pipeline: one for Snakemake 7, and one for scQers.

## Snakemake 7
```
micromamba create -c conda-forge -c bioconda -n snakemake7 snakemake=7 conda
```

## scQers
```
micromamba create -c dnachun -c conda-forge -c bioconda -n scqers scqers
```
