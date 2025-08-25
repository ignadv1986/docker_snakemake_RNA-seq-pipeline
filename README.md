# snakemake_RNA-seq-pipeline
Reusable Snakemake pipeline for RNA-Seq analysis from BAM files to DEGs using featureCounts and DESeq2 with apeglm shrinkage. Modular, configurable, and outputs ready-to-use CSV results.
## Content
This repository contains a flexible and reproducible RNA-Seq analysis pipeline built with Snakemake and R. It automates key steps from raw BAM files to differential expression results, outputting clean CSV files for easy downstream visualization and analysis in any tool.
## Requirements
- Snakemake
- R with Bioconductor packages: DESeq2, apeglm, etc.
- fatureCounts (from Subread package)
## Features
- Automated gene counting from BAM files using **featureCounts**.
- Centralized configuration via **YAML** and sample metadata TSV.
- **DESeq2** differential expression workflow with LFC shrinkage and DEG filtering.
- Ready for visualization and/or further analysis data generation.
## Instructions
1) Clone the repository:
git clone https://github.com/ignalo1986/snakemake_RNA-seq-pipeline.git
cd rna_seq_pipeline
2) Set up the environment:
Use Conda to install required tools:
conda create -n rnaseq -c bioconda -c conda-forge snakemake subread r-base r-deseq2 r-apeglm
conda activate rnaseq
3) Prepare your input:
Place .bam and .gtf files into the data/ directory.
4) Fill in metadata/samples.tsv with your sample names, BAM paths, and conditions, following this example
   sample	bam_file	            condition
Sample1	data/Sample1.bam	    WT
Sample2	data/Sample2.bam	    WT
Sample3	data/Sample3.bam	    KO
Sample4	data/Sample4.bam	    KO
5) Update config/config.yaml to match your experiment setup.
6) Run the pipeline:
snakemake --cores <number_of_threads>
7) View results:
Processed outputs (gene counts, DESeq2 results, filtered DEGs) will be saved in the results/ directory as CSV files, ready for downstream analysis or visualization.

