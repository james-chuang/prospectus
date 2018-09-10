
import = function(path){
    read_tsv(path, col_names = c("group", "sample", "annotation", "assay", "index", "position", "signal")) %>%
        mutate(group = fct_inorder(group, ordered=TRUE)) %>%
        group_by(group, annotation, position) %>%
        summarise(mid = median(signal),
                  low = quantile(signal, 0.25),
                  high = quantile(signal, 0.75)) %>%
        ungroup() %>%
        return()
}

main = function(theme_spec, mnase_data, gc_data,
                fig_width, fig_height,
                pdf_out){
    source(theme_spec)
    library(cowplot)

    mnase_df = import(mnase_data)
    gc_df = import(gc_data) %>%
        filter(group=="non-depleted")

    mnase_plot = ggplot(data = mnase_df, aes(x=position, color=group, fill=group)) +
        geom_vline(xintercept = 0, size=0.3, color="grey75") +
        geom_ribbon(aes(ymin=low, ymax=high), alpha=0.17, linetype='blank') +
        geom_line(aes(y=mid), alpha=0.75) +
        annotate(geom="text", x=-0.49, y=0.08, hjust=0, vjust=1, label="MNase-seq dyad signal",
                 size=7/72*25.4) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=2),
                           limits = c(0, max(mnase_df[["high"]])*1.05),
                           expand = c(0,0.002),
                           name = "normalized counts") +
        scale_color_ptol() +
        scale_fill_ptol() +
        theme_default +
        theme(legend.key.height = unit(10, "pt"),
              axis.text.x = element_blank(),
              axis.ticks.x = element_blank(),
              axis.title.y = element_text(hjust=0.5),
              panel.grid = element_blank(),
              legend.position = c(0.98, 0.99),
              legend.justification = c(1,1),
              legend.background = element_rect(color=NA, fill="white", size=0),
              plot.margin = margin(11/2, 11, 1, 0, unit="pt"))

    gc_plot = ggplot(data = gc_df, aes(x=position)) +
        geom_vline(xintercept = 0, size=0.3, color="grey75") +
        geom_ribbon(aes(ymin=low, ymax=high), alpha=0.17, fill="grey30", linetype='blank') +
        geom_line(aes(y=mid), alpha=0.75, color="grey30") +
        scale_x_continuous(breaks = c(-0.4, 0, 0.4),
                           labels = function(x) case_when(x==0 ~ "antisense TSS",
                                                          x==0.4 ~ "0.4 kb",
                                                          TRUE ~ as.character(x)) ,
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=3),
                           name = "% (21 bp)") +
        annotate(geom="text", x=-0.49, y=50, hjust=0, vjust=1, label="GC%",
                 size=7/72*25.4) +
        theme_default +
        theme(panel.grid = element_blank(),
              plot.margin = margin(1, 11, 11/2, 0, unit="pt"),
              axis.title.y = element_text(hjust=0.5))

    plot = plot_grid(mnase_plot, gc_plot, align="v", axis="rl", ncol=1,
              rel_heights = c(1, 0.66))

    ggplot2::ggsave(pdf_out, plot=plot, width=fig_width, height=fig_height, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     mnase_data = snakemake@input[["mnase_data"]],
     gc_data = snakemake@input[["gc_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])
