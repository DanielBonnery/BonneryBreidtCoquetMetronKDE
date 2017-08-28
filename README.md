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

![plot of chunk r2](figure/r2-1.png)![](figure/table1.png)

## 3. Run additional simulations

We ran simulations on different models. For each model, we produce a series of graphics and tables.

![](figure/model.png)
The following R statements  will run the simulations for all the models.


```r
library(BonneryBreidtCoquetMetronKDE)
demo(model1,package = "BonneryBreidtCoquetMetronKDE")
demo(model2,package = "BonneryBreidtCoquetMetronKDE")
demo(model3,package = "BonneryBreidtCoquetMetronKDE")
demo(model4,package = "BonneryBreidtCoquetMetronKDE")
demo(model5,package = "BonneryBreidtCoquetMetronKDE")
```



### Model  1 
![]( figure/model1/model1_col-figure0.png )
![]( figure/model1/model1_col-figure10.png )
![]( figure/model1/model1_col-figure11.png )
![]( figure/model1/model1_col-figure12.png )
![]( figure/model1/model1_col-figure13.png )
![]( figure/model1/model1_col-figure14.png )
![]( figure/model1/model1_col-figure15.png )
![]( figure/model1/model1_col-figure16.png )
![]( figure/model1/model1_col-figure17.png )
![]( figure/model1/model1_col-figure18.png )
![]( figure/model1/model1_col-figure19.png )
![]( figure/model1/model1_col-figure1.png )
![]( figure/model1/model1_col-figure20.png )
![]( figure/model1/model1_col-figure21.png )
![]( figure/model1/model1_col-figure22.png )
![]( figure/model1/model1_col-figure23.png )
![]( figure/model1/model1_col-figure24.png )
![]( figure/model1/model1_col-figure25.png )
![]( figure/model1/model1_col-figure26.png )
![]( figure/model1/model1_col-figure27.png )
![]( figure/model1/model1_col-figure28.png )
![]( figure/model1/model1_col-figure29.png )
![]( figure/model1/model1_col-figure2.png )
![]( figure/model1/model1_col-figure30.png )
![]( figure/model1/model1_col-figure31.png )
![]( figure/model1/model1_col-figure32.png )
![]( figure/model1/model1_col-figure33.png )
![]( figure/model1/model1_col-figure3.png )
![]( figure/model1/model1_col-figure4.png )
![]( figure/model1/model1_col-figure5.png )
![]( figure/model1/model1_col-figure6.png )
![]( figure/model1/model1_col-figure7.png )
![]( figure/model1/model1_col-figure8.png )
![]( figure/model1/model1_col-figure9.png )
### Model  2 
![]( figure/model2/model2_col-figure0.png )
![]( figure/model2/model2_col-figure10.png )
![]( figure/model2/model2_col-figure11.png )
![]( figure/model2/model2_col-figure12.png )
![]( figure/model2/model2_col-figure13.png )
![]( figure/model2/model2_col-figure14.png )
![]( figure/model2/model2_col-figure15.png )
![]( figure/model2/model2_col-figure16.png )
![]( figure/model2/model2_col-figure17.png )
![]( figure/model2/model2_col-figure18.png )
![]( figure/model2/model2_col-figure19.png )
![]( figure/model2/model2_col-figure1.png )
![]( figure/model2/model2_col-figure20.png )
![]( figure/model2/model2_col-figure21.png )
![]( figure/model2/model2_col-figure22.png )
![]( figure/model2/model2_col-figure23.png )
![]( figure/model2/model2_col-figure24.png )
![]( figure/model2/model2_col-figure25.png )
![]( figure/model2/model2_col-figure26.png )
![]( figure/model2/model2_col-figure27.png )
![]( figure/model2/model2_col-figure28.png )
![]( figure/model2/model2_col-figure29.png )
![]( figure/model2/model2_col-figure2.png )
![]( figure/model2/model2_col-figure30.png )
![]( figure/model2/model2_col-figure31.png )
![]( figure/model2/model2_col-figure32.png )
![]( figure/model2/model2_col-figure33.png )
![]( figure/model2/model2_col-figure3.png )
![]( figure/model2/model2_col-figure4.png )
![]( figure/model2/model2_col-figure5.png )
![]( figure/model2/model2_col-figure6.png )
![]( figure/model2/model2_col-figure7.png )
![]( figure/model2/model2_col-figure8.png )
![]( figure/model2/model2_col-figure9.png )
### Model  3 
![]( figure/model3/model3_col-figure0.png )
![]( figure/model3/model3_col-figure10.png )
![]( figure/model3/model3_col-figure11.png )
![]( figure/model3/model3_col-figure12.png )
![]( figure/model3/model3_col-figure13.png )
![]( figure/model3/model3_col-figure14.png )
![]( figure/model3/model3_col-figure15.png )
![]( figure/model3/model3_col-figure16.png )
![]( figure/model3/model3_col-figure17.png )
![]( figure/model3/model3_col-figure18.png )
![]( figure/model3/model3_col-figure19.png )
![]( figure/model3/model3_col-figure1.png )
![]( figure/model3/model3_col-figure20.png )
![]( figure/model3/model3_col-figure21.png )
![]( figure/model3/model3_col-figure22.png )
![]( figure/model3/model3_col-figure23.png )
![]( figure/model3/model3_col-figure24.png )
![]( figure/model3/model3_col-figure25.png )
![]( figure/model3/model3_col-figure26.png )
![]( figure/model3/model3_col-figure27.png )
![]( figure/model3/model3_col-figure28.png )
![]( figure/model3/model3_col-figure29.png )
![]( figure/model3/model3_col-figure2.png )
![]( figure/model3/model3_col-figure30.png )
![]( figure/model3/model3_col-figure31.png )
![]( figure/model3/model3_col-figure32.png )
![]( figure/model3/model3_col-figure33.png )
![]( figure/model3/model3_col-figure3.png )
![]( figure/model3/model3_col-figure4.png )
![]( figure/model3/model3_col-figure5.png )
![]( figure/model3/model3_col-figure6.png )
![]( figure/model3/model3_col-figure7.png )
![]( figure/model3/model3_col-figure8.png )
![]( figure/model3/model3_col-figure9.png )
### Model  4 
![]( figure/model4/model4_col-figure0.png )
![]( figure/model4/model4_col-figure10.png )
![]( figure/model4/model4_col-figure11.png )
![]( figure/model4/model4_col-figure12.png )
![]( figure/model4/model4_col-figure13.png )
![]( figure/model4/model4_col-figure14.png )
![]( figure/model4/model4_col-figure15.png )
![]( figure/model4/model4_col-figure16.png )
![]( figure/model4/model4_col-figure17.png )
![]( figure/model4/model4_col-figure18.png )
![]( figure/model4/model4_col-figure19.png )
![]( figure/model4/model4_col-figure1.png )
![]( figure/model4/model4_col-figure20.png )
![]( figure/model4/model4_col-figure21.png )
![]( figure/model4/model4_col-figure22.png )
![]( figure/model4/model4_col-figure23.png )
![]( figure/model4/model4_col-figure24.png )
![]( figure/model4/model4_col-figure25.png )
![]( figure/model4/model4_col-figure26.png )
![]( figure/model4/model4_col-figure27.png )
![]( figure/model4/model4_col-figure28.png )
![]( figure/model4/model4_col-figure29.png )
![]( figure/model4/model4_col-figure2.png )
![]( figure/model4/model4_col-figure30.png )
![]( figure/model4/model4_col-figure31.png )
![]( figure/model4/model4_col-figure32.png )
![]( figure/model4/model4_col-figure33.png )
![]( figure/model4/model4_col-figure3.png )
![]( figure/model4/model4_col-figure4.png )
![]( figure/model4/model4_col-figure5.png )
![]( figure/model4/model4_col-figure6.png )
![]( figure/model4/model4_col-figure7.png )
![]( figure/model4/model4_col-figure8.png )
![]( figure/model4/model4_col-figure9.png )
### Model  5 
![]( figure/model5/model5_col-figure0.png )
![]( figure/model5/model5_col-figure10.png )
![]( figure/model5/model5_col-figure11.png )
![]( figure/model5/model5_col-figure12.png )
![]( figure/model5/model5_col-figure13.png )
![]( figure/model5/model5_col-figure14.png )
![]( figure/model5/model5_col-figure15.png )
![]( figure/model5/model5_col-figure16.png )
![]( figure/model5/model5_col-figure17.png )
![]( figure/model5/model5_col-figure18.png )
![]( figure/model5/model5_col-figure19.png )
![]( figure/model5/model5_col-figure1.png )
![]( figure/model5/model5_col-figure20.png )
![]( figure/model5/model5_col-figure21.png )
![]( figure/model5/model5_col-figure22.png )
![]( figure/model5/model5_col-figure23.png )
![]( figure/model5/model5_col-figure24.png )
![]( figure/model5/model5_col-figure25.png )
![]( figure/model5/model5_col-figure26.png )
![]( figure/model5/model5_col-figure27.png )
![]( figure/model5/model5_col-figure28.png )
![]( figure/model5/model5_col-figure29.png )
![]( figure/model5/model5_col-figure2.png )
![]( figure/model5/model5_col-figure30.png )
![]( figure/model5/model5_col-figure31.png )
![]( figure/model5/model5_col-figure32.png )
![]( figure/model5/model5_col-figure33.png )
![]( figure/model5/model5_col-figure3.png )
![]( figure/model5/model5_col-figure4.png )
![]( figure/model5/model5_col-figure5.png )
![]( figure/model5/model5_col-figure6.png )
![]( figure/model5/model5_col-figure7.png )
![]( figure/model5/model5_col-figure8.png )
![]( figure/model5/model5_col-figure9.png )
## 2.2.3 Ouptputs: Tables
### Model  1 
![](figure/tables-0.png)

### Model  2 
![](figure/tables-1.png)

### Model  3 
![](figure/tables-2.png)

### Model  4 
![](figure/tables-3.png)

### Model  5 
![](figure/tables-4.png)
