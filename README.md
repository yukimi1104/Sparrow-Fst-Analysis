# Genomic Differentiation Analysis of Sparrow Populations
## 1. Abstract
This project investigates the genomic landscape of differentiation among three populations (8N, K, and Lesina). Following the methodology of Natola & Irwin (2025), we analyzed relative differentiation (Fst) and absolute distance (dxy, also known as pi_B) to explore biological drivers, which caused organisms to split into different species.
## 2. Method
Our workflow is conducted as the following pipeline.
### Tools and Parameters
- **VCFtools:**  calculate Weir and Cockerham’s Fst estimates.
- **Filtering Criteria:** 
  - **Biallelic SNPs only:** To ensure compatibility with standard population genetic models.
  - **MAF> 0.05:** To remove rare variants that may represent sequencing errors.
  - **Max-missing 0.8:** To ensure high data quality by requiring an 80% genotype call rate.
- **Window Size:** 50 kb non-overlapping windows were used to identify regional genomic islands of differentiation.
## 3. Scripts
- All scripts are modular and annotated to ensure reproducibility.
 -**scripts/01_prep_metadata.sh**: A Bash script to automatically extract and group sample IDs from the VCF into population lists.-**Snakefile**: Contain variant filtering and the calculation of windowed statistics 
 -**03_analysis_visualization.R**: An R script that generates Manhattan plots, Spearman correlations, and quantitative summary tables.
## 4. Results
Quantitative analysis of the 2,596 genomic windows revealed significant variation in differentiation across groups:
8N vs Lesina (Highest Divergence): Showed a mean FST of 0.401 with 961 highly divergent windows (FST > 0.5$).
Lesina vs K (Moderate Divergence): Showed a mean FST of 0.255.
8N vs K (Baseline): Represented the most similar pair with a mean FST of 0.104.
Large Z Effect: FST values on the Z chromosome (Mean 0.569) were significantly higher than the genomic background of Autosomes (Mean 0.078 - 0.213$), which is clearly visualized in the Manhattan plot.
Speciation Model: The positive Spearman correlation and elevated sex-chromosome differentiation support a model of divergence with gene flow.
## 5. Reference
- **Natola, L., & Irwin, D. E. (2025).** *Genomic landscape of differentiation in a three-way sapsucker hybrid zone.* Journal of Evolutionary Biology.
## 6. Reproducibility & Disclosure
- **Execution:** This pipeline can be reproduced by running the provided scripts in order (`01` to `03`) or by using the `Snakefile` (if applicable).
- **AI Disclosure:** The bioinformatic term and README formatting were adjusted with assistance from Gemini (Generative AI), following the biological framework of Natola & Irwin (2025).
## 7. Installation & Environment
The tools were installed as below:
- **VCFtools & BCFtools:** For genomic data filtering and summary statistics.
- **R (v4.5.2):** With libraries `ggplot2`, `dplyr`, `readr`,`patchwork`.
- **Snakemake:** For workflow orchestration.

