quick_heatmap <- function(dds, genes = c(), stratify_variable = c()) {


        # Check if stratifying variables are in the colData
        strat_vars_in <- stratify_variable %in% colnames(SummarizedExperiment::colData(dds))

        # If all aren't in, stop
        if (all(!strat_vars_in) & length(stratify_variable) > 0){
                stop("\nNone of the columns provided are in the dds column data.")
        }

        # If some aren't in, drop them and carry on
        else if (!(all(strat_vars_in)) & length(stratify_variable) > 0) {
                not_in <- stratify_variable[!strat_vars_in]
                warning(paste0("\nColumm '", not_in,  "' is not in the dds column data. Dropping.\n"))
                stratify_variable <- stratify_variable[strat_vars_in]
        }


        # Filter genes for just those supplied.
        # If none supplied, use all
        if (length(genes) == 0) {
                filtered_genes <- dds
        } else {
                filtered_genes <- dds[which(rownames(dds) %in% genes),]
                not_in <- genes[!(genes %in% rownames(filtered_genes))]
                if(length(not_in) > 0) warning(paste0("\nGene '", not_in, "' not found in dataset. Dropping.\n"))
        }

        col_data <- SummarizedExperiment::colData(filtered_genes)@listData %>%
                dplyr::as_tibble()

        col_data <- col_data %>%
                arrange(!!! syms(stratify_variable))


        annot_col <- as.data.frame(dplyr::select(col_data, !!!rlang::syms(stratify_variable)))
        rownames(annot_col) <- col_data$shortID

        matched_blca <- match(col_data$shortID, colnames(filtered_genes))
        arranged_blca <- filtered_genes[,matched_blca]

        norm_counts <- SummarizedExperiment::assay(arranged_blca, 2)

        myHeat <- grDevices::colorRampPalette(c("green", "black", "red"))

        pheatmap::pheatmap(mat = norm_counts,
                 scale = "row",
                 color = myHeat(100),
                 cluster_cols = F,
                 annotation_col = annot_col)
}
