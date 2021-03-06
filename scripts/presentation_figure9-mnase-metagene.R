
import = function(path, sample_list){
    read_tsv(path, col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        group_by(group, annotation, position) %>%
        summarise(mid = median(signal),
                  low = quantile(signal, 0.25),
                  high = quantile(signal, 0.75)) %>%
        ungroup() %>%
        mutate(group = ordered(group,
                               levels = c("WT-37C", "spt6-1004-37C"),
                               labels = c("WT", "italic(\"spt6-1004\")"))) %>%
        return()
}

main = function(theme_spec,
                mnase_data,
                fig_width, fig_height,
                pdf_out){
    source(theme_spec)
    sample_list = c("WT-37C-1", "spt6-1004-37C-1", "spt6-1004-37C-2")
    max_length=1.5

    df = import(mnase_data, sample_list=sample_list) %>%
        mutate_at(vars(-c(group, annotation, position)), funs(.*10))

    fig_four_a = ggplot(data = df,
                       aes(x=position, color=group, fill=group)) +
        # geom_vline(xintercept = 0, size=0.4, color="grey65") +
        geom_ribbon(aes(ymin=low, ymax=high), alpha=0.2, linetype='blank') +
        geom_line(aes(y=mid), size=1, alpha=0.7) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           labels = function(x){case_when(x==0 ~ "+1 dyad",
                                                          x==max_length ~ paste(x, "kb"),
                                                          TRUE ~ as.character(x))},
                           name = NULL,
                           expand = c(0,0)) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=2),
                           limits = c(0, max(df[["high"]]*1.05)),
                           expand = c(0,0),
                           labels = function(x){if_else(x<0, abs(x), x)},
                           name = "normalized counts") +
        ggtitle("MNase-seq dyad signal") +
        scale_color_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        scale_fill_ptol(labels = c("WT", bquote(italic("spt6-1004")))) +
        theme_presentation_default +
        theme(legend.key.height = unit(14, "pt"),
              legend.key.width = unit(30, "pt"),
              legend.position = c(0.7, 0.85),
              panel.grid = element_blank(),
              plot.margin = margin(0, 20, 3, 0, "pt"))

    ggsave(pdf_out, plot=fig_four_a, width=fig_width, height=fig_height, units="cm")
}

main(theme_spec = snakemake@input[["theme"]],
     mnase_data = snakemake@input[["mnase_data"]],
     fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])

