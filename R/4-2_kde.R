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
p0  <-function(y0,Obs,ker=ker,model=NULL,N){sum(ker$K((Obs$y-y0)/b(N)))/(b(N)*length(Obs$y))}

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
mf<-function(ker=kergaus,yfun=function(obs){obs$y},h=ks::hpi(x=yfun(Obs)),pifun=function(obs){obs$pik}){
  function(y0,Obs){apply(ker$K(outer(yfun(Obs),y0,"-")/h),2,sum)/apply(ker$K(outer(yfun(Obs),y0,"-")/h)/pifun(Obs),2,sum)}}


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
mftheo   <-function(model){function(y0,Obs){model$eta(list(y=y0),model$xi)}}
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
mf3<-function(ker=kergaus,yfun=function(obs){obs$y},h=ks::hpi(x=yfun(Obs)),pifun=function(obs){obs$pik}){function(y0,Obs){
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

Allestimates<-function(y0,
                       Obs,
                       model,
                       ker=kergaus,
                       h=ks::hpi(x=model$yfun(Obs)),
                       pifun=function(obs){obs$pik}){
  
  
  K0=ker$K(outer(model$yfun(Obs),y0,"-")/h)/h
  Ks=ker$K(outer(model$yfun(Obs),model$yfun(Obs),"-")/h)/h
  SK0=apply(K0,2,sum)
  SKs=apply(Ks,2,sum)
  pik=pifun(Obs)
  ys=model$yfun(Obs)
  Nhat=sum(1/pik)
  
  mus_20=mf(pifun=function(Obs){1/Obs$pik})(ys,Obs)/mf(pifun=function(Obs){1})(ys,Obs)
  mu0_for20=mf(pifun=function(Obs){1/Obs$pik})(y0,Obs)/mf(pifun=function(Obs){1})(y0,Obs)
  Ctildefor20=Ctildef(mus_20,pik,Nhat)
  
  mus_21=mftheo(model)(ys,Obs)
  mu0_13=mftheo(model)(y0,Obs)
  Ctilde17=Ctildef(mus_21,pik,Nhat)
  
  mus_22=mfhattheo(model)(ys,Obs)
  mu0_14=mftheo(model)(y0,Obs)
  Ctilde18=Ctildef(mus_22,pik,Nhat)
  
  mus_23bad=mfroughreg(yfun=model$yfun)(ys,Obs)
  mu0_15bad=mfroughreg(yfun=model$yfun)(y0,Obs)
  Ctilde19bad=Ctildef(mus_23bad,pik,Nhat)
  
  transpi<-(function(x){log(x/(1-x))})(pik)
  mus_23=(function(y){exp(y)/(1+exp(y))})(predict.lm(lm(transpi~ys,weights=1/pik)))
  mu0_15=(function(y){exp(y)/(1+exp(y))})(predict.lm(lm(transpi~ys,weights=1/pik),newdata=data.frame(ys=y0)))
  Ctilde19=Ctildef(mus_23,pik,Nhat)
  
  mus_25=apply(Ks/(pifun(Obs)^2),2,sum)/apply(Ks/(pifun(Obs)^2),2,sum)
  
  transpi2<-(function(x){log(1/x)-1})(pik)
  mus_26=(function(x){exp(-(x+1))})(predict.lm(lm(transpi2~ys,weights=1/pik)))
  
  
  
  
  #naive
  f4=SK0/length(Obs$y)
  if(FALSE){kde.outerK0mus(K0,rep(1,length(Obs$y)))-f4}
  #intersect
  f12<-kde.outerK0mus(K0,pik)
  
  #Compute inner
  
  f21<-kde.outerK0mus(K0,mus_21)         
  f22<-kde.outerK0mus(K0,mus_22)         
  f23bad<-kde.outerK0mus(K0,mus_23bad)         
  f23<-kde.outerK0mus(K0,mus_23)
  f25<-kde.outerK0mus(K0,mus_25)         
  f26<-kde.outerK0mus(K0,mus_26)         
  
  #Compute outer
  Nhat<-sum(1/pik)
  Chat<-length(ys)/Nhat
  m21<-mftheo(model)(ys,Obs)
  f13=f4*Chat/mu0_13
  f14=f4*Chat/mu0_14
  f15bad=SK0*Chat/mu0_15bad
  f15=f4*Chat/mu0_15
  
  f17=kde.innerf4Cmu0(f4,Ctilde17,mu0_13)
  f18=kde.innerf4Cmu0(f4,Ctilde18,mu0_14)
  f19=kde.innerf4Cmu0(f4,Ctilde19,mu0_15)
  f19bad=kde.innerf4Cmu0(f4,Ctilde19bad,mu0_15bad)
  Vf=varkde.outer(y0,Obs,yfun=model$yfun)
  
  cbind(f4=f4,
        f12=f12,
        f21=f21,
        f23=f23,
        f23bad=f23bad,
        f25=f25,
        f26=f26,
        f13=f13,
        f14=f14,
        f15=f15,
        f15bad=f15bad,
        f17=f17,
        f18=f18,
        f19=f19,
        f19bad=f19bad,
        Vf=Vf)
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


Simuletout<-function(model, y0,nrep=1000){
  ff<-plyr::raply(nrep,(function(){
    Obs<-generate.observations(model);
    Allestimates(y0,Obs,model)
  })(),.progress="text")
  dim(ff)
  
  dimnames(ff)<-list(1:nrep,1:length(y0),c("f4","f12","f21","f23","f23bad","f25","f26","f13","f14","f15","f15bad","f17","f18","f19","f19bad","Vf"))
  names(dimnames(ff))<-c("rep","i","variable")
  list(ff=ff,model=model,y0=y0,nrep=nrep)
}

analysetout<-function(dd){
  attach(dd)  
  aux<-data.frame(variable=c("f4","f12","f21","f23","f23bad","f25","f26","f13","f14","f15","f15bad","f17","f18","f19","f19bad","Vf"),
                  type=c("naive","both","inner","inner","inner","inner","inner","outer","outer","outer","outer","outer","outer","outer","outer","Variance"),
                  mu=c("1","pi","true","xihat","muhat","muhatbad","w","true","xihat","muhat","muhatbad","true","xihat","muhat","muhatbad","Variance"),
                  C=c("NA","NA","NA","NA","NA","NA","NA","hat","hat","hat","hat","tilde","tilde","tilde","tilde","Variance"))
  aux$muC=paste(aux$mu,aux$C)
  
  library(reshape2)
  A<-reshape2::melt(ff)
  AA<-reshape2::dcast(A,i+rep~variable,value.var="value")
  AAA<-reshape2::dcast(A,i+rep+variable~1,value.var="value")
  AA<-merge(AA,data.frame(i=1:length(y0),y0=y0,ftheta=model$dloi.y(y0)))
  AAA<-merge(AAA,data.frame(i=1:length(y0),y0=y0,ftheta=model$dloi.y(y0)))
  AAA<-merge(AAA,aux,by="variable",all.x=TRUE)
  names(AAA)[names(AAA)==1]<-"value"
  
  empvarA=plyr::aaply(ff[,,],2:3,var)
  empbias2A=(plyr::aaply(ff[,,],2:3,mean)-model$dloi.y(y0))^2
  coefvarA=sqrt(empbias2A+empvarA)/model$dloi.y(y0)
  
  
  
  empvar=merge(melt(data.frame(y0=y0,empvarA),id="y0"),aux, by="variable", all.x=TRUE)
  empmse=merge(melt(data.frame(y0=y0,empvarA+empbias2A),id="y0"),aux, by="variable", all.x=TRUE)
  avgvarest=data.frame(y0=y0,Vf=plyr::aaply(ff[,,"Vf"],2,mean))
  coefvar=merge(melt(data.frame(y0=y0,coefvarA),id="y0"),aux, by="variable", all.x=TRUE)
  meanempMSE=merge(plyr::ddply(.data = empmse,.variables = ~variable,.fun=function(d){data.frame(IntegratedMSE=sum(d$value*model$dloi.y(d$y0)/(c(d$y0[-1],2*y0[length(d$y0)]-d$y0[length(d$y0)-1])-d$y0)))}),aux)
  meanempMSE$IntegratedMSErel=meanempMSE$IntegratedMSE/meanempMSE$IntegratedMSE[levels(meanempMSE$variable)[meanempMSE$variable]=="f12"]
  
  return(list(model=model,meanempMSE=meanempMSE,model=model,y0=y0,nrep=nrep,AA=AA,AAA=AAA,ff=ff,empvar=empvar,empmse=empmse,avgvarest=avgvarest,coefvar=coefvar))
}




allplots<-function(dd){
  attach(dd)
  theme_set(theme_bw())
  w_graph1 <- ggplot(AA, aes(x=y0, y=f12, group=rep)) +
    scale_colour_grey("")+
    xlab("$y_0$")+ylab("")+
    geom_line(size=0.2, alpha=0.1,aes(linetype="$\\hat{f}_{nonpar}$",size=.2))+ 
    labs(title="", caption=paste0("Simulations for ",model$name," , obtained with ",nrep, " replications"))+    
    geom_line(data=data.frame(y0=y0,f=plyr::aaply(ff[,,"f12"],2,mean)),aes(x=y0,y=f,group=NULL,linetype="$\\hat{f}_{nonpar}$, averaged"),size=1)  +
    stat_function(fun = model$dloi.y,size=.4,aes(size=.4,linetype="$f$"))+
    scale_linetype_manual("",values = c("solid",  "solid","dashed")) +
    scale_size_manual(values = c(0.4, .2,1))+
    theme(legend.position = "bottom")+ 
    theme(legend.key.size = unit(2,"line"))+
    guides(size=FALSE, linetype=guide_legend(override.aes=list(size=c(.4,.2,1),alpha=c(1,.1,1))))
  
  
  w_graph2 <- ggplot(AA, aes(x=y0, y=Vf, group=rep)) +
    geom_line(size=0.2, alpha=0.1)+
    ggtitle(paste0("Empirical variance and variance estimates,",nrep, "replications"))+  
    geom_line(data=empvar[empvar$variable=="f12",],aes(x=y0,y=value,group=NULL), size=.8)+
    geom_line(data=avgvarest,aes(x=y0,y=Vf,group=NULL),size=.8,linetype="dashed")+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))
  
  
  
  
  
  
  
  w_graph_var <- ggplot(empvar[is.element(empvar$variable,c("f4","f12","f21","f23","f23bad","f25","f26","f13","f14","f15","f15bad","f17","f18","f19")),], 
                        aes(x=y0, y=value, linetype=mu,color=type)) +
    scale_colour_grey()+ 
    theme_bw()+
    geom_line()+ 
    ggtitle(paste0("Empirical variance for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  
  
  w_graph_vardetailed <- ggplot(empvar[is.element(empvar$variable,c("f4","f12","f21","f23","f23bad","f25","f26","f13","f14","f15","f15bad","f17","f18","f19","f19bad")),], 
                                aes(x=y0, y=value, linetype=variable)) +
    scale_colour_grey()+ 
    theme_bw()+
    geom_line()+ 
    ggtitle(paste0("Empirical variance for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  
  
  
  w_graph_mse_tildevshat <- ggplot(empmse[empvar$type=="outer",], 
                                   aes(x=y0, y=value, color=mu,linetype=C)) +
    scale_colour_grey()+ 
    theme_bw()+
    geom_line()+ 
    ggtitle(paste0("Empirical MSE, tilde vs hat, for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  
  
  w_graph_mse_innervsouter <- ggplot(empmse[is.element(empvar$type,c("outer","inner"))&is.element(empvar$C,c("NA","tilde")),], 
                                     aes(x=y0, y=value, color=mu,linetype=type)) +
    scale_colour_grey()+ 
    theme_bw()+
    geom_line()+ 
    ggtitle(paste0("Empirical MSE, inner versus outer, for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  
  
  
  w_graph_mse_tildevshat2 <- ggplot(empmse[empvar$type=="outer"&is.element(empvar$mu,c("true","xihat")),], 
                                    aes(x=y0, y=value, color=mu,linetype=C)) +
    theme_bw()+
    scale_colour_grey()+ 
    geom_line()+ 
    ggtitle(paste0("Empirical MSE, tilde vs hat (2) for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  
  
  
  w_graph_mse <- ggplot(empmse[is.element(empvar$variable,c("f4","f12","f21","f23","f23bad","f25","f26","f13","f14","f15","f15bad","f17","f18","f19","f19bad")),], 
                        aes(x=y0, y=value, linetype=muC,shade=type)) +
    theme_bw()+
    scale_colour_grey()+ 
    geom_line()+ 
    ggtitle(paste0("Empirical MSE for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  
  
  w_graph_msedetailed <- ggplot(empmse[is.element(empvar$variable,c("f4","f12","f21","f23","f23bad","f25","f26","f13","f14","f15","f15bad","f17","f18","f19")),], 
                                aes(x=y0, y=value, linetype=variable))+
    scale_colour_grey()+ 
    geom_line()+ 
    ggtitle(paste0("Empirical MSE for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  
  
  w_graph_mse_final <- ggplot(empmse[is.element(empvar$C,c("NA","tilde")),], 
                              aes(x=y0, y=value, linetype=mu,color=type)) +
    scale_colour_grey()+ 
    theme_bw()+
    geom_line()+ 
    ggtitle(paste0("Empirical MSE for ",nrep, " replications"))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+scale_y_log10()
  
  
  return(list(w_graph1=w_graph1,w_graph2=w_graph2,w_graph_var=w_graph_var,w_graph_vardetailed=w_graph_vardetailed,
              w_graph_mse_tildevshat=w_graph_mse_tildevshat,w_graph_mse_innervsouter=w_graph_mse_innervsouter,
              w_graph_mse_tildevshat2=w_graph_mse_tildevshat2,w_graph_mse=w_graph_mse,
              w_graph_msedetailed=w_graph_msedetailed,w_graph_mse_final=w_graph_mse_final))
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
hatetafunf2<-function(obs){predict.lm(object=lm(obs$pi~obs$y,weights = 1/obs$pi))}

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

