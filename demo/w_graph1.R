set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.Pareto.bernstrat
theta=2;
xi=1;
conditionalto=list(N=100000,sampleparam=list(tauh=c(0.01,0.1)))
model<-popmodelfunction(theta,xi,conditionalto)
Obs<-generate.observations(model)
y0<-1/((1-seq(0,1,length.out=1000))^(1/theta))[-c(1,800:1000)];
f<-fHT(y0,Obs)
vf<-varfHT(y0,Obs)

library(ggplot2)
w_graph1<-
  ggplot(data.frame(y0=y0,f=f,lb=f-qnorm(.975)*sqrt(vf),ub=f+qnorm(.975)*sqrt(vf)),aes(x=y0,y=f))+
  geom_line(color="blue")+
  stat_function(fun = function(y){(y>1)*theta/((y+(y==1))^(theta+1))})+
  geom_ribbon(aes(ymin=lb, ymax=ub, x=y0), alpha = 0.3)+ 
  ggtitle("One estimation, band based on HT variance estimation, Pareto")

if(dir.exists("datanotpushed")){save(w_graph1,file="datanotpushed/w_graph1.rda")}



f1=fHT(y0,Obs,pifun=hatetafunf(xihat=function(obs){xi},eta=model$eta))
f2=fHT(y0,Obs,pifun=hatetafunf(xihat=model$xihat,eta=model$eta))
f3=fHT(y0,Obs,pifun=hatetafunf2)


dff<-melt(data.frame(y0=y0,f=f,f1=f1,f2=f2,f3=f3),id="y0")
dff2<-data.frame(y0=y0,value=f,lb=f-qnorm(.975)*sqrt(vf),ub=f+qnorm(.975)*sqrt(vf))

library(ggplot2)
w_graph1.1<-
  ggplot(dff,aes(x=y0,y=value,colour=variable))+
  geom_line()+
  stat_function(fun = function(y){(y>1)*theta/((y+(y==1))^(theta+1))})+
#  geom_ribbon(data=dff2,aes(ymin=lb, ymax=ub,x=y0), alpha = 0.3,color="gray")+ 
  ggtitle("One estimation, Pareto")

if(dir.exists("datanotpushed")){save(w_graph1.1,file="datanotpushed/w_graph1.1.rda")}


