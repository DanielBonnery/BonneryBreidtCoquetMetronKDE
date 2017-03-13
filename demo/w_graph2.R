set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.Pareto.bernstrat
theta=2;
xi=1;
conditionalto=list(N=100000,sampleparam=list(tauh=c(0.01,0.1)))
model<-popmodelfunction(theta,xi,conditionalto)
y0<-1/((1-seq(0,1,length.out=1000))^(1/theta))[-c(1,800:1000)];
ff<-plyr::raply(1000,fHT(y0,generate.observations(model)),.progress="text")


library(ggplot2)
library(reshape2)
dat = as.data.frame(cbind(y0,t(ff)))
mdat =reshape2::melt(dat, id.vars="y0")
w_graph2 <- ggplot(mdat, aes(x=y0, y=value, group=variable)) +
  theme_bw() +
  theme(panel.grid=element_blank()) +
  geom_line(size=0.2, alpha=0.1)+ 
  ggtitle("1000 replications")+  stat_function(fun = function(y){(y>1)*theta/((y+(y==1))^(theta+1))},size=.1)

