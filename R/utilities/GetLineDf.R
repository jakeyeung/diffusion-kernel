# Jake Yeung
# May 17 2013
# GetLineDf.R


GetLineDf <- function(line_length){
    node1 <- seq(1, line_length-1)
    node2 <- seq(2, line_length)
    if (length(node1) == length(node2)) {
        line_df <- matrix(c(node1, node2), nrow=length(node1), ncol=2)
    }
    else{
        stop('node1 and node2 lengths are not equal')
    }
    return(line_df)
}