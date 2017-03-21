  set.seed(1)#NB: the seed was not set for the table in the publication
  popmodelfunction = model.dep.strat2
  set.seed(1)#NB: the seed was not set for the table in the publication
  conditionalto=list(N=50000,sigma=1 ,EX=1,SX=1,sampleparam=list(proph=c(.7,.3),tauh=c(1/70,2/15)))
  theta=c(.5,0,2)
  xi=2
  model<-popmodelfunction(theta,xi,conditionalto)
  yfun<-function(obs){obs$y[,2]}
  Obs<-generate.observations(model)
  y0<-seq(min(yfun(Obs)),max(yfun(Obs)),length.out=1000)
  nrep=1000
  ff<-plyr::raply(nrep,(function(){Obs<-generate.observations(model);cbind(f=fHT(y0,Obs,fun=yfun),Vf=varfHT(y0,Obs,fun=yfun))})(),.progress="text")
  dim(ff)
  dimnames(ff)<-list(1:nrep,1:(dim(ff)[2]),c("f","Vf"))
  names(dimnames(ff))<-c("rep","i","f")
  
  library(reshape2)
  A<-reshape2::melt(ff)
  AA<-reshape2::dcast(A,i+rep~f,value.var="value")
  AA<-merge(AA,data.frame(i=1:(dim(ff)[2]),y0=y0))
  if(dir.exists("datanotpushed")){save(AA,w_graph4.1,file="datanotpushed/w_graph4data.rda")}
  
  empvar=data.frame(y0=y0,Vf=plyr::aaply(ff[,,1],2,var))
  avgvarest=data.frame(y0=y0,Vf=plyr::aaply(ff[,,2],2,mean))
  
  library(ggplot2)
  w_graph4 <- ggplot(AA, aes(x=y0, y=f, group=rep)) +
    geom_line(size=0.2, alpha=0.1)+ 
    ggtitle("1000 replications")+    
    geom_line(data=data.frame(y0=y0,f=plyr::aaply(ff[,,1],2,mean)),aes(x=y0,y=f,group=NULL),size=.2,color="blue")  +
    stat_function(fun = function(y){dnorm(y,mean=theta[1],sd=theta[3])},size=.1,color="red")
    
  w_graph4.1 <- ggplot(AA, aes(x=y0, y=Vf, group=rep)) +
    geom_line(size=0.2, alpha=0.1)+
    ggtitle("1000 replications")+  
    geom_line(data=empvar,aes(x=y0,y=Vf,group=NULL), color="red")+
    geom_line(data=avgvarest,aes(x=y0,y=Vf,group=NULL), color="blue")
    
  if(dir.exists("datanotpushed")){save(w_graph4,w_graph4.1,file="datanotpushed/w_graph4.rda")}
