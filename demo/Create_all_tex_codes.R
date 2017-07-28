#Creation of tex files for figures.
#tex files will be printed in a tex folder in working directory.
#This package creates tex files out of all ggplot2 demo outputs contained in a datanotpushed folder

library(SweaveLst)#from DanielBonnery github
library(tikzDevice)

folder="datanotpushed/graphs/rda"
createallgraphs<-function(x){
y=load(x)
prefix<-basename(x)
prefix<-strsplit(prefix,".",fixed = TRUE)[[1]][1]

pdf(paste0("datanotpushed/graphs/pdf/",prefix,".pdf"))
try(eval(parse(text=paste0("print(",y,")"))))
dev.off()

tikz(paste0("datanotpushed/graphs/texyihui/",prefix,"_yihui.tex"),standAlone = TRUE)
try(eval(parse(text=paste0("print(",y,")"))))
dev.off()
try(system(paste0( "pdflatex datanotpushed/graphs/texyihui/",prefix,"_yihui.tex")))
try(system(paste0("mv ",prefix,"_yihui.pdf datanotpushed/graphs/pdfyihui/")))


Y=get(y)
attach(Y)
sapply(names(Y),function(z){
  png(paste0("datanotpushed/graphs/png/",prefix,z,".png"))
  try(eval(parse(text=paste0("print(",z,")"))))
  dev.off()

  tikz(paste0("datanotpushed/graphs/texyihui/",prefix,z,"_yihui.tex"),standAlone = FALSE)
  try(eval(parse(text=paste0("print(",z,")"))))
  dev.off()
  
  
})
}

sapply(list.files(folder),function(x){createallgraphs(file.path(folder,x))})

