# Jake Yeung
# May 17 2013
# GetAvgFirstPassageTime.R


GetAvgFirstPassageTime <- function(D, L, initial.node, end.node){
    # Calculate average first passage time (Eq. 5.4)
    # Defined as the average number of steps that a random walker,
    # starting in node i, will take to enter node k for the first time.
    #
    # Args:
    # D: diagonal matrix used to calculate pseudoinverse
    # L: psuedo inverse of Laplacian matrix, obtained from GetPseudoInverse
    # initial.node: initial starting node at which you start random walk
    # end.node: destination node at which you stop your random walk
    #
    # Returns:
    # AvgFirstPassageTime: the average number of steps that a random walker,
    # starting in node i, will take to enter node k for the first time.
    AvgFirstPassageTime <- 0  #Initialize before putting into loop
    for(j in 1:nrow(L)){
        AvgFirstPassageTime <- AvgFirstPassageTime + 
            (L[initial.node, j] - L[initial.node, end.node] - 
                 L[end.node, j] + L[end.node, end.node]) * D[j, j]   
    }
    if(abs(AvgFirstPassageTime) < 10^-9){
        #Round down to zero if steps are less than 1
        AvgFirstPassageTime = 0
    }
    return(AvgFirstPassageTime)
}