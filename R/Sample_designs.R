
birthweightsampledesign1<-function(sampleparam=list(n=90)){
  list(
    sampleparam=sampleparam,
    S=function(z,.sampleparam=sampleparam){
      w<-z; pik=1/w;
      while(sum(pik)/.sampleparam$n!=1){
        pik=.sampleparam$n*pik/sum(pik)
        pik[pik>1]<-1}
      sample(length(w),.sampleparam$n,prob=1/w,replace=FALSE)},
    Pik=function(z,.sampleparam=sampleparam){
      w<-z; pik=1/w;
      while(sum(pik)/.sampleparam$n!=1){
        pik=.sampleparam$n*pik/sum(pik)
        pik[pik>1]<-1}
    pik},
    demarc=function(z){NULL})
}

birthweightsampledesign2<-function(sampleparam=list(n=90,nstrata=18)){
  list(
    sampleparam=sampleparam,
    S=function(z,.sampleparam=sampleparam){
      w<-z[,2]; pik=1/w;
      while(sum(pik)/.sampleparam$n!=1){
        pik=.sampleparam$n*pik/sum(pik)
        pik[pik>1]<-1}
      oo=order(z[,1])
      rr=rank(z[,1])
      Strata=(1:.sampleparam$nstrata)[1+((cumsum(pik[oo])-1)%/%(.sampleparam$n/.sampleparam$nstrata))]
      sapply(1:.sampleparam$nstrata,function(h){sample(rr[Strata==h],size=5,prob=pik[oo][Strata==h],replace=FALSE)})},
    Pik=function(z,.sampleparam=sampleparam){w<-z[,2]; pik=1/w;
    while(sum(pik)/.sampleparam$n!=1){
      pik=.sampleparam$n*pik/sum(pik)
      pik[pik>1]<-1}
    pik},
    demarc=function(z,.sampleparam=sampleparam){
      w<-z[,2]; pik=1/w;
      while(sum(pik)/.sampleparam$n!=1){
        pik=.sampleparam$n*pik/sum(pik)
        pik[pik>1]<-1}
      oo=order(z[,1])
      rr=rank(z[,2])
      Strata=(1:.sampleparam$nstrata)[1+((cumsum(pik[oo])-1)%/%(.sampleparam$n/.sampleparam$nstrata))]
      sapply(1:nstrata,function(h){max(z[,1][oo][Strata==h])})})}
