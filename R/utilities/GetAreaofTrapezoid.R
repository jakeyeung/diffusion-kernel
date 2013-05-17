# Jake Yeung
# May 17 2013
# GetAreaofTrapezoid.R


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