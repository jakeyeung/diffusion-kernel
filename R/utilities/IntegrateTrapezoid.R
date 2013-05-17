# Jake Yeung
# May 17 2013
# IntegrateTrapezoid.R


IntegrateTrapezoid <- function(influence_matrix, sortdecreasing=TRUE){
    integrated_influence_mat <- apply(influence_matrix, 1, function(x){
        x.sorted <- sort(x, decreasing=sortdecreasing)
        total_area <- 0    # initialize
        for(i in 1:(length(x)-1)){
            total_area <- total_area + GetAreaofTrapezoid(x.sorted[i], x.sorted[i+1], 1)
        }
        return(total_area)
    })
    # print(integrated_influence_mat)
    return(integrated_influence_mat)
}