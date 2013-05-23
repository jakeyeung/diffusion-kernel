# Jake Yeung
# May 22 2013
# label_propagation_algorithms.R
# Testing label propagation algorithms. 


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
source(file=file.path(sourceDir, 'GetLineDf.R'))
source(file=file.path(sourceDir, 'GetHubDf.R'))


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