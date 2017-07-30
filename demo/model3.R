setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))

############################### MODEL 3
rm(list=ls());gc();graphics.off()

set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.dep.strat2
set.seed(1)#NB: the seed was not set for the table in the publication
conditionalto=list(N=50000,sigma=1 ,EX=1,SX=1,sampleparam=list(proph=c(.7,.3),tauh=c(1/70,2/15)))
theta=c(.5,0,2)
xi=2
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 3"
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
