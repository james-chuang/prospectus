
main = function(pdf_out, fig_height, fig_width){
    library(tidyverse)
    library(viridis)
    library(grid)
    library(gridExtra)

    df = tibble(counts = c(rnorm(50, sd=0.5),
                           rnorm(50, sd=1),
                           rnorm(50, sd=2),
                           rnorm(100, sd=0.5),
                           rnorm(100, sd=1),
                           rnorm(100, sd=2),
                           rnorm(200, sd=0.5),
                           rnorm(200, sd=1),
                           rnorm(200, sd=2)),
                occupancy = c(rep("low", 150),
                              rep("med", 300),
                              rep("high", 600)),
                fuzziness = c(rep("low", 50),
                              rep("med", 50),
                              rep("high", 50),
                              rep("low", 100),
                              rep("med", 100),
                              rep("high", 100),
                              rep("low", 200),
                              rep("med", 200),
                              rep("high", 200))) %>%
        mutate(occupancy = ordered(occupancy, levels = c("high", "med", "low")),
               fuzziness = ordered(fuzziness, levels = c("low", "med", "high")))

    diagram = ggplot(data = df, aes(x=counts)) +
        geom_histogram(binwidth=0.2,
                       fill = viridis(1)) +
        geom_hline(yintercept = 0) +
        scale_x_continuous(expand = c(0,0)) +
        scale_y_continuous(expand = c(0,0)) +
        facet_grid(occupancy~fuzziness) +
        theme_void() +
        theme(#axis.line = element_line(),
              strip.text = element_blank())

    fuzz_axis = ggplot() +
        annotate(geom="polygon",
                 x = c(0, 2, 2),
                 y = c(0, 0.2, 0),
                 fill = "grey70") +
        annotate(geom="text",
                 x = 1.3,
                 y = 0.05,
                 label = "fuzziness",
                 size = 12/72*25.4) +
        scale_x_continuous(expand = c(0,0)) +
        coord_fixed() +
        theme_void()

    occ_axis = ggplot() +
        annotate(geom="polygon",
                 x = c(0, 0, -0.2),
                 y = c(0, 1, 1),
                 fill = "grey70") +
        annotate(geom="text",
                 x = -0.05,
                 y = 0.65,
                 label = "occupancy",
                 angle = 90,
                 size = 12/72*25.4) +
        coord_fixed() +
        theme_void()

    plot = arrangeGrob(grobs = list(occ_axis, diagram,
                                    nullGrob(), fuzz_axis),
                nrow = 2, ncol = 2,
                heights = c(1, 0.2),
                widths = c(0.17, 1))

    ggsave(pdf_out, plot=plot, width=fig_width, height=fig_height, units="cm")
}

main(pdf_out = snakemake@output[["pdf"]],
     fig_height = snakemake@params[["height"]],
     fig_width = snakemake@params[["width"]])

