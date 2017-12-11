\name{BayesClassification}
\alias{BayesClassification}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
BayesClassification
}
\description{
Bayes Klassifikation den Daten zuordnen
}
\usage{
BayesClassification(Data,Means,SDs,Weights,

IsLogDistribution=Means*0,ClassLabels=c(1:length(Means)))
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Data}{vector of Data}
 \item{Means}{vector[1:L] of Means of Gaussians (of GMM)}
  \item{SDs}{vector of standard deviations, estimated Gaussian Kernels, has to be the same length as Means}
  \item{Weights}{vector of relative number of points in Gaussians (prior probabilities), has to be the same length as Means}
  \item{IsLogDistribution}{Optional, ==1 if distribution(i) is a LogNormal, default vector of zeros of length 1:L}

  \item{ClassLabels}{Optional numbered class labels that are assigned to the classes. default (1:L), L number of different components of gaussian mixture model}

}

\value{
Cls(1:n,1:d)               classiffication of Data, such that 1= first component of gaussian mixture model, 2= second component of gaussian mixture model and so on. For Every datapoint a number is returned.
}

\author{
Michael Thrun
}

\keyword{BayesClassification}% use one of  RShowDoc("KEYWORDS")
\keyword{Bayes}% __ONLY ONE__ keyword per line

\keyword{Classification}% use one of  RShowDoc("KEYWORDS")

