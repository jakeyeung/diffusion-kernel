# Jake Yeung
# May 17 2013
# SolveShiftedLaplacian.R


SolveShiftedLaplacian <- function(A, D, gamma){
    I <- diag(nrow(A))
    L <- -(A - D - gamma*I)
    L_inv_shifted <- solve(L)
    return(L_inv_shifted)
}