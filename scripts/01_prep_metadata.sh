#!/bin/bash
# Script: 01_prep_metadata.sh
# Description: Automate the extraction of sample IDs and group them into 3 populations
# Create data directory if it doesn't exist
mkdir -p data
# Extract all sample names from the VCF file
echo "Progress: Extracting sample names from VCF..."
bcftools query -l data/ProjTaxa.vcf.gz > data/all_samples.txt
# Group samples into 3 populations (8N, Lesina, K) based on ID patterns
# Use grep to filter IDs. 
echo "Progress: Sorting samples into population lists..."
grep "8N" data/all_samples.txt > pop_8N.txt
grep "Les" data/all_samples.txt > pop_Lesina.txt
grep "K" data/all_samples.txt > pop_K.txt
# Print summary statistics to the terminal
echo "------------------------------------------------"
echo "Metadata preparation complete:"
echo " - Population 8N:     $(wc -l < pop_8N.txt) samples"
echo " - Population Lesina: $(wc -l < pop_Lesina.txt) samples"
echo " - Population K:      $(wc -l < pop_K.txt) samples"
echo "------------------------------------------------"
