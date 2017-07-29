model.birthweight2<-function(
  theta=c(mu=39.853,sigma2=16.723),
  xi=c(xi=.175,xi0=-log(conditionalto$sampleparam$n/conditionalto$N)+.087^2/2-.175*theta[1]+.175^2*theta[2]/2,tau2=.087),
  conditionalto=list(N=15000,sampleparam=list(n=90,nstrata=18))){
  model<-model.birthweight1(theta,xi,conditionalto=conditionalto)
  model$rloiz=function(y,.xi=xi){cbind(y,exp(.xi[2]+.xi[1]*y+rnorm(length(y),sd=sqrt(.xi[3]))))}
  model$Scheme<- birthweightsampledesign2(conditionalto$sampleparam)
  model
}