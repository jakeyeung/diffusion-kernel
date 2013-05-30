# Jake Yeung

library(igraph)
library(ggplot2)

dir <- '/Data/jyeung/projects/random_walk_diffusion/output/hprd/text_outputs'
indir <- '/Data/jyeung/projects/random_walk_diffusion/input/hprd_data'
plotdir <- '/Data/jyeung/projects/random_walk_diffusion/output/hprd/plot_outputs/sanity_checks2'
fname <- 'hprd_full_table.txt'
genelist <- 'HPRD_noNA.txt'

df <- read.table(file.path(dir, fname), header=TRUE, sep='\t')

edgelist <- read.table(file.path(indir, genelist), header=TRUE, sep='\t')

g <- graph.data.frame(edgelist, directed=FALSE, vertices=NULL)

genelist = c('FOXC1', 'MORC4', 'CHRNA2', 'PEG10', 'SERPINA7', 'KY', 'GRB7', 'ERBB2')
genelist = c('SERPINA3', 'MUC4', 'MATK', 'PTEN', 'GRB7', 'ERBB2')
genelist = c('FOXC1', 'MORC4', 'CHRNA2', 'PEG10', 'SERPINA7', 'KY', 'GRB7', 'ERBB2')
genelist = c('CD44', 'JAK2', 'PIK3R2', 'IL6ST', 'JUP')
# genelist = c('FOXC1', 'MORC4', 'TP53', 'PTEN', 'CHRNA2', 'PEG10', 'SERPINA7', 'KY', 'GRB7', 'ERBB2')
genelist = c('SERPINA3', 'MUC4', 'MATK', 'PTEN', 'GRB7', 'ERBB2')
genelist = c('NRG2', 'MUC4')
for (gene in genelist){
rows_to_plot <- 40
df.subset <- subset(df, select=gene)

df.subset.ordered <- df.subset[order(df.subset[, gene], decreasing=TRUE), , drop=FALSE]

plotname = paste0(gene, '_igraphs_withdegrees.pdf')
print(file.path(plotdir, plotname))
pdf(file.path(plotdir, plotname), width=20, height=10)
plot(1:rows_to_plot, df.subset.ordered[1:rows_to_plot, ], xlab='Gene rank', ylab='Influence from gene')
ymax <- max(df.subset)
# Node degrees
# degree(g, rownames(df.subset.ordered)[1:rows_to_plot])
gene_names <- rownames(df.subset.ordered)[1:rows_to_plot]
i <- 0
for (gname in gene_names){
  i <- i + 1
  gene_names[i] <- paste(gname, degree(g, gname), sep='\n')
}
text(x=1:rows_to_plot, y=0.8*ymax, labels=gene_names, cex=0.5, main=paste(gene, 'influence on top', rows_to_plot, 'genes.'))
# Plot subgraph of gene
gene_neighbors <- neighborhood(g, 1, nodes=V(g)[gene])
gene_neighbors2 <- neighborhood(g, 2, nodes=V(g)[gene])
# gene_neighborhood <- V(g)[c(neighbors(g, gene), as.numeric(V(g)[gene]))]
# gene_neighborhood2 <- V(g)[neighbors(g, gene_neighborhood)]
sg1 <- induced.subgraph(g, vids=unlist(gene_neighbors))
sg2 <- induced.subgraph(g, vids=unlist(gene_neighbors2))
plot(sg1, main=paste(gene, 'Total Neighbors:', length(unlist(gene_neighbors))))
plot(sg2, layout=layout.fruchterman.reingold, main=paste(gene, 'Total Neighbors:', length(unlist(gene_neighbors2))))
# plot(sg1, main=paste(gene, 'Total Neighbors:', length(unlist(gene_neighbors))))
# plot(sg2, layout=layout.fruchterman.reingold, main=paste(gene, 'Total Neighbors:', length(unlist(gene_neighbors2))))
print(paste('Done for gene', gene))
dev.off()
}