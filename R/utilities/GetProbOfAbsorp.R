# Jake Yeung
# May 17 2013
# GetProbOfAbsorp.R


GetProbOfAbsorp  <- function(L, initial.node,  halt.node, end.node){
    # Calculate probability of absorption by node a
    # before absorption by node b, starting at node k (Eq. 5.2)
    # 
    # Args:
    # L: psuedo inverse of Laplacian matrix, obtained from GetPseudoInverse
    # end.node: 1st absorbing state, the desired end-point
    # halt.node: 2nd absorbing state the undesired or halt end-point
    # initial.node: initial node at which you start the random walk
    #
    # Returns: 
    # The probability of absorption by state a before absorption by state b,
    # when starting f rom state k. 
    ProbOfAbsorp <- (L[initial.node, end.node] - L[initial.node, halt.node] - 
                         L[end.node, halt.node] + L[halt.node, halt.node]) / 
        (L[end.node, end.node] + L[halt.node, halt.node] - 
             2 * L[end.node, halt.node])
    if(abs(ProbOfAbsorp) < 10^-9){
        #If ProbOfAbsorp is vanishingly small (or negative), round to zero.
        ProbOfAbsorp <- 0
    }
    return(ProbOfAbsorp)
}