# Load required libraries
library(ggplot2)     # For plotting
library(dplyr)      # For data manipulation

# Get command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check for required arguments
if (length(args) < 2) {
    stop("Input and output file paths are required.")
}

input_file <- args[1]  # Input file path
output_file <- args[2]  # Output file path

# Load the data, specifying the tab separator
data <- read.csv(input_file, sep = '\t')

# Rename columns for clarity
colnames(data) <- c("FileID", "SampleType", "TPMValue")
head(data)

# Ensure TPM values are numeric
data$TPMValue <- as.numeric(data$TPMValue)

# Generate summary statistics per sample type
summary_data <- data %>%
    group_by(SampleType) %>%
    summarize(
        count = n(),
        max_TPM = max(log2(TPMValue + 1), na.rm = TRUE)
    )

# Create the box plot
plot <- ggplot(data, aes(x = SampleType, y = log2(TPMValue + 1), fill = SampleType)) +
    geom_boxplot(outlier.colour = "red", outlier.size = 1.5, alpha = 0.7) +  # Outliers highlighted
    geom_text(data = summary_data, aes(x = SampleType, y = max_TPM, label = paste("n =", count)), vjust = -0.5, color = "blue", size = 4) +  # Change text color and size
    theme_bw() +  # Change theme to minimal
    labs(
        x = "Cell Type",
        y = "Log2(TPM + 1)",
        title = "Boxplot of TPM Values in Lung Adenocarcinoma"
    ) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))  # Center and bold the title

# Save the plot to file
ggsave(output_file, plot = plot, width = 8, height = 6)

