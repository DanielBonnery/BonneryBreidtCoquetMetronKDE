if(FALSE){
  graphics.off();rm(list=ls());gc(reset=TRUE);.rs.restartR()
  setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))
  unloadNamespace("pubBonneryBreidtCoquet2017")
  remove.packages("pubBonneryBreidtCoquet2017")
  devtools::install(".")
  library(pubBonneryBreidtCoquet2017)
  library(tikzDevice)
  library(ggplot2)
  demo(w_graph2,package="pubBonneryBreidtCoquet2017",ask=FALSE)
  demo(Create_all_tex_codes,package="pubBonneryBreidtCoquet2017",ask=FALSE)
  graphics.off();rm(list=ls());gc(reset=TRUE);.rs.restartR()
  }



##################
rm(list=ls());gc();graphics.off()
set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.Pareto.bernstrat
theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 1"
Obs<-generate.observations(model)
dd=Simuletout(model,y0=seq(min(model$yfun(Obs)),max(model$yfun(Obs)),length.out=300),nrep=1000)
  save(dd,file="datanotpushed/graphdata/model.Pareto.bernstrat.rda");
  load("datanotpushed/graphdata/model.Pareto.bernstrat.rda")
ee=analysetout(dd)
save(ee,file="datanotpushed/graphdata/model.Pareto.bernstrat_sum.rda");
load("datanotpushed/graphdata/model.Pareto.bernstrat_sum.rda")
pp<-allplots(ee)
save(pp,file="datanotpushed/graphs/rda/model_Pareto_bernstrat.rda")
load("datanotpushed/graphs/rda/model_Pareto_bernstrat.rda")
createallgraphs("datanotpushed/graphs/rda/model_Pareto_bernstrat.rda")
#print(pp)


##################
rm(list=ls());gc();graphics.off();.rs.restartR()
rm(list=ls());gc();
set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.proptosize
set.seed(1)#NB: the seed was not set for the table in the publication
conditionalto=list(N=50000,sampleparam=list(tau=.2))
theta=c(3)
xi=.5
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 2"
Obs<-generate.observations(model)
dd=Simuletout(model,
              y0=seq(min(model$yfun(Obs)),max(model$yfun(Obs)),length.out=250),
              nrep=300)
save(dd,file="datanotpushed/graphdata/modelproptosize.rda");
load("datanotpushed/graphdata/modelproptosize.rda")
ee=analysetout(dd)
save(ee,file="datanotpushed/graphdata/modelproptosize_sum.rda");
load("datanotpushed/graphdata/modelproptosize_sum.rda")

pp<-allplots(ee)
save(pp,file="datanotpushed/graphs/rda/modelproptosize.rda")
load("datanotpushed/graphs/rda/modelproptosize.rda")
createallgraphs("datanotpushed/graphs/rda/modelproptosize.rda")

print(pp)

###############################
rm(list=ls());gc();graphics.off();.rs.restartR()
graphics.off();rm(list=ls());gc();

set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.dep.strat2
set.seed(1)#NB: the seed was not set for the table in the publication
conditionalto=list(N=50000,sigma=1 ,EX=1,SX=1,sampleparam=list(proph=c(.7,.3),tauh=c(1/70,2/15)))
theta=c(.5,0,2)
xi=2
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 3"
Obs<-generate.observations(model)
dd=Simuletout(model,y0=seq(min(model$yfun(Obs)),max(model$yfun(Obs)),length.out=300),nrep=1000)
  save(dd,file="datanotpushed/graphdata/modeldepstrat2.rda");
  load("datanotpushed/graphdata/modeldepstrat2.rda")
ee=analysetout(dd)
  save(ee,file="datanotpushed/graphdata/modeldepstrat2_sum.rda");
  load("datanotpushed/graphdata/modeldepstrat2_sum.rda")
  pp<-allplots(ee)
save(pp,file="datanotpushed/graphs/rda/modeldepstrat2.rda")
load("datanotpushed/graphs/rda/modeldepstrat2.rda")
createallgraphs("datanotpushed/graphs/rda/modeldepstrat2.rda")


###############################
rm(list=ls());gc();graphics.off();.rs.restartR()
graphics.off();rm(list=ls());gc();

set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.birthweight1
set.seed(1)#NB: the seed was not set for the table in the publication
theta=c(mu=39.853,sigma2=16.723)
conditionalto=list(N=15000,sampleparam=list(n=90))
xi=c(xi=.175,xi0=-log(conditionalto$sampleparam$n/conditionalto$N)+.087^2/2-.175*theta[1]+.175^2*theta[2]/2,tau2=.087)
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 4"
Obs<-generate.observations(model)
dd=Simuletout(model,y0=seq(min(model$yfun(Obs)),max(model$yfun(Obs)),length.out=300),nrep=1000)
save(dd,file="datanotpushed/graphdata/modelbirthweight1.rda");
load("datanotpushed/graphdata/modelbirthweight1.rda")
ee=analysetout(dd)
save(ee,file="datanotpushed/graphdata/modelbirthweight1_sum.rda");
load("datanotpushed/graphdata/modelbirthweight1_sum.rda")
pp<-allplots(ee)
save(pp,file="datanotpushed/graphs/rda/modelbirthweight1.rda")
load("datanotpushed/graphs/rda/modelbirthweight1.rda")
createallgraphs("datanotpushed/graphs/rda/modelbirthweight1.rda")


###############################

graphics.off();rm(list=ls());gc();

set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.birthweight2
set.seed(1)#NB: the seed was not set for the table in the publication
theta=c(mu=39.853,sigma2=16.723)
conditionalto=list(N=15000,sampleparam=list(n=90,nstrata=18))
xi=c(xi=.175,xi0=-log(conditionalto$sampleparam$n/conditionalto$N)+.087^2/2-.175*theta[1]+.175^2*theta[2]/2,tau2=.087)
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 5"
Obs<-generate.observations(model)
dd=Simuletout(model,y0=seq(min(model$yfun(Obs)),max(model$yfun(Obs)),length.out=300),nrep=1000)
save(dd,file="datanotpushed/graphdata/modelbirthweight2.rda");
load("datanotpushed/graphdata/modelbirthweight2.rda")
ee=analysetout(dd)
save(ee,file="datanotpushed/graphdata/modelbirthweight2_sum.rda");
load("datanotpushed/graphdata/modelbirthweight2_sum.rda")
pp<-allplots(ee)
save(pp,file="datanotpushed/graphs/rda/modelbirthweight2.rda")
load("datanotpushed/graphs/rda/modelbirthweight2.rda")
createallgraphs("datanotpushed/graphs/rda/modelbirthweight2.rda")



