model.birthweight1<-function(
  theta=c(mu=39.853,sigma2=16.723),
  xi=c(xi=.175,xi0=-log(conditionalto$sampleparam$n/conditionalto$N)+.087^2/2-.175*theta[1]+.175^2*theta[2]/2,tau2=.087),
  conditionalto=list(N=15000,sampleparam=list(n=90))){
  #for simplicity of notation
  suppressMessages(attach(conditionalto))
  suppressMessages(attach(sampleparam))
  ## objects related to population generation
  rloiy <- function(.conditionalto=conditionalto,.theta=theta){
    rnorm(.conditionalto$N,.theta["mu"],sqrt(.theta["sigma2"]))}
  rloiz=function(y,.xi=xi){exp(.xi[2]+.xi[1]*y+rnorm(length(y),sd=sqrt(.xi[3])))}
  ## objects related to sampling frame and sample
  Scheme<- birthweightsampledesign1(sampleparam)
  tau=conditionalto$sampleparam$n/conditionalto$N
  #En    <- function(N){tau*N}#Global sampling rate (will be returned)
  # objects related to population and sample distribution
  dloitheta=function(y,.theta=theta){dnorm(y,.theta[1],sqrt(.theta[2]))}
  qloi.y=function(y,.theta=theta){qnorm(y,.theta[1],sqrt(.theta[2]))}
  ploi=function(y,.theta=theta){pnorm(y,.theta[1],sqrt(.theta[2]))}
  #Population generation function
  #Computation of rho function (function of y,theta,xi)
  rhothetaxi=function(y,theta,xi){exp(xi[2]*(theta[1]-y)+xi[2]^2*theta[2]^2/2)}
  #Computation of rho function (function of y)
  rho=function(y){return(rhothetaxi(y,theta,xi))}
  rhoxthetaxi=function(...){1};
  #Computation of rho function (function of y)
  # objects related to estimation
  xihat=function(Obs){c((sum(Obs$z*log(Obs$z)*Obs$y)-(sum(Obs$z*log(Obs$z)))*(sum(Obs$z*Obs$y))/sum(Obs$z))/(sum(Obs$z*Obs$y^2)-(sum(Obs$z*Obs$y))^2/(sum(Obs$z))),
                        xi[2],xi[3])}
  thetaht=function(Obs){sum(Obs$y/Obs$pik)/sum(1/Obs$pik)}
  thetaniais=function(Obs){mean(Obs$y)}
  # Final result
  return(list(
    theta=theta,xi=xi,conditionalto=conditionalto,
    rloiy=rloiy,
    ploi=ploi,
    dloitheta=dloitheta,
    dloi.y=dloitheta,
    qloi.y=qloi.y,
    rloiz=rloiz,
    dloilim=function(y){rho(y)*dchisq(y,theta)},
    Scheme=Scheme,
    rho=rho,
    rhothetaxi=rhothetaxi,
    rhoxthetaxi=rhoxthetaxi,
    vinf=function(y){tau*rho(y)-(tau*rho(y))^2},
    #En=En,
    tau=tau,
    xihat=xihat,
    thetaht=thetaht,  
    yfun=function(obs){obs$y},
    obsifyf=function(y,.conditionalto=conditionalto){list(y=y)},
    thetaniais=thetaniais,
    eta=function(Obs,.xi=xi,.conditionalto=conditionalto, .theta=theta){exp(-.xi[2]-.xi[1]*Obs$y+.xi[3]/2)}))
}