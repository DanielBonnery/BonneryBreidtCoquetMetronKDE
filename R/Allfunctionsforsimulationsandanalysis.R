#' Compute an estimate of E[I\mid Y=y0] 
#' @param model: An object of class model
#' @param npoints: number of points on the grid
#' @param y0: values where to compute the KDE
#' @param nrep: number of replications
#' @example
#' Simuletout(model=modelf(1),npoints=3,nrep=3)
Simuletout<-function(model,npoints=300,y0=grid1f(model,npoints),nrep=1000){
  ff<-plyr::raply(nrep,(function(x,.model=model,.y0=y0){
    Allestimates(.model,.y0)})(),.progress="text")
  dimnames(ff)[1:2]<-list(1:nrep,1:length(y0))
  names(dimnames(ff))<-c("rep","i","variable")
  list(ff=ff,model=model,y0=y0,nrep=nrep)
}

#' Analyses simulation_output
#' @param model: An object of class simulation_output
#' @example
#' analysetout(Simuletout(model=modelf(1),npoints=3,nrep=3))
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
  
  
  
  empvar=merge(reshape2::melt(data.frame(y0=y0,i=1:length(y0),empvarA),id=c("y0","i")),aux, by="variable", all.x=TRUE)
  empmse=merge(reshape2::melt(data.frame(y0=y0,i=1:length(y0),empmseA),id=c("y0","i")),aux, by="variable", all.x=TRUE)
  avgvarest=data.frame(y0=y0,i=1:length(y0),Vf=plyr::aaply(ff[,,"Vf"],2,mean))
  coefvar=merge(reshape2::melt(data.frame(y0=y0,i=1:length(y0),coefvarA),id=c("y0","i")),aux, by="variable", all.x=TRUE)
  
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



allplotscolor<-function(ee){
  attach(ee)
  sel =(1:npoints)[(1:npoints)%%(npoints%/%60)==1]
  sel2=(1:npoints)[(1:npoints)%%(npoints%/%300)==1]
  w_graph_0<-ggplot(AAA[(!is.element(AAA$variable,c("f15bad","f19bad","f23bad","Vf")))&AAA$rep==2&is.element(AAA$i,sel),], 
                    aes(x=y0, y=value, linetype=mu,color=jolitype)) +
    xlab("$y_0$")+ylab("")+
    geom_line()+ 
    labs(title="", caption=paste0(model$name,':  estimators of $f$'))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+
    stat_function(fun = model$dloi.y,size=.8,aes(size=.8,color="$f$",linetype="$f$"))+
    theme(legend.position = "right",legend.box = "vertical") + 
    theme(legend.key.size = unit(2,"line"))+ 
    guides(linetype=guide_legend(""),color=guide_legend(""))
  
  
  w_graph_0.2<-ggplot(AAA[is.element(AAA$variable,quoi[2:3])&AAA$rep==2,], 
                      aes(x=y0, y=value, color=jolivariable)) +
    xlab("$y_0$")+ylab("")+
    geom_line()+ 
    labs(title="", caption=paste0(model$name,': $p$, $\\hat{f}_{\\hat\\mu,\\rm{nopar}}$, and $f$'))+
    theme(legend.justification = c(1, 1), legend.position = c(1, 1))+
    stat_function(fun = model$dloi.y,size=.8,aes(size=.8,color="$f$"))+
    theme(legend.position = "right",legend.box = "vertical") + 
    theme(legend.key.size = unit(2,"line"))+ 
    scale_color_manual("",values=c("black","blue","red"))
    guides(color=guide_legend(""))
  
  
  
  w_graph_0_vsf <- function(x,variab="mu",variab2="jolitype"){
    tab=AAA[(!is.element(AAA$variable,c("f","f4","f15bad","f19bad","f23bad","mu0_12","mu0_13","mu0_14","mu0_15","mu0for25","mu0for26","Vf")))&AAA$rep==2,]
    tab$tretre=tab[[variab]]
    tab$trotro=tab[[variab2]]
    try(tab$ftheta[tab$ftheta<1e-10]<-1e-10)
    try(tab$value[is.na(tab$value)]<-1e-10)
    try(tab$value[tab$value<1e-10]<-1e-10)
    
    ggplot(tab[levels(tab$tretre)[tab$tretre]==x,], aes(x=y0, y=value,color=trotro)) +
      xlab("$y_0$")+ylab("")+
      stat_function(fun = model$dloi.y,size=.8,aes(size=.8,color="$f$"))+
      geom_line()+ 
      labs(title="", caption=paste0(model$name,': "',x,'"-type estimators of $f$'))+
      theme(legend.position = "right",legend.box = "vertical") + 
      theme(legend.key.size = unit(2,"line"))+ 
      guides(color=guide_legend(""))+
    theme(legend.position = "bottom")
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
                      aes(x=y0, y=f12,color="$\\hat{f}_{\\hat\\mu,\\rm{nonpar}}$")) +
    xlab("$y_0$")+ylab("")+
    stat_function(fun = model$dloi.y,size=.8,aes(size=.8,color="$f$"))+
    geom_line()+ 
    geom_ribbon(aes(ymin=lb, ymax=ub, x=y0,fill="$\\hat{f}_{\\hat\\mu,\\rm{nonpar}}$"), alpha = 0.3, colour=NA,show.legend=F)+ 
    labs(title="", caption=paste0(model$name,':  Confidence interval for $\\hat{f}_{\\hat\\mu,\\rm{nonpar}}$'))+
    theme(legend.position = "right",legend.box = "vertical") + 
    theme(legend.key.size = unit(2,"line"))+
    guides(color=guide_legend(""),color=guide_legend(""))
  
  
  w_graph1f <- function(x){
    BB=AA[AA$rep<150 &is.element(AA$i,sel),c("y0",x,"rep")]
    names(BB)<-c("y0","est","Rep")
    joliname=aux$jolivariable2[aux$variable==x]
    
    ggplot(BB, aes(x=y0, y=est, group=Rep)) +
      xlab("$y_0$")+ylab("")+
      geom_line(size=0.2, alpha=0.1,aes(color=joliname,size=.2))+ 
      labs(title="", caption=paste0("Simulations for ",model$name,", ",joliname ," repeated ",min(nrep,50), " times"))+    
      geom_line(data=data.frame(y0=y0,f=empmeanA[,x]),
                aes(x=y0,y=f,group=NULL,color=paste0(joliname,", averaged on ",nrep," replications")),size=1)  +
      stat_function(fun = model$dloi.y,size=.4,aes(size=.4,color="$f$"))+
      scale_size_manual(values = c(0.4, .2,1))+
      scale_color_manual(values=c("blue","blue","black"))+
      theme(legend.position = "bottom")+ 
      theme(legend.key.size = unit(2,"line"))+
      guides(size=FALSE, color=guide_legend(override.aes=list(size=c(.4,1,1),alpha=c(.1,1,1))))}
  w_graph_1s<-plyr::alply(c("f4","f12","f13","f14","f15","fhat25","fhat26","f20","f21","f22","f23","f25","f26"),1,w_graph1f)
  names(w_graph_1s)<-paste0("w_graph1_",c("f4","f12","f13","f14","f15","fhat25","fhat26","f20","f21","f22","f23","f25","f26"))
  
  w_graph2 <- ggplot(AA[AA$rep<50 &(is.element(AA$i,sel)),], aes(x=y0, y=Vf, group=rep)) +
    xlab("$y_0$")+ylab("")+
    geom_line(size=0.2, alpha=0.1,aes(color="$\\hat{V}$"))+
    labs(title="", caption=paste0("Empirical variance and variance estimates, simulations for ",model$name,", repeated ",min(50,nrep), " times"))+  
    geom_line(data=empvar[empvar$variable=="f12",],aes(x=y0,y=value,group=NULL,color="Empirical variance"), size=.8)+
    geom_line(data=avgvarest,aes(x=y0,y=Vf,group=NULL,color=paste0("$\\hat{V}$, averaged on ",ee$nrep," replications")),size=.8)+
    scale_color_manual(values=c("black","blue","blue"))+
    scale_size_manual(values = c(1, .2,1))+
    theme(legend.position = "bottom")+ 
    theme(legend.key.size = unit(2,"line"))+
    guides(size=FALSE, color=guide_legend(override.aes=list(size=c(.4,.2,1),alpha=c(1,.1,1))))
  
  
  
  
  
  
  
  w_graph_var <- ggplot(empvar[sel,][is.element(empvar$variable,quoi[-c(1,23)])&is.element(empvar$i,sel),], 
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
           aes(x=y0, y=value,color=trotro)) +
      scale_colour_function1()+ 
      xlab("$y_0$")+ylab("")+
      theme_bw()+
      geom_line()+ 
      labs(title="", caption=paste0(model$name,": Emp. MSE, ",x,", ",nrep," replications"))+
      scale_y_log10()+
      theme(legend.position = "right",legend.box = "vertical") + 
      theme(legend.key.size = unit(2,"line"))+ 
      guides(color=guide_legend(""))
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
            w_graph2=w_graph2),
       w_graph_1s,
       w_graph_mse_vsmus,
       w_graph_mse_vstypes,
       w_graph_0_vsmus,
       w_graph_0_vstypes)
  
  return(pp)
}




allplots<-function(ee,scale_colour_function1=ggplot2::scale_colour_grey){
  attach(ee)
  
  sel=(1:npoints)[(1:npoints)%%(npoints%/%60)==1]
  sel2=(1:npoints)[(1:npoints)%%(npoints%/%300)==1]
  
  theme_set(theme_bw())
  w_graph_0<-ggplot(AAA[(!is.element(AAA$variable,c("f15bad","f19bad","f23bad","Vf")))&AAA$rep==2&is.element(AAA$i,sel),], 
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
    scale_colour_grey()+ 
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
      scale_colour_grey()+ 
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
    scale_colour_grey()+ 
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
      scale_colour_grey("")+
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
    geom_line(data=avgvarest,aes(x=y0,y=Vf,group=NULL,linetype=paste0("$\\hat{V}$, averaged on ",nrep," replications")),size=.8)+
    scale_linetype_manual("",values = c("solid",  "solid","dashed")) +
    scale_size_manual(values = c(0.4, .2,1))+
    theme(legend.position = "bottom")+ 
    theme(legend.key.size = unit(2,"line"))+
    guides(size=FALSE, linetype=guide_legend(override.aes=list(size=c(.4,.2,1),alpha=c(1,.1,1))))
  
  
  
  
  
  
  
  w_graph_var <- ggplot(empvar[is.element(empvar$variable,quoi[-c(1,23)])&is.element(empvar$i,sel),], 
                        aes(x=y0, y=value, linetype=mu,color=jolitype)) +
    xlab("$y_0$")+ylab("")+
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
           aes(x=y0, y=value,color=trotro)) +
      xlab("$y_0$")+ylab("")+
      geom_line()+ 
      labs(title="", caption=paste0(model$name,": Emp. MSE, ",x,", ",nrep," replications"))+
      scale_y_log10()+
      theme(legend.position = "right",legend.box = "vertical") + 
      theme(legend.key.size = unit(2,"line"))+ 
      guides(color=guide_legend(""))
  }
  w_graph_mse_vsmus<-plyr::alply(levels(empmse$mu)[levels(empmse$mu)!="$\\hat\\mu,\\rm{par(rough)}$"],1,w_graph_mse_vsf)
  names(w_graph_mse_vsmus)<-paste0("w_graph_mse_vsmu",1:(nlevels(empmse$mu)-1))
  w_graph_mse_vstypes<-plyr::alply(levels(empmse$jolitype),1,w_graph_mse_vsf,variab="jolitype",variab2="mu")
  names(w_graph_mse_vstypes)<-paste0("w_graph_mse_vsmu",1:nlevels(empmse$jolitype))
  
  
  
  

  pp=c(list(w_graph_0=w_graph_0,
            w_graph_0.1=w_graph_0.1,
            w_graph2=w_graph2),
       w_graph_1s,
       w_graph_mse_vsmus,
       w_graph_mse_vstypes,
       w_graph_0_vsmus,
       w_graph_0_vstypes)
  
  return(pp)
}






createallgraphs<-function(x){
  y=load(x)
  prefix<-basename(x)
  prefix<-strsplit(prefix,".",fixed = TRUE)[[1]][1]
  
  #pdf(paste0("datanotpushed/graphs/pdf/",prefix,".pdf"))
  #try(eval(parse(text=paste0("print(",y,")"))))
  #dev.off()
  
  tikz(paste0("datanotpushed/graphs/tex/",prefix,".tex"),standAlone = TRUE,sanitize=FALSE)
  try(eval(parse(text=paste0("print(",y,")"))))
  dev.off()
  
  tx  <- readLines(paste0("datanotpushed/graphs/tex/",prefix,".tex"))
  tx  <- c(tx[3],"\\usepackage{pgfplots}","\\usepgfplotslibrary{external}","\\tikzexternalize", tx[-(1:4)])
  writeLines(tx, paste0("datanotpushed/graphs/tex/",prefix,".tex"))
  
  
  try(system(paste0( "pdflatex -shell-escape -interaction=nonstopmode datanotpushed/graphs/tex/",prefix,".tex")))
  try(system(paste0("mv ",prefix,".pdf datanotpushed/graphs/pdf/")))
  
  if(FALSE){
    Y=get(y)
    attach(Y)
    sapply(names(Y),function(z){
      png(paste0("datanotpushed/graphs/png/",prefix,z,".png"))
      try(eval(parse(text=paste0("print(",z,")"))))
      dev.off()
      
      tikz(paste0("datanotpushed/graphs/tex/",prefix,z,".tex"),standAlone = FALSE)
      try(eval(parse(text=paste0("print(",z,")"))))
      dev.off()
    })}
}

createalltables<-function(ee,dest.folder="datanotpushed/table"){
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
  cat(capture.output(cat(y)),file=file.path(dest.folder,paste0(tolower(gsub(" ", "",ee$model$name, fixed = TRUE)),".tex")),append=FALSE)
  
  try(system(paste0("cd ",dest.folder,";pdflatex -shell-escape -interaction=nonstopmode tables.tex")))
  return(ddd)
}


JayRtablef<-function(ee){
  jj=cbind(y0=ee$y0,reshape2::acast(ee$empmse,y0~variable,value.var="value"))[,1:15]
  rownames(jj)<-NULL
  jj
}
