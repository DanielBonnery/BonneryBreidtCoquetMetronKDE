##Chapitre 4. Kernel density estimation  
##4.1. Definitions
# Kernels
kergaus<-list(K=dnorm,intK2=(1/(2*sqrt(pi))));
ker<-kergaus

# bandwidths
b<-function(N){1/sqrt(N)}
varp<-function(y0,b,ker=ker,model=model,N){(model$dloi(y0)/(N*b(N)))*(model$vinf(y0)/(model$tau^2)+((model$rho(y0))^2))*ker$intK2}
varpsr<-function(y0,b,ker=ker,model=model,N){varp(y0,b,ker=ker,model=model,N)/((model$rho(y0))^2)}

# Kernel density estimators definition of kde
p0  <-function(y0,Obs,ker=ker,model,N){sum(ker$K((Obs$y-y0)/b(N)))/(b(N)*length(Obs$y))}
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' fHT(y0,Obs)
#' fHT(1,Obs)

fHT<-function(y0,Obs,ker=kergaus,yfun=function(obs){obs$y},pifun=function(obs){obs$pik},h=ks::hpi(x=yfun(Obs))){
  apply(ker$K(outer(yfun(Obs),y0,"-")/h)/pifun(Obs),2,sum)/(h*sum(1/pifun(Obs)))}

#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=1.5
#' .Obs<-generate.observations(model);
#'varfHT0(y0,Obs)
#'
varfHT0<-function(y0,.Obs,.ker=kergaus,.yfun=function(obs){obs$y},.h=ks::hpi(x=.yfun(.Obs))){
  Y<-cbind(.ker$K((.yfun(.Obs)-y0)/.h)/.Obs$pik,.h/.Obs$pik)
  LL <-(function(x){c(1/x[2],-x[1]/(x[2]^2))})(apply(Y,2,sum))
  eps<-Y%*%LL
  sum((1-.Obs$pik)*(eps^2))
  }
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0<-1/((1-seq(0,1,length.out=1000))^(1/theta));
#' .Obs<-generate.observations(model);
#' varfHT(y0,Obs)
varfHT <-function(Y0, Obs, ker=kergaus,yfun=function(obs){obs$y}, h=ks::hpi(x= yfun(Obs))){
  sapply(Y0,FUN=varfHT0,.Obs=Obs,.ker=ker,.yfun=yfun,.h=h)}

p   <-function(y0,Obs,b,ker=ker,model,N){sapply(y0,p0,Obs=Obs,b=b,ker=ker,model=model)}
p2  <-function(y0,Obs,b,ker=ker,model,N){as.vector(kde(Obs$y,hpi(x=Obs$y)/2,eval.points=y0)$estimate)}
psr <-function(y0,Obs,b,ker=ker,model,N){p(y0,Obs,b,ker=ker,model=model)/model$rho(y0)}
p2sr<-function(y0,Obs,b,ker=ker,model,N){p2(y0,Obs,b,ker=ker,model=model)/model$rho(y0)}

# Calculus of variance
moments<-function(y0,b,ker=ker,model=model,lafun=psr,N=N,nrep=1000){
  XX<-matrix(NA,nrep,length(y0))
  for(i in 1:nrep){
  Obs<-genere(m,N)
  XX[i,]<-lafun(y0,Obs,b,ker=ker,model=model)}
  return(list(E=apply(XX,2,mean),var=apply(XX,2,var)))}
##Simulations and verification of variance formula
Verif<-function(m,N,b,nrep=100,nbpts=30,fic,verifvp){
  y0<-seq(model$support[1],model$support[2],length.out=nbpts);
  mmts<-moments(y0,b,ker=ker,model=model,lafun=p,N=N,nrep=nrep);
  vpemp<-mmts$var;
  vp<-varp(y0,b=b,ker=ker,model=model,N=N);
  png(paste(fic,"_1.png"))
    plot(y0,vpemp/vp,type='l',col="blue");
    title("v empirique/v theorique")
  dev.off()
  png(paste(fic,"_2.png"))
    plot(y0,vp,type='l',col="blue");
    points(y0,vpemp,type='l',col="orange");
    points(y0,verifvp(y0),type='l',col="red");
    title("v empirique(orange) - v theorique (bleu) - v theorique verif (rouge)") 
  dev.off()
  png(paste(fic,"_3.png"))
    plot(y0,model$dloi(y0),type='l',col="black");
    plot(y0,model$rho(y0)*model$dloi(y0),type='l',col="blue");
    points(y0,mmts$E,type='l',col="orange");
    title("E[p] empirique(orange) -  f (bleu)- rho f (noir)") 
  dev.off()
  png(paste(fic,"_4.png"))
    Obs<-genere(m,N)
    plot(y0,model$rho(y0)*model$dloi(y0),type='l',col="black");
    points(y0,p(y0,Obs,b,ker=ker,model=model),type='l',col="orange");
    title("p orange -  rho f (bleu)- rho f (noir)") 
    dev.off()
return(list(vp=vp,vpemp=vpemp,y0=y0,mmts=mmts,model=model,verifvp=verifvp,N=N,nrep=nrep))
}

