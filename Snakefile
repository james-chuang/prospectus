#!/usr/bin/env python

configfile: "config.yaml"

include: "rules/spt6_figures.smk"
include: "rules/stress_figures.smk"
include: "rules/spt5_figures.smk"
include: "rules/presentation_figures.smk"

rule all:
    input:
        "figures/figure0_txn-diagram.pdf",
        "figures/figure1_tss-seq-coverage.pdf",
        "figures/figure2_tss-seq-heatmaps.pdf",
        "figures/figure3_tfiib-nexus-tata.pdf",
        "figures/figure4_tfiib-heatmaps.pdf",
        "figures/figure5_tss-diffexp-summary.pdf",
        "figures/figure6_tss-expression-levels.pdf",
        "figures/figure7_tss-v-tfiib.pdf",
        "figures/figure8_tfiib-spreading-ssa4.pdf",
        "figures/figure9_mnase-metagene.pdf",
        "figures/figure10_global-nuc-fuzz-occ.pdf",
        "figures/figure11_mnase-heatmap.pdf",
        "figures/figure12_intragenic-mnase.pdf",
        "figures/figure13_seqlogos.pdf",
        "figures/figure14_intragenic-tata.pdf",
        "figures/stress_figure1-tfiib-heatmaps.pdf",
        "figures/spt5_figure1-netseq-metagene.pdf",
        "figures/spt5_figure2-rnaseq-heatmaps.pdf",
        "figures/spt5_figure3-antisense-heatmaps.pdf",
        "figures/spt5_figure4-mnase-metagene.pdf",
        "figures/spt5_figure5-antisense-mnase-metagene.pdf",
        "prospectus.pdf",
        "presentation.pdf",
        "figures/presentation_figure1-timeline.pdf",
        "figures/presentation_figure2_tss-seq-heatmaps.pdf",
        "figures/presentation_figure3_tfiib-heatmaps.pdf",
        "figures/presentation_figure0-mvd1-coverage.pdf",
        "figures/presentation_figure4_tss-v-tfiib.pdf",
        "figures/presentation_figure5-nucattributes.pdf",
        "figures/presentation_figure6-tss-diffexp-summary.pdf",
        "figures/presentation_figure7-tss-expression-levels.pdf",

rule compile_document:
    input:
        "figures/figure0_txn-diagram.pdf",
        "figures/figure1_tss-seq-coverage.pdf",
        "figures/figure2_tss-seq-heatmaps.pdf",
        "figures/figure3_tfiib-nexus-tata.pdf",
        "figures/figure4_tfiib-heatmaps.pdf",
        "figures/figure5_tss-diffexp-summary.pdf",
        "figures/figure6_tss-expression-levels.pdf",
        "figures/figure7_tss-v-tfiib.pdf",
        "figures/figure8_tfiib-spreading-ssa4.pdf",
        "figures/figure9_mnase-metagene.pdf",
        "figures/figure10_global-nuc-fuzz-occ.pdf",
        "figures/figure11_mnase-heatmap.pdf",
        "figures/figure12_intragenic-mnase.pdf",
        "figures/figure13_seqlogos.pdf",
        "figures/figure14_intragenic-tata.pdf",
        "figures/stress_figure1-tfiib-heatmaps.pdf",
        "figures/spt5_figure1-netseq-metagene.pdf",
        "figures/spt5_figure2-rnaseq-heatmaps.pdf",
        "figures/spt5_figure3-antisense-heatmaps.pdf",
        "figures/spt5_figure4-mnase-metagene.pdf",
        "figures/spt5_figure5-antisense-mnase-metagene.pdf",
        "figures/spt5_figure6_global-nuc-fuzz-occ.pdf",
        tex = "prospectus.tex"
    output:
        "prospectus.pdf"
    conda: "envs/latex.yaml"
    shell: """
        tectonic {input.tex}
        """

rule compile_presentation:
    input:
        "figures/figure0_txn-diagram.pdf",
        "figures/figure1_tss-seq-coverage.pdf",
        # "figures/figure2_tss-seq-heatmaps.pdf",
        "figures/figure3_tfiib-nexus-tata.pdf",
        "figures/figure4_tfiib-heatmaps.pdf",
        "figures/figure5_tss-diffexp-summary.pdf",
        "figures/figure6_tss-expression-levels.pdf",
        "figures/figure7_tss-v-tfiib.pdf",
        "figures/figure8_tfiib-spreading-ssa4.pdf",
        "figures/figure9_mnase-metagene.pdf",
        "figures/figure10_global-nuc-fuzz-occ.pdf",
        "figures/figure11_mnase-heatmap.pdf",
        "figures/figure12_intragenic-mnase.pdf",
        "figures/figure13_seqlogos.pdf",
        "figures/figure14_intragenic-tata.pdf",
        "figures/stress_figure1-tfiib-heatmaps.pdf",
        "figures/spt5_figure1-netseq-metagene.pdf",
        "figures/spt5_figure2-rnaseq-heatmaps.pdf",
        "figures/spt5_figure3-antisense-heatmaps.pdf",
        "figures/spt5_figure4-mnase-metagene.pdf",
        "figures/spt5_figure5-antisense-mnase-metagene.pdf",
        "figures/spt5_figure6_global-nuc-fuzz-occ.pdf",
        "figures/presentation_figure1-timeline.pdf",
        "figures/presentation_figure2_tss-seq-heatmaps.pdf",
        "figures/presentation_figure3_tfiib-heatmaps.pdf",
        "figures/presentation_figure0-mvd1-coverage.pdf",
        "figures/presentation_figure4_tss-v-tfiib.pdf",
        "figures/presentation_figure5-nucattributes.pdf",
        "figures/presentation_figure6-tss-diffexp-summary.pdf",
        "figures/presentation_figure7-tss-expression-levels.pdf",
        tex = "presentation.tex"
    output:
        "presentation.pdf"
    conda: "envs/latex.yaml"
    shell: """
        tectonic {input.tex}
        """

