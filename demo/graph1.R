graphics.off();rm(list=ls());gc(reset=TRUE);
setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))
try(unloadNamespace("pubBonneryBreidtCoquet2017"))
try(remove.packages("pubBonneryBreidtCoquet2017"))
try(devtools::install("."))
library(pubBonneryBreidtCoquet2017)
library(tikzDevice)
library(ggplot2)
model=modelf(3)
save(model,file=paste0("datanotpushed/model/",model$id,".rda"));
if(FALSE){
  load(paste0("datanotpushed/model/",model$id,".rda"))
}
dd=Simuletout(model,3000)
save(dd,file=paste0("datanotpushed/graphdata/",model$id,".rda"));
if(FALSE){
  load(paste0("datanotpushed/graphdata/",model$id,".rda"))
}
ee=analysetout(dd)
save(ee,file=paste0("datanotpushed/graphdata/",model$id,"_sum.rda"));
rm(dd)
if(FALSE){
  load(paste0("datanotpushed/graphdata/",model$id,"_sum.rda"))
}
pp<-allplots(ee)
createalltables(ee)
save(pp,file=paste0("datanotpushed/graphs/rda/",model$id,".rda"))
createallgraphs(paste0("datanotpushed/graphs/rda/",model$id,".rda"))


jj<-JayRtablef(ee)
save(jj,file=paste0("datanotpushed/graphs/forJay/",model$id,".rda"))
