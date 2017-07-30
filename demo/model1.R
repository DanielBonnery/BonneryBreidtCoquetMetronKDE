################## MODEL 1
setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))

set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.Pareto.bernstrat
theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 1"
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
