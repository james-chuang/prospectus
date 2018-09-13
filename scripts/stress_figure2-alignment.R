library(tidyverse)
library(forcats)
library(gridExtra)

main = function(target_name, query_name, in_chrsize, align_data, chain_data, net_data,
                align_plot_out, chain_plot_out, net_plot_out, all_plot_out){
    chrsizes = read_tsv(in_chrsize,
                        col_names=c('chrom', 'length')) %>%
        mutate(chrom = fct_inorder(chrom, ordered=TRUE),
               cum_length = cumsum(length),
               offset = lag(cum_length, default = 0))

    df = read_tsv(align_data, col_names=FALSE)
    df = df[c(TRUE, FALSE),] %>% bind_cols(df[c(FALSE, TRUE), ]) %>%
        select(1:5) %>%
        magrittr::set_colnames(c('target_start', 'query_start', 'query_chrom', 'target_end', 'query_end')) %>%
        mutate(query_id = fct_inorder(query_chrom, ordered=TRUE),
               target_chrom = cut(target_end, breaks = c(0, chrsizes[["cum_length"]]),
                                  labels = chrsizes[["chrom"]], include_lowest=TRUE,
                                  ordered_result = TRUE)) %>%
        drop_na() %>%
        left_join(chrsizes %>% select(chrom, offset), by=c("target_chrom"="chrom")) %>%
        mutate(target_chrom=fct_inorder(target_chrom, ordered=TRUE)) %>%
        mutate_at(vars(target_start, target_end), funs(.-offset)) %>%
        mutate_if(is.numeric, funs(./1e6))

    align_plot = ggplot(data = df, aes(x=target_start, xend=target_end, y=query_start, yend=query_end)) +
        geom_segment() +
        scale_x_continuous(breaks = scales::pretty_breaks(n=2),
                           name = paste(target_name, "genomic coordinate (Mb)")) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=2),
                           name = paste(query_name, "genomic coordinate (Mb)")) +
        facet_grid(fct_rev(query_chrom)~target_chrom, scales="free", space="free", switch="both") +
        ggtitle("lastz alignment") +
        theme_bw() +
        theme(text = element_text(size=12, color="black", face="bold"),
              axis.text = element_text(size=6, color="black", face="plain"),
              strip.placement="outside",
              strip.background = element_blank(),
              strip.text.y = element_text(angle=-180, hjust=1),
              strip.text.x = element_text(angle=50, vjust=1),
              panel.spacing = unit(0, "pt"),
              panel.grid = element_blank(),
              panel.border = element_rect(color="grey85"))


    chain = read_table2(chain_data, comment="#",
                        col_names=c('chain', 'score',
                                    'target_chrom', 'target_size', 'target_strand', 'target_start', 'target_end',
                                    'query_chrom', 'query_size', 'query_strand', 'query_start', 'query_end',
                                    'chain_id')) %>%
        select(-chain) %>%
        mutate(target_chrom = ordered(target_chrom, levels=levels(df[["target_chrom"]])),
               query_chrom = ordered(query_chrom, levels=levels(df[["query_id"]])),
               new_target_start = if_else(target_strand=="+", target_start, target_end),
               new_target_end = if_else(target_strand=="+", target_end, target_start),
               new_query_start = if_else(query_strand=="+", query_start, query_end),
               new_query_end = if_else(query_strand=="+", query_end, query_start),
               target_start = new_target_start,
               target_end = new_target_end,
               query_start = new_query_start,
               query_end = new_query_end) %>%
        select(-c(new_target_start, new_target_end, new_query_start, new_query_end)) %>%
        mutate_at(vars(target_start, target_end, query_start, query_end), funs(./1e6))

    chain_plot = ggplot(data = chain,
                        aes(x=target_start, xend=target_end, y=query_start, yend=query_end, color=score)) +
        geom_segment() +
        scale_x_continuous(breaks = scales::pretty_breaks(n=2),
                           name = paste(target_name, "genomic coordinate (Mb)")) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=2),
                           name = paste(query_name, "genomic coordinate (Mb)")) +
        facet_grid(fct_rev(query_chrom)~target_chrom, scales="free", space="free", switch="both") +
        ggtitle("chained alignments") +
        theme_bw() +
        theme(text = element_text(size=12, color="black", face="bold"),
              axis.text = element_text(size=6, color="black", face="plain"),
              strip.placement="outside",
              strip.background = element_blank(),
              strip.text.y = element_text(angle=-180, hjust=1),
              strip.text.x = element_text(angle=50, vjust=1),
              panel.spacing = unit(0, "pt"),
              panel.grid = element_blank(),
              panel.border = element_rect(color="grey85"))


    net = read_tsv(net_data,
                   col_names=c("score", "target_chrom", "target_start", "target_size", "target_strand", "target_srcsize",
                               "query_chrom", "query_start", "query_size", "query_strand", "query_srcsize")) %>%
        mutate(target_chrom = ordered(target_chrom, levels=levels(df[["target_chrom"]])),
               query_chrom = ordered(query_chrom, levels=levels(df[["query_id"]])),
               target_end = if_else(target_strand=="+", target_start+target_size, target_start-target_size),
               query_end = if_else(query_strand=="+", query_start+query_size, query_start-query_size)) %>%
        mutate_at(vars(target_start, target_end, query_start, query_end), funs(./1e6))

    net_plot = ggplot(data = net,
                      aes(x=target_start, xend=target_end, y=query_start, yend=query_end, color=score)) +
        geom_segment() +
        scale_x_continuous(breaks = scales::pretty_breaks(n=2),
                           name = paste(target_name, "genomic coordinate (Mb)")) +
        scale_y_continuous(breaks = scales::pretty_breaks(n=2),
                           name = paste(query_name, "genomic coordinate (Mb)")) +
        facet_grid(fct_rev(query_chrom)~target_chrom, scales="free", space="free", switch="both") +
        ggtitle("netted alignments") +
        theme_bw() +
        theme(text = element_text(size=12, color="black", face="bold"),
              axis.text = element_text(size=6, color="black", face="plain"),
              strip.placement="outside",
              strip.background = element_blank(),
              strip.text.y = element_text(angle=-180, hjust=1),
              strip.text.x = element_text(angle=50, vjust=1),
              panel.spacing = unit(0, "pt"),
              panel.grid = element_blank(),
              panel.border = element_rect(color="grey85"))


    plot = arrangeGrob(align_plot, chain_plot, net_plot, ncol=1)

    ggsave(align_plot_out, plot=align_plot, width=30, height=20, units="cm")
    ggsave(chain_plot_out, plot=chain_plot, width=30, height=20, units="cm")
    ggsave(net_plot_out, plot=net_plot, width=30, height=20, units="cm")
    ggsave(all_plot_out, plot=plot, width=30, height=50, units="cm")

}

main(target_name = snakemake@params[["target_name"]],
     query_name = snakemake@params[["query_name"]],
     in_chrsize = snakemake@input[["chrsizes"]],
     align_data = snakemake@input[["align"]],
     chain_data = snakemake@input[["chain"]],
     net_data = snakemake@input[["net"]],
     align_plot_out = snakemake@output[["align"]],
     chain_plot_out = snakemake@output[["chain"]],
     net_plot_out = snakemake@output[["net"]],
     all_plot_out = snakemake@output[["allplots"]])
