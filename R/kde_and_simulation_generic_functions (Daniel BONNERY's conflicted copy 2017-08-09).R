#' Simulate observations and return kernel density estimates
#' @param model: a model object
#' @param N: integer, for population size
#' @param nbreps: number of replicates
#' @return 
#' @examples
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=100000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=1.5
#' Obs<-generate.observations(model)
#' simulekde(model,1.5,100)

set.seed(1)#NB: the seed was not set for the table in the publication
sigma=1
conditionalto=list(sigma=1,
N=5000,
EX=1,SX=1,sampleparam=list(proph=c(.7,.3),tauh=c(1/70,2/15)))

theta=c(.5,0,2)
xi=2


#' popmodelfunction = pubBonneryBreidtCoquet2016::model.dep.strat2
#' model<-popmodelfunction(theta,xi,conditionalto);y0=1.5
#' Obs<-generate.observations(model)
#' simulekde(model,1.5,100)
#' simulekde(model,1,100)
#' simulekde(model,.5,100)





#' library(ggplot2)
#' ggplot(data=data.frame(y=Obs$y), aes(y)) +geom_density()+stat_function(fun=model$dloiy)

simulekde<-function(model,y0,nbreps=300){
  #Set the precision (used in optimisation procedure)
    suppressMessages(attach(model))
    suppressMessages(attach(Scheme))
    Estim <- plyr::rlply(nbreps,
                       (function(){
                         Obs<-generate.observations(model)
                         return(list(f=fHT0(y0,Obs),Vf=varfHT0(y0,Obs)))})(),
                       .progress = "text")
    
  noms<-names(Estim[[1]])
  Estim<-Estim[sapply(Estim,function(l){!is.character(l$Sample)})]
  Estim<-lapply(as.list(noms),function(nom){plyr::laply(Estim,function(ll){ll[[nom]]})})
  names(Estim)<-noms
    suppressMessages(attach(Estim))
  Var<-lapply(Estim,var,na.rm=TRUE)
  M=lapply(Estim,function(est){apply(as.matrix(est),2,mean,na.rm=TRUE)})
  return(list(
    model=model,
    nbreps=nbreps,
    y0=y0,
    Estim=Estim,
    Variance=Var,
    Mean=M))}



simulekde2<-function(model,y0,nbreps=300){
  #Set the precision (used in optimisation procedure)
  suppressMessages(attach(model))
  suppressMessages(attach(Scheme))
  Y <- model$rloiy()
  
  Estim <- plyr::rlply(nbreps,
                       (function(){
                         Z <- rloiz(Y)
                         S <- model$Scheme$S(Z)
                         Pik <- model$Scheme$Pik(Z)
                         Obs=list(y = as.matrix(Y)[S, ], z = as.matrix(Z)[S, ], pik = Pik[S])
                         return(list(f=fHT0(y0,Obs),Vf=varfHT0(y0,Obs)))})(),
                       .progress = "text")
  
  noms<-names(Estim[[1]])
  Estim<-Estim[sapply(Estim,function(l){!is.character(l$Sample)})]
  Estim<-lapply(as.list(noms),function(nom){plyr::laply(Estim,function(ll){ll[[nom]]})})
  names(Estim)<-noms
  suppressMessages(attach(Estim))
  Var<-lapply(Estim,var,na.rm=TRUE)
  M=lapply(Estim,function(est){apply(as.matrix(est),2,mean,na.rm=TRUE)})
  return(list(
    model=model,
    nbreps=nbreps,
    y0=y0,
    Estim=Estim,
    Variance=Var,
    Mean=M))}


#7. Simulations and output
#

Simulation_kde_data<-function(popmodelfunction,theta,xi,conditionalto,
                          method=NULL,nbreps=3000,nbrepI=3000,nbrepSigma=1000){
  model<-popmodelfunction(theta,xi,conditionalto)
  suppressWarnings(sim<-simulekde(model,nbreps=nbreps,method))
  return(list(model=model,sim=sim))}

simulation.summary<-function(table_data){
    ll<-c(table_data$sim[c("Mean","Bias","Variance","M.S.E.","E")],table_data$cave["V"])
    X<-do.call(rbind,
               lapply(c("Naive","Pseudo","Sample","Full"),function(est){
                 do.call(data.frame,c(list(Estimator=est),
                                      list("theta"=as.array(list(table_data$model$theta))),
                                      list("xi"=as.array(list(table_data$model$xi))),
                                      list("Contidional to"=as.array(list(table_data$model$conditionalto))),
                                      list("Mean"=as.array(list(signif(ll$Mean[est][[1]],3)))),
                                      list("% Relative Bias"=as.array(list(signif(100*ll$Bias[est][[1]]/ll$E[est][[1]],3)))),
                                      list("RMSE Ratio"=as.array(list(signif(diag(as.matrix(ll$"M.S.E."[est][[1]]))/diag(as.matrix(ll$"M.S.E"["Sample"][[1]],3)))))),
                                      list("Empirical Variance"=as.array(list(signif(diag(as.matrix(ll$Variance[est][[1]],3)))))),
                                      list("Asymptotic Variance"=as.array(list(signif(diag(as.matrix(ll$V[est][[1]],3))))))))}))
    names(X)<-c("Estimator",
                "$\\theta$","$\\xi$",paste0("Conditional to (", paste(names(unlist(table_data$model$conditionalto)),collapse=","),")"),"Mean","% Relative Bias","RMSE Ratio","Empirical Variance","Asymptotic Variance")
    X}