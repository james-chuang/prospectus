
import = function(path, sample_list, experiment){
    df = read_tsv(path, col_names = c("group", "sample", "annotation", "index", "position", "signal")) %>%
        filter((sample %in% sample_list) & ! is.na(signal)) %>%
        mutate(group = fct_inorder(group, ordered=TRUE)) %>%
        group_by(group, annotation, index, position) %>%
        summarise(signal = mean(signal)) %>%
        ungroup()

    if (experiment=="spt6"){
        df %<>% mutate(group = ordered(group,
                                       levels = c("WT-37C", "spt6-1004-37C"),
                                       labels = c("WT", "italic(\"spt6-1004\")")))
    }
    return(df)
}

plot_heatmap = function(data_path, sample_list, anno_path, cps_dist,
                        experiment = "spt6",
                        max_length, add_ylabel, y_label="",
                        cutoff_pct, colorbar_title){

    anno_df = read_tsv(anno_path,
                       col_names = c('chrom', 'start', 'end',
                                     'name', 'score', 'strand')) %>%
        rowid_to_column(var="index") %>%
        arrange(desc(end-start)) %>%
        rowid_to_column(var="sorted_index") %>%
        mutate(cps_position = (end-start)/1000-cps_dist)

    df = import(data_path, sample_list=sample_list, experiment=experiment) %>%
        left_join(anno_df %>% select(index, sorted_index), by="index")

    label_df = df %>%
        group_by(group) %>%
        summarise(sorted_index = max(sorted_index),
                  position = max(position))

    heatmap = ggplot() +
        geom_raster(data=df, aes(x=position, y=sorted_index, fill=signal),
                    interpolate=FALSE) +
        geom_path(data = anno_df %>% filter(cps_position <= max_length),
                     aes(x=cps_position, y=sorted_index),
                  size=0.5, linetype="dotted", color="white", alpha=0.9) +
        geom_text(data=label_df, aes(x = if_else(experiment=="spt6", 1, 0.9), y=sorted_index, label=group),
                  hjust=0, nudge_y=if_else(experiment=="spt6", -250, -100), size=9/72*25.4, parse=TRUE) +
        scale_x_continuous(breaks = scales::pretty_breaks(n=3),
                           expand = c(0, 0),
                           labels = function(x){case_when(x==0 ~ "TSS",
                                                          x==2 ~ "2 kb",
                                                          TRUE ~ as.character(x))}) +
        scale_y_continuous(breaks = function(x){seq(min(x)+500, max(x)-500, 500)},
                           name = if(add_ylabel){paste(n_distinct(df[["sorted_index"]]), y_label)} else {""},
                           expand = c(0, 0)) +
        # scale_fill_distiller(palette = "PuBu", direction=1,
        scale_fill_viridis(option = "inferno",
                           limits = c(NA, quantile(df[["signal"]], cutoff_pct)),
                           breaks = scales::pretty_breaks(n=2),
                           oob = scales::squish,
                           name = colorbar_title,
                           guide = guide_colorbar(title.position="top",
                                                  barwidth=12,
                                                  barheight=0.3,
                                                  title.hjust=0.5)) +
        facet_grid(.~group, labeller=label_parsed) +
        theme_heatmap
    return(heatmap)
}

