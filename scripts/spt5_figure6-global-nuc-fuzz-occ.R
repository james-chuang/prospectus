
import = function(path, group){
    read_tsv(path) %>%
        transmute(occupancy = smt_value,
                  fuzziness = fuzziness_score,
                  group = group) %>%
        return()
}


main = function(theme_spec,
                wt_mnase_quant, spt6_mnase_quant,
                annotation,
                fig_width, fig_height,
                pdf_out){
    source(theme_spec)

    df = import(wt_mnase_quant, group="non-depleted") %>%
        bind_rows(import(spt6_mnase_quant, group="depleted")) %>%
        mutate(group = fct_inorder(group, ordered=TRUE))

    summary_df = df %>%
        group_by(group) %>%
        summarise(mean_occ = mean(occupancy),
                  sd_occ = sd(occupancy),
                  mean_fuzz = mean(fuzziness),
                  sd_fuzz = sd(fuzziness),
                  median_occ = median(occupancy),
                  median_fuzz = median(fuzziness))

    fig_four_c = ggplot() +
        # geom_segment(data = summary_df,
        #              aes(x=median_fuzz, xend=median_fuzz,
        #                  y=0, yend=median_occ, color=group),
        #              alpha=0.3, linetype="dashed", size=0.3) +
        # geom_segment(data = summary_df,
        #              aes(x=35, xend=median_fuzz,
        #                  y=median_occ, yend=median_occ, color=group),
        #              alpha=0.3, linetype="dashed", size=0.3) +
        geom_density2d(data = df,
                       aes(x=fuzziness, y=occupancy,
                           color=group, alpha=log10(..level..)),
                       na.rm=TRUE, h=c(10,7000), size=0.3, bins=6) +
        # stat_bin_hex(geom="point",
        #              data = df,
        #              aes(x=fuzziness, y=occupancy, color=..count..),
        #              binwidth=c(1,500),
        #              size=0.1) +
        facet_grid(.~group) +
        # scale_color_viridis(option="inferno") +
        # geom_point(data = summary_df,
        #            aes(x=median_fuzz, y=median_occ, color=group),
        #            size=0.5) +
        scale_color_ptol(guide=guide_legend(keyheight = unit(9, "pt"),
                                            keywidth = unit(12, "pt"))) +
        scale_alpha(guide=FALSE, range = c(0.35, 1)) +
        scale_x_continuous(limits = c(30, 80),
                           breaks = scales::pretty_breaks(n=3),
                           expand = c(0,0),
                           name = expression(fuzziness %==% std. ~ dev ~ of ~ dyad ~ positions ~ (bp))) +
        scale_y_continuous(limits = c(NA, 80000),
                           breaks = scales::pretty_breaks(n=2),
                           labels = function(x){x/1e4},
                           expand = c(0,0),
                           name = "occupancy (au)") +
        ggtitle("nucleosome occupancy and fuzziness") +
        theme_default +
        theme(panel.grid = element_blank(),
              panel.border = element_blank(),
              axis.line = element_line(size=0.25, color="grey65"),
              axis.title.x = element_text(size=7),
              legend.position = c(0.99, 0.99),
              plot.margin = margin(11/2, 11/2, 0, 0, "pt"))

    ggsave(pdf_out, plot=fig_four_c, width=fig_width, height=fig_height, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     wt_mnase_quant = snakemake@input[["wt_mnase_quant"]],
     spt6_mnase_quant = snakemake@input[["spt6_mnase_quant"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])

