#!/usr/bin/env python

rule stress_figure1:
    input:
        theme = config["theme_spec"],
        tfiib_data = config["stress_figure1"]["tfiib_data"]
    output:
        pdf = "figures/stress_figure1-tfiib-heatmaps.pdf"
    params:
        height = eval(str(config["stress_figure1"]["height"])),
        width = eval(str(config["stress_figure1"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/stress_figure1-tfiib-heatmaps.R"


