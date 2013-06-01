# Jake Yeung
# May 17 2013
# GetAvgCommuteTime.R


GetAvgCommuteTime <- function(D, L, initial.node, end.node){
    # Calculate average commute time (Eq 5.6)
    # 
    # Args:
    # D: diagonal matrix used to calculate pseudoinverse
    # L: psuedo inverse of Laplacian matrix, obtained from GetPseudoInverse
    # initial.node: initial starting node
    # end.node: destination node
    # 
    # Returns:
    # AvgCommuteTime: defined as average number of steps that a random walker,
    # starting in node i, will take to enter node k for the first time and
    # go back to node i.
    AvgCommuteTime <- sum(diag(D)) * (L[initial.node, initial.node] + 
                                      L[end.node, end.node] - 2 * L[initial.node, end.node])
    if(abs(AvgCommuteTime) < 1){
        #Round down to zero if steps are less than 1
        AvgCommuteTime = 0
    }
    return(AvgCommuteTime)
}
