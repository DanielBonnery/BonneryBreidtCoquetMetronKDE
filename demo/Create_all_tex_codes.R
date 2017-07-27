#Creation of tex files for figures.
#tex files will be printed in a tex folder in working directory.
#This package creates tex files out of all ggplot2 demo outputs contained in a datanotpushed folder

folder="datanotpushed/graphs/rda"
if(!dir.exists(folder)){
folder=readline("Enter the path to a  folder containing demo outputs from working directory  and Press [enter] to continue")
if(!dir.exists(folder)){stop(paste0("The folder ",file.path(getwd(),folder),"you entered does not exist"))}
}

if(!dir.exists("datanotpushed/graphs/tex")){dir.create("datanotpushed/graphs/tex")}
if(!dir.exists("datanotpushed/graphs/pdf")){dir.create("datanotpushed/graphs/pdf")}
if(!dir.exists("datanotpushed/graphs/png")){dir.create("datanotpushed/graphs/png")}
library(SweaveLst)#from DanielBonnery github
createallgraphs<-function(x){
y=load(x)
prefix<-basename(x)
prefix<-strsplit(prefix,".",fixed = TRUE)[[1]][1]

pdf(paste0(prefix,".pdf"))
try(eval(parse(text=paste0("print(",y,")"))))
dev.off()
try(system(paste0("mv ",prefix,".pdf datanotpushed/graphs/pdf/")))

Y=get(y)
attach(Y)
sapply(names(Y),function(z){
  try(graphtikzcode(texte = paste0("print(",z,")"),createtexfileinto=file.path("datanotpushed/graphs/tex",prefix,z)))
  png(paste0(prefix,z,".png"))
  try(eval(parse(text=paste0("print(",z,")"))))
  dev.off()
  try(system(paste0("mv ",prefix,z,".png datanotpushed/graphs/png/")))
})
}

sapply(list.files(folder),function(x){createallgraphs(file.path(folder,x))})

