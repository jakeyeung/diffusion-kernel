# Jake Yeung
# June 8 2013
# invert_shifted_laplacian2.R
# More efficient way to invert shifted laplacian than SolveShiftedLaplacian.R

invert_shifted_laplacian2 <- function(L, gamma, remove_diags=FALSE, 
                                      keep_colnames=TRUE){
    # L is laplacian of the network (graph.laplacian(g) from igraph)
    L_shifted_inverse <- solve(-(-L - gamma*diag(nrow(L))))
    if (remove_diags==TRUE){
        diag(L_shifted_inverse) <- 0
    }
    if (keep_colnames==TRUE){
        # Add colnames
        colnames(L_shifted_inverse) <- colnames(L)
        rownames(L_shifted_inverse) <- rownames(L)
    }
    return(L_shifted_inverse)
}