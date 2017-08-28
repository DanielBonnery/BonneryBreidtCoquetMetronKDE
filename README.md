# Kernel Estimation for a Superpopulation Probability Density Function under Informative Selection
`BonneryBreidtCoquetMetronKDE` is an R package that contains the source code to reproduce the graphs and simulations of the article
"Kernel Estimation for a Superpopulation Probability Density Function under Informative Selection", by 
Daniel Bonnéry (UMD),  F. Jay Breidt (CSU) and  François Coquet (Irmar and Ensai), article under revision in Metron Journal.

## 1. Install the package
You will need to have Rtools installed, as well as the devtools package.


```r
devtools::install_github("DanielBonnery/BonneryBreidtCoquetMetronKDE",dependencies=TRUE)
```

Note that this package depends on different R packages, including:
* [pubBonneryBreidtCoquet2016](https://github.com/DanielBonnery/pubBonneryBreidtCoquet2016) is an R package that contains generic functions to simulate populations and draw samples.
* [yihui/tikzDevice](https://github.com/yihui/tikzDevice) is an R package that allows to create tikz code from a graph.

Some functions of `BonneryBreidtCoquetMetronKDE` produce pdf graphics and need pdflatex to be installed.

## 2. Produce the paper graphs and tables.



```r
library(BonneryBreidtCoquetMetronKDE)
demo(MSE_Figure)
```










