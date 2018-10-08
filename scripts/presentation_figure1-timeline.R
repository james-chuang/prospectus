library(tidyverse)
library(lubridate)

main = function(fig_width, fig_height, pdf_out){

    df = tibble(event=c("started grad school",
                        "started in Winston lab",
                        "prospectus meeting deadline",
                        "went on leave",
                        "returned from leave",
                        "MNase-seq",
                        "TSS-seq",
                        "NET/RNA-seq",
                        "ChIP-nexus",
                        "today"),
                start = c(ymd(20130903),
                          ymd(20140812),
                          ymd(20160507),
                          ymd(20160911),
                          ymd(20161208),
                          ymd(20170516),
                          ymd(20170601),
                          ymd(20170601),
                          ymd(20170829),
                          ymd(20181011)),
                y = c(1,
                      -1,
                      6,
                      -1,
                      -2,
                      4.5,
                      2.5,
                      1.75,
                      1,
                      6))

    plot = ggplot(data = df) +
        # annotate(geom="segment",
        #          x=ymd(20130903), xend=ymd(20181011),
        #          y=0, yend=0, arrow=arrow(),
        #          size=4) +
        geom_hline(yintercept = 0, size=4) +
        annotate(geom="segment",
                 x=c(ymd(20160507), ymd(20170516)),
                 xend=c(ymd(20181011), ymd(20181011)),
                 y=c(5.5, 4), yend=c(5.5, 4),
                 linetype="dashed") +
        annotate(geom="label",
                 x=c((ymd(20181011)-ymd(20160507))/2+ymd(20160507),
                     (ymd(20181011)-ymd(20170516))/2+ymd(20170516)),
                 y=c(5.5,4),
                 label=c("2 years, 157 days!",
                         "1 year, 148 days"), size=20/72*25.4, label.size=NA) +
        geom_segment(aes(x=start, xend=start,
                         y=y),
                     yend=0,
                     size=2) +
        geom_point(aes(x=start, y=0),
                   shape=21, size=5, color="black", fill="white", stroke=3) +
        geom_label(aes(x=start-4, y=y, label=event), size=20/72*25.4, hjust=0,
                   label.padding=unit(0.4, "lines"),
                   label.size=0.7) +
        scale_x_date(date_breaks = "1 year",
                     expand = c(0.1, 0),
                     labels = scales::date_format("%Y")) +
        theme_minimal() +
        theme(text = element_text(size=20),
              axis.title = element_blank(),
              axis.text.y = element_blank(),
              axis.text.x = element_text(color="black", size=30,
                                         face="bold"),
              panel.grid.major.y = element_blank(),
              panel.grid.minor.y = element_blank())

    ggsave(pdf_out, plot=plot, width=fig_width, height=fig_height, units="in")
}

main(fig_width = snakemake@params[["width"]],
     fig_height = snakemake@params[["height"]],
     pdf_out = snakemake@output[["pdf"]])

