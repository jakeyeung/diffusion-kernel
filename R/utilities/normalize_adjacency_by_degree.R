# Jake Yeung
# May 31 2013
# normalize_adjacency_by_degree.R
# Normalize adjacency matrix by node degree.

normalize_adjacency_by_degree <- function(A, D){
    for (i in 1:nrow(A)){
        for (j in 1:ncol(A)){
            if (A[i, j]==1){
                A[i, j] = A[i, j] / diag(D)[j]
            }
        }
    }
    return(A)
}
