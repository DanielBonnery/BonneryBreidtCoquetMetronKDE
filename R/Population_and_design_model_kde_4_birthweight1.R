model.birthweight1<-function(
  theta=c(mu=39.853,sigma2=16.723),
  xi=c(xi=.175,xi0=-log(conditionalto$sampleparam$n/conditionalto$N)+.087^2/2-.175*theta[1]+.175^2*theta[2]/2,tau2=.087),
  conditionalto=list(N=15000,sampleparam=list(n=90))){
  #for simplicity of notation
  suppressMessages(attach(conditionalto))
  suppressMessages(attach(sampleparam))
  ## objects related to population generation
  rloiy <- function(.conditionalto=conditionalto,.theta=theta){
    rnrom(.conditionalto$N,.theta["mu"],sqrt(.theta["sigma2"]))}
  rloiz=function(y,.xi=xi){cbind(y=y, w=exp(.xi["xi0"]+.xi["xi"]*y+rnorm(y,sd=sqrt(tau2))))}
  ## objects related to sampling frame and sample
  Scheme<- birthweightsampledesign1(sampleparam)
  tau=conditionalto$sampleparam$n/conditionalto$N
  #En    <- function(N){tau*N}#Global sampling rate (will be returned)
  # objects related to population and sample distribution
  dloitheta=function(y,theta=conditionalto$theta){dnrom(y,theta["mu"],sqrt(theta["sigma2"]))}
  qloi.y=function(y,theta=conditionalto$theta){qnrom(y,theta["mu"],sqrt(theta["sigma2"]))}
  ploi=function(y,theta=conditionalto$theta){pnrom(y,theta["mu"],sqrt(theta["sigma2"]))}
  #Population generation function
  #Computation of rho function (function of y,theta,xi)
  rhothetaxi=function(y,theta,xi){(y+xi)/(theta+xi)}
  #Computation of rho function (function of y)
  rho=function(y){return(rhothetaxi(y,theta,xi))}
  rhoxthetaxi=function(...){1};
  #Computation of rho function (function of y)
  # objects related to estimation
  xihat=function(Obs){(sum(Obs$w*log(Obs$w)*Obs$y)-(sum(Obs$w*ln(Obs$w)))*(sum(Obs$w*Obs$y))/sum(Obs$w))/(sum(Obs$w*Obs$y^2)-(sum(Obs$w*Obs$y))^2/(sum(Obs$w)))}
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
    thetaniais=thetaniais,
    eta=function(Obs,.xi=xi,.conditionalto=conditionalto, .theta=theta){
      (1-(1-(Obs$y+.xi^2)/(.conditionalto$N*(.theta+.xi^2)))^(tau*.conditionalto$N))}))}
