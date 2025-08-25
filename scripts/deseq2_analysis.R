#!/usr/bin/env Rscript

# Load necessary libraries
suppressMessages({
  library(DESeq2)
  library(apeglm)
})

# Parse command-line arguments
args <- commandArgs(trailingOnly = TRUE)

if(length(args) < 7){
  stop("Usage: Rscript deseq2_analysis.R <counts.csv> <metadata.tsv> <treatment> <control> <results_prefix> <log2fc_threshold> <padj_threshold>")
}

counts_file <- args[1]
metadata_file <- args[2]
treatment <- args[3]
control <- args[4]
results_prefix <- args[5]
log2fc_threshold <- as.numeric(args[6])
padj_threshold <- as.numeric(args[7])

cat("Loading counts from:", counts_file, "\n")
counts <- read.csv(counts_file, row.names=1)

cat("Loading metadata from:", metadata_file, "\n")
metadata <- read.csv(metadata_file, sep="\t", row.names=1)

# Make sure samples match and in order
metadata <- metadata[colnames(counts), ]

cat("Creating DESeq2 dataset\n")
dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData = metadata,
                              design = ~ condition)

cat("Running DESeq2\n")
dds <- DESeq(dds)

cat("Extracting results for condition:", treatment, "vs", control, "\n")
res <- results(dds, contrast = c("condition", treatment, control))

cat("Performing log2 fold change shrinkage\n")
res_shrunk <- lfcShrink(dds, coef=2, type="apeglm")

# Save full results
full_res_file <- paste0(results_prefix, "_full_results.csv")
cat("Saving full results to:", full_res_file, "\n")
write.csv(as.data.frame(res), full_res_file)

# Save shrunk results
shrunk_res_file <- paste0(results_prefix, "_shrunk_results.csv")
cat("Saving shrunk results to:", shrunk_res_file, "\n")
write.csv(as.data.frame(res_shrunk), shrunk_res_file)

# Filter DEGs
cat("Filtering DEGs with abs(log2FC) >", log2fc_threshold, "and padj <", padj_threshold, "\n")
deg <- res_shrunk[which(!is.na(res_shrunk$padj) &
                          res_shrunk$padj < padj_threshold &
                          abs(res_shrunk$log2FoldChange) > log2fc_threshold), ]

deg_file <- paste0(results_prefix, "_DEGs_filtered.csv")
cat("Saving filtered DEGs to:", deg_file, "\n")
write.csv(as.data.frame(deg), deg_file)

cat("DESeq2 analysis complete!\n")
