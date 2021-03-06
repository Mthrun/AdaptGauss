\name{EMGauss}
\alias{EMGauss}

\title{EM Algorithm for GMM}
\description{
Expectation-Maximization algorithm to calculate optimal Gaussian Mixture Model for given data in one Dimension.
}
\usage{
EMGauss(Data, K, Means, SDs,Weights, MaxNumberofIterations,fast)
}

\arguments{
  \item{Data}{vector of data points}
  \item{K}{estimated amount of Gaussian Kernels}
  \item{Means}{vector(1:L), Means of Gaussians,  L ==  Number of Gaussians}
  \item{SDs}{estimated Gaussian Kernels = standard deviations}
  \item{Weights}{optional, relative number of points in Gaussians (prior probabilities): 
                                  sum(Weights) ==1, default weight is 1/L}
  \item{MaxNumberofIterations}{Optional, Number of Iterations; default=10}
	\item{fast}{Default: FALSE: Using mclust's EM see function \code{densityMclust} of that package, TRUE: Naive but faster EM implementation, which may be numerical unstable, because log(gauss) is not used}
}
\details{
  No adding or removing of Gaussian kernels. Number of Gaussian hast to be set by the length of the vector of Means, SDs and Weights.
	This EM is only for univariate data. For multivariate data see package \code{mclust}
}
\value{
List with
  \item{Means}{means of GMM generated by EM algorithm}
  \item{SDs}{standard deviations of GMM generated by EM algorithm}
  \item{Weights}{prior probabilities of Gaussians}
}

\references{
Bishop, Christopher M. Pattern recognition and machine learning. springer, 2006, p 435 ff
}
\author{Onno Hansen-Goos, Michael Thrun, Florian Lerch}
\seealso{\code{\link{AdaptGauss}}}

\keyword{Expectation-Maximization}
\keyword{EM}
\keyword{Expectation}
\keyword{Maximization}
\keyword{EM algorithm}
\keyword{Expectation-Maximization algorithm}