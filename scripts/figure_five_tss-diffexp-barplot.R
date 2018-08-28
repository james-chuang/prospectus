
import = function(df, path, label_col_id, category){
    df = read_tsv(path) %>%
        distinct(chrom, start, end, peak_name, score, strand, .keep_all = TRUE) %>%
        select(chrom, start, end, label=label_col_id, score, strand, log2_foldchange, lfc_SE, stat,
               log10_pval, log10_padj, mean_expr, condition_expr, control_expr) %>%
        mutate(category = category) %>%
        bind_rows(df, .) %>%
        return()
}

main = function(theme_spec, in_genic, in_intra, in_anti, in_inter, alpha,
                fig_width, fig_height,
                pdf_out){
    source(theme_spec)

    df = tibble() %>%
        import(in_genic, label_col_id="genic_name", category="genic") %>%
        import(in_intra, label_col_id="orf_name", category="intragenic") %>%
        import(in_anti, label_col_id="transcript_name", category="antisense") %>%
        import(in_inter, label_col_id="peak_name", category="intergenic") %>%
        mutate(category = fct_inorder(category, ordered=TRUE),
               significance = if_else(log10_padj > -log10(alpha), TRUE, FALSE)) %>%
        mutate(direction = if_else(log2_foldchange >= 0, "upregulated", "downregulated"))

    summary_df = df %>% count(category, significance, direction) %>%
        group_by(category) %>%
        mutate(group_total = sum(n)) %>%
        ungroup() %>%
        spread(direction, n) %>%
        filter(significance) %>%
        mutate(ymax=cumsum(group_total),
               ymin=ymax-group_total,
               y=(ymax+ymin)/2) %>%
        rowid_to_column(var = "ymax_unscaled") %>%
        mutate(ymin_unscaled = lag(ymax_unscaled, default=as.integer(0)),
               y_unscaled = (ymin_unscaled+ymax_unscaled)/2)

    diffexp_summary = ggplot(data = summary_df) +
        geom_segment(aes(x=if_else(category=="genic", upregulated, -downregulated),
                         xend=if_else(category=="genic", 3000, -4100),
                         # y=y+800, yend=y+800),
                         y=y_unscaled+0.17, yend=y_unscaled+0.17),
                     alpha=0.2, size=0.2) +
        geom_rect(aes(xmin=0, xmax=upregulated,
                      # ymax=ymax, ymin=ymin),
                      ymax=ymax_unscaled, ymin=ymin_unscaled),
                  # size=0.5, color="white", fill=ptol_pal()(2)[2], alpha=0.7) +
                  size=0.5, color="white", fill="#fdcdac", alpha=0.9) +
        geom_rect(aes(xmin=-downregulated, xmax=0,
                      # ymax=ymax, ymin=ymin),
                      ymax=ymax_unscaled, ymin=ymin_unscaled),
                  size=0.5, color="white", fill="#cbd5e8", alpha=0.9) +
        geom_text(aes(x=if_else(upregulated>1000, upregulated/2, upregulated+30),
                      hjust = if_else(upregulated>1000, 0.5, 0),
                      # y=y,
                      y=y_unscaled,
                      label=upregulated),
                  size=9/72*25.4) +
        geom_text(aes(x=if_else(downregulated>900, -downregulated/2, -(downregulated+30)),
                      hjust = if_else(downregulated>900, 0.5, 1),
                      # y=y,
                      y=y_unscaled,
                      label=downregulated),
                  size=9/72*25.4) +
        geom_text(aes(x=if_else(category=="genic", 3000, -4100),
                      hjust = if_else(category=="genic", 1, 0),
                      # y=y,
                      y=y_unscaled,
                      label = category),
                  size=7/72*25.4) +
        annotate(geom="label", x=max(summary_df[["upregulated"]])/2,
                 fill= "#fdcdac",
                 label.r = unit(0, "pt"),
                 label.size = NA,
                 # y=-500,
                 y=-0.3,
                 hjust=0.5, label="upregulated", size=7/72*25.4) +
        annotate(geom="label", x=max(summary_df[["downregulated"]])/-2,
                 # y=-500,
                 fill= "#cbd5e8",
                 label.r = unit(0, "pt"),
                 label.size = NA,
                 y=-0.3,
                 hjust=0.5, label="downregulated", size=7/72*25.4) +
        # scale_y_reverse(limits = c(max(summary_df[["ymax"]]), -2500),
        scale_y_reverse(limits = c(max(summary_df[["ymax_unscaled"]]), -.5),
                        expand = c(0,0))+
        theme_void() +
        theme(plot.margin = margin(l=0, t=11/2, unit="pt"))

    orf_label = textGrob(label="ORF",
                         x=0.55, y=0.5, gp=gpar(fontsize=7))
    orf_box = roundrectGrob(x=0.55, y=0.5, width=0.35, height=0.2,
                            r = unit(0.3, "snpc"),
                            gp = gpar(fill="white"))
    inter = textGrob(label = "intergenic",
                     x=0.07, y=0.35, hjust=0, vjust=0.5, gp=gpar(fontsize=7))
    inter_dash = linesGrob(x=c(0.31, 0.31), y=c(0.5, 0.35), gp=gpar(lty="twodash"))
    inter_arrow = linesGrob(x=c(0.31, 0.245), y=c(0.35, 0.35),
                            arrow = arrow(length=unit(0.15, "cm")))
    intra = textGrob(label = "intragenic",
                     x=0.78, y=0.93, hjust=0, vjust=0.5, gp=gpar(fontsize=7))
    intra_dash = linesGrob(x=c(0.6, 0.6), y=c(0.5, 0.93), gp=gpar(lty="twodash"))
    intra_arrow = linesGrob(x=c(0.6, 0.77), y=c(0.93, 0.93),
                            arrow = arrow(length=unit(0.15, "cm")))
    genic = textGrob(label = "genic",
                     x=0.78, y=0.73, hjust=0, vjust=0.5, gp=gpar(fontsize=7))
    genic_dash = linesGrob(x=c(0.35, 0.35), y=c(0.5, 0.73), gp=gpar(lty="twodash"))
    genic_arrow = linesGrob(x=c(0.35, 0.77), y=c(0.73, 0.73),
                            arrow = arrow(length=unit(0.15, "cm")))
    anti = textGrob(label = "antisense",
                     x=0.2, y=0.2, hjust=0, vjust=0.5, gp=gpar(fontsize=7))
    anti_dash = linesGrob(x=c(0.5, 0.5), y=c(0.5, 0.2), gp=gpar(lty="twodash"))
    anti_arrow = linesGrob(x=c(0.5, 0.37), y=c(0.2, 0.2),
                            arrow = arrow(length=unit(0.15, "cm")))
    genome_line = linesGrob(x=c(0.09,0.93), y=c(0.5, 0.5))

    diagram = gTree(children = gList(genome_line,
                                 intra_dash, intra_arrow,
                                 genic_dash, genic_arrow,
                                 inter_dash, inter_arrow,
                                 anti_dash, anti_arrow,
                                 orf_box, orf_label, inter, intra, anti, genic))

    fig_one_c = arrangeGrob(diagram, diffexp_summary, ncol=1, heights=c(0.4, 1))

    ggsave(pdf_out, plot=fig_one_c, width=fig_width, height=fig_height, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     in_genic = snakemake@input[["in_genic"]],
     in_intra = snakemake@input[["in_intra"]],
     in_anti = snakemake@input[["in_anti"]],
     in_inter = snakemake@input[["in_inter"]],
     alpha = 0.1,
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])

