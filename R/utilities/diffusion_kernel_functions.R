# Jake Yeung
# May 15 2013
# diffusion_kernel_functions.R


# RandomWalkFunctions --------------------------------------------------------


GetPseudoInverseRandWalk  <- function(A, D){
    # Calculates pseudo inverse of the laplacian matrix (Eq. 5.1)
    # 
    # Args:
    # A: adjacency matrix of the network
    # D: diagonal matrix of the network
    #
    # Returns:
    # The pseudo inverse of the Laplacian matrix
    ones <- matrix(100, nrow = nrow(A), ncol = 1)
    some.factor <- as.numeric(t(ones) %*% ones / nrow(A))  # See equation 5.1
    PseudoL <- solve(((D - A) - some.factor)) + some.factor
    return(PseudoL)
}


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
    AvgCommuteTime <- sum(diag(D.hub)) * (L[initial.node, initial.node] + 
                                              L[end.node, end.node] - 2 * L[initial.node, end.node])
    if(abs(AvgCommuteTime) < 1){
        #Round down to zero if steps are less than 1
        AvgCommuteTime = 0
    }
    return(AvgCommuteTime)
}



# DiffusionModelFunctions -------------------------------------------------


SolveShiftedLaplacian <- function(A, D, gamma){
    I <- diag(nrow(A))
    L <- -(A - D - gamma*I)
    L_inv_shifted <- solve(L)
    return(L_inv_shifted)
}


GetSteadyStateDiffusion <- function(L_inv_shifted){
    length_of_matrix <- nrow(L_inv_shifted)
    influence_matrix <- matrix(0, ncol = length_of_matrix, nrow = length_of_matrix)
    for(i in 1:nrow(L_inv_shifted)){
        b <- matrix(0, ncol=1, nrow=length_of_matrix, byrow=TRUE)
        b[i] <- 1
        influence_matrix[i, ] <- as.vector(L_inv_shifted %*% b)
    }
    return(influence_matrix)
}


# iGraphFunctions ---------------------------------------------------------


GetGraphFromDF <- function(df){
    g <- graph.data.frame(df, directed=FALSE)
}


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



# AggregationFunctions ----------------------------------------------------


# PlotFunctions ----------------------------------------------------------

plotInfluence <- function(influence_matrix, xlabel, ylabel, xmin, xmax, ymin, 
                          ymax, title, sortdecreasing=TRUE){
    # Plot blank
    par(mar=c(5.1, 4.1, 4.1, 8.1), xpd=TRUE)    # Create extra space on right
    plot(1, type="n", xlab=xlabel, ylab=ylabel, xlim=c(xmin, xmax), 
         ylim=c(ymin, ymax), main=title)
    
    # Set plot vectors
    xvector <- seq(1, nrow(influence_matrix))
    colvector <- palette()[2:length(palette())]
    plotcolorvector = rep(NA, length(xvector))
    
    # Plot in loop
    for(i in 1:nrow(influence_matrix)){
        paletteindex <- i - (i%/%length(colvector)) * (length(colvector)-1)
        shadeindex <- length(colvector) - (i %/% length(colvector) + 1)
        plotcolor <- colors()[grep(colvector[paletteindex], colors())][shadeindex]
        points(xvector, sort(influence_matrix[i, ], decreasing=sortdecreasing),
               type='b', pch=i, 
               col=plotcolor)
        plotcolorvector[i] = plotcolor
    }
    legend('topright', inset=c(-0.2, 0), legend=xvector, 
           pch=1:length(colvector), col=plotcolorvector, title='Influence of Node')
    # legend(0.9*xmax, ymax, xvector, pch=1:length(colvector), col=plotcolorvector)
    
}


getColors <- function(plot.it=F,locate=0)
{
    if(!plot.it)
    {
        return(.Internal(colors())) # so far, not different from colors()
    } # close on if
    else
    {
        ytop    <- rep(seq(1/26,1,by=1/26),each=26)[1:657]
        ybottom <- rep(seq(0,1-1/26,by=1/26),each=26)[1:657]
        xleft   <- rep(seq(0,1-1/26,by=1/26),times=26)[1:657]
        xright  <- rep(seq(1/26,1,by=1/26),times=26)[1:657]
        pall    <- round(col2rgb(colors())/256)
        pall    <- colSums(pall) ; pall2 <- character(0)
        pall2[pall>0]   <- "black"
        pall2[pall==0]  <- "white"
        
        par(mar=c(0,0,1,0))
        
        plot.new()
        title(main="Palette of colors()")
        rect(xleft,ybottom,xright,ytop,col=colors())
        text(x=xleft+((1/26)/2)
             ,y=ytop-((1/26)/2)
             ,labels = 1:657
             ,cex=0.55
             ,col=pall2)
        
    } # close on else
    if(locate==0) print("Palette of colors()")
    else
    {
        colmat    <- matrix(c(1:657,rep(NA,26^2-657)),byrow=T,ncol=26,nrow=26)
        cols        <- NA
        i        <- NA
        for(i in 1:locate)
        {
            h    <- locator(1)
            if(any(h$x<0,h$y<0,h$x>1,h$y>1)) stop("locator out of bounds!")
            else
            {
                cc        <- floor(h$x/(1/26))+1
                rr        <- floor(h$y/(1/26))+1            
                cols[i]    <- .Internal(colors())[colmat[rr,cc]]
            } # close on else
        } # close on i
        return(cols)
    } # close on else
} # close on else+function



# InfluenceAnalysisFunctions ----------------------------------------------


GetAreaofTrapezoid <- function(a, b, c){
    # Calculate area of trapezoid.
    # Assumes trapezoid has one right angle to parallel sides
    # Arguments
    # a: Height of one side
    # b: height of other side
    # c: length of side that is 90 degrees from a and b. 
    area_trapezoid <- (c/2) * (b + a)
    return(area_trapezoid)
}


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


NormalizeInfluence <- function(influence_matrix){
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