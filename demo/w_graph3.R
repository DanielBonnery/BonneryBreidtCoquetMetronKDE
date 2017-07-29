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
f<-kde.outer(y0,Obs,yfun=yfun)
vf<-varkde.outer(y0,Obs,yfun=yfun)
h=ks::hpi(x=yfun(Obs))
library(ggplot2)
w_graph3<-
  ggplot(data.frame(y0=y0,f=f,lb=f-qnorm(.975)*sqrt(vf),ub=f+qnorm(.975)*sqrt(vf)),aes(x=y0,y=f))+
  geom_line(color="blue")+
  stat_function(fun = function(y){dnorm(y,mean=theta[1],sd=theta[3])})+
  geom_ribbon(aes(ymin=lb, ymax=ub, x=y0), alpha = 0.3)+ 
  ggtitle("One estimation, band based on HT variance estimation, Normal")

if(dir.exists("datanotpushed")){save(w_graph3,file="datanotpushed/w_graph3.rda")}

