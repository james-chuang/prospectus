#!/usr/bin/env python

configfile: "config.yaml"

rule all:
    input:
        "figures/figure_two_tss-seq-heatmaps.pdf",
        "prospectus.pdf"

rule figure_two:
    input:
        theme = config["theme_spec"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        tss_sense = config["figure_two"]["tss_sense"],
        tss_antisense = config["figure_two"]["tss_antisense"]
    output:
        pdf = "figures/figure_two_tss-seq-heatmaps.pdf"
    params:
        height = config["figure_two"]["height"],
        width = config["figure_two"]["width"],
    conda: "envs/plot.yaml"
    script:
        "scripts/figure_two_tss-seq-heatmaps.R"

rule compile_document:
    input:
        "prospectus.tex"
    output:
        "prospectus.pdf"
    conda: "envs/latex.yaml"
    shell: """
        tectonic {input}
        """




