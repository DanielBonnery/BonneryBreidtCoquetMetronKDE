setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))
model=modelf(5)
set.seed(1)
dd=Simuletout(model,3000)
ee=analysetout(dd)
jj=cbind(y0=ee$y0,reshape2::acast(ee$empmse,y0~variable,value.var="value"))[,1:15]
graph1<-ggplot(jj)
rownames(jj)<-NULL
jj

