# Jake Yeung
# May 24 2013
# VennDiagramTwoLists.R
# Plots diagram of two gene lists. 

PlotVennDiagram <- function(stringlist1, stringlist2, list1_name, list2_name){
    # Aggregate column names
    names_all <- list(stringlist1, stringlist2)
    names_sorted <- sort(unique(unlist(names_all)))
    
    # Make matrix of 0s
    MAT <- matrix(rep(0, length(names_sorted)*length(names_all)), ncol=2)
    colnames(MAT) <- c(list1_name, list2_name)
    rownames(MAT) <- names_sorted
    
    # Fill matrix
    lapply(seq_along(names_all), function(i){
        MAT[names_sorted %in% names_all[[i]], i] <<- table(names_all[[i]])
    })
    
    # Plot Venn Diagram
    v <- venneuler(MAT)
    plot(v)
}