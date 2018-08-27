#!/usr/bin/env python

configfile: "config.yaml"

rule all:
    input:
        "figures/figure_one_tss-seq-coverage.pdf",
        "figures/figure_two_tss-seq-heatmaps.pdf",
        # "figures/figure_three_tfiib-nexus-tata.pdf",
        "prospectus.pdf"

rule figure_one:
    input:
        theme = config["theme_spec"],
        data_path = config["figure_one"]["data_path"]
    output:
        pdf = "figures/figure_one_tss-seq-coverage.pdf"
    params:
        height = config["figure_one"]["height"],
        width = config["figure_one"]["width"],
    conda: "envs/plot.yaml"
    script:
        "scripts/figure_one_tss_coverage.R"

rule figure_two:
    input:
        theme = config["theme_spec"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        annotation = config["figure_two"]["annotation"],
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

rule figure_three:
    input:
        theme = config["theme_spec"],
        sense_tfiib_data = config["figure_three"]["sense_tfiib_data"],
        antisense_tfiib_data = config["figure_three"]["antisense_tfiib_data"],
    output:
        pdf = "figures/figure_three_tfiib-nexus-tata.pdf"
    params:
        height = config["figure_three"]["height"],
        width = config["figure_three"]["width"],
    conda: "envs/plot.yaml"
    script:
        "scripts/figure_three_tfiib-nexus-tata.R"

rule compile_document:
    input:
        "figures/figure_one_tss-seq-coverage.pdf",
        "figures/figure_two_tss-seq-heatmaps.pdf",
        tex = "prospectus.tex"
    output:
        "prospectus.pdf"
    conda: "envs/latex.yaml"
    shell: """
        tectonic {input.tex}
        """




