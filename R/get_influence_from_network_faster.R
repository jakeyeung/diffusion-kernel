# Jake Yeung
# June 08 2013
# get_influence_from_network_faster.R
# Faster way than get_influence_from_network.R to get diffusion network.

# SetCommandArgs ----------------------------------------------------------

args <- commandArgs(trailingOnly=TRUE)
filename <- args[1]
# Filename is stored in /input/
diff_full_table_fname <- args[2]
diff_total_fname <- args[3]
influence_degree_plot_fname <- args[4]

# LoadLibraries -----------------------------------------------------------

library(igraph)
library(ggplot2)

# SetDirectories ----------------------------------------------------------

fileDir <- getwd()    # /diffusion-kernel/R/
sourceDir <- file.path(fileDir, 'utilities')
baseDir <- dirname(dirname(dirname(fileDir)))    # /random_walk_diffusion
plotDir <- file.path(baseDir, 'output', 'hprd', 'plot_outputs')
textDir <- file.path(baseDir, 'output', 'hprd', 'text_outputs')
inputfileDir <- file.path(baseDir, 'input')

# SourceFunctions ---------------------------------------------------------

source(file.path(sourceDir, 'GetGraphFromDf.R'))
source(file.path(sourceDir, 'invert_shifted_laplacian2.R'))

# Set constants -----------------------------------------------------------

gamma <- 1    # Rate of "sink" in each node for diffusion model.

# ReadTable ---------------------------------------------------------------

network <- read.table(file.path(inputfileDir, filename), 
                      sep="\t", header=TRUE,  stringsAsFactors=FALSE, 
                      na.strings = "null")

# CleanNetworkData --------------------------------------------------------

g <- GetGraphFromDf(df=network, remove_isolated_nodes=TRUE)

summary(g)

# ObtainMatrixInfo --------------------------------------------------------

L <- graph.laplacian(g)    # Laplacian matrix


# Solve inverse of shifted Laplacian. -----------------------------------

L_shifted_inv <- invert_shifted_laplacian2(L, gamma, remove_diags=TRUE, 
                                           keep_colnames=TRUE)

# SaveDiffusionInfluence --------------------------------------------------

write.table(signif(L_shifted_inv, 3), 
            file=file.path(textDir, diff_full_table_fname), sep='\t')