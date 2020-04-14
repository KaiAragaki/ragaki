# ragaki

This is/will be a collection of functions that I'd rather not copy and paste
everywhere in my code. It's also a great learning/suffering experience.

When you undoubtable find an edge case I didn't think of that isn't covered,
please open an issue post. 

## quick_heatmap
In brief, takes:
1. A `dds` object with normalized counts as its second assay
2. A list of genes (or if none supplied, uses all)
3. Variables on which to stratify/annotate the heatmap with (this must be a column name from `colData(dds)`)

Then generates a heatmap

### Future directions
1. Allow for subsetting by `colData` `colname`
2. Allow for passing arguments to pheatmap
