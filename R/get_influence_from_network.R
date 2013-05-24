# Jake Yeung
# May 11 2013
# get_influence_hprd_network.R
# Uses diffusion model to analyze HPRD network
# Usage in commandline: 
# Rscript get_influence_hprd_network.R HPRD_network_filename.txt table_output_fname.txt influence_list.txt plotfname.pdf


# SetCommandArgs ----------------------------------------------------------

args <- commandArgs(trailingOnly=TRUE)
filename <- args[1]
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
hprdDir <- file.path(baseDir, 'input', 'hprd_data')


# SourceFunctions ---------------------------------------------------------

source(file.path(sourceDir, 'GetGraphFromDf.R'))
source(file.path(sourceDir, 'SolveShiftedLaplacian.R'))
source(file.path(sourceDir, 'GetSteadyStateDiffusion.R'))
source(file.path(sourceDir, 'NormalizeInfluence.R'))


# Set constants -----------------------------------------------------------

gamma <- 1    # Rate of "sink" in each node for diffusion model.

if (is.na(args[1]) == TRUE){
    filename <- 'HPRD_noNA.txt'
    print(paste('No argument specified, using', 
                filename, 'as network filename'))
} else{
    filename <- args[1]
}


# ReadTable ---------------------------------------------------------------

network <- read.table(file.path(hprdDir, filename), 
                      sep="\t", header=TRUE,  stringsAsFactors=FALSE, 
                      na.strings = "null", as.is=c("V1","V2"))


# CleanNetworkData --------------------------------------------------------

g <- GetGraphFromDf(df=network, remove_isolated_nodes=TRUE)

summary(g) # 9477 nodes, 53167 edges in hprd


# ObtainMatrixInfo --------------------------------------------------------

A <- get.adjacency(g)    # Adjacency matrix
L <- graph.laplacian(g)    # Laplacian matrix
D <- diag(diag(L))    # Diagonal matrix


# DiffusionKernel ---------------------------------------------------------


starttime <- proc.time()
# Solve diffusion kernel in two steps:
# 1: Solve shifted laplacian
# 2: Get steady state diffusion
L_inv_shifted <- SolveShiftedLaplacian(A, D, gamma)
influence_matrix_diffusion <- GetSteadyStateDiffusion(L_inv_shifted, 
                                                      remove_diags=TRUE)
print(proc.time() - starttime)

# Add colnames and rownames

colnames(influence_matrix_diffusion) <- colnames(A)
rownames(influence_matrix_diffusion) <- rownames(A)


# GetNormalizedInfluenceMatrix --------------------------------------------

influence_matrix_diffusion.norm <- NormalizeInfluence(influence_matrix_diffusion)


# TotalInfluenceMatrix ------------------------------------------------

sum_diffusion_matrix <- rowSums(influence_matrix_diffusion)
sum_diffusion_matrix.norm <- rowSums(influence_matrix_diffusion.norm)


# SaveDiffusionInfluence --------------------------------------------------

write.table(signif(influence_matrix_diffusion, 3), 
            file=file.path(textDir, diff_full_table_fname), sep='\t')

# write.table(signif(influence_matrix_diffusion.norm, 3), 
#             file=file.path(textDir, 'diffusion_influence_hprd.txt'), sep='\t')


# TotalInfluence -------------------------------------------------------------

sum_diff_mat_table <- as.data.frame(sum_diffusion_matrix)
colnames(sum_diff_mat_table) <- 'total_influence'

# sum_diff_mat_table.norm <- as.data.frame(sum_diffusion_matrix.norm)
# colnames(sum_diff_mat_table.norm) <- 'total_influence'
# write.table(sum_diff_mat_table.norm, 
#             file=file.path(textDir, 'total_influence.txt'), sep='\t')


# AddNodeDegreesToTable ------------------------------------------

sum_diff_mat_table <- cbind(sum_diff_mat_table, 'node_degree'=degree(g))
# sum_diff_mat_table.norm <- cbind(sum_diff_mat_table.norm, 
#                                  'node_degree'=degree(g))


# SaveTotalInfluenceNodeDegreeTable ---------------------------------------

write.table(sum_diff_mat_table, 
            file=file.path(textDir, diff_total_fname), sep='\t')

# PlotInfluencevsNodeDegree -----------------------------------------------

p <- qplot(node_degree, total_influence, data=sum_diff_mat_table, alpha=I(1/50), 
           xlab='Node Degree', ylab='Total Influence', 
           main='Total Influence vs Node Degree') + scale_x_log10()
ggsave(file=file.path(plotDir, influence_degree_plot_fname), plot=p)

# p <- qplot(node_degree, total_influence, data=sum_diff_mat_table, alpha=I(1/50), 
#            xlab='Node Degree', ylab='Normalized Total Influence', 
#            main='Normalized Total Influence vs Node Degree') + 
#         scale_x_log10()
# ggsave(file=file.path(plotDir, 'normalized_tot_inf_vs_node_degree.pdf'), plot=p)


