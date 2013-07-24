# Jake Yeung
# get_shortest_path_from_two_gene_lists.R
# July 22 2013
#
# Usage: Rscript get_shortest_path_from_two_gene_lists.R [outlier_genes_fullpath] [aberrant_genes_fullpath] [ppi_network_fullpath] [output_fullpath]
# Where outlier_genes, aberrant_genes, ppi_network all contain headers as first row (doesn't matter name of header).


# Import Libraries --------------------------------------------------------

library(igraph)


# Read Command Arguments --------------------------------------------------

args <- commandArgs(TRUE)
outlier_gene_filename <- args[1]
aberrant_gene_filename <- args[2]
ppi_network_filename <- args[3]
pathlength_output_filename <- args[4]
pathnames_output_filename <- args[5]


# Load Gene Lists ---------------------------------------------------------

outlier_genes <- read.table(outlier_gene_filename, 
                         header=TRUE, sep='\t')
aberrant_genes <- read.table(aberrant_gene_filename,
                         header=TRUE, sep='\t')
ppi_network <- read.table(ppi_network_filename,
                          header=TRUE, sep='\t')


# Load PPI to IGraph Object ------------------------------------------------------

g <- graph.data.frame(ppi_network, directed=FALSE)


# Subset Genes in PPI Network --------------------------------------------

outlier_genes_subset <- outlier_genes[which(outlier_genes[, 1] %in% V(g)$name), ]
aberrant_genes_subset <- aberrant_genes[which(aberrant_genes[, 1] %in% V(g)$name), ]

outlier_nodes <- V(g)[which(V(g)$name %in% outlier_genes[, 1])]
aberrant_nodes <- V(g)[which(V(g)$name %in% aberrant_genes[, 1])]


# Calculate Shortest Path -------------------------------------------------

# Length
# print('Calculating shortest path lengths...')
# shortest_path_lengths <- shortest.paths(g, v=aberrant_nodes, 
#                                        to=outlier_nodes)
# write.table(shortest_path_lengths, file=pathlength_output_filename, 
#             quote=FALSE, row.names=TRUE, col.names=TRUE)
# rm(shortest_path_lengths)    # Dump

# Node names
print('Getting short path nodes...')

# shortest_path_names_matrix <- matrix(data=NA, nrow=length(aberrant_nodes), 
#                                      ncol=length(outlier_nodes), 
#                                      dimnames=list(aberrant_nodes$name,
#                                                    outlier_nodes$name))

count = 0
fileConn <- file(pathnames_output_filename, 'w')
for(rname in aberrant_nodes$name){
    count <- count + 1
    print(paste0(count, ' of ', length(aberrant_nodes)))
    shortest_path_index_list <- get.shortest.paths(g, rname, 
                                                 outlier_nodes$name)
    shortest_path_names_list <- lapply(shortest_path_index_list, function(x){
        gene_names_list <- paste0(V(g)[x]$name, collapse=';')
        return(gene_names_list)
    })
    # print(paste0(shortest_path_names_list, collapse='\t'))
    writeLines(paste0(shortest_path_names_list, collapse='\t'), con=fileConn, sep='\n')
    # print(as.vector(unlist(shortest_path_names_list)))
    
    # write.table(as.vector(unlist(shortest_path_index_list)), file=pathnames_output_filename, 
    #             row.names=FALSE, col.names=FALSE, append=TRUE, sep='\t')
    # writeLines(as.matrix(unlist(shortest_path_names_list)), con=fileConn)
    # writeLines('', con=fileConn, sep='\n')
}
close(fileConn)

# plot(density(shortest_path_lengths), xlab='Shortest Path Length', main='Distribution of shortest path lengths')

