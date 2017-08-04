# model0 a default object of class model
model0<-list(yfun=function(obs){obs$y},
             pifun=function(obs){obs$pik},
             xi=NULL,
             theta=NULL,
             contitionalto=list(sampleparam=NULL,N=NULL),
             xihat=function(...){NULL})
append(class(model0),"Model")
##4.1. Definitions
# Kernels
kergaus<-list(K=dnorm,intK2=(1/(2*sqrt(pi))));
ker<-kergaus


#' Compute an estimate of E[I\mid Y=y0] 
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param afun: Function that takes Obs as an argument and returns inverses of weights for units on the sample 
#' @param h: Bandwidth
#' @example
#' model=modelf(1)
#' y0<-grid1f(model,100)
#' plot(y0,mf(model)(y0,generate.observations(model)),type='l')
  mf<-function(model=model0,ker=kergaus,yfun=model$yfun,afun=model$pifun){
  function(y0,Obs,h=ks::hpi(x=yfun(Obs))){apply(ker$K(outer(yfun(Obs),y0,"-")/h),2,sum)/apply(ker$K(outer(yfun(Obs),y0,"-")/h)/afun(Obs),2,sum)}}


#' Compute an estimate of E[I\mid Y=y0] of the form $m(y,\hat{\xi})$ 
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param afun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' model=modelf(1)
#' y0<-grid1f(model,100)
#' plot(y0,mftheo(model)(y0,generate.observations(model)),type='l')
mftheo   <-function(model=model0,xi=model$xi){function(y0,Obs){model$eta(model$obsifyf(y0),.xi=xi)}}
#' Compute an estimate of E[I\mid Y=y0] of the form $m(y,\hat{\xi})$ 
#' @param y0: Point of vector of points where the conditional expected value is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param afun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' model<-modelf(1)popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' (mfhattheo(model))(1:3,Obs)
mfhattheo<-function(model=model0,
                    xihatfun=model$xihat){
  function(y0,Obs){model$eta(model$obsifyf(y0),.xi=xihatfun(Obs))}}

#' Compute HT-like kernel density estimates 
#' @param y0: Point of vector of points where the density estimate is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param afun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' popmodelfunction = model.Pareto.bernstrat
#' theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
#' model<-popmodelfunction(theta,xi,conditionalto);y0=c(.5,1,1.5)
#' Obs<-generate.observations(model);
#' kde.outer(y0,Obs)
#' kde.outer(1,Obs)
kde.outer<-function(y0,
                    Obs,
                    model,
                    ker=kergaus,
                    yfun=model$yfun,
                    afun=model$pifun,
                    h=ks::hpi(x=yfun(Obs))){
  apply(ker$K(outer(yfun(Obs),y0,"-")/h)/afun(Obs),2,sum)/(h*sum(1/afun(Obs)))}

kde.outerK0mus<-function(K0,mus){apply(K0/mus,2,sum)/(sum(1/mus))}


Trapeze<-function(y0,f4,mu){f4/(mu*caTools::trapz(y0,f4/mu))}


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
                    model=model0,
                    ker=kergaus,
                    h=ks::hpi(x=model$yfun(Obs)),
                    .rhohatfun=rhohatfunf()){
  kde.outer(y0,Obs,model=NULL,afun=function(obs){1},h=h)/.rhohatfun(y0,Obs)}
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


grid1f<-function(model,npoints=300){seq(model$qloi.y(1/(npoints+1)),model$qloi.y(npoints/(npoints+1)),length.out=npoints)}
grid2f<-function(model,npoints=300){model$qloi.y(seq(1/(npoints+1)),(npoints/(npoints+1)),length.out=npoints)}


#' Compute Pfeffermann like kernel density estimators 
#' @param Model: object of class model
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
#' Allestimates(model,Obs,y0)
Allestimates<-function(model,  Obs=generate.observations(model),y0=grid1f(model),ker=kergaus,h=ks::hpi(x=model$yfun(Obs))){
  K0=ker$K(outer(model$yfun(Obs),y0,"-")/h)/h
  Ks=ker$K(outer(model$yfun(Obs),model$yfun(Obs),"-")/h)/h
  SK0=apply(K0,2,sum)
  SKs=apply(Ks,2,sum)
  pik=model$pifun(Obs)
  ys=model$yfun(Obs)
  Nhat=sum(1/pik)
  xihat=model$xihat(Obs)
  
  mus_20=apply(Ks,2,sum)/apply(Ks/(Obs$pik),2,sum)
  mu0_12=mf(yfun = model$yfun,afun=function(Obs){1})(y0,Obs)/mf(yfun = model$yfun,afun=function(Obs){1/Obs$pik})(y0,Obs)
  #Ctilde16=Ctildef(mus_20,pik,Nhat)
  
  mus_21=mftheo(model)(ys,Obs)
  mu0_13=mftheo(model)(y0,Obs)
  #Ctilde17=Ctildef(mus_21,pik,Nhat)
  
  mus_22=mftheo(model,xihat)(ys,Obs)
  mu0_14=mftheo(model,xihat)(y0,Obs)
  #Ctilde18=Ctildef(mus_22,pik,Nhat)
  
  #mus_23bad=mfroughreg(model)(ys,Obs)
  #mu0_15bad=mfroughreg(model)(y0,Obs)
  #Ctilde19bad=Ctildef(mus_23bad,pik,Nhat)
  
  transpi<-(function(x){log(x/(1-x))})(pik)
  mus_23=(function(y){exp(y)/(1+exp(y))})(predict.lm(lm(transpi~ys,weights=1/pik)))
  mu0_15=(function(y){exp(y)/(1+exp(y))})(predict.lm(lm(transpi~ys,weights=1/pik),newdata=data.frame(ys=y0)))
  #Ctilde19=Ctildef(mus_23,pik,Nhat)
  
  mus_25=apply(Ks/Obs$pik,2,sum)/apply(Ks/(Obs$pik^2),2,sum)
  mu0for25=apply(K0/Obs$pik,2,sum)/apply(K0/(Obs$pik^2),2,sum)
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
  
    Vf=varkde.outer(model,y0,Obs)
  
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
varkde.outer <-function(model,y0, Obs, ker=kergaus,yfun=model$yfun, h=ks::hpi(x= yfun(Obs))){
  sapply(y0,FUN=varkde.outer0,.Obs=Obs,.ker=ker,.yfun=yfun,.h=h)}

