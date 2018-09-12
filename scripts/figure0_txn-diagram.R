
main = function(theme_spec,
                fig_width, fig_height,
                pdf_out){
    source(theme_spec)

    orf_label = textGrob(label="coding DNA sequence",
                         x=0.58, y=0.46, gp=gpar(fontsize=7))
    orf_box = roundrectGrob(x=0.58, y=0.45, width=0.55, height=0.23,
                            r = unit(0.3, "snpc"),
                            gp = gpar(fill="white"))
    inter = textGrob(label = "intergenic",
                     x=0.17, y=0.17, hjust=1, vjust=0.5, gp=gpar(fontsize=7))
    inter_dash = linesGrob(x=c(0.17, 0.17), y=c(0.40, 0.30), gp=gpar(lty="dashed"))
    inter_arrow = linesGrob(x=c(0.17, 0.04), y=c(0.30, 0.30),
                            arrow = arrow(length=unit(0.15, "cm")))
    intra = textGrob(label = "intragenic",
                     x=0.6, y=0.98, hjust=0, vjust=1, gp=gpar(fontsize=7))
    intra_dash = linesGrob(x=c(0.6, 0.6), y=c(0.45, 0.81), gp=gpar(lty="dashed"))
    intra_arrow = linesGrob(x=c(0.6, 0.94), y=c(0.81, 0.81),
                            arrow = arrow(length=unit(0.15, "cm")))
    genic = textGrob(label = "genic",
                     x=0.24, y=0.79, hjust=0, vjust=0.5, gp=gpar(fontsize=7))
    genic_dash = linesGrob(x=c(0.24, 0.24), y=c(0.45, 0.67), gp=gpar(lty="dashed"))
    genic_arrow = linesGrob(x=c(0.24, 0.94), y=c(0.67, 0.67),
                            arrow = arrow(length=unit(0.15, "cm")))
    anti = textGrob(label = "antisense",
                     x=0.5, y=0.02, hjust=1, vjust=0, gp=gpar(fontsize=7))
    anti_dash = linesGrob(x=c(0.5, 0.5), y=c(0.45, 0.19), gp=gpar(lty="dashed"))
    anti_arrow = linesGrob(x=c(0.5, 0.34), y=c(0.19, 0.19),
                            arrow = arrow(length=unit(0.15, "cm")))
    genome_line = linesGrob(x=c(0.02,0.98), y=c(0.45, 0.45))

    diagram = gTree(children = gList(genome_line,
                                 intra_dash, intra_arrow,
                                 genic_dash, genic_arrow,
                                 inter_dash, inter_arrow,
                                 anti_dash, anti_arrow,
                                 orf_box, orf_label, inter, intra, anti, genic))
    ggsave(pdf_out, plot=diagram, width=fig_width, height=fig_height, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])

