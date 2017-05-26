set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.Pareto.bernstrat
theta=2;
xi=1;
nrep=1000
conditionalto=list(N=100000,sampleparam=list(tauh=c(0.01,0.1)))
model<-popmodelfunction(theta,xi,conditionalto)
y0<-1/((1-seq(0,1,length.out=1000))^(1/theta))[-c(1,800:1000)];
ff<-plyr::raply(nrep,(function(){
  Obs<-generate.observations(model);
  cbind(f=fHT(y0,Obs),
       f1=fHT(y0,Obs,pifun=hatetafunf(xihat=function(obs){xi},eta=model$eta)),
       f2=fHT(y0,Obs,pifun=hatetafunf(xihat=model$xihat,eta=model$eta)),
       f3=fHT(y0,Obs,pifun=hatetafunf2),
       Vf=varfHT(y0,Obs))})(),.progress="text")
dim(ff)

true.density=function(y){(y>1)*theta/((y+(y==1))^(theta+1))}


dimnames(ff)<-list(1:nrep,2:799,c("f","known xi","estimated xi","hat eta","Vf"))
names(dimnames(ff))<-c("rep","i","f")
if(dir.exists("datanotpushed")){save(ff,file="datanotpushed/w_graph2data");load("datanotpushed/w_graph2data")}

library(reshape2)
A<-reshape2::melt(ff)
AA<-reshape2::dcast(A,i+rep~f,value.var="value")
AA<-merge(AA,data.frame(i=2:799,y0=y0))

empvarA=plyr::aaply(ff[,,1:4],2:3,var)
empbias2A=(plyr::aaply(ff[,,1:4],2:3,mean)-true.density(y0))^2


empvar=melt(data.frame(y0=y0,empvarA),id="y0")
empmse=melt(data.frame(y0=y0,empvarA+empbias2A),id="y0")
avgvarest=data.frame(y0=y0,Vf=plyr::aaply(ff[,,5],2,mean))

library(ggplot2)
w_graph2 <- ggplot(AA, aes(x=y0, y=f, group=rep)) +
  geom_line(size=0.2, alpha=0.1)+ 
  ggtitle("1000 replications")+    
  geom_line(data=data.frame(y0=y0,f=plyr::aaply(ff[,,1],2,mean)),aes(x=y0,y=f,group=NULL),size=.2,color="blue")  +
  stat_function(fun = true.density,size=.1,color="red")+
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))

  
w_graph2.1 <- ggplot(AA, aes(x=y0, y=Vf, group=rep)) +
  geom_line(size=0.2, alpha=0.1)+
  ggtitle("1000 replications")+  
  geom_line(data=empvar[empvar$variable=="f",],aes(x=y0,y=value,group=NULL), color="red")+
  geom_line(data=avgvarest,aes(x=y0,y=Vf,group=NULL), color="blue")+
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))


w_graph2.2 <- ggplot(empvar, aes(x=y0, y=value, color=variable)) +
  geom_line()+ 
  ggtitle(paste0("Empirical variance for ",nrep, " replications"))+
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()



w_graph2.3 <- ggplot(empmse, aes(x=y0, y=value, color=variable)) +
  geom_line()+ 
  ggtitle(paste0("Empirical MSE for ",nrep, " replications"))+
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()


  
if(dir.exists("datanotpushed")){save(w_graph2,w_graph2.1,w_graph2.2,w_graph2.3,file="datanotpushed/w_graph2.rda")}
