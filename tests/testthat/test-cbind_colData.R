test_that("arguments are compatible", {
        normal_df        <- data.frame(x = 1:10, row.names = LETTERS[1:10])
        diff_rownames_df <- data.frame(y = 11:20, row.names = LETTERS[7:16])
        too_short_df     <- data.frame(y = 1:9, row.names = LETTERS[1:9])
        too_long_df      <- data.frame(y = 1:11, row.names = LETTERS[1:11])
        same_colname_df  <- data.frame(x = 11:20, row.names = LETTERS[1:10])
        expect_error(cbind_colData(normal_df, diff_rownames_df), "Rownames of arguments could not be matched.")
        expect_error(cbind_colData(normal_df, too_short_df), "Arguments are of different lengths.")
        expect_error(cbind_colData(normal_df, too_long_df), "Arguments are of different lengths.")
        expect_error(cbind_colData(normal_df, same_colname_df), "Column names are not unique.")
})

test_that("binding works", {
        normal_df        <- data.frame(x = 1:10, row.names = LETTERS[1:10])
        scrambled_df     <- data.frame(y = 11:20, row.names = c("J", "E", "C", "H", "A", "D", "F", "I", "G", "B"))
        combined_df      <- data.frame(x = 1:10, y = c(15, 20, 13, 16, 12, 17, 19, 14, 18, 11), row.names = LETTERS[1:10])
        expect_equal(cbind_colData(normal_df, scrambled_df), combined_df)
})

