#!/usr/bin/env python

configfile: "config.yaml"

rule all:
    input:
        "figures/figure1_tss-seq-coverage.pdf",
        "figures/figure2_tss-seq-heatmaps.pdf",
        "figures/figure3_tfiib-nexus-tata.pdf",
        "figures/figure4_tfiib-heatmaps.pdf",
        "figures/figure5_tss-diffexp-summary.pdf",
        "figures/figure6_tss-expression-levels.pdf",
        "figures/figure7_tss-v-tfiib.pdf",
        "figures/figure8_tfiib-spreading-ssa4.pdf",
        "prospectus.pdf"

rule compile_document:
    input:
        "figures/figure1_tss-seq-coverage.pdf",
        "figures/figure2_tss-seq-heatmaps.pdf",
        "figures/figure3_tfiib-nexus-tata.pdf",
        "figures/figure4_tfiib-heatmaps.pdf",
        "figures/figure5_tss-diffexp-summary.pdf",
        "figures/figure6_tss-expression-levels.pdf",
        "figures/figure7_tss-v-tfiib.pdf",
        "figures/figure8_tfiib-spreading-ssa4.pdf",
        tex = "prospectus.tex"
    output:
        "prospectus.pdf"
    conda: "envs/latex.yaml"
    shell: """
        tectonic {input.tex}
        """

rule figure_one:
    input:
        theme = config["theme_spec"],
        data_path = config["figure_one"]["data_path"]
    output:
        pdf = "figures/figure1_tss-seq-coverage.pdf"
    params:
        height = eval(str(config["figure_one"]["height"])),
        width = eval(str(config["figure_one"]["width"])),
    conda: "envs/plot.yaml"
    script:
        "scripts/figure1_tss-coverage.R"


rule figure_two:
    input:
        theme = config["theme_spec"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        annotation = config["figure_two"]["annotation"],
        tss_sense = config["figure_two"]["tss_sense"],
        tss_antisense = config["figure_two"]["tss_antisense"]
    output:
        pdf = "figures/figure2_tss-seq-heatmaps.pdf"
    params:
        height = eval(str(config["figure_two"]["height"])),
        width = eval(str(config["figure_two"]["width"])),
    conda: "envs/plot.yaml"
    script:
        "scripts/figure2_tss-seq-heatmaps.R"

rule figure_three:
    input:
        theme = config["theme_spec"],
        sense_tfiib_data = config["figure_three"]["sense_tfiib_data"],
        antisense_tfiib_data = config["figure_three"]["antisense_tfiib_data"],
    output:
        pdf = "figures/figure3_tfiib-nexus-tata.pdf"
    params:
        height = eval(str(config["figure_three"]["height"])),
        width = eval(str(config["figure_three"]["width"])),
    conda: "envs/plot.yaml"
    script:
        "scripts/figure3_tfiib-nexus-tata.R"

rule figure_four:
    input:
        theme = config["theme_spec"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        annotation = config["figure_four"]["annotation"],
        tfiib_data = config["figure_four"]["tfiib_data"],
    output:
        pdf = "figures/figure4_tfiib-heatmaps.pdf"
    params:
        height = eval(str(config["figure_four"]["height"])),
        width = eval(str(config["figure_four"]["width"])),
    conda: "envs/plot.yaml"
    script:
        "scripts/figure4_tfiib-heatmaps.R"

rule figure_five:
    input:
        in_genic = config["figure_five"]["genic"],
        in_intra = config["figure_five"]["intragenic"],
        in_anti = config["figure_five"]["antisense"],
        in_inter = config["figure_five"]["intergenic"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure5_tss-diffexp-summary.pdf",
    params:
        height = eval(str(config["figure_five"]["height"])),
        width = eval(str(config["figure_five"]["width"])),
    conda: "envs/plot.yaml"
    script:
        "scripts/figure5_tss-diffexp-barplot.R"

rule figure_six:
    input:
        tss_genic = config["figure_six"]["tss_genic"],
        tss_intragenic = config["figure_six"]["tss_intragenic"],
        tss_antisense = config["figure_six"]["tss_antisense"],
        tss_intergenic = config["figure_six"]["tss_intergenic"],
        # tfiib_genic = config["figure_one"]["one_d"]["tfiib_genic"],
        # tfiib_intragenic = config["figure_one"]["one_d"]["tfiib_intragenic"],
        # tfiib_intergenic = config["figure_one"]["one_d"]["tfiib_intergenic"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure6_tss-expression-levels.pdf",
    params:
        height = eval(str(config["figure_six"]["height"])),
        width = eval(str(config["figure_six"]["width"])),
    conda: "envs/plot.yaml"
    script:
        "scripts/figure6_tss-expression-levels.R"

rule figure_seven:
    input:
        genic = config["figure_seven"]["genic"],
        intragenic = config["figure_seven"]["intragenic"],
        antisense = config["figure_seven"]["antisense"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure7_tss-v-tfiib.pdf",
    params:
        height = eval(str(config["figure_seven"]["height"])),
        width = eval(str(config["figure_seven"]["width"])),
    conda: "envs/plot.yaml"
    script:
        "scripts/figure7_tss-v-tfiib.R"

rule figure_eight:
    input:
        tfiib_data = config["figure_eight"]["tfiib_data"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure8_tfiib-spreading-ssa4.pdf",
    params:
        height = eval(str(config["figure_eight"]["height"])),
        width = eval(str(config["figure_eight"]["width"])),
    conda: "envs/plot.yaml"
    script:
        "scripts/figure8_tfiib-spreading-ssa4.R"
