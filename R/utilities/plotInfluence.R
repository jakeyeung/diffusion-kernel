# Jake Yeung
# May 17 2013
# plotInfluence.R


plotInfluence <- function(influence_matrix, xlabel, ylabel, xmin, xmax, ymin, 
                          ymax, title, saveDir, saveFileName, sortdecreasing=TRUE){
    x11()
    
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
    legend('topright', inset=c(-0.28, 0), legend=xvector, 
           pch=1:length(colvector), col=plotcolorvector, title='Influence of Node')
    # legend(0.9*xmax, ymax, xvector, pch=1:length(colvector), col=plotcolorvector)
    
    dev.copy2pdf(file=file.path(saveDir, saveFileName))
}