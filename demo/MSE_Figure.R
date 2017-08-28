model=modelf(1)

set.seed(1)
dd=Simuletout(model,3000)
ee=analysetout(dd)
rm(dd)
jj<-JayRtablef(ee)
par(mfrow=c(2,1))
tmp<-gray.colors(3, start = 0.3, end = 0.9, gamma = 2.2, alpha = NULL)
par(mfrow=c(2,1))
plot(range(jj[,1]),log10(range(jj[,4:15])),type="n",xlab=expression(y[0]),
     ylab=expression(paste(plain(log)[10],"(Mean Square Error)")),
     main="Outer estimators")
COL=c("DarkGray","LightGray","LightGray","Black","DarkGray","Black")
COL<-tmp[c(2,1,1,3,2,3)]
LTY=c(2,1,4,2,3,3)
LTY=c(1,1,2,1,2,2)
LWD=c(2,3,3,1,2,1)
LWD=rep(2,6)
for(i in 1:6){
  lines(jj[,1],log10(jj[,i+3]),col=COL[i],lty=LTY[i],lwd=LWD[i])
}
plot(range(jj[,1]),log10(range(jj[,4:15])),type="n",xlab=expression(y[0]),ylab=expression(paste(plain(log)[10],"(Mean Square Error)")))
for(i in 1:6){
  lines(jj[,1],log10(jj[,i+9]),col=COL[i],lty=LTY[i],lwd=LWD[i])
}

createalltables(ee,dest.folder = NULL)