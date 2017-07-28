if(FALSE){
unloadNamespace("pubBonneryBreidtCoquet2017")
    library(pubBonneryBreidtCoquet2017)
  setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))
  demo(w_graph2,package="pubBonneryBreidtCoquet2017",ask=FALSE)
  demo(Create_all_tex_codes,package="pubBonneryBreidtCoquet2017",ask=FALSE)
  }

##################
rm(list=ls());gc();graphics.off()
set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.Pareto.bernstrat
theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
model<-popmodelfunction(theta,xi,conditionalto)
yfun<-function(obs){obs$y}
Obs<-generate.observations(model)
dd=Simuletout(model,y0=seq(min(yfun(Obs)),max(yfun(Obs)),length.out=100),nrep=30)
if(dir.exists("datanotpushed")){
  save(dd,file="datanotpushed/graphdata/model.Pareto.bernstrat.rda");
  load("datanotpushed/graphdata/model.Pareto.bernstrat.rda")
  }
library(ggplot2)
pp<-allplots(dd)
if(dir.exists("datanotpushed/graphs/rda")){save(pp,file="datanotpushed/graphs/rda/model_Pareto_bernstrat.rda")}
print(pp)


##################

rm(list=ls());gc()
set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.proptosize
set.seed(1)#NB: the seed was not set for the table in the publication
conditionalto=list(N=50000,sampleparam=list(tau=.2))
theta=c(3)
xi=.5
model<-popmodelfunction(theta,xi,conditionalto)
yfun<-function(obs){obs$y}
Obs<-generate.observations(model)
dd=Simuletout(model,
              y0=seq(min(yfun(Obs)),max(yfun(Obs)),length.out=25),
              nrep=30)
if(dir.exists("datanotpushed")){
  save(dd,file="datanotpushed/graphdata/modelproptosize.rda");
 load("datanotpushed/graphdata/model.Pareto.bernstrat.rda")}
library(ggplot2)
pp<-allplots(dd)
if(dir.exists("datanotpushed/graphs/rda")){save(pp,file="datanotpushed/graphs/rda/modelproptosize.rda")}

print(pp)

###############################
rm(list=ls());gc()

set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.dep.strat2
set.seed(1)#NB: the seed was not set for the table in the publication
conditionalto=list(N=50000,sigma=1 ,EX=1,SX=1,sampleparam=list(proph=c(.7,.3),tauh=c(1/70,2/15)))
theta=c(.5,0,2)
xi=2
model<-popmodelfunction(theta,xi,conditionalto)
yfun<-function(obs){obs$y[,2]}
Obs<-generate.observations(model)
true.density=function(x){dnorm(x,mean=theta[1],sd=theta[3])}
dd=Simuletout(model,y0=seq(min(yfun(Obs)),max(yfun(Obs)),length.out=30),nrep=30,yfun=yfun,true.density=true.density)
if(dir.exists("datanotpushed")){save(dd,file="datanotpushed/graphdata/modelproptosize.rda");load("datanotpushed/graphdata/model.Pareto.bernstrat.rda")}
library(ggplot2)
pp<-allplots(dd)
if(dir.exists("datanotpushed/graphs/rda")){save(pp,file="datanotpushed/graphs/rda/modelproptosize.rda")}

