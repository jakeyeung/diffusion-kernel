# Jake Yeung
# May 17 2013
# GetPseudoInverseRandomWalk.R

GetPseudoInverseRandWalk  <- function(A, D){
    # Calculates pseudo inverse of the laplacian matrix (Eq. 5.1)
    # 
    # Args:
    # A: adjacency matrix of the network
    # D: diagonal matrix of the network
    #
    # Returns:
    # The pseudo inverse of the Laplacian matrix
    ones <- matrix(100, nrow = nrow(A), ncol = 1)
    some.factor <- as.numeric(t(ones) %*% ones / nrow(A))  # See equation 5.1
    PseudoL <- solve(((D - A) - some.factor)) + some.factor
    return(PseudoL)
}