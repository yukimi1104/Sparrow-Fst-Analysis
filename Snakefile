# Snakemake Workflow: Comparative Genomic Differentiation (3 Populations)
# Analyzes 8N, Lesina, and K to explore genomic divergence landscapes.
# rule all: Defines the final output files required for project completion.
rule all:
    input:
        "results/Figure_4_Manhattan.pdf",
        "results/Figure_5_Correlation.pdf"
# Variant Filtering
# Clean raw data to ensure high-quality, biallelic SNPs.
rule filter_vcf:
    input:
        vcf="data/ProjTaxa.vcf.gz"
    output:
        filtered="data/ProjTaxa_filtered.recode.vcf"
    shell:
        """
        # Filtering criteria:
        # 1. --remove-indels & --min/max-alleles 2: Restrict to biallelic SNPs.
        # 2. --maf 0.05: Filter rare variants to minimize sequencing noise.
        # 3. --max-missing 0.8: Ensure 80% genotype call rate per site.
        # 4. --min/max-meanDP: Filter by depth to avoid artifacts.
        vcftools --gzvcf {input.vcf} \
          --remove-indels \
          --min-alleles 2 --max-alleles 2 \
          --maf 0.05 \
          --max-missing 0.8 \
          --min-meanDP 3 --max-meanDP 50 \
          --recode --recode-INFO-all \
          --out data/ProjTaxa_filtered
        """
# Population Statistics Calculation
# Generate windowed Fst and Pi for all three population pairs.
rule calculate_stats:
    input:
        vcf="data/ProjTaxa_filtered.recode.vcf"
    output:
        # Pairwise Fst outputs
        fst_8N_L="results/8N_vs_Lesina.windowed.weir.fst",
        fst_8N_K="results/8N_vs_K.windowed.weir.fst",
        fst_L_K="results/Lesina_vs_K.windowed.weir.fst",
        # Nucleotide Diversity (Pi) outputs for dxy calculation
        pi_8N="results/8N_pi.windowed.pi",
        pi_L="results/Lesina_pi.windowed.pi",
        pi_K="results/K_pi.windowed.pi"
    shell:
        """
        # Calculate Relative Differentiation (Fst) for all pairs in 50kb windows
        vcftools --vcf {input.vcf} --weir-fst-pop pop_8N.txt --weir-fst-pop pop_Lesina.txt --fst-window-size 50000 --fst-window-step 50000 --out results/8N_vs_Lesina
        vcftools --vcf {input.vcf} --weir-fst-pop pop_8N.txt --weir-fst-pop pop_K.txt --fst-window-size 50000 --fst-window-step 50000 --out results/8N_vs_K
        vcftools --vcf {input.vcf} --weir-fst-pop pop_Lesina.txt --weir-fst-pop pop_K.txt --fst-window-size 50000 --fst-window-step 50000 --out results/Lesina_vs_K
        # Calculate Pi per population to derive absolute divergence (Pi_B, also known as dxy)
        vcftools --vcf {input.vcf} --keep pop_8N.txt --window-pi 50000 --out results/8N_pi
        vcftools --vcf {input.vcf} --keep pop_Lesina.txt --window-pi 50000 --out results/Lesina_pi
        vcftools --vcf {input.vcf} --keep pop_K.txt --window-pi 50000 --out results/K_pi
        """
#Statistical Analysis and Visualization
#Run the R script to process data and generate finalfigures.
rule visualize_results:
    input:
        fst_8N_L="results/8N_vs_Lesina.windowed.weir.fst",
        fst_8N_K="results/8N_vs_K.windowed.weir.fst",
        fst_L_K="results/Lesina_vs_K.windowed.weir.fst",
        pi_8="results/8N_pi.windowed.pi",
        pi_L="results/Lesina_pi.windowed.pi"
    output:
        manhattan="results/Figure_4_Manhattan.pdf",
        correlation="results/Figure_5_Correlation.pdf"
    script:
        "scripts/03_analysis_visualization.R"
