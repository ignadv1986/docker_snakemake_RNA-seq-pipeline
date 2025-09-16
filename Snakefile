import pandas as pd
# Load sample metadata
samples = pd.read_csv("metadata/samples.tsv", sep="\t")
SAMPLES = samples["sample"].tolist()

# Define final targets
rule all:
    input:
        expand("results/counts/{sample}_counts.csv", sample=SAMPLES),
        "results/all_samples_combined_counts.csv",
        "results/deseq2_results_KO_vs_WT.csv"

# Run featurecounts on each bam file
rule featurecounts:
    input:
        bam = lambda wildcards: samples.loc[samples["sample"] == wildcards.sample, "bam"].values[0],
        gtf = config["gtf"]
    output:
        counts = "results/counts/{sample}_counts.csv"
    threads: config["featurecounts"]["nthreads"]
    container:
        "docker.io/ignadv1986/rna-seq-r-packages:latest"
    shell:
        """
        featureCounts \
        -a {input.gtf} \
        -o {output.counts} \
        -T {threads} \
        -p {("--paired-end" if config["featurecounts"]["isPairedEnd"] else "")} \
        -g {config["featurecounts"]["GTF.attrType"]} \
        -t {config["featurecounts"]["GTF.featureType"]} \
        {input.bam}
        """

# Merge counts using R
rule merge_counts:
    input:
        expand("results/counts/{sample}_counts.csv", sample=SAMPLES)
    output:
        "results/all_samples_combined_counts.csv"
    container:
        "docker.io/ignadv1986/rna-seq-r-packages:latest"
    shell:
        "Rscript scripts/merge_counts.R"

# Run DESeq2, LFC shrinkage and DEG filtering
rule run_deseq2:
    input:
        counts = f"{config['results_dir']}/all_samples_combined_counts.csv",
        metadata = config["metadata_file"]
    output:
        full_results = f"{config['results_dir']}/deseq2_full_results.csv",
        shrunk_results = f"{config['results_dir']}/deseq2_shrunk_results.csv",
        filtered_DEGs = f"{config['results_dir']}/DEGs_filtered.csv"
    params:
        treatment = config["conditions"]["treatment"],
        control = config["conditions"]["control"],
        log2fc_threshold = 0.585,  # log2(1.5)
        padj_threshold = 0.05
    container:
        "docker.io/ignadv1986/rna-seq-r-packages:latest"
    shell:
        """
        Rscript scripts/deseq2_analysis.R \
            {input.counts} {input.metadata} {params.treatment} {params.control} \
            {config[results_dir]}/deseq2 \
            {params.log2fc_threshold} {params.padj_threshold}
        """
