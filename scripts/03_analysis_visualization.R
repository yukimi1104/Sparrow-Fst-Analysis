# Script: 03_analysis_visualization.R
# Visualization and Statistical Summary for 3 Populations
# Load necessary libraries
library(ggplot2)
library(dplyr)
library(patchwork)
library(readr)
# Load data and pre-processing
# Load Fst windowed results for three pairwise comparisons
fst_8N_L <- read_table("results/8N_vs_Lesina.windowed.weir.fst") %>% mutate(Comparison = "8N vs Lesina")
fst_8N_K <- read_table("results/8N_vs_K.windowed.weir.fst")      %>% mutate(Comparison = "8N vs K")
fst_L_K  <- read_table("results/Lesina_vs_K.windowed.weir.fst")  %>% mutate(Comparison = "Lesina vs K")
# Combine all Fst data into a single dataframe
all_fst <- bind_rows(fst_8N_L, fst_8N_K, fst_L_K)
# Load Nucleotide Diversity (Pi) results
pi_8N <- read_table("results/8N_pi.windowed.pi") %>% rename(Pi_8N = PI)
pi_L  <- read_table("results/Lesina_pi.windowed.pi") %>% rename(Pi_L = PI)
pi_K  <- read_table("results/K_pi.windowed.pi") %>% rename(Pi_K = PI)
# MANHATTAN plot (3-WAY COMPARISON) -------------------------------
plot4 <- ggplot(all_fst, aes(x = BIN_START / 1e6, y = WEIGHTED_FST)) +
  geom_point(alpha = 0.5, color = "#228B22", size = 0.8) + # I prefer green color
  facet_wrap(~Comparison, ncol = 1) +
  theme_bw() + # white background
  theme(
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "white"),
    text = element_text(family = "sans")
  ) +
  labs(
    title = "Genomic Landscapes of Differentiation (Fst)",
    subtitle = "Window-based analysis (50kb) across three populations",
    x = "Genomic Position (Mb)",
    y = "Weighted Fst (Weir and Cockerham)"
  )
# Save as PDF
ggsave("results/Figure_4_Manhattan.pdf", plot4, width = 10, height = 12)
# Correlation analysis
# Join Fst data with Pi data for Correlation analysis based on Chromosome and Bin Position
correlation_data <- fst_8N_L %>%
  inner_join(pi_8N, by = c("CHROM", "BIN_START", "BIN_END")) %>%
  inner_join(pi_L,  by = c("CHROM", "BIN_START", "BIN_END")) %>%
  mutate(Avg_Pi = (Pi_8N + Pi_L) / 2)
# Calculate Spearman Correlation
spearman_res <- cor.test(correlation_data$WEIGHTED_FST, correlation_data$Avg_Pi, method = "spearman")
plot5 <- ggplot(correlation_data, aes(x = Avg_Pi, y = WEIGHTED_FST)) +
  geom_point(alpha = 0.4, color = "#2E8B57") + # SeaGreen
  geom_smooth(method = "lm", color = "black", linetype = "dashed") +
  theme_minimal() +
  labs(
    title = "Correlation: Fst vs. Nucleotide Diversity (Pi)",
    subtitle = paste("Spearman's rho:", round(spearman_res$estimate, 3), 
                     "| p-value:", format.pval(spearman_res$p.value)),
    x = "Mean Nucleotide Diversity (Pi)",
    y = "Weighted Fst"
  )
# Save as PDF
ggsave("results/Figure_5_Correlation.pdf", plot5, width = 8, height = 6)
# This step categorizes windows into Z-Chromosome or Autosomes for quantification
summary_table <- all_fst %>%
  mutate(Chr_Type = ifelse(CHROM == "chrZ", "Z_Chromosome", "Autosomes")) %>%
  group_by(Comparison, Chr_Type) %>%
  summarise(
    Mean_Fst = mean(WEIGHTED_FST, na.rm = TRUE),
    Median_Fst = median(WEIGHTED_FST, na.rm = TRUE),
    Max_Fst = max(WEIGHTED_FST, na.rm = TRUE),
    Total_Windows = n(),
    Highly_Divergent_Windows = sum(WEIGHTED_FST > 0.5, na.rm = TRUE),
    .groups = "drop"
  )
# Export the final refined statistics
write_csv(summary_table, "results/Fst_Detailed_Summary.csv")
message("Success: Figures and Detailed Summary (Z vs Autosomes) generated in /results.")
