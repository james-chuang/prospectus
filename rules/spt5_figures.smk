#!/usr/bin/env python

rule spt5_figure1:
    input:
        netseq_data = config["spt5_figure1"]["netseq_data"],
        annotation = config["spt5_figure1"]["annotation"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/spt5_figure1-netseq-metagene.pdf",
    params:
        height = eval(str(config["spt5_figure1"]["height"])),
        width = eval(str(config["spt5_figure1"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt5_figure1-netseq-metagene.R"

rule spt5_figure2:
    input:
        theme = config["theme_spec"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        annotation = config["spt5_figure2"]["annotation"],
        rnaseq_data = config["spt5_figure2"]["rnaseq_data"],
    output:
        pdf = "figures/spt5_figure2-rnaseq-heatmaps.pdf"
    params:
        height = eval(str(config["spt5_figure2"]["height"])),
        width = eval(str(config["spt5_figure2"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt5_figure2-rnaseq-heatmaps.R"

rule spt5_figure3:
    input:
        theme = config["theme_spec"],
        tssseq_data = config["spt5_figure3"]["tssseq_data"],
        rnaseq_data = config["spt5_figure3"]["rnaseq_data"],
        netseq_data = config["spt5_figure3"]["netseq_data"],
    output:
        pdf = "figures/spt5_figure3-antisense-heatmaps.pdf"
    params:
        height = eval(str(config["spt5_figure3"]["height"])),
        width = eval(str(config["spt5_figure3"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt5_figure3-antisense-heatmaps.R"

rule spt5_figure4:
    input:
        theme = config["theme_spec"],
        mnase_data = config["spt5_figure4"]["mnase_data"],
    output:
        pdf = "figures/spt5_figure4-mnase-metagene.pdf"
    params:
        height = eval(str(config["spt5_figure4"]["height"])),
        width = eval(str(config["spt5_figure4"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt5_figure4-mnase-metagene.R"

rule spt5_figure5:
    input:
        theme = config["theme_spec"],
        mnase_data = config["spt5_figure5"]["mnase_data"],
        gc_data = config["spt5_figure5"]["gc_data"],
    output:
        pdf = "figures/spt5_figure5-antisense-mnase-metagene.pdf"
    params:
        height = eval(str(config["spt5_figure5"]["height"])),
        width = eval(str(config["spt5_figure5"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt5_figure5-antisense-mnase-metagene.R"

rule spt5_figure6:
    input:
        wt_mnase_quant = config["spt5_figure6"]["wt_mnase_quant"],
        spt6_mnase_quant = config["spt5_figure6"]["spt5_mnase_quant"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/spt5_figure6_global-nuc-fuzz-occ.pdf",
    params:
        height = eval(str(config["spt5_figure6"]["height"])),
        width = eval(str(config["spt5_figure6"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/spt5_figure6-global-nuc-fuzz-occ.R"




