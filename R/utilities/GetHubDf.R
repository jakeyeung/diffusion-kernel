# Jake Yeung
# May 17 2013
# GetHubDf.R


GetHubDf <- function(total_neighbhours, start_node_name=1){
    node1 <- rep(start_node_name, (total_neighbhours-1))
    print(node1)
    node2 <- seq(start_node_name+1, (total_neighbhours-1)+start_node_name)
    print(node2)
    if (length(node1) == length(node2)) {
        hub_df <- matrix(c(node1, node2), nrow=length(node1), ncol=2)
    }
    else{
        stop('node1 and node2 lengths are not equal')
    }
    return(hub_df)
}