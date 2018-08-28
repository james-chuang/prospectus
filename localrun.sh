#!/bin/bash

#SBATCH -p priority
#SBATCH -t 6:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH -n 1
#SBATCH -e snakemake.err
#SBATCH -o snakemake.log
#SBATCH -J spt6_2018_figures

snakemake -p -R `cat <(snakemake --lc) <(snakemake --li) <(snakemake --lp)` --latency-wait 300 --rerun-incomplete --use-conda --cores 8
