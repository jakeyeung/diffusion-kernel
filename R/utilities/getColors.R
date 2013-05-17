# Jake Yeung
# May 17 2013
# GetColors.R


GetColors <- function(plot.it=F,locate=0)
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