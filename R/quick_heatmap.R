#' Quickly make group-stratified heatmaps
#'
#' @param dds A DDS object with the \code{assay(dds, 2)} containing normalized counts.
#' @param genes A list containing hgnc symbols.
#' @param stratify_variable_col A character list of colnames from \code{colData(dds)} on which to stratify
#' @param stratify_variable_row A character list of colnames from \code{rowData(dds)} on which to stratify
#' @param color_blind_friendly Should the output be Red-Blue instead of Red-Green?
#' @param assay_number The slot in the SummarizedExperiment object where the normalized counts reside
#' @param col_id_position The column position in colData which the sample identifier lies
#' @param row_id_position The column position in rowData which the gene identifier lies
#'
#' @return A pheatmap
#' @export
#'
#' @examples
quick_heatmap <- function(dds, genes = c(), stratify_variable_col = c(),
                          stratify_variable_row = c(), color_blind_friendly = F,
                          assay_number = 2, col_id_position = 1, row_id_position = 1) {

        # Check if stratifying variables are in the data
        strat_vars_in_col <- stratify_variable_col %in% colnames(SummarizedExperiment::colData(dds))
        strat_vars_in_row <- stratify_variable_row %in% colnames(SummarizedExperiment::rowData(dds))

        # If all aren't in, stop
        if (all(!strat_vars_in_col) & length(stratify_variable_col) > 0){
                stop("\nNone of the columns provided are in the dds column data.")
        }

        if (all(!strat_vars_in_row) & length(stratify_variable_row) > 0) {
                stop("\nNone of the rows provided are in the dds row data.")
        }

        # If some aren't in, drop them and carry on
        if (!(all(strat_vars_in_col)) & length(stratify_variable_col) > 0) {
                not_in <- stratify_variable_col[!strat_vars_in_col]
                warning(paste0("\nColumm '", not_in,  "' is not in the dds column data. Dropping.\n"))
                stratify_variable_col <- stratify_variable_col[strat_vars_in_col]
        }

        if (!(all(strat_vars_in_row)) & length(stratify_variable_row) > 0) {
                not_in <- stratify_variable_row[!strat_vars_in_row]
                warning(paste0("\nRow '", not_in,  "' is not in the dds row data. Dropping.\n"))
                stratify_variable_row <- stratify_variable_row[strat_vars_in_row]
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

        # Prepare Column Annotation Dataframe
        if(length(stratify_variable_col) > 0) {
                col_data <- SummarizedExperiment::colData(filtered_genes)@listData %>%
                        dplyr::as_tibble() %>%
                        dplyr::arrange(!!!rlang::syms(stratify_variable_col))

                annot_col <- as.data.frame(dplyr::select(col_data, !!!rlang::syms(stratify_variable_col)))
                rownames(annot_col) <- col_data[[col_id_position]]

                matched_dds <- match(col_data[[col_id_position]], colnames(filtered_genes))
                filtered_genes <- filtered_genes[,matched_dds]
        }

        if(length(stratify_variable_col) == 0){
                annot_col <- NA
        }

        # Prepare Row Annotation Dataframe
        if(length(stratify_variable_row) > 0) {
                row_data <- SummarizedExperiment::rowData(filtered_genes)@listData %>%
                        dplyr::as_tibble() %>%
                        dplyr::arrange(!!!rlang::syms(stratify_variable_row))

                annot_row <- as.data.frame(dplyr::select(row_data, !!!rlang::syms(stratify_variable_row)))
                rownames(annot_row) <- row_data[[row_id_position]]

                matched_dds <- match(row_data[[row_id_position]], rownames(filtered_genes))
                filtered_genes <- filtered_genes[matched_dds,]
        }
        if(length(stratify_variable_row) == 0){
                annot_row <- NA
        }

        # Remove genes that have an SD of 0
        filtered_genes <- filtered_genes[which(apply(SummarizedExperiment::assay(dds, 1), 1, stats::sd) != 0)]
        zero_sd <- names(which(apply(SummarizedExperiment::assay(dds, 1), 1, stats::sd) == 0))
        if(length(zero_sd > 0)) {
                warning(paste0("\nGene '", zero_sd, "' had an SD of 0 and has been dropped."))
        }

        norm_counts <- SummarizedExperiment::assay(filtered_genes, assay_number)

        # Choose Heatmap Palette
        if (color_blind_friendly == T) {
                myHeat <- grDevices::colorRampPalette(c("deepskyblue", "black", "red"))
        } else {
                myHeat <- grDevices::colorRampPalette(c("green", "black", "red"))
        }


        pheatmap::pheatmap(mat = norm_counts,
                 color = myHeat(100),
                 scale = "row",
                 cluster_cols = F,
                 annotation_col = annot_col,
                 annotation_row = annot_row,
                 show_colnames = F,
                 border_color = "NA")
}
