#' Joins dds colData with rowname matching
#'
#' @param colData_1 colData to be joined TO
#' @param colData_2 coldata to join
#'
#' @return joined colData
#' @export
#'
#' @examples
cbind_colData <- function(colData_1, colData_2) {

        if (sum(colnames(colData_1) %in% colnames(colData_2)) > 0) {
                stop("Column names are not unique.")
        }

        if (nrow(colData_1) != nrow(colData_2)){
                stop("Arguments are of different lengths.")
        }

        if (!all(rownames(colData_1) %in% rownames(colData_2))) {
                stop("Rownames of arguments could not be matched.")
        }

        new_order <- match(rownames(colData_1), rownames(colData_2))
        ordered_colData_2 <- colData_2[new_order, , drop = F]
        cbind(colData_1, ordered_colData_2)
}
