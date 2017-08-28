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

![plot of chunk r0_1](figure/r0_1-1.png)

|Estimator                                 |IMSE          |IMSE $\mid Y<q_{.25}$ |IMSE $\mid q_{.25}<Y<q_{.5}$ |IMSE $\mid q_{.5}<Y<q_{.75}$ |IMSE $\mid q_{.75}<Y$ |
|:-----------------------------------------|:-------------|:---------------------|:----------------------------|:----------------------------|:---------------------|
|$f$                                       |0 (0)         |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$f^\dagger_{\hat\mu,\rm{par}}$ (25)       |0.0064 (2.7)  |0.0046 (2.4)          |0.00036 (1.5)                |0.0011 (16)                  |0.00033 (2.2)         |
|$f^\dagger_{\hat\mu,\rm{nonpar}}$ (22)    |0.0024 (1)    |0.0019 (1)            |0.00024 (1)                  |7.4e-05 (1)                  |0.00015 (1)           |
|$f^\dagger_{\mu,\xi}$ (23)                |0.0041 (1.7)  |0.0036 (1.9)          |0.00031 (1.3)                |0.00018 (2.5)                |5.7e-05 (0.38)        |
|$f^\dagger_{\mu,\hat\xi}$ (24)            |0.0098 (4.2)  |0.0071 (3.7)          |0.00095 (3.9)                |0.00047 (6.4)                |0.0013 (8.9)          |
|$f^\dagger_{\hat\omega,\rm{nonpar}}$ (26) |0.0048 (2)    |0.0039 (2)            |0.00035 (1.5)                |4e-04 (5.4)                  |0.00012 (0.78)        |
|$f^\dagger_{\hat\omega,\rm{par}}$ (27)    |0.0078 (3.3)  |0.0052 (2.7)          |0.00045 (1.9)                |0.0017 (23)                  |0.00052 (3.5)         |
|$p$ (4)                                   |0.041 (17)    |0.024 (13)            |0.0083 (35)                  |0.00079 (11)                 |0.0075 (50)           |
|$\hat{f}_{\hat\mu,\rm{par}}$ (14)         |0.0078 (3.3)  |0.006 (3.2)           |0.00036 (1.5)                |0.0011 (15)                  |0.00034 (2.2)         |
|$\hat{f}_{\hat\mu,\rm{nonpar}}$ (11)      |0.0037 (1.6)  |0.0032 (1.7)          |0.00017 (0.69)               |0.00011 (1.6)                |0.00022 (1.5)         |
|$\hat{f}_{\mu,\xi}$ (12)                  |0.00094 (0.4) |0.00054 (0.28)        |0.00021 (0.89)               |0.00013 (1.8)                |5.7e-05 (0.38)        |
|$\hat{f}_{\mu,\hat\xi}$ (13)              |0.012 (4.9)   |0.0088 (4.6)          |0.0011 (4.6)                 |0.00046 (6.2)                |0.0013 (8.7)          |
|$\hat{f}_{\hat\omega,\rm{nonpar}}$ (17)   |0.0016 (0.67) |0.00092 (0.48)        |0.00022 (0.9)                |0.00034 (4.6)                |0.00011 (0.74)        |
|$\hat{f}_{\hat\omega,\rm{par}}$ (18)      |0.0091 (3.8)  |0.0065 (3.4)          |0.00044 (1.8)                |0.0016 (21)                  |0.00053 (3.5)         |
|$\hat\mu,\rm{par}$                        |0.45 (190)    |0.00088 (0.46)        |0.00037 (1.5)                |0.0031 (42)                  |0.44 (2900)           |
|$\hat\mu,\rm{nonpar}$                     |0.011 (4.8)   |0.0048 (2.5)          |0.00084 (3.5)                |0.00018 (2.4)                |0.0055 (37)           |
|$\mu,\hat\xi$                             |0.13 (54)     |0.0028 (1.5)          |0.00064 (2.7)                |0.00015 (2.1)                |0.12 (830)            |
|$\mu,\xi$                                 |0 (0)         |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$\hat\omega,\rm{nonpar}$                  |0.008 (3.4)   |0.00017 (0.088)       |0.00018 (0.73)               |0.00028 (3.7)                |0.0074 (49)           |
|$\hat\omega,\rm{par}$                     |52 (22000)    |0.00096 (0.51)        |0.00049 (2)                  |0.0044 (59)                  |52 (340000)           |

## 3. Run additional simulations

We ran simulations on different models. For each model, we produce a series of graphics and tables.

![](figure/model1.png)
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
### Model 1:

|Estimator                                 |IMSE           |IMSE $\mid Y<q_{.25}$ |IMSE $\mid q_{.25}<Y<q_{.5}$ |IMSE $\mid q_{.5}<Y<q_{.75}$ |IMSE $\mid q_{.75}<Y$ |
|:-----------------------------------------|:--------------|:---------------------|:----------------------------|:----------------------------|:---------------------|
|$f$                                       |0 (0)          |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$f^\dagger_{\hat\mu,\rm{par}}$ (25)       |0.0018 (1.6)   |0.00023 (1.9)         |4e-04 (2)                    |0.00014 (0.57)               |0.00099 (1.8)         |
|$f^\dagger_{\hat\mu,\rm{nonpar}}$ (22)    |0.0011 (1)     |0.00012 (1)           |2e-04 (1)                    |0.00025 (1)                  |0.00055 (1)           |
|$f^\dagger_{\mu,\xi}$ (23)                |0.0016 (1.5)   |0.00015 (1.2)         |0.00028 (1.4)                |9.6e-05 (0.38)               |0.0011 (2)            |
|$f^\dagger_{\mu,\hat\xi}$ (24)            |0.0018 (1.6)   |2e-04 (1.6)           |3e-04 (1.5)                  |1e-04 (0.41)                 |0.0012 (2.2)          |
|$f^\dagger_{\hat\omega,\rm{nonpar}}$ (26) |0.0011 (0.98)  |0.00015 (1.2)         |0.00019 (0.94)               |0.00025 (1)                  |0.00051 (0.93)        |
|$f^\dagger_{\hat\omega,\rm{par}}$ (27)    |0.0017 (1.5)   |0.00023 (1.9)         |0.00039 (1.9)                |0.00014 (0.56)               |0.00097 (1.8)         |
|$p$ (4)                                   |0.015 (13)     |0.0072 (59)           |0.00052 (2.6)                |0.0034 (14)                  |0.0037 (6.7)          |
|$\hat{f}_{\hat\mu,\rm{par}}$ (14)         |0.0011 (0.94)  |0.00013 (1.1)         |0.00019 (0.95)               |0.00024 (0.95)               |0.00049 (0.9)         |
|$\hat{f}_{\hat\mu,\rm{nonpar}}$ (11)      |0.0016 (1.4)   |0.00043 (3.5)         |0.00015 (0.74)               |0.00044 (1.8)                |0.00054 (0.98)        |
|$\hat{f}_{\mu,\xi}$ (12)                  |0.00098 (0.87) |9.8e-05 (0.8)         |0.00019 (0.92)               |0.00022 (0.9)                |0.00047 (0.86)        |
|$\hat{f}_{\mu,\hat\xi}$ (13)              |0.0011 (0.96)  |0.00013 (1)           |2e-04 (0.99)                 |0.00023 (0.92)               |0.00052 (0.96)        |
|$\hat{f}_{\hat\omega,\rm{nonpar}}$ (17)   |0.0016 (1.4)   |0.00047 (3.8)         |0.00014 (0.71)               |0.00043 (1.7)                |0.00053 (0.97)        |
|$\hat{f}_{\hat\omega,\rm{par}}$ (18)      |0.001 (0.93)   |0.00013 (1.1)         |0.00019 (0.93)               |0.00023 (0.94)               |0.00049 (0.89)        |
|$\hat\mu,\rm{par}$                        |0.00018 (0.16) |0.00018 (1.5)         |7.9e-07 (0.0039)             |3.3e-07 (0.0013)             |3.4e-07 (0.00062)     |
|$\hat\mu,\rm{nonpar}$                     |0.00045 (0.4)  |0.00043 (3.5)         |2.5e-06 (0.012)              |2.7e-06 (0.011)              |1e-05 (0.018)         |
|$\mu,\hat\xi$                             |0.0011 (1)     |0.0011 (8.9)          |2.8e-05 (0.14)               |1.3e-05 (0.051)              |1e-05 (0.018)         |
|$\mu,\xi$                                 |0 (0)          |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$\hat\omega,\rm{nonpar}$                  |0.0015 (1.3)   |0.0015 (12)           |4.6e-06 (0.023)              |8e-07 (0.0032)               |5.2e-06 (0.0095)      |
|$\hat\omega,\rm{par}$                     |0.00017 (0.15) |0.00017 (1.4)         |8.2e-07 (0.004)              |3.4e-07 (0.0014)             |3.4e-07 (0.00062)     |
### Model 2:

|Estimator                                 |IMSE              |IMSE $\mid Y<q_{.25}$ |IMSE $\mid q_{.25}<Y<q_{.5}$ |IMSE $\mid q_{.5}<Y<q_{.75}$ |IMSE $\mid q_{.75}<Y$ |
|:-----------------------------------------|:-----------------|:---------------------|:----------------------------|:----------------------------|:---------------------|
|$f$                                       |0 (0)             |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$f^\dagger_{\hat\mu,\rm{par}}$ (25)       |0.0031 (1.1)      |0.00043 (1)           |0.00062 (1.1)                |0.00047 (0.85)               |0.0016 (1.4)          |
|$f^\dagger_{\hat\mu,\rm{nonpar}}$ (22)    |0.0027 (1)        |0.00043 (1)           |0.00055 (1)                  |0.00056 (1)                  |0.0012 (1)            |
|$f^\dagger_{\mu,\xi}$ (23)                |9.7e+45 (3.6e+48) |1.6e+45 (3.6e+48)     |2.5e+45 (4.5e+48)            |3.7e+45 (6.6e+48)            |1.9e+45 (1.7e+48)     |
|$f^\dagger_{\mu,\hat\xi}$ (24)            |1.1e+46 (4.1e+48) |1.8e+45 (4.1e+48)     |2.8e+45 (5.1e+48)            |4.2e+45 (7.6e+48)            |2.4e+45 (2.1e+48)     |
|$f^\dagger_{\hat\omega,\rm{nonpar}}$ (26) |0.0026 (0.96)     |0.00046 (1.1)         |0.00051 (0.92)               |5e-04 (0.89)                 |0.0011 (0.98)         |
|$f^\dagger_{\hat\omega,\rm{par}}$ (27)    |0.0031 (1.1)      |0.00043 (1)           |0.00061 (1.1)                |0.00047 (0.84)               |0.0016 (1.3)          |
|$p$ (4)                                   |0.016 (6)         |0.0078 (18)           |0.00077 (1.4)                |0.0036 (6.3)                 |0.004 (3.5)           |
|$\hat{f}_{\hat\mu,\rm{par}}$ (14)         |0.0026 (0.97)     |0.00043 (1)           |0.00053 (0.95)               |0.00055 (0.98)               |0.0011 (0.96)         |
|$\hat{f}_{\hat\mu,\rm{nonpar}}$ (11)      |0.0029 (1.1)      |0.00064 (1.5)         |0.00051 (0.92)               |0.00066 (1.2)                |0.0011 (0.94)         |
|$\hat{f}_{\mu,\xi}$ (12)                  |0.0026 (0.94)     |0.00039 (0.92)        |0.00052 (0.94)               |0.00054 (0.96)               |0.0011 (0.95)         |
|$\hat{f}_{\mu,\hat\xi}$ (13)              |0.0026 (0.97)     |0.00043 (1)           |0.00052 (0.95)               |0.00055 (0.97)               |0.0011 (0.96)         |
|$\hat{f}_{\hat\omega,\rm{nonpar}}$ (17)   |0.0029 (1.1)      |0.00067 (1.6)         |0.00049 (0.89)               |0.00064 (1.1)                |0.0011 (0.92)         |
|$\hat{f}_{\hat\omega,\rm{par}}$ (18)      |0.0026 (0.97)     |0.00043 (1)           |0.00052 (0.95)               |0.00055 (0.97)               |0.0011 (0.96)         |
|$\hat\mu,\rm{par}$                        |4.6e-05 (0.017)   |4.4e-05 (0.1)         |7.5e-07 (0.0013)             |3.2e-07 (0.00057)            |3e-07 (0.00026)       |
|$\hat\mu,\rm{nonpar}$                     |5.9e-05 (0.022)   |4.8e-05 (0.11)        |2.2e-06 (0.0039)             |2.1e-06 (0.0037)             |6e-06 (0.0052)        |
|$\mu,\hat\xi$                             |0.00065 (0.24)    |0.00058 (1.4)         |3.5e-05 (0.063)              |1.6e-05 (0.029)              |1.2e-05 (0.011)       |
|$\mu,\xi$                                 |0 (0)             |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$\hat\omega,\rm{nonpar}$                  |0.00033 (0.12)    |0.00032 (0.75)        |3.8e-06 (0.007)              |8.4e-07 (0.0015)             |3.1e-06 (0.0027)      |
|$\hat\omega,\rm{par}$                     |4.4e-05 (0.016)   |4.2e-05 (0.099)       |7.7e-07 (0.0014)             |3.2e-07 (0.00058)            |3e-07 (0.00026)       |
### Model 3:

|Estimator                                 |IMSE              |IMSE $\mid Y<q_{.25}$ |IMSE $\mid q_{.25}<Y<q_{.5}$ |IMSE $\mid q_{.5}<Y<q_{.75}$ |IMSE $\mid q_{.75}<Y$ |
|:-----------------------------------------|:-----------------|:---------------------|:----------------------------|:----------------------------|:---------------------|
|$f$                                       |0 (0)             |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$f^\dagger_{\hat\mu,\rm{par}}$ (25)       |0.022 (10)        |0.0016 (2.9)          |0.0073 (9.9)                 |0.0068 (10)                  |0.0068 (31)           |
|$f^\dagger_{\hat\mu,\rm{nonpar}}$ (22)    |0.0021 (1)        |0.00053 (1)           |0.00074 (1)                  |0.00065 (1)                  |0.00022 (1)           |
|$f^\dagger_{\mu,\xi}$ (23)                |0.0026 (1.2)      |0.00053 (1)           |0.00079 (1.1)                |0.001 (1.6)                  |0.00023 (1)           |
|$f^\dagger_{\mu,\hat\xi}$ (24)            |0.0026 (1.2)      |0.00053 (1)           |0.00079 (1.1)                |0.001 (1.6)                  |0.00023 (1)           |
|$f^\dagger_{\hat\omega,\rm{nonpar}}$ (26) |0.035 (16)        |0.0022 (4.2)          |0.0018 (2.4)                 |0.028 (42)                   |0.003 (13)            |
|$f^\dagger_{\hat\omega,\rm{par}}$ (27)    |0.023 (11)        |0.0014 (2.6)          |0.0072 (9.8)                 |0.0072 (11)                  |0.0075 (34)           |
|$p$ (4)                                   |0.089 (42)        |0.011 (21)            |0.019 (26)                   |0.014 (21)                   |0.045 (200)           |
|$\hat{f}_{\hat\mu,\rm{par}}$ (14)         |0.023 (11)        |0.0015 (2.9)          |0.0073 (9.8)                 |0.0068 (10)                  |0.0072 (32)           |
|$\hat{f}_{\hat\mu,\rm{nonpar}}$ (11)      |0.0019 (0.89)     |0.00053 (1)           |0.00069 (0.93)               |0.00046 (0.7)                |0.00024 (1.1)         |
|$\hat{f}_{\mu,\xi}$ (12)                  |0.002 (0.94)      |0.00052 (0.99)        |0.00072 (0.98)               |0.00055 (0.84)               |0.00021 (0.97)        |
|$\hat{f}_{\mu,\hat\xi}$ (13)              |0.002 (0.94)      |0.00052 (0.99)        |0.00072 (0.98)               |0.00055 (0.84)               |0.00021 (0.97)        |
|$\hat{f}_{\hat\omega,\rm{nonpar}}$ (17)   |0.031 (14)        |0.0022 (4.1)          |0.0017 (2.3)                 |0.024 (36)                   |0.0034 (15)           |
|$\hat{f}_{\hat\omega,\rm{par}}$ (18)      |0.024 (11)        |0.0013 (2.5)          |0.0072 (9.8)                 |0.0072 (11)                  |0.0079 (36)           |
|$\hat\mu,\rm{par}$                        |0.068 (32)        |0.00052 (0.98)        |9.4e-05 (0.13)               |0.0011 (1.7)                 |0.066 (300)           |
|$\hat\mu,\rm{nonpar}$                     |0.0035 (1.6)      |2.9e-12 (5.6e-09)     |6e-05 (0.081)                |0.0034 (5.2)                 |6e-05 (0.27)          |
|$\mu,\hat\xi$                             |3.5e-08 (1.6e-05) |2.3e-19 (4.4e-16)     |3.8e-10 (5.1e-07)            |2e-08 (3.1e-05)              |1.4e-08 (6.4e-05)     |
|$\mu,\xi$                                 |0 (0)             |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$\hat\omega,\rm{nonpar}$                  |0.0037 (1.7)      |3.9e-16 (7.3e-13)     |2e-07 (0.00027)              |0.002 (3.1)                  |0.0017 (7.6)          |
|$\hat\omega,\rm{par}$                     |0.12 (54)         |5e-04 (0.94)          |8.5e-05 (0.12)               |0.0012 (1.8)                 |0.11 (520)            |
### Model 4:


|Estimator                                 |IMSE             |IMSE $\mid Y<q_{.25}$ |IMSE $\mid q_{.25}<Y<q_{.5}$ |IMSE $\mid q_{.5}<Y<q_{.75}$ |IMSE $\mid q_{.75}<Y$ |
|:-----------------------------------------|:----------------|:---------------------|:----------------------------|:----------------------------|:---------------------|
|$f$                                       |0 (0)            |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$f^\dagger_{\hat\mu,\rm{par}}$ (25)       |0.098 (1.1)      |0.067 (1.1)           |0.0049 (0.93)                |0.0038 (0.48)                |0.022 (1.6)           |
|$f^\dagger_{\hat\mu,\rm{nonpar}}$ (22)    |0.086 (1)        |0.059 (1)             |0.0053 (1)                   |0.008 (1)                    |0.014 (1)             |
|$f^\dagger_{\mu,\xi}$ (23)                |0.067 (0.78)     |0.054 (0.9)           |0.0038 (0.72)                |0.0042 (0.53)                |0.0054 (0.39)         |
|$f^\dagger_{\mu,\hat\xi}$ (24)            |0.068 (0.79)     |0.054 (0.91)          |0.0042 (0.79)                |0.0042 (0.53)                |0.0056 (0.4)          |
|$f^\dagger_{\hat\omega,\rm{nonpar}}$ (26) |0.35 (4)         |0.18 (3)              |0.043 (8.2)                  |0.052 (6.5)                  |0.073 (5.2)           |
|$f^\dagger_{\hat\omega,\rm{par}}$ (27)    |0.097 (1.1)      |0.068 (1.2)           |0.0049 (0.92)                |0.0038 (0.47)                |0.02 (1.4)            |
|$p$ (4)                                   |0.058 (0.67)     |0.038 (0.65)          |0.01 (1.9)                   |0.0037 (0.46)                |0.0054 (0.39)         |
|$\hat{f}_{\hat\mu,\rm{par}}$ (14)         |0.11 (1.2)       |0.075 (1.3)           |0.0071 (1.3)                 |0.0048 (0.6)                 |0.02 (1.4)            |
|$\hat{f}_{\hat\mu,\rm{nonpar}}$ (11)      |0.081 (0.93)     |0.058 (0.98)          |0.0045 (0.85)                |0.0065 (0.81)                |0.012 (0.84)          |
|$\hat{f}_{\mu,\xi}$ (12)                  |0.069 (0.8)      |0.058 (0.98)          |0.0027 (0.5)                 |0.0033 (0.42)                |0.0049 (0.35)         |
|$\hat{f}_{\mu,\hat\xi}$ (13)              |0.07 (0.81)      |0.059 (0.99)          |0.0029 (0.56)                |0.0033 (0.42)                |0.005 (0.36)          |
|$\hat{f}_{\hat\omega,\rm{nonpar}}$ (17)   |0.32 (3.7)       |0.19 (3.2)            |0.035 (6.5)                  |0.048 (6.1)                  |0.043 (3.1)           |
|$\hat{f}_{\hat\omega,\rm{par}}$ (18)      |0.11 (1.2)       |0.076 (1.3)           |0.0069 (1.3)                 |0.0046 (0.57)                |0.018 (1.3)           |
|$\hat\mu,\rm{par}$                        |0.0029 (0.034)   |2.2e-05 (0.00037)     |2.7e-05 (0.0051)             |4.3e-05 (0.0054)             |0.0028 (0.2)          |
|$\hat\mu,\rm{nonpar}$                     |0.02 (0.23)      |7.9e-07 (1.3e-05)     |1e-05 (0.002)                |7.7e-05 (0.0097)             |0.02 (1.4)            |
|$\mu,\hat\xi$                             |0.00022 (0.0025) |3.4e-08 (5.7e-07)     |4.2e-07 (7.8e-05)            |2.8e-06 (0.00035)            |0.00022 (0.015)       |
|$\mu,\xi$                                 |0 (0)            |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$\hat\omega,\rm{nonpar}$                  |0.02 (0.24)      |4.4e-05 (0.00075)     |0.00016 (0.031)              |0.00041 (0.051)              |0.02 (1.4)            |
|$\hat\omega,\rm{par}$                     |0.003 (0.034)    |2.4e-05 (0.00041)     |3.1e-05 (0.0058)             |5.1e-05 (0.0064)             |0.0029 (0.21)         |
### Model 5:

|Estimator                                 |IMSE          |IMSE $\mid Y<q_{.25}$ |IMSE $\mid q_{.25}<Y<q_{.5}$ |IMSE $\mid q_{.5}<Y<q_{.75}$ |IMSE $\mid q_{.75}<Y$ |
|:-----------------------------------------|:-------------|:---------------------|:----------------------------|:----------------------------|:---------------------|
|$f$                                       |0 (0)         |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$f^\dagger_{\hat\mu,\rm{par}}$ (25)       |0.0064 (2.7)  |0.0046 (2.4)          |0.00036 (1.5)                |0.0011 (16)                  |0.00033 (2.2)         |
|$f^\dagger_{\hat\mu,\rm{nonpar}}$ (22)    |0.0024 (1)    |0.0019 (1)            |0.00024 (1)                  |7.4e-05 (1)                  |0.00015 (1)           |
|$f^\dagger_{\mu,\xi}$ (23)                |0.0041 (1.7)  |0.0036 (1.9)          |0.00031 (1.3)                |0.00018 (2.5)                |5.7e-05 (0.38)        |
|$f^\dagger_{\mu,\hat\xi}$ (24)            |0.0098 (4.2)  |0.0071 (3.7)          |0.00095 (3.9)                |0.00047 (6.4)                |0.0013 (8.9)          |
|$f^\dagger_{\hat\omega,\rm{nonpar}}$ (26) |0.0048 (2)    |0.0039 (2)            |0.00035 (1.5)                |4e-04 (5.4)                  |0.00012 (0.78)        |
|$f^\dagger_{\hat\omega,\rm{par}}$ (27)    |0.0078 (3.3)  |0.0052 (2.7)          |0.00045 (1.9)                |0.0017 (23)                  |0.00052 (3.5)         |
|$p$ (4)                                   |0.041 (17)    |0.024 (13)            |0.0083 (35)                  |0.00079 (11)                 |0.0075 (50)           |
|$\hat{f}_{\hat\mu,\rm{par}}$ (14)         |0.0078 (3.3)  |0.006 (3.2)           |0.00036 (1.5)                |0.0011 (15)                  |0.00034 (2.2)         |
|$\hat{f}_{\hat\mu,\rm{nonpar}}$ (11)      |0.0037 (1.6)  |0.0032 (1.7)          |0.00017 (0.69)               |0.00011 (1.6)                |0.00022 (1.5)         |
|$\hat{f}_{\mu,\xi}$ (12)                  |0.00094 (0.4) |0.00054 (0.28)        |0.00021 (0.89)               |0.00013 (1.8)                |5.7e-05 (0.38)        |
|$\hat{f}_{\mu,\hat\xi}$ (13)              |0.012 (4.9)   |0.0088 (4.6)          |0.0011 (4.6)                 |0.00046 (6.2)                |0.0013 (8.7)          |
|$\hat{f}_{\hat\omega,\rm{nonpar}}$ (17)   |0.0016 (0.67) |0.00092 (0.48)        |0.00022 (0.9)                |0.00034 (4.6)                |0.00011 (0.74)        |
|$\hat{f}_{\hat\omega,\rm{par}}$ (18)      |0.0091 (3.8)  |0.0065 (3.4)          |0.00044 (1.8)                |0.0016 (21)                  |0.00053 (3.5)         |
|$\hat\mu,\rm{par}$                        |0.45 (190)    |0.00088 (0.46)        |0.00037 (1.5)                |0.0031 (42)                  |0.44 (2900)           |
|$\hat\mu,\rm{nonpar}$                     |0.011 (4.8)   |0.0048 (2.5)          |0.00084 (3.5)                |0.00018 (2.4)                |0.0055 (37)           |
|$\mu,\hat\xi$                             |0.13 (54)     |0.0028 (1.5)          |0.00064 (2.7)                |0.00015 (2.1)                |0.12 (830)            |
|$\mu,\xi$                                 |0 (0)         |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$\hat\omega,\rm{nonpar}$                  |0.008 (3.4)   |0.00017 (0.088)       |0.00018 (0.73)               |0.00028 (3.7)                |0.0074 (49)           |
|$\hat\omega,\rm{par}$                     |52 (22000)    |0.00096 (0.51)        |0.00049 (2)                  |0.0044 (59)                  |52 (340000)           |
