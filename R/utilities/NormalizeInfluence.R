# Jake Yeung
# May 17 2013
# NormalizeInfluence.R


NormalizeInfluence <- function(influence_matrix){
    # Normalizes influence by dividing by inverse of 'total influence'
    total_influence <- apply(influence_matrix, 1, function(x){
        1 / sum(x)
    })
    influence_matrix.norm <- matrix(NA, nrow=nrow(influence_matrix), 
                                    ncol=ncol(influence_matrix))
    for (i in 1:nrow(influence_matrix)){
        for (j in 1:ncol(influence_matrix)){
            influence_matrix.norm[i, j] <- influence_matrix[i, j] / total_influence[i]
        }
    }
    return(influence_matrix.norm)
}