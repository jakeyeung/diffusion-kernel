# Jake Yeung
# May 17 2013
# GetGraphFromDf.R


GetGraphFromDf <- function(df, remove_isolated_nodes=FALSE){
    g <- graph.data.frame(df, directed=FALSE)
    if (remove_isolated_nodes==FALSE){
        
    }
    else if (remove_isolated_nodes==TRUE){
        # Delete edges from the graph which has self loop
        g <- delete.edges(g, which(is.loop(g)))    
        
        # Deleting self-loops may create isolated vertices, remove these.
        # Delete vertices that are isolated
        g <- delete.vertices(g, which(degree(g) == 0))    
    }
    return(g)
}