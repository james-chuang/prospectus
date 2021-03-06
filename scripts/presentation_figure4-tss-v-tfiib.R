
import = function(df, path, category){
    df = read_tsv(path) %>%
        mutate(category=category) %>%
        bind_rows(df, .) %>%
        return()
}

main = function(theme_spec, genic, intragenic, antisense,
                fig_width, fig_height,
                pdf_out){
    source(theme_spec)

    df = tibble() %>%
        import(genic, 'genic') %>%
        import(intragenic, 'intragenic') %>%
        import(antisense, 'antisense') %>%
        mutate(category=fct_inorder(category, ordered=TRUE)) %>%
        filter(! is.na(tss_lfc) & ! is.na(tfiib_lfc))
    count_df = df %>% count(category)

    fig_two_d = ggplot(data = df) +
        geom_hline(yintercept = 0, color="grey65") +
        geom_vline(xintercept = 0, color="grey65") +
        geom_abline(intercept = 0, slope=1, color="grey65") +
        stat_bin_hex(geom="point",
                     aes(x=tss_lfc, y=tfiib_lfc, color=(..count..)),
                     binwidth=c(0.11, 0.11), alpha=0.6, size=0.1, fill=NA) +
        geom_label(data = count_df,
                  aes(label=paste0("n=",n)),
                  x=-6, y=5, hjust=0, size=7/72*25.4,
                  label.padding = unit(2, "pt"),
                  label.r = unit(0, "pt"),
                  label.size = NA) +
        facet_wrap(~category, nrow=1) +
        scale_color_viridis(guide=FALSE, option="inferno") +
        scale_y_continuous(limits = c(-4.5, 6),
                           name = expression(atop("TFIIB ChIP-nexus", log[2] ~ textstyle(frac(italic("spt6-1004"), "WT"))))) +
                           # name = expression("TFIIB ChIP-nexus" ~ log[2] ~ displaystyle(frac(italic("spt6-1004"), "WT")))) +
        scale_x_continuous(limits = c(-6, 8),
                           name = expression("TSS-seq" ~ log[2] ~ textstyle(frac(italic("spt6-1004"), "WT")))) +
                           # name = expression("TSS-seq" ~ log[2] ~ displaystyle(frac(italic("spt6-1004"), "WT")))) +
        theme_default +
        theme(strip.text = element_text(size=12, color="black"),
              axis.text = element_text(size=10),
              axis.title.x = element_text(size=12),
              axis.title.y = element_text(size=12, angle=0, vjust=0.5),
              panel.grid.minor.x = element_blank(),
              panel.grid.minor.y = element_blank(),
              panel.spacing.y = unit(0, "pt"),
              plot.margin=margin(0,2,0,0,"pt"))

    ggsave(pdf_out, plot=fig_two_d, width=fig_width, height=fig_height, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     genic = snakemake@input[["genic"]],
     intragenic = snakemake@input[["intragenic"]],
     antisense = snakemake@input[["antisense"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])

