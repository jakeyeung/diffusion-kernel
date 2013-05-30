# Jake Yeung
# May 24 2013
# rearrange_two_influence_graphs.R
# Keep only proteins that are common, order columns and rows so
# they are identical.



# LoadLibraries -----------------------------------------------------------

# library(venneuler)
# to install use command:
# install.packages('venneuler')

# CommandArgs -------------------------------------------------------------

args <- commandArgs(trailingOnly=TRUE)

if (length(args)==4){
    influence_filename1 <- args[1]
    influence_filename2 <- args[2]
    influence_output_fname1 <- args[3]
    influence_output_fname2 <- args[4]
} else{
    print('Using predefined arguments instead...')
    influence_filename1 <- 'hprd_full_table3.txt'
    influence_filename2 <- 'HPRD_InfluenceGraph_HotNet.txt'
    influence_output_fname1 <- 'hprd_full_table_uniques.txt'
    influence_output_fname2 <- 'hotnet_full_table_uniques.txt'
}


# DefineDirectories -------------------------------------------------------

fileDir <- getwd()    # /diffusion-kernel/R/
sourceDir <- file.path(fileDir, 'utilities')
baseDir <- dirname(dirname(dirname(fileDir)))    # /random_walk_diffusion
plotDir <- file.path(baseDir, 'output', 'hprd', 'plot_outputs')
textDir <- file.path(baseDir, 'output', 'hprd', 'text_outputs')
hprdDir <- file.path(baseDir, 'input', 'hprd_data')


# DefineConstants ---------------------------------------------------------

gene_list1_name <- 'jake_hprd'
gene_list2_name <- 'hotnet_hrpd'
uncommon_gene_table_fname1 <- 'unique_genes_in_HPRD_compared_to_HotNet.txt'
uncommon_gene_table_fname2 <- 'unique_genes_in_HotNet_compared_to_HPRD.txt'
df1_unique_gene_colname <- 'unique_genes_in_jhprd_vs_hotnethprd'
df2_unique_gene_colname <- 'unique_genes_in_hotnethprd_vs_jhprd'


# DefineFunctions ---------------------------------------------------------

jpeek <- function(df){
    print(df[1:5, 1:5])
}

# source(file.path(sourceDir, 'PlotVennDiagram.R'))


# ReadFiles ---------------------------------------------------------------

# Read influence file that was output from get_influence_from_network.R
influence_table1 <- read.table(file.path(textDir, influence_filename1), 
                               header=TRUE, sep='\t')
# Read influenec file that was output by hotnet (requires row.names=1)
influence_table2 <- read.table(file.path(textDir, influence_filename2), 
                               header=TRUE, sep='\t', row.names=1)

# Peak
jpeek(influence_table1)
jpeek(influence_table2)



# DefineColnames -------------------------------------------------------

gene_names1 <- colnames(influence_table1)
gene_names2 <- colnames(influence_table2)

# FindUncommonColumns -------------------------------------------------------

uncommon_genes1.index <- which(!gene_names1 %in% gene_names2)
uncommon_genes2.index <- which(!gene_names2 %in% gene_names1)


# WriteUncommonGenesIntoTable ---------------------------------------------

# Names of uncommon genes
uncommon_genes1.names <- gene_names1[uncommon_genes1.index]
uncommon_genes2.names <- gene_names1[uncommon_genes2.index]

# Write to table
df1 = data.frame(df1_unique_gene_colname = uncommon_genes1.names)
df2 = data.frame(df2_unique_gene_colname = uncommon_genes2.names)

write.table(df1, file=file.path(textDir, uncommon_gene_table_fname1), 
            quote=FALSE, sep='\t', 
            row.names=FALSE, col.names=TRUE)
write.table(df2, file=file.path(textDir, uncommon_gene_table_fname2), 
            quote=FALSE, sep='\t', 
            row.names=FALSE, col.names=TRUE)


# ReorderInfluencesByCommonGene -------------------------------------------

common_genes1_index <- which(gene_names1 %in% gene_names2)
common_genes2_index <- which(gene_names2 %in% gene_names1)

# Find names of the common genes, use gene1list, doesn't matter
common_gene_names <- gene_names1[common_genes1_index]

# Reorder influence matrices
# By row and columns
influence_table1.common <- influence_table1[common_gene_names, common_gene_names]
influence_table2.common <- influence_table2[common_gene_names, common_gene_names]


# WriteReorderedMatrices --------------------------------------------------

write.table(influence_table1.common, file=file.path(textDir, influence_output_fname1),
            quote=FALSE, sep='\t', row.names=TRUE, col.names=TRUE)
write.table(influence_table2.common, file=file.path(textDir, influence_output_fname2),
            quote=FALSE, sep='\t', row.names=TRUE, col.names=TRUE)







