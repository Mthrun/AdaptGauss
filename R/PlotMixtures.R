PlotMixtures <- function(Data,
                         Means, SDs, Weights = rep(1/length(Means),length(Means)),
                         IsLogDistribution = rep(FALSE,length(Means)),
                         Plotter = "native",
                         SingleColor = 'blue',
                         MixtureColor = 'red',
                         DataColor = 'black',
                         SingleGausses = FALSE, axes = TRUE,
                         xlab = "", ylab = "PDE",
                         xlim = NULL, ylim = NULL,
                         Title = "GMM",
                         ParetoRad = NULL, ...){
  # PlotMixtures(Data,Means,SDs,Weights,IsLogDistribution,SingleColor,MixtureColor);
  # PlotMixtures(Data,Means,SDs,Weights,IsLogDistribution);
  # Plot a Mixture of Gaussians
  
  # INPUT
  # Data(1:AnzCases)            this data column for which the distribution was modelled
  # Means(1:L,1)                Means of Gaussians,  L ==  Number of Gaussians
  # SDs(1:L,1)                estimated Gaussian Kernels = standard deviations
  # OPTIONAL
  # Weights(1:L,1)              relative number of points in Gaussians (prior probabilities): sum(Weights) ==1, default 1/L
  # IsLogDistribution(1:L)      default ==0*(1:L), gibt an ob die jeweilige Verteilung eine Lognormalverteilung ist
  #
  # SingleColor                 PlotSymbol of all the single gaussians, default magenta
  # MixtureColor                PlotSymbol of the mixture default black
  #
  # SingleGausses               Sollen die einzelnen Gauss auch gezeichnet werden, dann TRUE
  # ParetoRad                   Vorberechneter Pareto Radius
  # ...							            other plot arguments like xlim = c(1,10)
  #
  # Author: MT 08/2015,
  # 1.Editor: MT 1/2016: PDF4Mixtures als eigene Funktion ausgelagert
  # 2. Editor: FL 9/2016: ... wird auch an title weitergegeben
  # 3. Editor: QMS 10/2022: Plotly
  #Nota: Based on a Version of HeSa Feb14 (reimplemented from ALUs matlab version)
    
  if(missing(Data)) stop('Data is missing.')
  
  if(!(Plotter %in% c("native", "plotly"))){
    warning("PlotMixtures: Incorrect plotter selected. Doing nothing.")
  }
  
  if(!inherits(Data,'numeric')){
    warning('Data is not a numerical vector. calling as.vector')
    Data=as.vector(Data)
  }

  if(length(Data)==length(Means)){
    warning('Probably "Data" interchanged with "Means" ')
  }

  if(!is.null(ParetoRad)){
    pareto_radius = ParetoRad
  }else{
    pareto_radius<-DataVisualizations::ParetoRadius(Data)
  }
  pdeVal        <- DataVisualizations::ParetoDensityEstimation(Data,pareto_radius)
  

  if(missing(IsLogDistribution)){
    IsLogDistribution = rep(FALSE,length(Means))
  }
  if(length(IsLogDistribution)!=length(Means)){
    warning(paste('Length of Means',length(Means),'does not equal length of IsLogDistribution',length(IsLogDistribution),'Generating new IsLogDistribution'))
    IsLogDistribution = rep(FALSE,length(Means))
  }
  X = sort(na.last=T,unique(Data)) # sort ascending and make sure of uniqueness
  AnzGaussians = length(Means)
  MyPlot = NULL
  
  
  pdfV=Pdf4Mixtures(X, Means, SDs, Weights)
  SingleGaussian=pdfV$PDF
  GaussMixture=pdfV$PDFmixture
  
  # Limits
  GaussMixtureInd=which(GaussMixture>0.00001)
  if(missing(xlim)){ # if no limits for x-axis are comitted
    xl = max(X[GaussMixtureInd],na.rm=T)
    xa = min(X[GaussMixtureInd], 0,na.rm=T)
    xlim = c(xa,xl)
  }
  # Je plot xlim und ylim uebergeben
  # Falls dies nicht geschieht, werden beide Achsen falsch skaliert!
  if(is.null(ylim)){ # if no limits for y-axis are comitted
    yl <- max(GaussMixture,pdeVal$paretoDensity,na.rm=T)
    ya <- min(GaussMixture, 0,na.rm=T)
    ylim <- c(ya,yl+0.1*yl)
    #ylim= par("yaxp")[1:2]
  }
  
  if(Plotter=="plotly"){
    MyPlot = plotly::plot_ly(type = "scatter", mode = "markers")
    if(SingleColor != 0){
      MyPlot = plotly::add_lines(p = MyPlot,
                                 x = X,
                                 y = pdfV$PDFmixture,
                                 line = list(color = MixtureColor), name = "GMM")
      for(i in 1:AnzGaussians){
        MyPlot = plotly::add_lines(p = MyPlot,
                                   x = X,
                                   y = pdfV$PDF[,i],
                                   line = list(color = SingleColor), name = paste0("GMM Comp.", i))
      }
      MyPlot = plotly::add_lines(p = MyPlot,
                                 x = pdeVal$kernels,
                                 y = pdeVal$paretoDensity,
                                 line = list(color = DataColor), name = "Empirical Density Est.")
      MyPlot = plotly::layout(p = MyPlot, title = Title,
                              xaxis = list(title = xlab, range = xlim))
    }else{
      MyPlot = plotly::add_lines(p = MyPlot,
                                 x = X,
                                 y = pdfV$PDFmixture,
                                 line = list(color = MixtureColor), name = "GMM")
    }
  }else if(Plotter=="native"){
    if(SingleColor  != 0){
      # 	for(g in c(1:AnzGaussians)){
      # 		if(IsLogDistribution[g] == TRUE){ # LogNormal
      # 			SingleGaussian[,g] <- Symlognpdf(X,Means[g],SDs[g])*Weights[g] # LogNormal
      # 		}else{ # Gaussian
      # 			SingleGaussian[,g] = dnorm(X,Means[g],SDs[g])*Weights[g]
      # 		}# if IsLogDistribution(i) ==T
      # 		GaussMixture =  GaussMixture + SingleGaussian[,g]
      # 	} # for g
      plot.new()
      par(xaxs='i')
      par(yaxs='i')
      par(usr=c(xlim,ylim))
      #par(mar=c(5.1,4.1,4.1,2.1))
      #par(ann=F)
      if(SingleGausses){
        for(g in c(1:AnzGaussians)){
          par(new = TRUE)
          points(X, SingleGaussian[,g], col = SingleColor, type = 'l', xlim = xlim, ylim = ylim, ylab="PDE", ...)
        }
      }
      points(X, GaussMixture, col = MixtureColor, type = 'l',xlim = xlim,...)
    } else{#SingleColor  == 0
      plot(X, GaussMixture, col = MixtureColor, type = 'l', xlim, ylim,axes=FALSE, ...)
    }
    if(axes){
      axis(1,xlim=xlim,col="black",las=1) #x-Achse
      axis(2,ylim=ylim,col="black",las=1) #y-Achse
      #title(xlab=xlab,ylab=ylab,main = "")
      #box() #Kasten um Graphen
      title(xlab=xlab,ylab=ylab,...)
    }
    #par(oldpar) # geht nicht, da sonst zB. abline( v =  0.4) nicht bei 0.4 sitzt...
    
    points(pdeVal$kernels,pdeVal$paretoDensity,type='l', xlim = xlim, ylim = ylim,col=DataColor,...)
  }
  return(list("MyPlot" = MyPlot,
              "xlim"   = xlim,
              "ylim"   = ylim))
}
