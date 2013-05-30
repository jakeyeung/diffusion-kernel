# Jake Yeung
# 29 may 2013
# power_series_expansion.R
# Use power series approximation to calculate G, the inverse of laplacian.

power_series_expansion <- function(A, D, gamma, iterations){
    # Calculate laplacian inverse using a power series approximation
    
    # Check dimensions are equal.
    if(all(dim(D) != dim(A))){
        stop('Dimensions of adjacency and diagonal matrix not equal.')
    }
    G0 <- solve(D + gamma * diag(nrow(D)))    # Should be trivial to calculate
    G <- G0    # Initialize
    prev_term <- G0
    for (i in 0:(iterations-1)){
        added_term <- prev_term %*% A %*% G0
        G <- G + added_term
        prev_term <- added_term
    }
    return(G)
}
