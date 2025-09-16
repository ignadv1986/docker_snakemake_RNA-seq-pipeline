# snakemake_RNA-seq-pipeline
Reusable Snakemake pipeline for RNA-Seq analysis starting from BAM files, to analyze differential expression using featureCounts and DESeq2 with apeglm shrinkage. The pipeline leverages a Docker container to ensure reproducible and consistent environments.
## Content
This repository contains a flexible and reproducible RNA-Seq analysis pipeline built with Snakemake and R. It automates all key steps from aligned BAM files through gene counting, and differential expression analysis, outputting clean CSV files for easy downstream visualization and analysis.
A Dockerfile is provided that automates the installation of all required tools, including those for preprocessing raw FASTQ files. While the current Snakemake pipeline operates on BAM files, the Docker container’s environment supports preprocessing steps as well, offering flexibility if raw FASTQ data is available.
## Requirements
**Docker (recommended):** The Docker container includes all necessary software, including R packages, featureCounts, and alignment tools for preprocessing raw FASTQ files.
**lternatively, Conda:** If you prefer not to use Docker, you must manually install the required tools and packages, including:
- Snakemake
- R with Bioconductor packages: DESeq2, apeglm, etc.
- featureCounts (from Subread package)
## Features
- **Docker container** includes all tools needed for preprocessing raw FASTQ files (not currently included in the Snakemake pipeline).
- Automated gene counting from BAM files using **featureCounts**.
- Centralized configuration via **YAML** and sample metadata TSV.
- **DESeq2** differential expression workflow with LFC shrinkage and DEG filtering.
- Ready for visualization and/or further analysis data generation.
## Instructions
1) Clone the repository  
```bash
git clone https://github.com/ignalo1986/snakemake_RNA-seq-pipeline.git  
cd rna_seq_pipeline
```
2) Set up the environment
- Option A (recommended):
Install Docker (if not done) and pull the repository with all the needed tools
```bash
docker pull ignadv1986/rna-seq-r-packages:latest
```
- Option B
Using Conda
```bash
conda create -n rnaseq -c bioconda -c conda-forge snakemake subread r-base r-deseq2 r-apeglm  
conda activate rnaseq
```
3) Prepare your input  
Place .bam and .gtf files into the data/ directory.

4) Fill in metadata/samples.tsv with your sample names, BAM paths, and conditions, following this example:  
| sample  | bam_file          | condition |  
| Sample1 | data/Sample1.bam  | WT        |  
| Sample2 | data/Sample2.bam  | WT        |  
| Sample3 | data/Sample3.bam  | KO        |  
| Sample4 | data/Sample4.bam  | KO        |  


5) Update config/config.yaml to match your experiment setup.
   
6) Run the pipeline:  
- If using Docker (Option A):
```bash
snakemake --use-docker --cores <number_of_threads>
```
- If using Conda (Option B):
```bash
snakemake --cores <number_of_threads>
```
7) View results:
Processed outputs (gene counts, DESeq2 results, filtered DEGs) will be saved in the results/ directory as CSV files, ready for downstream analysis or visualization.

