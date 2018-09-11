
main = function(theme_spec, tfiib_path,
                fig_width, fig_height,
                pdf_out){
    source(theme_spec)

    df = read_tsv(tfiib_path,
                  col_names = c('group', 'sample', 'annotation', 'index', 'position', 'signal')) %>%
        filter(group %in% c("YPD", "diamide", "SD", "nitrogen")) %>%
        group_by(group, annotation, index, position) %>%
        summarise(signal = mean(signal)) %>%
        group_by(group, annotation) %>%
        complete(index, position, fill=list(signal=0)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels = c("YPD", "diamide", "SD", "nitrogen"),
                               labels = c("unstressed",
                                          "oxidative stress",
                                          "amino acid starvation",
                                          "nitrogen starvation")),
               annotation = ordered(annotation,
                                    levels = c("diamide-induced",
                                               "aa-starvation-induced",
                                               "nitrogen-induced"),
                                    labels = c("oxidative\nstress\ninduced\n(245)",
                                               "amino acid\nstarvation\ninduced\n(127)",
                                               "nitrogen\nstarvation\ninduced\n(44)")))

    plot = ggplot(data = df, aes(x=position, y=index, fill=signal)) +
        geom_raster(interpolate=FALSE) +
        scale_fill_viridis(limits = c(NA, quantile(df[["signal"]], 0.95)),
                           oob = scales::squish,
                           option = "inferno",
                           breaks = scales::pretty_breaks(n=2),
                           name = "TFIIB ChIP-nexus protection",
                           guide = guide_colorbar(title.position = "top",
                                                  barwidth = 8,
                                                  barheight = 0.3,
                                                  title.hjust=0.5)) +
        scale_x_continuous(breaks = c(0, 1, 2),
                           labels = c("genic TSS", "1", "2 kb"),
                           expand = c(0, 0)) +
        scale_y_reverse(breaks = function(x){seq(25, max(x), 25)},
                        expand = c(0,0)) +
        facet_grid(annotation~group, space="free_y", scales="free_y",
                   switch="y") +
        theme_heatmap +
        theme(strip.text = element_text(),
              strip.text.x = element_text(vjust=0,
                                          margin = margin(b=2, unit="pt")),
              strip.text.y = element_text(angle=-180, hjust=1),
              axis.title.y = element_blank(),
              axis.ticks = element_line(),
              strip.placement = "outside",
              axis.ticks.length = unit(2, "pt"),
              plot.margin = margin(11/2, 11/2, 11/2, 0, "pt"))
    plot = ggplotGrob(plot)
    plot = editGrob(grid.force(plot),
                    gPath("GRID.stripGrob", "GRID.text"),
                    grep=TRUE,
                    global=TRUE,
                    just="right", x=unit(1, "npc"))

    ggsave(pdf_out, plot=plot, width=fig_width, height=fig_height, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     tfiib_path = snakemake@input[["tfiib_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])
