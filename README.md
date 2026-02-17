# Genomic Differentiation Analysis of Sparrow Populations
## Description
This project investigates the genomic landscape of differentiation among three sparrow populations (8N, K, and Lesina). Following the biological framework of Natola & Irwin (2025), the pipeline processes raw VCF files, calculates relative differentiation (FST) and nucleotide diversity (pi), and generates Manhattan plots and statistical summaries to identify genomic islands of divergence. 
## Repository Structure
- `data/` : Directory for raw VCF files (ignored in version control).
- `metadata/` : Output directory for population sample lists.
- `results/` : Output directory for filtered VCFs, Fst/Pi calculations, tables, and plots.
- `scripts/01_prep_metadata.sh` : Bash script to extract and group sample IDs from the VCF.
- `scripts/03_analysis_visualization.R` : R script for merging data, statistical analysis, and plotting.
- `Snakefile` : Snakemake workflow for automated variant filtering and windowed statistics.
- `environment.yaml` : Conda environment configuration file.
## Installation & Environment Setup
To ensure full reproducibility, a Conda environment file is provided. It contains all the necessary dependencies (`snakemake`, `vcftools`, `bcftools`, `r-base`, and R packages like `ggplot2`, `dplyr`, `patchwork`).
1. Clone this repository:
   ```bash
   git clone [https://github.com/yukimi1104/Sparrow-Fst-Analysis.git](https://github.com/yukimi1104/Sparrow-Fst-Analysis.git)
   cd Sparrow-Fst-Analysis
Create and activate the Conda environment:
Bashconda env create -f environment.yaml
conda activate sparrow_fst
Usage: From Raw VCF to Visualization
Follow these sequential steps to reproduce the entire analysis from raw sequence data to the final figures.
Step 1: Data Preparation
Place your raw VCF files into the data/ directory. The pipeline specifically expects the following filenames based on the Snakefile:data/autosomes_sparrows.vcfdata/chrZ_sparrows.vcfStep 
2: Generate Population Metadata
Run the bash script to extract sample IDs from the Z chromosome VCF and categorize them into population-specific lists (8N, K, Lesina) under the metadata/ folder.Bashbash scripts/01_prep_metadata.sh
Step 3: Execute the Snakemake Pipeline
Run Snakemake to perform variant filtering (Biallelic SNPs, MAF > 0.05, Max-missing 0.8) and calculate 50kb windowed FST and pi statistics using VCFtools.Bashsnakemake --cores 4
Step 4: Statistical Analysis and Visualization
Once Snakemake finishes computing the statistics in the results/ folder, run the R script to generate the summary table and figures.BashRscript scripts/03_analysis_visualization.R
This will output Fst_Detailed_Summary.csv, Figure_4_Manhattan.pdf, and Figure_5_Correlation.pdf in the results/ directory.
GUI and Visual Editor Disclosure GUI Usage: No Graphical User Interfaces (GUIs) or point-and-click applications were used for data filtering or analysis. All steps were executed via the command line.
Visual Editors: All figures and visualizations (including the multi-panel Manhattan plot and correlation scatter plot) were generated entirely programmatically using ggplot2 and patchwork in R. No external visual editors (e.g., Adobe Illustrator, Inkscape) were used to modify the final output.Authors and Acknowledgment
Author: Yiran Chen
Reference: Natola, L., & Irwin, D. E. (2025). Genomic landscape of differentiation in a three-way sapsucker hybrid zone. Journal of Evolutionary Biology.
AI Disclosure: AI assistance (Gemini) was used for terminological refinement, README standard formatting, and LaTeX report adjustments.
