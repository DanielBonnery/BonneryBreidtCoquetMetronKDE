  if(FALSE){
  library(pubBonneryBreidtCoquet2017)
  library(ggplot2)
  ker=kergaus
  pifun=function(obs){obs$pik}
  popmodelfunction = model.Pareto.bernstrat
  theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
  model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
  Obs<-generate.observations(model);
  h=ks::hpi(x=model$yfun(Obs))
  pifun=function(obs){obs$pik}
  setwd(file.path(Mydirectories::Dropbox.directory(),"Travail/Recherche/Travaux/Estimation non paramétrique de la densité/pubBonneryBreidtCoquet2017"))
  load("datanotpushed/graphdata/model.Pareto.bernstrat.rda")
  attach(dd)
}

##4.1. Definitions
# Kernels
kergaus<-list(K=dnorm,intK2=(1/(2*sqrt(pi))));
ker<-kergaus

# bandwidths
b<-function(N){1/sqrt(N)}
varp<-function(y0,b,ker=ker,model=model,N){(model$dloi(y0)/(N*b(N)))*(model$vinf(y0)/(model$tau^2)+((model$rho(y0))^2))*ker$intK2}
varpsr<-function(y0,b,ker=ker,model=model,N){varp(y0,b,ker=ker,model=model,N)/((model$rho(y0))^2)}

# Kernel density estimators definition of kde
p0  <-function(y0,Obs,ker=ker,model,N){sum(ker$K((model$yfun(Obs)-y0)/b(N)))/(b(N)*length(model$yfun(Obs)))}

#' Compute an estimate of E[I\mid Y=y0] 
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param pifun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' mf(y0,Obs)
mf<-function(ker=kergaus,yfun=function(obs){obs$y},pifun=function(obs){obs$pik}){
  function(y0,Obs,h=ks::hpi(x=yfun(Obs))){apply(ker$K(outer(yfun(Obs),y0,"-")/h),2,sum)/apply(ker$K(outer(yfun(Obs),y0,"-")/h)/pifun(Obs),2,sum)}}


#' Compute an estimate of E[I\mid Y=y0] of the form $m(y,\hat{\xi})$ 
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param pifun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' (mftheo(model))(1:3,Obs)
mftheo   <-function(model,xi=model$xi){function(y0,Obs){model$eta(list(y=y0),.xi=xi)}}
#' Compute an estimate of E[I\mid Y=y0] of the form $m(y,\hat{\xi})$ 
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param pifun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' (mfhattheo(model))(1:3,Obs)
mfhattheo<-function(model,xihatfun=model$xihat){function(y0,Obs){model$eta(list(y=y0),xihatfun(Obs))}}
#' Compute an estimate of 1/E[1/\pi\mid Y=y0] of the form $m(y,\hat{\xi})$ 
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param pifun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' (mf3())(y0,Obs)
mf3<-function(ker=kergaus,yfun=function(obs){obs$y},pifun=function(obs){obs$pik}){function(y0,Obs,h=ks::hpi(x=yfun(Obs))){
  1/(apply(ker$K(outer(yfun(Obs),y0,"-")/h)/(pifun(Obs)^2),2,sum)/apply(ker$K(outer(yfun(Obs),y0,"-")/h)/pifun(Obs),2,sum))}}


#' Compute an estimate of E[\pi\mid Y=y0] with linear regression 
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param pifun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' mfreg()(y0,Obs)
mfroughreg<-function(ker=kergaus,yfun=function(obs){obs$y},pifun=function(obs){obs$pik}){function(y0,Obs){
  y=yfun(Obs);pi=pifun(Obs)
  predict.lm(object=lm(pi~y,weights = 1/pi),newdata=data.frame(y=y0))}}


mfroughreg<-function(ker=kergaus,yfun=function(obs){obs$y},pifun=function(obs){obs$pik}){function(y0,Obs){
  y=yfun(Obs);pi=pifun(Obs)
  predict.lm(object=lm(pi~y,weights = 1/pi),newdata=data.frame(y=y0))}}


#' Compute an estimate of E[E[\pi\mid Y]]  
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param pifun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' mfmean(Obs)
mfmean<-function(.mf=mf,yfun=function(obs){obs$y},pifun=function(obs){obs$pik},Nhatfun=function(obs){sum(1/pifun(Obs))}){
  function(Obs){sum(.mf(yfun(Obs),Obs)/pifun(Obs))/Nhatfun(Obs)}}
#' Compute an estimate of E[E[\pi\mid Y]]  
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param pifun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' rhohatfun()(1,Obs)

rhohatfun <-function(.mf=mf(),Nhatfun=function(obs){sum(1/obs$pik)}){function(y0,Obs){.mf(y0,Obs)/(mfmean(.mf,Nhatfun=Nhatfun)(Obs))}}

#' Compute HT-like kernel density estimates 
#' @param y0: Point of vector of points where the density estimate is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param pifun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' kde.outer(y0,Obs)
#' kde.outer(1,Obs)
kde.outer<-function(y0,Obs,ker=kergaus,
                    yfun=function(obs){obs$y},
                    pifun=function(obs){obs$pik},
                    h=ks::hpi(x=yfun(Obs))){
  apply(ker$K(outer(yfun(Obs),y0,"-")/h)/pifun(Obs),2,sum)/(h*sum(1/pifun(Obs)))}

kde.outerK0mus<-function(K0,mus){apply(K0/mus,2,sum)/(sum(1/mus))}


#' Compute Pfeffermann like kernel density estimators 
#' @param y0: Point of vector of points where the density estimate is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param .rhohatfun: proxy for rho(y0) 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' kde.inner(y0,Obs)
kde.inner<-function(y0,
                    Obs,
                    ker=kergaus,
                    model,
                    h=ks::hpi(x=model$yfun(Obs)),
                    .rhohatfun=rhohatfun()){
  kde.outer(y0,Obs,pifun=function(obs){1},h=h)/.rhohatfun(y0,Obs)}
#' Compute Pfeffermann like kernel density estimators 
#' @param y0: Point of vector of points where the density estimate is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param .rhohatfun: proxy for rho(y0) 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' kde.inner(y0,Obs)
kde.innerf4Cmu0<-function(f4,Ctilde,mu0){Ctilde*f4/mu0}
Ctildef<-function(mus,pik,Nhat){sum(mus/pik)/Nhat}


#' Compute Pfeffermann like kernel density estimators 
#' @param y0: Point of vector of points where the density estimate is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param .rhohatfun: proxy for rho(y0) 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' Allestimates(y0,Obs,model)


grid1f<-function(model,npoints=300){seq(model$qloi.y(1/(npoints+1)),model$qloi.y(npoints/(npoints+1)),length.out=npoints)}
grid2f<-function(model,npoints=300){model$qloi.y(seq(1/(npoints+1)),(npoints/(npoints+1)),length.out=npoints)}

Allestimates<-function(model,y0=grid1f(model)){
  
  Obs<-generate.observations(model)
  ker=kergaus
  pifun=function(obs){obs$pik}
  h=ks::hpi(x=model$yfun(Obs))
  K0=ker$K(outer(model$yfun(Obs),y0,"-")/h)/h
  Ks=ker$K(outer(model$yfun(Obs),model$yfun(Obs),"-")/h)/h
  SK0=apply(K0,2,sum)
  SKs=apply(Ks,2,sum)
  pik=Obs$pik
  ys=model$yfun(Obs)
  Nhat=sum(1/pik)
  xihat=model$xihat(Obs)
  mus_20=apply(Ks/(Obs$pik),2,sum)/apply(Ks,2,sum)
  mu0_12=mf(yfun = model$yfun,pifun=function(Obs){1/Obs$pik})(y0,Obs)/mf(yfun = model$yfun,pifun=function(Obs){1})(y0,Obs)
  #Ctilde16=Ctildef(mus_20,pik,Nhat)
  
  mus_21=mftheo(model)(ys,Obs)
  mu0_13=mftheo(model)(y0,Obs)
  #Ctilde17=Ctildef(mus_21,pik,Nhat)
  
  mus_22=mftheo(model,xihat)(ys,Obs)
  mu0_14=mftheo(model,xihat)(y0,Obs)
  #Ctilde18=Ctildef(mus_22,pik,Nhat)
  
  #mus_23bad=mfroughreg(yfun=model$yfun)(ys,Obs)
  #mu0_15bad=mfroughreg(yfun=model$yfun)(y0,Obs)
  #Ctilde19bad=Ctildef(mus_23bad,pik,Nhat)
  
  transpi<-(function(x){log(x/(1-x))})(pik)
  mus_23=(function(y){exp(y)/(1+exp(y))})(predict.lm(lm(transpi~ys,weights=1/pik)))
  mu0_15=(function(y){exp(y)/(1+exp(y))})(predict.lm(lm(transpi~ys,weights=1/pik),newdata=data.frame(ys=y0)))
  #Ctilde19=Ctildef(mus_23,pik,Nhat)
  
  mus_25=apply(Ks/(Obs$pik^2),2,sum)/apply(Ks/Obs$pik,2,sum)
  mu0for25=apply(K0/(Obs$pik^2),2,sum)/apply(K0/Obs$pik,2,sum)
  #Ctildefor25=Ctildef(mus_25,pik,Nhat)
  
  transpi2<-(function(x){log(1/x)-1})(pik)
  mus_26=(function(x){exp(-(x+1))})(predict.lm(lm(transpi2~ys,weights=1/pik)))
  mu0for26=(function(x){exp(-(x+1))})(predict.lm(lm(transpi2~ys,weights=1/pik),newdata=data.frame(ys=y0)))
  #Ctildefor26=Ctildef(mus_26,pik,Nhat)
  
  
  
  #naive
  f=model$dloi.y(y0)
  f4=SK0/length(ys)
  if(FALSE){kde.outerK0mus(K0,rep(1,length(ys)))-f4}
  #intersect
  f12<-kde.outerK0mus(K0,pik)
  
  #Compute inner
  
  f20<-kde.outerK0mus(K0,mus_20)         
  f21<-kde.outerK0mus(K0,mus_21)         
  f22<-kde.outerK0mus(K0,mus_22)         
  #f23bad<-kde.outerK0mus(K0,mus_23bad)         
  f23<-kde.outerK0mus(K0,mus_23)
  f25<-kde.outerK0mus(K0,mus_25)         
  f26<-kde.outerK0mus(K0,mus_26)         
  
  #Compute outer
  Chat<-length(ys)/Nhat
  Trapeze<-function(y0,f4,mu){f4/(mu*caTools::trapz(y0,f4/mu))}
  f13   =if(is.null(model$nc)){Trapeze(y0,f4,mu0_13)}else{f4/(mu0_13*model$nc(ys,model$xi,h))}
  f14   =if(is.null(model$nc)){Trapeze(y0,f4,mu0_14)}else{f4/(mu0_14*model$nc(ys,xihat,h))}
  #f15bad=f4*Chat/mu0_15bad
  f15   =Trapeze(y0,f4,mu0_15)
  fhat25   =Trapeze(y0,f4,mu0for25)
  fhat26   =Trapeze(y0,f4,mu0for26)
  
  #f16=kde.innerf4Cmu0(f4,Ctilde16,mu0_12)
  #f17=kde.innerf4Cmu0(f4,Ctilde17,mu0_13)
  #f18=kde.innerf4Cmu0(f4,Ctilde18,mu0_14)
  #f19=kde.innerf4Cmu0(f4,Ctilde19,mu0_15)
  #f19bad=kde.innerf4Cmu0(f4,Ctilde19bad,mu0_15bad)
  #ftilde25=kde.innerf4Cmu0(f4,Ctildefor25,mu0for25)
  #ftilde26=kde.innerf4Cmu0(f4,Ctildefor26,mu0for26)
  
    Vf=varkde.outer(y0,Obs,yfun=model$yfun)
  
  cbind(f=f,
        f4=f4,
        f12=f12,
        f13=f13,
        f14=f14,
        f15=f15,
        #f15bad=f15bad,
        fhat25=fhat25,
        fhat26=fhat26,
        #f16=f16,
        #f17=f17,
        #f18=f18,
        #f19=f19,
        #f19bad=f19bad,
        #ftilde25=ftilde25,
        #ftilde26=ftilde26,
        f20=f20,
        f21=f21,
        f22=f22,
        f23=f23,
        #f23bad=f23bad,
        f25=f25,
        f26=f26,
        Vf=Vf,
        mu0_12=mu0_12,
        mu0_13=mu0_13,
        mu0_14=mu0_14,
        mu0_15=mu0_15,
        mu0for25=mu0for25,
        mu0for26=mu0for26)
}


  

#' Compute Pfeffermann like kernel density estimators 
#' @param y0: Point of vector of points where the density estimate is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param .rhohatfun: proxy for rho(y0) 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' Simuletout(model,Obs,model)

quoi=c("f","f4",
       "f12","f13","f14","f15","f15bad","fhat25",  "fhat26",
       "f16","f17","f18","f19","f19bad","ftilde25","ftilde26",
       "f20","f21","f22","f23","f23bad","f25",     "f26",
       "mu0_12","mu0_13","mu0_14","mu0_15","mu0_15bad","mu0for25","mu0for26",
       "Vf")
equationnumber=c("","(4)",
                "(12)","(13)","(14)","(15)","(15bad)","(hat25)",  "(hat26)",
                "(16)","(17)","(18)","(19)","(19bad)","(tilde25)","(tilde26)",
                "(20)","(21)","(22)","(23)","(23bad)","(25)",     "(26)",
                rep("",8))
joliquoi=c("$f$","$p$",paste0("$",
  rep(c("\\hat{f}","$\\tilde{f}$","f^\\dagger",""),each=7),
  rep(c("_{",""),times=c(21,7)),
  rep(c("\\hat\\mu,\\rm{nonpar}","\\mu,\\xi","\\mu,\\hat\\xi","\\hat\\mu,\\rm{par}","\\hat\\mu,\\rm{par(rough)}","\\hat\\omega,\\rm{nonpar}","\\hat\\omega,\\rm{par}"),times=4),
  rep(c("}$",""),times=c(21,7))),"\\hat{V}")
  
  
  aux<-data.frame(variable=quoi,
                  jolivariable=joliquoi,
                  equationnumber=equationnumber,
                  jolivariable2=paste(equationnumber,joliquoi),
                  type=c("f","p",rep(c("hatf","tildef","fdagger","hatmu"),each=7),"hatV"),
                  jolitype=c("f","$p$",rep(c("$\\hat{f}$","$\\tilde{f}$","$f^\\dagger$","$\\hat\\mu$"),each=7),"$\\hat{V}$"),
                  mu=c("","1",rep(c("$\\hat\\mu,\\rm{nonpar}$","$\\mu,\\xi$","$\\mu,\\hat\\xi$","$\\hat\\mu,\\rm{par}$","$\\hat\\mu,\\rm{par(rough)}$","$\\hat\\omega,\\rm{nonpar}$","$\\hat\\omega,\\rm{par}$"),times=4),"$\\hat{V}$"),
                  mulaid=c("","1",rep(c("nonpar$","xi","xihat","muhatpar","muhatparrough","omeganonpar$","omegapar$"),times=4),"$V$"))

  

Checkdensity<-function(model,npoints){
  attach(model)
  y0=seq(model$qloi.y(1/(npoints+1)),model$qloi.y(npoints/(npoints+1)),length.out=npoints)
  plyr::aaply(Allestimates(model,y0),2,function(y){caTools::trapz(y0,y)})}
  
  
Simuletout<-function(model,npoints=300,y0=grid1f(model,npoints),nrep=1000){
  #library(foreach)
  #library(doParallel)
  #workers <- makeCluster(8) 
  #registerDoParallel(workers)
    #ff<-plyr::aaply(1:nrep,1,function(x,.model=model,.y0=y0){
     # library(pubBonneryBreidtCoquet2017)
    #  Allestimates(.model,.y0)},.parallel=TRUE,.paropts=list(.export=c("y0","model")))

    ff<-plyr::raply(nrep,(function(x,.model=model,.y0=y0){
      Allestimates(.model,.y0)})(),.progress="text")
    
    
    dimnames(ff)[1:2]<-list(1:nrep,1:length(y0))
  names(dimnames(ff))<-c("rep","i","variable")
  list(ff=ff,model=model,y0=y0,nrep=nrep)
}



analysetout<-function(dd){
  attach(dd)  
  A<-reshape2::melt(ff[1:min(50,dim(ff)[1]),,])
  AA<-reshape2::dcast(A,i+rep~variable,value.var="value")
  AAA<-reshape2::dcast(A,i+rep+variable~1,value.var="value")
  AA<-merge(AA,data.frame(i=1:length(y0),y0=y0,ftheta=model$dloi.y(y0)))
  AAA<-merge(AAA,data.frame(i=1:length(y0),y0=y0,ftheta=model$dloi.y(y0)))
  AAA<-merge(AAA,aux,by="variable",all.x=TRUE)
  names(AAA)[names(AAA)==1]<-"value"
  
  empmeanA=plyr::aaply(ff[,,],2:3,mean,na.rm=TRUE)
  empvarA=plyr::aaply(ff[,,],2:3,var,na.rm=TRUE)
  empbias2A=(empmeanA-ff[1,,rep(c("f","mu0_13"),times=c(14,7))])^2
  empmseA=empvarA+empbias2A
  coefvarA=sqrt(empbias2A+empvarA)/ff[1,,"f"]
  
  
  
  empvar=merge(melt(data.frame(y0=y0,empvarA),id="y0"),aux, by="variable", all.x=TRUE)
  empmse=merge(melt(data.frame(y0=y0,empmseA),id="y0"),aux, by="variable", all.x=TRUE)
  avgvarest=data.frame(y0=y0,Vf=plyr::aaply(ff[,,"Vf"],2,mean))
  coefvar=merge(melt(data.frame(y0=y0,coefvarA),id="y0"),aux, by="variable", all.x=TRUE)
  
  interval<-mean(y0[-1]-y0[-length(y0)])
  
  meanempMSE=merge(plyr::ddply(.data = empmse,.variables = ~variable,
                               .fun=function(d){nn<-nrow(d);data.frame(IntegratedMSE=sum(d$value)*interval)}),aux)
  meanempMSE$IntegratedMSErel=meanempMSE$IntegratedMSE/meanempMSE$IntegratedMSE[levels(meanempMSE$variable)[meanempMSE$variable]=="f12"]
  
  empmse$class<-cut(empmse$y0,breaks = model$qloi.y(c(0:4)/4))
  levels(empmse$class)=c("$Y<q_{.25}$","$q_{.25}<Y<q_{.5}$","$q_{.5}<Y<q_{.75}$","$q_{.75}<Y$")
  meanempMSEq=merge(plyr::ddply(.data = empmse,.variables = ~class+variable,
                                .fun=function(d){nn<-nrow(d);if(nn>0){
                                  #data.frame(IntegratedMSEq=sum(d$value[-nn]*model$dloi.y(d$y0[-nn])*(c(d$y0[-1]-d$y0[-nn]))))
                                  data.frame(IntegratedMSEq=sum(d$value)*  interval)
                                }else{data.frame(IntegratedMSEq=0)}},.drop=FALSE),aux)
  
  ref=meanempMSEq[levels(meanempMSEq$variable)[meanempMSEq$variable]=="f12",c("class","IntegratedMSEq")]
  names(ref)[2]<-"ref"
  meanempMSEq=merge(meanempMSEq,ref)
  meanempMSEq$IntegratedMSErelq=meanempMSEq$IntegratedMSE/meanempMSEq$ref
  meanempMSEq=reshape2::dcast(reshape2::melt(meanempMSEq,measure.vars =c("IntegratedMSEq","IntegratedMSErelq"),variable.name = "measure") ,formula = variable+jolivariable2+jolitype+mu~measure+class,value.var="value")
  
  meanempMSE=merge(meanempMSE,meanempMSEq)
  ee=list(npoints=length(y0),model=model,empmeanA=empmeanA,meanempMSE=meanempMSE,model=model,y0=y0,nrep=nrep,AA=AA,AAA=AAA,empvar=empvar,empmse=empmse,avgvarest=avgvarest,coefvar=coefvar)
  return(ee)
}




allplots<-function(ee,scale_colour_function1=ggplot2::scale_colour_grey){
  attach(ee)
  
  sel=(1:npoints)[(1:npoints)%%(npoints%/%100)==1]
  
  theme_set(theme_bw())
  w_graph_0<-ggplot(AAA[(!is.element(AAA$variable,c("f15bad","f19bad","f23bad","Vf")))&AAA$rep==2,], 
                   aes(x=y0, y=value, linetype=mu,color=jolitype)) +
    xlab("$y_0$")+ylab("")+
    scale_colour_grey()+ 
    theme_bw()+
    geom_line()+ 
    labs(title="", caption=paste0(model$name,':  estimators of $f$'))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+
    stat_function(fun = model$dloi.y,size=.8,aes(size=.8,color="$f$",linetype="$f$"))+
    theme(legend.position = "right",legend.box = "vertical") + 
    theme(legend.key.size = unit(2,"line"))+ 
    guides(linetype=guide_legend(""),color=guide_legend(""))
  
  
  w_graph_0.2<-ggplot(AAA[is.element(AAA$variable,quoi[2:3])&AAA$rep==2,], 
                    aes(x=y0, y=value, linetype=jolivariable)) +
    xlab("$y_0$")+ylab("")+
    scale_colour_function1()+ 
    theme_bw()+
    geom_line()+ 
    labs(title="", caption=paste0(model$name,': $p$, $\\hat{f}_{\\hat\\mu,\\rm{nopar}}$, and $f$'))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+
    stat_function(fun = model$dloi.y,size=.8,aes(size=.8,linetype="$f$"))+
    theme(legend.position = "right",legend.box = "vertical") + 
    theme(legend.key.size = unit(2,"line"))+ 
    guides(linetype=guide_legend(""))
  
  
  
  w_graph_0_vsf <- function(x,variab="mu",variab2="jolitype"){
    tab=AAA[(!is.element(AAA$variable,c("f","f4","f15bad","f19bad","f23bad","mu0_12","mu0_13","mu0_14","mu0_15","mu0for25","mu0for26","Vf")))&AAA$rep==2,]
    tab$tretre=tab[[variab]]
    tab$trotro=tab[[variab2]]
    try(tab$ftheta[tab$ftheta<1e-10]<-1e-10)
        try(tab$value[is.na(tab$value)]<-1e-10)
            try(tab$value[tab$value<1e-10]<-1e-10)
    
    ggplot(tab[levels(tab$tretre)[tab$tretre]==x,], 
           aes(x=y0, y=value,linetype=trotro,color=trotro)) +
      scale_colour_function1()+ 
      xlab("$y_0$")+ylab("")+
      theme_bw()+
      geom_line()+ 
      stat_function(fun = model$dloi.y,size=.8,aes(size=.8,color="$f$",linetype="$f$"))+
      labs(title="", caption=paste0(model$name,': "',x,'"-type estimators of $f$'))+
      theme(legend.position = "right",legend.box = "vertical") + 
      theme(legend.key.size = unit(2,"line"))+ 
      guides(linetype=guide_legend(""),color=guide_legend(""))
      }
  w_graph_0_vsmus<-plyr::alply(levels(empmse$mu)[!is.element(levels(empmse$mu),c("$\\hat\\mu,\\rm{par(rough)}$","$\\hat{V}$","","1"))],1,w_graph_0_vsf)
  names(w_graph_0_vsmus)<-paste0("w_graph_0_vsmu",(1:(nlevels(empmse$mu)))[!is.element(levels(empmse$mu),c("$\\hat\\mu,\\rm{par(rough)}$","$\\hat{V}$","","1"))])
  w_graph_0_vstypes<-plyr::alply(levels(empmse$jolitype)[!is.element(levels(empmse$jolitype),c("$\\hat\\mu$","$\\hat{V}$","$\\tilde{f}$","$p$","f"))],1,w_graph_0_vsf,variab="jolitype",variab2="mu")
  names(w_graph_0_vstypes)<-paste0("w_graph_0_vsmu",(1:nlevels(empmse$jolitype))[!is.element(levels(empmse$jolitype),c("$\\hat\\mu$","$\\hat{V}$","$\\tilde{f}$","$p$","f"))])


  
  
  
  
  dff2<-reshape2::dcast(
    AAA[is.element(AAA$variable,c("f12","Vf"))&AAA$rep==1,]
    ,i+y0+ftheta~variable,value.var="value")
  dff2$lb=dff2$f12-qnorm(.975)*sqrt(dff2$Vf)
  dff2$ub=dff2$f12+qnorm(.975)*sqrt(dff2$Vf)
  
  w_graph_0.1<-ggplot(dff2, 
                   aes(x=y0, y=f12,linetype="$\\hat{f}_{\\hat\\mu,\\rm{nonpar}}$")) +
    xlab("$y_0$")+ylab("")+
    scale_colour_function1()+ 
    theme_bw()+
    geom_line()+ 
    stat_function(fun = model$dloi.y,size=.8,aes(size=.8,linetype="$f$"))+
    geom_ribbon(aes(ymin=lb, ymax=ub, x=y0,fill="$\\hat{f}_{\\hat\\mu,\\rm{nonpar}}$"), alpha = 0.3, colour=NA,show.legend=F)+ 
    labs(title="", caption=paste0(model$name,':  Confidence interval for $\\hat{f}_{\\hat\\mu,\\rm{nonpar}}$'))+
    theme(legend.position = "right",legend.box = "vertical") + 
    theme(legend.key.size = unit(2,"line"))+
    guides(linetype=guide_legend(""),color=guide_legend(""))+
    scale_fill_manual("",values=c("gray",NA,"gray"))
  
  
  w_graph1f <- function(x){
    BB=AA[AA$rep<50 &is.element(AA$i,sel),c("y0",x,"rep")]
    names(BB)<-c("y0","est","Rep")
    joliname=aux$jolivariable2[aux$variable==x]
    
    ggplot(BB, aes(x=y0, y=est, group=Rep)) +
    scale_colour_function1("")+
    xlab("$y_0$")+ylab("")+
    geom_line(size=0.2, alpha=0.1,aes(linetype=joliname,size=.2))+ 
    labs(title="", caption=paste0("Simulations for ",model$name,", ",joliname ," repeated ",min(nrep,50), " times"))+    
    geom_line(data=data.frame(y0=y0,f=empmeanA[,x]),aes(x=y0,y=f,group=NULL,linetype=paste0(joliname,", averaged on ",nrep," replications")),size=1)  +
    stat_function(fun = model$dloi.y,size=.4,aes(size=.4,linetype="$f$"))+
    scale_linetype_manual("",values = c("solid",  "solid","dashed")) +
    scale_size_manual(values = c(0.4, .2,1))+
    theme(legend.position = "bottom")+ 
    theme(legend.key.size = unit(2,"line"))+
    guides(size=FALSE, linetype=guide_legend(override.aes=list(size=c(.4,.2,1),alpha=c(1,.1,1))))}
  w_graph_1s<-plyr::alply(c("f4","f12","f13","f14","f15","fhat25","fhat26","f20","f21","f22","f23","f25","f26"),1,w_graph1f)
  names(w_graph_1s)<-paste0("w_graph1_",c("f4","f12","f13","f14","f15","fhat25","fhat26","f20","f21","f22","f23","f25","f26"))
  
  w_graph2 <- ggplot(AA[AA$rep<50 &(is.element(AA$i,sel)),], aes(x=y0, y=Vf, group=rep)) +
  xlab("$y_0$")+ylab("")+
    geom_line(size=0.2, alpha=0.1,aes(linetype="$\\hat{V}$"))+
    labs(title="", caption=paste0("Empirical variance and variance estimates, simulations for ",model$name,", repeated ",min(50,nrep), " times"))+  
    geom_line(data=empvar[empvar$variable=="f12",],aes(x=y0,y=value,group=NULL,linetype="Empirical variance"), size=.8)+
    geom_line(data=avgvarest,aes(x=y0,y=Vf,group=NULL,linetype="$\\hat{V}$, averaged on ",nrep," replications"),size=.8)+
    scale_linetype_manual("",values = c("solid",  "solid","dashed")) +
    scale_size_manual(values = c(0.4, .2,1))+
    theme(legend.position = "bottom")+ 
    theme(legend.key.size = unit(2,"line"))+
    guides(size=FALSE, linetype=guide_legend(override.aes=list(size=c(.4,.2,1),alpha=c(1,.1,1))))
  
  
  
  
  
  
  
  w_graph_var <- ggplot(empvar[is.element(empvar$variable,quoi[-c(1,23)]),], 
                        aes(x=y0, y=value, linetype=mu,color=jolitype)) +
    xlab("$y_0$")+ylab("")+
    scale_colour_function1()+ 
    theme_bw()+
    geom_line()+ 
    labs(title="", caption=paste0("Empirical variance, simulations for ",model$name,", obtained for ",nrep," replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()+
    theme(legend.position = "right",legend.box = "vertical") + 
    theme(legend.key.size = unit(2,"line"))+ 
    guides(linetype=guide_legend(""),color=guide_legend(""))
  
  w_graph_mse_vsf <- function(x,variab="mu",variab2="jolitype"){
    tab=empmse[(!is.element(empmse$variable,c("f4","f15bad","f19bad","f23bad","Vf"))),]
    tab$tretre=tab[[variab]]
    tab$trotro=tab[[variab2]]
    try(tab$value[is.na(tab$value)]<-1e-10)
    try(tab$value[tab$value<1e-10]<-1e-10)
    
    ggplot(tab[levels(tab$tretre)[tab$tretre]==x,], 
                                   aes(x=y0, y=value,linetype=trotro)) +
    scale_colour_function1()+ 
      xlab("$y_0$")+ylab("")+
      theme_bw()+
    geom_line()+ 
    labs(title="", caption=paste0(model$name,": Emp. MSE, ",x,", ",nrep," replications"))+
    scale_y_log10()+
          theme(legend.position = "right",legend.box = "vertical") + 
            theme(legend.key.size = unit(2,"line"))+ 
            guides(linetype=guide_legend(""),color=guide_legend(""))
  }
  w_graph_mse_vsmus<-plyr::alply(levels(empmse$mu)[levels(empmse$mu)!="$\\hat\\mu,\\rm{par(rough)}$"],1,w_graph_mse_vsf)
  names(w_graph_mse_vsmus)<-paste0("w_graph_mse_vsmu",1:(nlevels(empmse$mu)-1))
  w_graph_mse_vstypes<-plyr::alply(levels(empmse$jolitype),1,w_graph_mse_vsf,variab="jolitype",variab2="mu")
  names(w_graph_mse_vstypes)<-paste0("w_graph_mse_vsmu",1:nlevels(empmse$jolitype))
  
  
  
  
  w_graph_mse_final <- ggplot(empmse[is.element(empvar$C,c("NA","tilde")),], 
                              aes(x=y0, y=value, linetype=mu,color=jolitype)) +
    scale_colour_function1()+ 
    theme_bw()+
    geom_line()+ 
    ggtitle(paste0("Empirical MSE for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  pp=c(list(w_graph_0=w_graph_0,
            w_graph_0.1=w_graph_0.1,
            w_graph2=w_graph2,w_graph_var=w_graph_var),
       w_graph_1s,
       w_graph_mse_vsmus,
       w_graph_mse_vstypes,
       w_graph_0_vsmus,
       w_graph_0_vstypes)
  
  return(pp)
}















#' @param Obs: 
#' @example
pifun0<-function(Obs){Obs$pik}


#' @param xihat: a function of obs  
#' @param eta: a function of obs and xi
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' eta<-function(obs,xi){conditionalto$sampleparam$tauh[1]+(conditionalto$sampleparam$tauh[2]-conditionalto$sampleparam$tauh[1])*obs$y^(-xi)}
#' xihat<-model$xihat
#' Obs<-generate.observations(model);
#' kde.outer(y0,Obs)
#' #1. kde for rho*f in the numerator, known pi with known xi in the denominator. (infeasible)
#' kde.outer(y0,Obs,pifun=hatetafunf(xihat=function(obs){xi},eta=eta))
#' #2. kde for rho*f in the numerator, known pi  with design-weighted estimates of xi in the denominator. (sometimes feasible)
#' kde.outer(y0,Obs,pifun=hatetafunf(xihat=xihat,eta=eta))
hatetafunf<-function(xihat=function(Obs){1},eta=function(Obs,xi){Obs$pik}){function(obs){eta(obs,xihat(obs))}}

#' @param xihat: a function of obs  
#' @param eta: a function of obs and xi
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' eta<-function(obs,xi){conditionalto$sampleparam$tauh[1]+(conditionalto$sampleparam$tauh[2]-conditionalto$sampleparam$tauh[1])*obs$y^(-xi)}
#' xihat<-model$xihat
#' Obs<-generate.observations(model);

#' #3. kde for rho*f in the numerator, unknown pi estimated via design-weighted parametric methods in the denominator. (feasible)
#' kde.outer(y0,Obs,pifun=hatetafunf2)
#' #4. kde for rho*f in the numerator, unknown pi estimated via design-weighted nonparametric methods in the denominator. 
#' # (This is equivalent to Hajek if we use design-weighted Nadaraya-Watson estimator of pi in denominator. )
#' kde.outer(y0,Obs)
hatetafunf2<-function(obs,yfun=function(obs){obs$y}){y=yfun(obs);predict.lm(object=lm(obs$pi~y,weights = 1/obs$pi))}

#' # We could also consider the following product-type alternatives, again normalizing at the end to get a density, if needed: 
#' # kde for rho*f multiplied by estimator of (1/ pi) estimated via design-weighted parametric methods, regressing 1/pi on y

#' # kde for rho*f multiplied by estimator of (1/ pi) estimated via design-weighted nonparametric methods 
#' # (design-weighted Nadaraya-Watson estimate of 1/pi)




#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=1.5
#' .Obs<-generate.observations(model);
#'varkde.outer0(y0,Obs)
#'
varkde.outer0<-function(y0,.Obs,.ker=kergaus,.yfun=function(obs){obs$y},.h=ks::hpi(x=.yfun(.Obs))){
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
#' varkde.outer(y0,Obs)
varkde.outer <-function(Y0, Obs, ker=kergaus,yfun=function(obs){obs$y}, h=ks::hpi(x= yfun(Obs))){
  sapply(Y0,FUN=varkde.outer0,.Obs=Obs,.ker=ker,.yfun=yfun,.h=h)}

p   <-function(y0,Obs,b,ker=ker,model,N){sapply(y0,p0,Obs=Obs,b=b,ker=ker,model=model)}
p2  <-function(y0,Obs,b,ker=ker,model,N){as.vector(kde(model$yfun(Obs),hpi(x=model$yfun(Obs))/2,eval.points=y0)$estimate)}
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


createallgraphs<-function(x){
  y=load(x)
  prefix<-basename(x)
  prefix<-strsplit(prefix,".",fixed = TRUE)[[1]][1]
  
  #pdf(paste0("datanotpushed/graphs/pdf/",prefix,".pdf"))
  #try(eval(parse(text=paste0("print(",y,")"))))
  #dev.off()
  
  tikz(paste0("datanotpushed/graphs/texyihui/",prefix,"_yihui.tex"),standAlone = TRUE,sanitize=FALSE)
  try(eval(parse(text=paste0("print(",y,")"))))
  dev.off()
  
  tx  <- readLines(paste0("datanotpushed/graphs/texyihui/",prefix,"_yihui.tex"))
  tx  <- c(tx[3],"\\usepackage{pgfplots}","\\usepgfplotslibrary{external}","\\tikzexternalize", tx[-(1:4)])
  writeLines(tx, paste0("datanotpushed/graphs/texyihui/",prefix,"_yihui.tex"))
  
  
  try(system(paste0( "pdflatex -shell-escape -interaction=nonstopmode datanotpushed/graphs/texyihui/",prefix,"_yihui.tex")))
  try(system(paste0("mv ",prefix,"_yihui.pdf datanotpushed/graphs/pdfyihui/")))
  
  
  Y=get(y)
  attach(Y)
  sapply(names(Y),function(z){
    png(paste0("datanotpushed/graphs/png/",prefix,z,".png"))
    try(eval(parse(text=paste0("print(",z,")"))))
    dev.off()
    
    tikz(paste0("datanotpushed/graphs/texyihui/",prefix,z,"_yihui.tex"),standAlone = FALSE)
    try(eval(parse(text=paste0("print(",z,")"))))
    dev.off()
    
    
  })
}

createalltables<-function(ee){

  
  ddd=ee$meanempMSE[-nrow(ee$meanempMSE),]
  ddd[!is.element(ddd$variable,c("f15bad","f19bad","f23bad")),]
  names(ddd)<-gsub("IntegratedMSE","IMSE",names(ddd),fixed=TRUE)
  ccoo<-function(x,y){paste0(signif(ddd[[x]],2)," (",signif(ddd[[y]],2),")")}
  ddd[[5]]=ccoo(5,10)
  for(i in 1:4){ddd[[10+i]]=ccoo(10+i,14+i)}
  ddd=ddd[-c(1,3:4,6:10,15:18)]
  names(ddd)<-gsub("q_$"," $\\mid ",names(ddd),fixed=TRUE)
  names(ddd)<-gsub("jolivariable2","Estimator",names(ddd),fixed=TRUE)
  
  y=SweaveLst::stargazer2(ddd,summary=FALSE,style="aer",title=ee$model$name,label=paste0("tab",ee$model$name),rownames=FALSE)
  y=gsub("\\\\","\\",y,fixed=TRUE);cat(y)
  cat(capture.output(cat(y)),file=file.path("datanotpushed/table",paste0(tolower(gsub(" ", "",ee$model$name, fixed = TRUE)),".tex")),append=FALSE)
  
  try(system("cd datanotpushed/table;pdflatex -shell-escape -interaction=nonstopmode tables.tex"))
  return(ddd)
  }
