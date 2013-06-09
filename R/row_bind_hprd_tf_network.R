# Jake Yeung
# May 30 2013
# row_bind_hprd_tf_network.R
# Merge HPRD with TF network.

# SetCommandArgs ----------------------------------------------------------

args <- commandArgs(trailingOnly=TRUE)
network1 <- args[1]
# network1 <- 'hprd_data/HPRD_noNA.txt'
network2 <- args[2]
# network2 <- 'tf_target/combined_tf_targets.txt'
output_fname <- args[3]
# output_fname <- 'merged_data/merged_ppi.txt'


# SetDirectories ----------------------------------------------------------

fileDir <- getwd()    # /diffusion-kernel/R/
sourceDir <- file.path(fileDir, 'utilities')
baseDir <- dirname(dirname(dirname(fileDir)))    # /random_walk_diffusion
inputDir <- file.path(baseDir, 'input')


# SourceFunctions ---------------------------------------------------------


# ReadTable ---------------------------------------------------------------

network1 <- read.table(file.path(inputDir, network1), 
                      sep="\t", header=TRUE,  stringsAsFactors=FALSE, 
                      na.strings = "null")

network2 <- read.table(file.path(inputDir, network2), header=FALSE,  stringsAsFactors=FALSE)



# Rowbind_Columns -----------------------------------------------------------

merged_network <- rbind(network1, network2)


# WriteTable --------------------------------------------------------------

write.table(merged_network, file.path(inputDir, output_fname), quote=FALSE,
            sep='\t', row.names=FALSE, col.names=TRUE)



