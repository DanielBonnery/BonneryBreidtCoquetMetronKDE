#Creation of tex files for figures.
#tex files will be printed in a tex folder in working directory.
#This package creates tex files out of all ggplot2 demo outputs contained in a datanotpushed folder

library(SweaveLst)#from DanielBonnery github
library(tikzDevice)

folder="datanotpushed/graphs/rda"

sapply(list.files(folder),function(x){createallgraphs(file.path(folder,x))})

