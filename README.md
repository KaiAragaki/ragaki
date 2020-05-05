# ragaki

This is/will be a collection of functions that I'd rather not copy and paste
everywhere in my code. It's also a great learning/suffering experience.

When you undoubtably find an edge case I didn't think of, please open an issue post. 

## quick_heatmap
In brief, takes:
1. A `dds` object with normalized counts as its second assay
2. A list of genes (or if none supplied, uses all)
3. Variables on which to stratify/annotate the heatmap with (this must be a column name from `colData(dds)`

...then generates a heatmap

### Future directions
1. Allow for subsetting by `colData` `colname`
2. Allow for passing arguments to pheatmap

## cbind_colData
Takes two dataframes, or a dataframe and a `SummarizedExperiment`, and joins them with one another, matching by their rownames.

Plays nice with `DESeq2`'s `dds` objects and the like because it does *not* use the tidyverse.

### Future directions
1. Implement the tidyverse! I would much prefer to use all the trappings of dplyr et al than have to work with my own implementation. Perhaps a thin wrapper of some sort? 
