#!/usr/bin/env python

rule figure0:
    input:
        theme = config["theme_spec"],
    output:
        pdf = "figures/figure0_txn-diagram.pdf"
    params:
        height = eval(str(config["figure0"]["height"])),
        width = eval(str(config["figure0"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure0_txn-diagram.R"

rule figure1:
    input:
        theme = config["theme_spec"],
        data_path = config["figure1"]["data_path"]
    output:
        pdf = "figures/figure1_tss-seq-coverage.pdf"
    params:
        height = eval(str(config["figure1"]["height"])),
        width = eval(str(config["figure1"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure1_tss-coverage.R"

rule figure2:
    input:
        theme = config["theme_spec"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        annotation = config["figure2"]["annotation"],
        tss_sense = config["figure2"]["tss_sense"],
        tss_antisense = config["figure2"]["tss_antisense"]
    output:
        pdf = "figures/figure2_tss-seq-heatmaps.pdf"
    params:
        height = eval(str(config["figure2"]["height"])),
        width = eval(str(config["figure2"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure2_tss-seq-heatmaps.R"

rule figure3:
    input:
        theme = config["theme_spec"],
        sense_tfiib_data = config["figure3"]["sense_tfiib_data"],
        antisense_tfiib_data = config["figure3"]["antisense_tfiib_data"],
    output:
        pdf = "figures/figure3_tfiib-nexus-tata.pdf"
    params:
        height = eval(str(config["figure3"]["height"])),
        width = eval(str(config["figure3"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure3_tfiib-nexus-tata.R"

rule figure4:
    input:
        theme = config["theme_spec"],
        heatmap_scripts = "scripts/plot_heatmap.R",
        annotation = config["figure4"]["annotation"],
        tfiib_data = config["figure4"]["tfiib_data"],
    output:
        pdf = "figures/figure4_tfiib-heatmaps.pdf"
    params:
        height = eval(str(config["figure4"]["height"])),
        width = eval(str(config["figure4"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure4_tfiib-heatmaps.R"

rule figure5:
    input:
        in_genic = config["figure5"]["genic"],
        in_intra = config["figure5"]["intragenic"],
        in_anti = config["figure5"]["antisense"],
        in_inter = config["figure5"]["intergenic"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure5_tss-diffexp-summary.pdf",
    params:
        height = eval(str(config["figure5"]["height"])),
        width = eval(str(config["figure5"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure5_tss-diffexp-barplot.R"

rule figure6:
    input:
        tss_genic = config["figure6"]["tss_genic"],
        tss_intragenic = config["figure6"]["tss_intragenic"],
        tss_antisense = config["figure6"]["tss_antisense"],
        tss_intergenic = config["figure6"]["tss_intergenic"],
        # tfiib_genic = config["figure_one"]["one_d"]["tfiib_genic"],
        # tfiib_intragenic = config["figure_one"]["one_d"]["tfiib_intragenic"],
        # tfiib_intergenic = config["figure_one"]["one_d"]["tfiib_intergenic"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure6_tss-expression-levels.pdf",
    params:
        height = eval(str(config["figure6"]["height"])),
        width = eval(str(config["figure6"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure6_tss-expression-levels.R"

rule figure7:
    input:
        genic = config["figure7"]["genic"],
        intragenic = config["figure7"]["intragenic"],
        antisense = config["figure7"]["antisense"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure7_tss-v-tfiib.pdf",
    params:
        height = eval(str(config["figure7"]["height"])),
        width = eval(str(config["figure7"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure7_tss-v-tfiib.R"

rule figure8:
    input:
        tfiib_data = config["figure8"]["tfiib_data"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure8_tfiib-spreading-ssa4.pdf",
    params:
        height = eval(str(config["figure8"]["height"])),
        width = eval(str(config["figure8"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure8_tfiib-spreading-ssa4.R"

rule figure9:
    input:
        mnase_data = config["figure9"]["mnase_data"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure9_mnase-metagene.pdf",
    params:
        height = eval(str(config["figure9"]["height"])),
        width = eval(str(config["figure9"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure9_mnase-metagene.R"

rule figure10:
    input:
        wt_mnase_quant = config["figure10"]["wt_mnase_quant"],
        spt6_mnase_quant = config["figure10"]["spt6_mnase_quant"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure10_global-nuc-fuzz-occ.pdf",
    params:
        height = eval(str(config["figure10"]["height"])),
        width = eval(str(config["figure10"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure10_global-nuc-fuzz-occ.R"

rule figure11:
    input:
        netseq_data = config["figure11"]["netseq_data"],
        mnase_data = config["figure11"]["mnase_data"],
        quant_data = config["figure11"]["quant_data"],
        annotation = config["figure11"]["annotation"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure11_mnase-heatmap.pdf",
    params:
        height = eval(str(config["figure11"]["height"])),
        width = eval(str(config["figure11"]["width"])),
        assay = "NET-seq"
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure11_mnase-heatmaps.R"

rule figure12:
    input:
        mnase_data = config["figure12"]["mnase_data"],
        gc_data = config["figure12"]["gc_data"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure12_intragenic-mnase.pdf",
    params:
        height = eval(str(config["figure12"]["height"])),
        width = eval(str(config["figure12"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure12_intragenic-mnase.R"

rule figure13:
    input:
        data_paths = config["figure13"]["data_paths"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure13_seqlogos.pdf",
    params:
        height = eval(str(config["figure13"]["height"])),
        width = eval(str(config["figure13"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure13_seqlogos.R"

rule figure14:
    input:
        tata_genic_path = config["figure14"]["tata_genic"],
        tata_intra_path = config["figure14"]["tata_intragenic"],
        tata_random_path = config["figure14"]["tata_random"],
        theme = config["theme_spec"]
    output:
        pdf = "figures/figure14_intragenic-tata.pdf",
    params:
        height = eval(str(config["figure14"]["height"])),
        width = eval(str(config["figure14"]["width"])),
    conda: "../envs/plot.yaml"
    script:
        "../scripts/figure14_intragenic-tata.R"

