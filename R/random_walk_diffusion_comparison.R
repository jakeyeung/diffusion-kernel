# Jake Yeung
# May 8 2013
# random_walk_diffusion_comparison.R
# Compare random walk with diffusion. Toy example. 



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
source(file=file.path(sourceDir, 'GetSteadyStateDiffusion.R'))

# Random Walk Functions
source(file=file.path(sourceDir, 'GetPseudoInverseRandomWalk.R'))
source(file=file.path(sourceDir, 'GetAvgFirstPassageTime.R'))
source(file=file.path(sourceDir, 'GetAvgCommuteTime.R'))

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


# InitializeGraph ---------------------------------------------------------


df_line <- GetLineDf(line_length)
df_hub <- GetHubDf(hub_size, line_length)
df_scorpion <- rbind(df_line, df_hub)

g <- GetGraphFromDf(df_scorpion)
plot(g)
A <- get.adjacency(g)    # Adjacency matrix
L <- graph.laplacian(g)    # Laplacian matrix
D <- diag(diag(L))    # Diagonal matrix



# DiffusionModel ----------------------------------------------------------

L_inv_shifted <- SolveShiftedLaplacian(A, D, gamma)

starttime <- proc.time()
influence_matrix_diffusion <- GetSteadyStateDiffusion(L_inv_shifted, 
                                                      remove_diags=TRUE)
print(proc.time() - starttime)


# RandomWalkModel ---------------------------------------------------------

L_inv_pseudo <- GetPseudoInverseRandWalk(A, D)

influence_matrix_randwalk <- diag(0, nrow=nrow(L_inv_pseudo))    # Initialize

starttime <- proc.time()
for(i in 1:nrow(L_inv_pseudo)){
  for(j in 1:nrow(L_inv_pseudo)){
#     influence_matrix_randwalk[i, j] <- GetAvgFirstPassageTime(D,
#                                                               L_inv_pseudo,
#                                                               i,
#                                                               j)
    influence_matrix_randwalk[i, j] <- GetAvgCommuteTime(D,
                                                          L_inv_pseudo,
                                                          i,
                                                          j)
  }
  print(c('All random walk times computed for node ', i))
}
print(proc.time() - starttime)


# TotalInfluenceMatrix ------------------------------------------------

sum_diffusion_matrix <- rowSums(influence_matrix_diffusion)

sum_randwalk_matrix <- rowSums(influence_matrix_randwalk)


# CalculateNormalizedDiffusionInfluence -----------------------------------

influence_matrix_diffusion.norm <- NormalizeInfluence(influence_matrix_diffusion)


# PlotDiffusionResults ----------------------------------------------------

# Plot parameters: diffusion
xlabel='Ranked node'
ylabel='Influence'
xmin <- 0
xmax <- nrow(influence_matrix_diffusion)
ymin <- 0
ymax <- max(influence_matrix_diffusion)*1.2
title <- 'Diffusion Influence Graph'

plotInfluence(influence_matrix_diffusion, xlabel, ylabel, xmin, xmax, ymin, 
              ymax, title, saveDir=plotDir, 
              saveFileName='diffusion_influence_graph.pdf', 
              sortdecreasing=TRUE)


# PlotRandomWalkInfluenceGraph --------------------------------------------

# Plot parameters: random walk
xlabel='Ranked node'
ylabel='Average Passage Time'
xmin <- 0
xmax <- nrow(influence_matrix_randwalk)
ymin <- 0
ymax <- max(influence_matrix_randwalk)*1.2
title <- 'Random Walk Influence Graph'

plotInfluence(influence_matrix_randwalk, xlabel, ylabel, xmin, xmax, ymin, 
              ymax, title, 
              saveDir=plotDir,
              saveFileName='randomwalk_influence_graph.pdf',
              sortdecreasing=FALSE)


# PlotSumsofInfluence -----------------------------------------------------

x11()
barplot(sum_diffusion_matrix, names.arg=rownames(L), xlab='node', 
        ylab='total_influence', 
        main='Total influence of each node: diffusion model')
dev.copy2pdf(file=file.path(plotDir, 'total_influence_diffusion_model.pdf'))

x11()
barplot(sum_randwalk_matrix, names.arg=rownames(L), xlab='node', 
        ylab='total_influence', 
        main='Total influence of each node: random walk model')
dev.copy2pdf(file=file.path(plotDir, 'total_influence_randomwalk_model.pdf'))



# PlotNormalizedInfluence -------------------------------------------------

xlabel='Ranked node'
ylabel='Normalized Influence'
xmin <- 0
xmax <- nrow(influence_matrix_diffusion.norm)
ymin <- 0
ymax <- max(influence_matrix_diffusion.norm)*1.2
title <- 'Diffusion Influence Graph: Normalized by Total Influence'

plotInfluence(influence_matrix_diffusion.norm, xlabel, ylabel, xmin, xmax, ymin, 
              ymax, title, 
              saveDir=plotDir,
              saveFileName='diffusion_normalized_influence_graph.pdf',
              sortdecreasing=TRUE)

x11()
barplot(rowSums(influence_matrix_diffusion.norm), names.arg=rownames(L), xlab='node', 
        ylab='total normalized influence', main='Total normalized influence of each node: diffusion model')
dev.copy2pdf(file=file.path(plotDir, 'total_normalized_influence_diffusion.pdf'))
