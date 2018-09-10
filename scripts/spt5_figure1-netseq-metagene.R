
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "assay", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        mutate(group = fct_inorder(group, ordered=TRUE)) %>%
        group_by(group, annotation, position) %>%
        summarise(mid = median(signal),
                  low = quantile(signal, 0.25),
                  high = quantile(signal, 0.75)) %>%
        ungroup() %>%
        return()
}

main = function(theme_spec, netseq_data,
                annotation,
                fig_width, fig_height,
                pdf_out){
    source(theme_spec)
    sample_list = c("non-depleted-3", "non-depleted-4", "depleted-1", "depleted-2")

    df = import(netseq_data, sample_list=sample_list)

    plot = ggplot(data = df, aes(x=position, color=group, fill=group)) +
        geom_vline(xintercept = c(0, 2), size=0.3, color="grey75") +
        geom_ribbon(aes(ymin=low, ymax=high), alpha=0.17, linetype='blank') +
        geom_line(aes(y=mid), alpha=0.75) +
        scale_x_continuous(breaks = c(0, 2),
                           labels = c("TSS", "CPS"),
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=1),
                           limits = c(0, max(df[["high"]])*1.05),
                           expand = c(0,0.002),
                           name = "normalized counts") +
        ggtitle("sense NET-seq signal") +
        scale_color_ptol() +
        scale_fill_ptol() +
        theme_default +
        theme(legend.key.height = unit(10, "pt"),
              panel.grid = element_blank(),
              legend.position = c(0.7, 0.99),
              legend.background = element_rect(color=NA, fill="white", size=0),
              plot.margin = margin(11/2, 11/2, 11/2, 0, unit="pt"))

    ggsave(pdf_out, plot=plot, width=fig_width, height=fig_height, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     netseq_data = snakemake@input[["netseq_data"]],
     annotation = snakemake@input[["annotation"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])

