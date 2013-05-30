# Jake Yeung
# May 29 2013
# truncated_vs_full_diffusion.R

# SetDirectories ----------------------------------------------------------


# Assumes current directory is source directory
fileDir <- getwd()    # /diffusion-kernel/R/
sourceDir <- file.path(fileDir, 'utilities')
baseDir <- dirname(dirname(dirname(fileDir)))    # /random_walk_diffusion
plotDir <- file.path(baseDir, 'output', 'toy_graphs')


# LoadLibraries ----------------------------------------------------------


library(igraph)


# SourceFiles -------------------------------------------------------------


# iGraph Functions
source(file=file.path(sourceDir, 'GetGraphFromDf.R'))
source(file=file.path(sourceDir, 'GetLineDf.R'))
source(file=file.path(sourceDir, 'GetHubDf.R'))

# Diffuion Kernel Functions
source(file=file.path(sourceDir, 'SolveShiftedLaplacian.R'))
source(file=file.path(sourceDir, 'power_series_expansion.R'))
source(file=file.path(sourceDir, 'GetSteadyStateDiffusion.R'))


# Plot Functions
source(file=file.path(sourceDir, 'plotInfluence.R'))

# Analysis Functions
source(file=file.path(sourceDir, 'NormalizeInfluence.R'))

# Set constants -----------------------------------------------------------

# Toy graph parameters
line_length <- 4    # Minimum must be 2. 
if (line_length < 2){
    warning('Warning, line length should be greater than or equal to 2.')
}
hub_size <- 8
if (hub_size<2){
    warning('Warning, hub size should be greater than or equal to 2.')
}
gamma <- 1    # Rate of "sink" in each node for diffusion model.

set.seed(1)    # Random weights


# InitializeGraph ---------------------------------------------------------


df_line <- GetLineDf(line_length)
df_hub <- GetHubDf(hub_size, line_length)
df_scorpion <- rbind(df_line, df_hub)
colnames(df_scorpion) <- c('V1', 'V2')


# AddWeights --------------------------------------------------------------

weight <- runif(nrow(df_scorpion))
weights_hub <- runif(nrow(df_hub))
# weights_hub <- rep(1, nrow(df_hub))
df_scorpion <- cbind(df_scorpion, weight)
df_hub <- cbind(df_hub, weights_hub)
colnames(df_hub) <- c('V1', 'V2', 'weight')
df_hub[, 1] <- df_hub[, 1] - 3
df_hub[, 2] <- df_hub[, 2] - 3

g <- graph.data.frame(data.frame(df_scorpion), directed=FALSE, vertices=NULL)
# g <- graph.data.frame(data.frame(df_hub), directed=FALSE, vertices=NULL)

# g <- GetGraphFromDf(df_scorpion)
plot(g, edge.width=E(g)$weight*10)


A <- get.adjacency(g, attr='weight')    # Adjacency matrix
L <- graph.laplacian(g, weights=E(g)$weights)    # Laplacian matrix
D <- diag(diag(L))    # Diagonal matrix



# CalculateExactL ---------------------------------------------------------

Linv <- SolveShiftedLaplacian(A, D, gamma)
influence_matrix_diffusion <- GetSteadyStateDiffusion(Linv, 
                                                      remove_diags=FALSE)


# CalculateApproximateL ---------------------------------------------------

Linv_approx <- power_series_expansion(A, D, gamma, 10)
influence_matrix_diffusion_approx <- GetSteadyStateDiffusion(Linv_approx, 
                                                             remove_diags=TRUE)


# PlotResults -------------------------------------------------------------

# Plot parameters: diffusion
xlabel='Ranked node'
ylabel='Influence'
xmin <- 0
xmax <- nrow(influence_matrix_diffusion)
ymin <- 0
ymax <- max(influence_matrix_diffusion)*1.2
title <- 'Diffusion Influence Graph: Linv Exact'

plotInfluence(influence_matrix_diffusion, xlabel, ylabel, xmin, xmax, ymin, 
              ymax, title, saveDir=plotDir, 
              saveFileName='diffusion_influence_graph_test1.pdf', 
              sortdecreasing=TRUE)

# Plot parameters: diffusion
xlabel='Ranked node'
ylabel='Influence'
xmin <- 0
xmax <- nrow(influence_matrix_diffusion)
ymin <- 0
ymax <- max(influence_matrix_diffusion)*1.2
title <- 'Diffusion Influence Graph: Linv Approx'

plotInfluence(influence_matrix_diffusion_approx, xlabel, ylabel, xmin, xmax, ymin, 
              ymax, title, saveDir=plotDir, 
              saveFileName='diffusion_influence_graph_test2.pdf', 
              sortdecreasing=TRUE)

