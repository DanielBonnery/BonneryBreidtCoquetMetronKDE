folder="datanotpushed"
if(!dir.exists(folder)){
  folder=readline("Enter the path to a  folder containing demo outputs from working directory  and Press [enter] to continue")
  if(!dir.exists(folder)){stop(paste0("The folder ",file.path(getwd(),folder),"you entered does not exist"))}
}


set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.proptosize
set.seed(1)#NB: the seed was not set for the table in the publication
conditionalto=list(N=50000,sampleparam=list(tau=.2))
theta=c(3)
xi=.5
model<-popmodelfunction(theta,xi,conditionalto)
yfun<-function(obs){obs$y}
Obs<-generate.observations(model)
y0<-seq(min(yfun(Obs)),max(yfun(Obs)),length.out=1000)
nrep=10
ff<-plyr::raply(nrep,(function(){Obs<-generate.observations(model);
cbind(f=fHT(y0,Obs,yfun=yfun),
      f1=fHT(y0,Obs,yfun=yfun,pifun=hatetafunf(xihat=function(obs){xi},eta=model$eta)),
      f2=fHT(y0,Obs,yfun=yfun,pifun=hatetafunf(xihat=model$xihat,eta=model$eta)),
      f3=fHT(y0,Obs,yfun=yfun,pifun=hatetafunf2),
      Vf=varfHT(y0,Obs,yfun=yfun))})(),.progress="text")
dim(ff)
dimnames(ff)<-list(1:nrep,1:(dim(ff)[2]),c("f","known xi","estimated xi","hat eta","Vf"))
names(dimnames(ff))<-c("rep","i","f")
save(ff,file=file.path(folder,"w_graph5data.rda"));load(file.path(folder,"w_graph5data.rda"))

true.density=function(x){dnorm(x,mean=theta[1],sd=theta[3])}






library(reshape2)
A<-reshape2::melt(ff)
AA<-reshape2::dcast(A,i+rep~f,value.var="value")
AA<-merge(AA,data.frame(i=1:(dim(ff)[2]),y0=y0))

empvarA=plyr::aaply(ff[,,1:4],2:3,var)
empbias2A=(plyr::aaply(ff[,,1:4],2:3,mean)-true.density(y0))^2

empvar=melt(data.frame(y0=y0,empvarA),id="y0")
empmse=melt(data.frame(y0=y0,empvarA+empbias2A),id="y0")
avgvarest=data.frame(y0=y0,Vf=plyr::aaply(ff[,,5],2,mean))

#  empvar=data.frame(y0=y0,Vf=plyr::aaply(ff[,,1],2,var))
#avgvarest=data.frame(y0=y0,Vf=plyr::aaply(ff[,,2],2,mean))

library(ggplot2)
w_graph5 <- ggplot(AA, aes(x=y0, y=f, group=rep)) +
  geom_line(size=0.2, alpha=0.1)+ 
  ggtitle("1000 replications")+    
  geom_line(data=data.frame(y0=y0,f=plyr::aaply(ff[,,1],2,mean)),aes(x=y0,y=f,group=NULL),size=.2,color="blue")  +
  stat_function(fun = true.density,size=.4,color="red")+
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))



w_graph5.1 <- ggplot(AA, aes(x=y0, y=Vf, group=rep)) +
  geom_line(size=0.2, alpha=0.1)+
  ggtitle("1000 replications")+  
  geom_line(data=empvar[empvar$variable=="f",],aes(x=y0,y=value,group=NULL), color="red")+
  geom_line(data=avgvarest,aes(x=y0,y=Vf,group=NULL), color="blue")+
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))


w_graph5.2 <- ggplot(empvar, aes(x=y0, y=value, color=variable)) +
  geom_line()+ 
  ggtitle(paste0("Empirical variance for ",nrep, " replications"))+
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()



w_graph5.3 <- ggplot(empmse, aes(x=y0, y=value, color=variable)) +
  geom_line()+ 
  ggtitle(paste0("Empirical MSE for ",nrep, " replications"))+
  theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()


save(w_graph5,w_graph5.1,w_graph5.2,w_graph5.3,file=file.path(folder,"w_graph5.rda"))









