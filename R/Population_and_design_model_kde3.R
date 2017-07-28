model.proptosize<-function(
  theta=c(theta.p=1),
  xi=.5,
  conditionalto=list(N=1000,sampleparam=list(tau=.2))){
  #for simplicity of notation
  suppressMessages(attach(conditionalto))
  suppressMessages(attach(sampleparam))
  ## objects related to population generation
  rloiy <- function(.conditionalto=conditionalto,.theta=theta){
    rchisq(conditionalto$N,.theta)}
  rloiz=function(y,.xi=xi){y+rchisq(y,.xi)}
  ## objects related to sampling frame and sample
  Scheme<- SWRPPS(sampleparam)
  En    <- function(N){tau*N}#Global sampling rate (will be returned)
  # objects related to population and sample distribution
  dloitheta=function(y,theta=conditionalto$theta){dchisq(y,theta)}
  qloi.y=function(y){qchisq(y,theta)}
  #Population generation function
  #Computation of rho function (function of y,theta,xi)
  rhothetaxi=function(y,theta,xi){(y+xi)/(theta+xi)}
  #Computation of rho function (function of y)
  rho=function(y){return(rhothetaxi(y,theta,xi))}
  rhoxthetaxi=function(...){1};
  #Computation of rho function (function of y)
  # objects related to estimation
  xihat=function(Obs){sum((Obs$z-Obs$y)^2/Obs$pik)/(sum(1/Obs$pik))}
  thetaht=function(Obs){sum(Obs$y/Obs$pik)/sum(1/Obs$pik)}
  thetaniais=function(Obs){mean(Obs$y)}
  # Final result
  return(list(
    theta=theta,xi=xi,conditionalto=conditionalto,
    rloiy=rloiy,
    ploi=function(y){pchisq(y,theta)},
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
    En=En,
    tau=tau,
    xihat=xihat,
    thetaht=thetaht,  
    yfun=function(obs){obs$y},
    thetaniais=thetaniais,
    eta=function(Obs,.xi=xi,.conditionalto=conditionalto, .theta=theta){
      (1-(1-(Obs$y+.xi^2)/(.conditionalto$N*(.theta+.xi^2)))^(tau*.conditionalto$N))}))}