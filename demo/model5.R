setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))


############################### MODEL 5

rm(list=ls());gc();graphics.off()

set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.birthweight2
set.seed(1)#NB: the seed was not set for the table in the publication
theta=c(mu=39.853,sigma2=16.723)
conditionalto=list(N=15000,sampleparam=list(n=90,nstrata=18))
xi=c(xi=.175,xi0=-log(conditionalto$sampleparam$n/conditionalto$N)+.087^2/2-.175*theta[1]+.175^2*theta[2]/2,tau2=.087)
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 5"
id=tolower(gsub(".", "",gsub(" ", "",model$name, fixed = TRUE), fixed = TRUE))
dd=Simuletout(model)
save(dd,file=paste0("datanotpushed/graphdata/",id,".rda"));
load(paste0("datanotpushed/graphdata/",id,".rda"))
ee=analysetout(dd)
save(ee,file=paste0("datanotpushed/graphdata/",id,".rda"));
load(paste0("datanotpushed/graphdata/",id,".rda"))
pp<-allplots(ee)
#ppc<-allplots(ee,scale_colour_function1=ggplot2::scale_colour_hue,scale_colour_function2=ggplot2::scale_colour_hue)
createalltables(ee)
save(pp,file=paste0("datanotpushed/graphs/rda/",id,".rda"))
createallgraphs(paste0("datanotpushed/graphs/rda/",id,".rda"))


