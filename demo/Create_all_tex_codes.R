#Creation of tex files for figures.
#tex files will be printed in a tex folder in working directory.
#This package creates tex files out of all ggplot2 demo outputs contained in a datanotpushed folder
folder="datanotpushed"
if(!dir.exists(folder)){
folder=readline("Enter the path to a  folder containing demo outputs from working directory  and Press [enter] to continue")
if(!dir.exists(folder)){stop(paste0("The folder ",file.path(getwd(),folder),"you entered does not exist"))}
}

if(!dir.exists("tex")){dir.create("tex")}
library(SweaveLst)#from DanielBonnery github
createallgraphs<-function(x){
y=load(x)
sapply(y,function(z){
  load(x)
  zz="error"
  try(graphtikzcode(texte = paste0("print(",z,")"),createtexfileinto=file.path("tex",z)))})}

sapply(list.files("datanotpushed"),function(x){createallgraphs(file.path("datanotpushed",x))})

