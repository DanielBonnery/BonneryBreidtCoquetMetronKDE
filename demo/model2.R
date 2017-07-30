setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))


################## MODEL 2
rm(list=ls());gc();graphics.off()
set.seed(1)#NB: the seed was not set for the table in the publication
popmodelfunction = model.proptosize
set.seed(1)#NB: the seed was not set for the table in the publication
conditionalto=list(N=15000,sampleparam=list(tau=.2))
theta=c(3)
xi=.5
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 2"
id=tolower(gsub(".", "",gsub(" ", "",model$name, fixed = TRUE), fixed = TRUE))
dd=Simuletout(model)
save(dd,file=paste0("datanotpushed/graphdata/",id,".rda"));
load(paste0("datanotpushed/graphdata/",id,".rda"))
ee=analysetout(dd)
save(ee,file=paste0("datanotpushed/graphdata/",id,"_sum.rda"));
load(paste0("datanotpushed/graphdata/",id,"_sum.rda"))
pp<-allplots(ee)
#ppc<-allplots(ee,scale_colour_function1=ggplot2::scale_colour_hue,scale_colour_function2=ggplot2::scale_colour_hue)
createalltables(ee)
save(pp,file=paste0("datanotpushed/graphs/rda/",id,".rda"))
createallgraphs(paste0("datanotpushed/graphs/rda/",id,".rda"))