\name{OptimalNoBins}
\alias{OptimalNoBins}

\title{ Optimal Number Of Bins }
\description{
  Calculation of the optimal number of bins for a histogram.
}
\usage{
OptimalNoBins(Data)
}

\arguments{
  \item{Data}{Data}
}
\note{
  OptimalNoBins() is a kernel density estimation for fixed intervals.
}
\value{
  \item{optNrOfBins}{The best possible number of bins. Not less than 10 though}
}
\references{  
David W. Scott Jerome P. Keating: A Primer on Density Estimation for the Great Home Run Race of 98, STATS 25, 1999, pp 16-22.
}
\author{Alfred Ultsch, Michael Thrun}
\details{The bin width ist defined with bw=3.49*stdrobust(1/(n)^1/3)}

\examples{ 
 Data = c(rnorm(1000),rnorm(2000)+2,rnorm(1000)*2-1)
 optNrOfBins = OptimalNoBins(Data)
 minData = min(Data,na.rm = TRUE)
 maxData = max(Data,na.rm = TRUE)
 i = maxData-minData
 optBreaks = seq(minData, maxData, i/optNrOfBins) # bins in fixed intervals
 hist(Data, breaks=optBreaks)
}
\seealso{\code{\link{ParetoRadius}}}
\keyword{ histogram }
\keyword{ bins }
\keyword{kernel density estimation}