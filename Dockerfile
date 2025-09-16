FROM rna-seq-bamtools

# Install R and required system dependencies
RUN apt-get update && apt-get install -y \
    r-base \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Bioconductor packages and ggplot2 in R
RUN R -e "install.packages('BiocManager', repos='https://cloud.r-project.org')" && \
    R -e "BiocManager::install(c('Rsubread', 'DESeq2', 'apeglm', 'biomaRt', 'featureCounts'))" && \
    R -e "install.packages('ggplot2', repos='https://cloud.r-project.org')"

WORKDIR /data

CMD ["R"]

