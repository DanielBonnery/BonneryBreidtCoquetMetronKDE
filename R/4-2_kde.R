#' generate observations according to a population and design model
#' @param model: a model object, as defined by modelf
#' @example
#' generate.observations(modelf(1))
generate.observations<-
function (model) 
{
  Y <- model$rloiy()
  Z <- model$rloiz(Y)
  S <- model$Scheme$S(Z)
  Pik <- model$Scheme$Pik(Z)
  list(y = as.matrix(Y)[S, ], z = as.matrix(Z)[S, ], pik = Pik[S],m=mean(model$yfun(list(y=as.matrix(Y)))),N=model$conditionalto$N,n=length(S))
}
#' model0 a default object of class model
model0<-list(yfun=function(obs){obs$y},
             pifun=function(obs){obs$pik},
             xi=NULL,
             theta=NULL,
             contitionalto=list(sampleparam=NULL,N=NULL),
             xihat=function(...){NULL})
append(class(model0),"Model")
##4.1. Definitions
# Kernels

#' Gaussian kernel
kergaus<-list(K=dnorm,intK2=(1/(2*sqrt(pi))));
ker<-kergaus

#' Compute an estimate of E[I\mid Y=y0] 
#' @param model: a model
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param afun: Function that takes Obs as an argument and returns inverses of weights for units on the sample 
#' @example
#' model=modelf(1)
#' y0<-grid1f(model,100)
#' plot(y0,mf(model)(y0,generate.observations(model)),type='l')
  mf<-function(model=model0,ker=kergaus,yfun=model$yfun,afun=model$pifun){
  function(y0,Obs,h=ks::hpi(x=yfun(Obs))){apply(ker$K(outer(yfun(Obs),y0,"-")/h),2,sum)/apply(ker$K(outer(yfun(Obs),y0,"-")/h)/afun(Obs),2,sum)}}

#' Compute an estimate of E[I\mid Y=y0] of the form $m(y,\hat{\xi})$ 
#' @param model: a model
#' @param xi: a value for the xi parameter of the model
#' @example
#' model=modelf(1)
#' y0<-grid1f(model,100)
#' plot(y0,mftheo(model)(y0,generate.observations(model)),type='l')
mftheo   <-function(model=model0,xi=model$xi){function(y0,Obs){model$eta(model$obsifyf(y0),.xi=xi)}}
#' Compute an estimate of E[I\mid Y=y0] of the form $m(y,\hat{\xi})$ 
#' @param model: a model
#' @param xihatfun: an estimator of xi (a function of Obs)
#' @example
#' model=modelf(1)
#' y0<-grid1f(model,100)
#' plot(y0,mfhattheo(model)(y0,generate.observations(model)),type='l')

mfhattheo<-function(model=model0,
                    xihatfun=model$xihat){
  function(y0,Obs){mftheo(model,xihatfun(Obs))(y0,Obs)}}

#' Compute HT-like kernel density estimates 
#' @param y0: Point of vector of points where the density estimate is needed
#' @param Obs: Observations
#' @param ker: kernel function
#' @param yfun: Function that takes Obs as argument and returns the list of $y$s
#' @param afun: Function that takes Obs as an argument and returns the weights on the sample 
#' @param h: Bandwidth
#' @example
#' model<-modelf(1)
#' Obs<-generate.observations(model);
#' kde.outer(grid1f(model,10),Obs,model)
kde.outer<-function(y0,
                    Obs,
                    model,
                    ker=kergaus,
                    yfun=model$yfun,
                    afun=model$pifun,
                    h=ks::hpi(x=yfun(Obs))){
  apply(ker$K(outer(yfun(Obs),y0,"-")/h)/afun(Obs),2,sum)/(h*sum(1/afun(Obs)))}

#' Compute outer  kernel density estimates from Kernels applied to all differences between observed values and grid points, and values of mu on the sample 
#' @param K0: a matrix
#' @param mu: a vector of length dim(K0)[1]
#' @example
#' model<-modelf(1)
#' Obs<-generate.observations(model);
#' h=ks::hpi(x=model$yfun(Obs))
#' K0=ker$K(outer(model$yfun(Obs),y0,"-")/h)/h
#' mus=mftheo(model)(model$yfun(Obs),Obs)
#' kde.outerK0mus(K0,mus)
kde.outerK0mus<-function(K0,mus){apply(K0/mus,2,sum)/(sum(1/mus))}

#' Method to normalise $f/\mu$ so that the trapeze approximation of  $\int f(y) d(y)$ is equal to 1.
#' @param y0: Point of vector of points where the density estimate is needed
#' @param f0: a vector of same length than y0
#' @param mu0: a vector of same length than y0
#' @example
#' model<-modelf(1)
#' Obs<-generate.observations(model);
#' h=ks::hpi(x=model$yfun(Obs))
#' y0=grid1f(model)
#' SK0=apply(ker$K(outer(model$yfun(Obs),y0,"-")/h)/h,2,sum)
#' f_naive=SK0/length(model$yfun(Obs))
#' mu0=mftheo(model)(y0,Obs)
#' caTools::trapz(y0,Trapeze(y0,f_naive,mu0))
Trapeze<-function(y0,f0,mu0){f0/(mu0*caTools::trapz(y0,f0/mu0))}
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
kde.innerf_naiveCmu0<-function(f_naive,Ctilde,mu0){Ctilde*f_naive/mu0}


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
Allkdeestimates<-function(model,  Obs=generate.observations(model),y0=grid1f(model),ker=kergaus,h=ks::hpi(x=model$yfun(Obs))){
  K0=ker$K(outer(model$yfun(Obs),y0,"-")/h)/h
  Ks=ker$K(outer(model$yfun(Obs),model$yfun(Obs),"-")/h)/h
  SK0=apply(K0,2,sum)
  SKs=apply(Ks,2,sum)
  pik=model$pifun(Obs)
  ys=model$yfun(Obs)
  Nhat=sum(1/pik)
  xihat=model$xihat(Obs)
  
  mus_nonpar=apply(Ks,2,sum)/apply(Ks/(Obs$pik),2,sum)
  mu0_nonpar=mf(yfun = model$yfun,afun=function(Obs){1})(y0,Obs)/mf(yfun = model$yfun,afun=function(Obs){1/Obs$pik})(y0,Obs)

  mus_parxi=mftheo(model)(ys,Obs)
  mu0_parxi=mftheo(model)(y0,Obs)

  mus_parxihat=mftheo(model,xihat)(ys,Obs)
  mu0_parxihat=mftheo(model,xihat)(y0,Obs)

  transpi<-(function(x){log(x/(1-x))})(pik)
  mus_muhat=(function(y){exp(y)/(1+exp(y))})(predict.lm(lm(transpi~ys,weights=1/pik)))
  mu0_muhat=(function(y){exp(y)/(1+exp(y))})(predict.lm(lm(transpi~ys,weights=1/pik),newdata=data.frame(ys=y0)))

  mus_wnonpar=apply(Ks/Obs$pik,2,sum)/apply(Ks/(Obs$pik^2),2,sum)
  mu0_wnonpar=apply(K0/Obs$pik,2,sum)/apply(K0/(Obs$pik^2),2,sum)

  transpi2<-(function(x){log(1/x)-1})(pik)
  mus_wpar=(function(x){exp(-(x+1))})(predict.lm(lm(transpi2~ys,weights=1/pik)))
  mu0_wpar=(function(x){exp(-(x+1))})(predict.lm(lm(transpi2~ys,weights=1/pik),newdata=data.frame(ys=y0)))

  #naive
  f=model$dloi.y(y0)
  f_naive=SK0/length(ys)
  if(FALSE){kde.outerK0mus(K0,rep(1,length(ys)))-f_naive}
  #intersect
  f_inner_nonpar<-kde.outerK0mus(K0,pik)
  
  #Compute outer
  f_outer_nonpar  <-kde.outerK0mus(K0,mus_nonpar)         
  f_outer_parxi   <-kde.outerK0mus(K0,mus_parxi)         
  f_outer_parxihat<-kde.outerK0mus(K0,mus_parxihat)         
  f_outer_muhat<-kde.outerK0mus(K0,mus_muhat)
  f_outer_wnonpar<-kde.outerK0mus(K0,mus_wnonpar)         
  f_outer_wpar<-kde.outerK0mus(K0,mus_wpar)         
  
  #Compute inner
  
  f_inner_parxi      =if(is.null(model$nc)){Trapeze(y0,f_naive,mu0_parxi)}else{f_naive/(mu0_parxi*model$nc(ys,model$xi,h))}
  f_inner_parxihat   =if(is.null(model$nc)){Trapeze(y0,f_naive,mu0_parxihat)}else{f_naive/(mu0_parxihat*model$nc(ys,xihat,h))}
  f_inner_muhat      =Trapeze(y0,f_naive,mu0_muhat)
  f_inner_wnonpar          =Trapeze(y0,f_naive,mu0_wnonpar)
  f_inner_wpar             =Trapeze(y0,f_naive,mu0_wpar)
  

    Vf=varkde.outer(model,y0,Obs)
  
  cbind(f=f,
        f_naive         =f_naive,
        f_inner_nonpar  =f_inner_nonpar,
        f_inner_parxi   =f_inner_parxi,
        f_inner_parxihat=f_inner_parxihat,
        f_inner_muhat   =f_inner_muhat,
        f_inner_wnonpar =f_inner_wnonpar,
        f_inner_wpar    =f_inner_wpar,
        f_outer_nonpar  =f_outer_nonpar,
        f_outer_parxi   =f_outer_parxi,
        f_outer_parxihat=f_outer_parxihat,
        f_outer_muhat   =f_outer_muhat,
        f_outer_wnonpar =f_outer_wnonpar,
        f_outer_wpar    =f_outer_wpar,
        Vf              =Vf,
        mu0_nonpar      =mu0_nonpar,
        mu0_parxi      =mu0_parxi,
        mu0_parxihat   =mu0_parxihat,
        mu0_muhat      =mu0_muhat,
        mu0_wnonpar    =mu0_wnonpar,
        mu0_wpar       =mu0_wpar)

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

quoi=c("f","f_naive",
       c(outer(c( "nonpar","parxi","parxihat","muhat","wnonpar","wpar"),
               c("f_outer","f_inner","mu0"),
               function(x,y){paste(y,x,sep="_")})),
       "Vf")
equationnumber=c("","(4)",
                "(11)","(12)","(13)","(14)","(17)",     "(18)",
                "(22)","(23)","(24)","(25)","(26)",  "(27)",
                rep("",7))
joliquoi=c("$f$","$p$",paste0("$",
  rep(c("\\hat{f}","f^\\dagger",""),each=6),
  rep(c("_{",""),times=c(12,6)),
  rep(c("\\hat\\mu,\\rm{nonpar}","\\mu,\\xi","\\mu,\\hat\\xi","\\hat\\mu,\\rm{par}","\\hat\\omega,\\rm{nonpar}","\\hat\\omega,\\rm{par}"),times=3),
  rep(c("}$","$"),times=c(12,6))),"$\\hat{V}$")
  
  
  aux<-data.frame(variable=quoi,
                  jolivariable=joliquoi,
                  equationnumber=equationnumber,
                  jolivariable2=paste(joliquoi,equationnumber),
                  type=c("f","p",rep(c("hatf","fdagger","hatmu"),each=6),"hatV"),
                  jolitype=c("$f$","$p$",rep(c("$\\hat{f}$","$f^\\dagger$","$\\hat\\mu$"),each=6),"$\\hat{V}$"),
                  mu=c("","1",rep(c("$\\hat\\mu,\\rm{nonpar}$","$\\mu,\\xi$","$\\mu,\\hat\\xi$","$\\hat\\mu,\\rm{par}$","$\\hat\\omega,\\rm{nonpar}$","$\\hat\\omega,\\rm{par}$"),times=3),"$\\hat{V}$"),
                  mulaid=c("","1",rep(c("nonpar$","xi","xihat","muhatpar","omeganonpar$","omegapar$"),times=3),"$V$"))

  

Checkdensity<-function(model,npoints){
  attach(model)
  y0=grid1f(model,npoints)
  plyr::aaply(Allkdeestimates(model,y0),2,function(y){caTools::trapz(y0,y)})}
  

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

