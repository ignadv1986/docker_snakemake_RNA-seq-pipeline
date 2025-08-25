library(dplyr)

# List all count files
count_files <- list.files(path = "results/counts", pattern = "_counts.csv$", full.names = TRUE)

# Initialize combined counts object
combined_counts <- NULL

for (file in count_files) {
  counts_df <- read.csv(file, skip = 1, row.names = 1)  # skip first line (featureCounts stats)
  
  sample_name <- gsub("_counts.csv$", "", basename(file))
  
  # featureCounts outputs counts in the 7th column; select that column
  counts <- counts_df[, 7, drop = FALSE]
  colnames(counts) <- sample_name
  
  if (is.null(combined_counts)) {
    combined_counts <- counts
  } else {
    combined_counts <- cbind(combined_counts, counts)
  }
}

# Save combined counts matrix
write.csv(combined_counts, file = "results/all_samples_combined_counts.csv", quote = FALSE)
