
main = function(theme_spec, data_path,
                fig_height, fig_width, pdf_out){
    source(theme_spec)

    df = read_tsv(data_path,
                  col_names = c('group', 'sample', 'annotation', 'assay',
                                'index', 'position', 'signal')) %>%
        filter(group=="spt6+", between(position, -0.035, 0.035)) %>%
        group_by(position) %>%
        summarise(signal = mean(signal))

    plot = ggplot(data = df, aes(x=position*1000, y=signal)) +
        geom_col(fill=wildtype_color, color=NA) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x) case_when(x == 0 ~ "TSS",
                                                          x == 20 ~ paste(x, "nt"),
                                                          TRUE ~ as.character(x)),
                           name = NULL) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=3),
                           limits = c(0, max(df[["signal"]])*1.05),
                           expand = c(0,0),
                           name = "normalized counts") +
        theme_default +
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.border = element_blank(),
              axis.line = element_line(size=0.2, color="grey70"))
    ggsave(pdf_out, plot=plot, height=fig_height, width=fig_width, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     data_path = snakemake@input[["data_path"]],
     fig_height = snakemake@params[["height"]],
     fig_width = snakemake@params[["width"]],
     pdf_out = snakemake@output[["pdf"]])

