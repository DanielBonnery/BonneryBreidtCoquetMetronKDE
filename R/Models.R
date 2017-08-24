#model 1
model1f<-function(){
  popmodelfunction = model.Pareto.bernstrat
  theta=4;xi=1;conditionalto=list(N=10000,sampleparam=list(tauh=c(0.01,0.1)))
  model<-popmodelfunction(theta,xi,conditionalto)
  model$name="Model 1"
  id=tolower(gsub(".", "",gsub(" ", "",model$name, fixed = TRUE), fixed = TRUE))
  model$id=id
  save(model,file=paste0("datanotpushed/model/",id,".rda"));
  model}
#model 2
model2f<-function(){popmodelfunction = model.proptosize
set.seed(1)#NB: the seed was not set for the table in the publication
conditionalto=list(N=15000,sampleparam=list(tau=.2))
theta=c(3)
xi=.5
model<-popmodelfunction(theta,xi,conditionalto)
model$name="Model 2"
id=tolower(gsub(".", "",gsub(" ", "",model$name, fixed = TRUE), fixed = TRUE))
model$id=id
model}

#model 3
model3f<-function(){
  popmodelfunction = model.dep.strat2
  set.seed(1)#NB: the seed was not set for the table in the publication
  conditionalto=list(N=50000,sigma=1 ,EX=1,SX=1,sampleparam=list(proph=c(.7,.3),tauh=c(1/70,2/15)))
  theta=c(.5,0,2)
  xi=2
  model<-popmodelfunction(theta,xi,conditionalto)
  model$name="Model 3"
  id=tolower(gsub(".", "",gsub(" ", "",model$name, fixed = TRUE), fixed = TRUE))
  model$id=id
  model}
#model 4
model4f<-function(){
  popmodelfunction = model.birthweight1
  theta=c(mu=39.853,sigma2=16.723)
  conditionalto=list(N=15000,sampleparam=list(n=90))
  xi=c(xi=.175,xi0=-log(conditionalto$sampleparam$n/conditionalto$N)+.087^2/2-.175*theta[1]+.175^2*theta[2]/2,tau2=.087)
  model<-popmodelfunction(theta,xi,conditionalto)
  model$name="Model 4"
  id=tolower(gsub(".", "",gsub(" ", "",model$name, fixed = TRUE), fixed = TRUE))
  model$id=id
  model$nc<-function(ys,xi,h){
    exp(xi[1]-xi[3]/2)/(length(ys)*h)*sum(exp((sqrt(h/2)*xi[2]+ys/sqrt(2*h))^2-ys^2/(2*h)))
  }
  model}

#model 5
model5f<-function(){
  popmodelfunction = model.birthweight2
  theta=c(mu=39.853,sigma2=16.723)
  conditionalto=list(N=15000,sampleparam=list(n=90,nstrata=18))
  xi=c(xi=.175,xi0=-log(conditionalto$sampleparam$n/conditionalto$N)+.087^2/2-.175*theta[1]+.175^2*theta[2]/2,tau2=.087)
  model<-popmodelfunction(theta,xi,conditionalto)
  model$name="Model 5"
  model$id=tolower(gsub(".", "",gsub(" ", "",model$name, fixed = TRUE), fixed = TRUE))
  model$nc<-function(ys,xi,h){
    exp(xi[2]-xi[3]/2)/(length(ys))*sum(exp((sqrt(h/2)*xi[1]+ys/sqrt(2*h))^2-ys^2/(2*h)))
  }
  model}


modelf<-function(i){
  if(i==1){model=model1f()}
  if(i==2){model=model2f()}
  if(i==3){model=model3f()}
  if(i==4){model=model4f()}
  if(i==5){model=model5f()}
  model}
