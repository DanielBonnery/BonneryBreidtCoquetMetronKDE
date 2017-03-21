set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.Pareto.bernstrat
theta=2;
xi=1;
nrep=1000
conditionalto=list(N=100000,sampleparam=list(tauh=c(0.01,0.1)))
model<-popmodelfunction(theta,xi,conditionalto)
y0<-1/((1-seq(0,1,length.out=1000))^(1/theta))[-c(1,800:1000)];
ff<-plyr::raply(nrep,(function(){Obs<-generate.observations(model);cbind(f=fHT(y0,Obs),Vf=varfHT(y0,Obs))})(),.progress="text")
dim(ff)
dimnames(ff)<-list(1:nrep,2:799,c("f","Vf"))
names(dimnames(ff))<-c("rep","i","f")

library(reshape2)
A<-reshape2::melt(ff)
AA<-reshape2::dcast(A,i+rep~f,value.var="value")
AA<-merge(AA,data.frame(i=2:799,y0=y0))

empvar=data.frame(y0=y0,Vf=plyr::aaply(ff[,,1],2,var))
avgvarest=data.frame(y0=y0,Vf=plyr::aaply(ff[,,2],2,mean))

library(ggplot2)
w_graph2 <- ggplot(AA, aes(x=y0, y=f, group=rep)) +
  geom_line(size=0.2, alpha=0.1)+ 
  ggtitle("1000 replications")+    
  geom_line(data=data.frame(y0=y0,f=plyr::aaply(ff[,,1],2,mean)),aes(x=y0,y=f,group=NULL),size=.2,color="blue")  +
  stat_function(fun = function(y){(y>1)*theta/((y+(y==1))^(theta+1))},size=.1,color="red")
  
w_graph2.1 <- ggplot(AA, aes(x=y0, y=Vf, group=rep)) +
  geom_line(size=0.2, alpha=0.1)+
  ggtitle("1000 replications")+  
  geom_line(data=empvar,aes(x=y0,y=Vf,group=NULL), color="red")+
  geom_line(data=avgvarest,aes(x=y0,y=Vf,group=NULL), color="blue")
  
  save(w_graph2,w_graph2.1,file="figure/w_graph2")
