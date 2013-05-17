# Jake Yeung
# May 17 2013
# GetSteadyStateDiffusion.R


GetSteadyStateDiffusion <- function(L_inv_shifted, remove_diags=TRUE){
    length_of_matrix <- nrow(L_inv_shifted)
    influence_matrix <- matrix(0, ncol = length_of_matrix, nrow = length_of_matrix)
    for(i in 1:nrow(L_inv_shifted)){
        b <- matrix(0, ncol=1, nrow=length_of_matrix, byrow=TRUE)
        b[i] <- 1
        influence_matrix[i, ] <- as.vector(L_inv_shifted %*% b)
    }
    if (remove_diags==TRUE){
        diag(influence_matrix) <- 0
    }
    return(influence_matrix)
}