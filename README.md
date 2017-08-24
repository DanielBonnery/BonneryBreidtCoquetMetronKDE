# Kernel Estimation for a Superpopulation Probability Density Function under Informative Selection
`pubBonneryBreidtCoquet2017` is an R package that contains the source code to reproduce the graphs and simulations of the article
"Kernel Estimation for a Superpopulation Probability Density Function under Informative Selection", by 
Daniel Bonnéry (UMD),  F. Jay Breidt (CSU) and  François Coquet (Irmar and Ensai), article under revision in Metron Journal.

## 1. How to install the package

```r
devtools::install_github("DanielBonnery/pubBonneryBreidtCoquet2017",dependencies=TRUE)
```

Note that this package depends on different R packages, including:
* [pubBonneryBreidtCoquet2016](https://github.com/DanielBonnery/pubBonneryBreidtCoquet2016) is an R package that contains generic functions to simulate populations and draw samples.
* [yihui/tikzDevice](https://github.com/yihui/tikzDevice) is an R package that allows to create tikz code from a graph.

Some functions of `pubBonneryBreidtCoquet2017` produce pdf graphics and need pdflatex to be installed.

## 2. Run the simulations

## 2.1. Obtain the paper graphs and tables.



```r
demo(MSE_Figure,package = "pubBonneryBreidtCoquet2017")
```

![plot of chunk r0_1](figure/r0_1-1.png)![plot of chunk r0_1](figure/r0_1-2.png)

|Estimator                                    |IMSE           |IMSE $\mid Y<q_{.25}$ |IMSE $\mid q_{.25}<Y<q_{.5}$ |IMSE $\mid q_{.5}<Y<q_{.75}$ |IMSE $\mid q_{.75}<Y$ |
|:--------------------------------------------|:--------------|:---------------------|:----------------------------|:----------------------------|:---------------------|
|$f$                                          |0 (0)          |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|(15) $\hat{f}_{\hat\mu,\rm{par}}$            |0.0017 (1.6)   |0.00023 (1.9)         |4e-04 (1.9)                  |0.00014 (0.59)               |0.00098 (1.9)         |
|(12) $\hat{f}_{\hat\mu,\rm{nonpar}}$         |0.0011 (1)     |0.00012 (1)           |2e-04 (1)                    |0.00023 (1)                  |0.00052 (1)           |
|(13) $\hat{f}_{\mu,\xi}$                     |0.0016 (1.5)   |0.00015 (1.2)         |0.00027 (1.3)                |9.1e-05 (0.39)               |0.0011 (2.1)          |
|(14) $\hat{f}_{\mu,\hat\xi}$                 |0.0018 (1.7)   |0.00019 (1.6)         |0.00029 (1.4)                |9.7e-05 (0.42)               |0.0012 (2.3)          |
|(4) $p$                                      |0.015 (14)     |0.0072 (59)           |0.00052 (2.6)                |0.0033 (14)                  |0.0037 (7.1)          |
|(23) $f^\dagger_{\hat\mu,\rm{par}}$          |0.001 (0.94)   |0.00013 (1)           |0.00019 (0.91)               |0.00022 (0.95)               |0.00048 (0.93)        |
|(20) $f^\dagger_{\hat\mu,\rm{nonpar}}$       |0.0015 (1.4)   |0.00043 (3.5)         |0.00015 (0.73)               |0.00041 (1.8)                |0.00051 (0.99)        |
|(21) $f^\dagger_{\mu,\xi}$                   |0.00094 (0.87) |9.8e-05 (0.81)        |0.00018 (0.86)               |0.00021 (0.9)                |0.00045 (0.87)        |
|(22) $f^\dagger_{\mu,\hat\xi}$               |0.001 (0.96)   |0.00012 (0.99)        |0.00019 (0.94)               |0.00021 (0.91)               |0.00051 (0.98)        |
|(25) $f^\dagger_{\hat\omega,\rm{nonpar}}$    |0.0015 (1.4)   |0.00046 (3.8)         |0.00014 (0.69)               |4e-04 (1.7)                  |5e-04 (0.97)          |
|(26) $f^\dagger_{\hat\omega,\rm{par}}$       |0.001 (0.93)   |0.00012 (1)           |0.00018 (0.89)               |0.00022 (0.94)               |0.00048 (0.92)        |
|(wnonpar) $\hat{f}_{\hat\omega,\rm{nonpar}}$ |0.001 (0.96)   |0.00014 (1.2)         |0.00019 (0.94)               |0.00022 (0.97)               |0.00048 (0.92)        |
|(wpar) $\hat{f}_{\hat\omega,\rm{par}}$       |0.0017 (1.6)   |0.00023 (1.9)         |0.00039 (1.9)                |0.00013 (0.57)               |0.00097 (1.9)         |
|$\hat\mu,\rm{par}                            |0.00016 (0.15) |0.00016 (1.3)         |7.7e-07 (0.0038)             |3.3e-07 (0.0014)             |3.2e-07 (0.00061)     |
|$\hat\mu,\rm{nonpar}                         |0.00041 (0.38) |0.00039 (3.2)         |2.7e-06 (0.013)              |2.8e-06 (0.012)              |1e-05 (0.02)          |
|$\mu,\hat\xi                                 |0.00089 (0.83) |0.00086 (7)           |2.1e-05 (0.1)                |9.2e-06 (0.04)               |7.1e-06 (0.014)       |
|$\mu,\xi                                     |0 (0)          |0 (0)                 |0 (0)                        |0 (0)                        |0 (0)                 |
|$\hat\omega,\rm{nonpar}                      |0.0014 (1.3)   |0.0014 (12)           |4.5e-06 (0.022)              |8.1e-07 (0.0035)             |5.4e-06 (0.01)        |
|$\hat\omega,\rm{par}                         |0.00015 (0.14) |0.00015 (1.2)         |8e-07 (0.0039)               |3.3e-07 (0.0014)             |3.1e-07 (6e-04)       |

## 2.2. Additional simulations

## 2.2.1 Models 
We ran simulations on different models. For each model, we produce a series of graphics and tables.

![](model.png)


## 2.2.2 How to run
The following R statements  will run the simulations for all the models.


```r
demo(model1,package = "pubBonneryBreidtCoquet2017")
demo(model2,package = "pubBonneryBreidtCoquet2017")
demo(model3,package = "pubBonneryBreidtCoquet2017")
demo(model4,package = "pubBonneryBreidtCoquet2017")
demo(model5,package = "pubBonneryBreidtCoquet2017")
```


## 2.2.3 Ouptputs


[[1]]
![plot of chunk r1_1](figure/r1_1-1.png)
[[2]]
![plot of chunk r1_1](figure/r1_1-2.png)
[[3]]
![plot of chunk r1_1](figure/r1_1-3.png)
[[4]]
![plot of chunk r1_1](figure/r1_1-4.png)
[[5]]
![plot of chunk r1_1](figure/r1_1-5.png)
[[6]]
![plot of chunk r1_1](figure/r1_1-6.png)
[[7]]
![plot of chunk r1_1](figure/r1_1-7.png)
[[8]]
![plot of chunk r1_1](figure/r1_1-8.png)
[[9]]
![plot of chunk r1_1](figure/r1_1-9.png)
[[10]]
![plot of chunk r1_1](figure/r1_1-10.png)
[[11]]
![plot of chunk r1_1](figure/r1_1-11.png)
[[12]]
![plot of chunk r1_1](figure/r1_1-12.png)
[[13]]
![plot of chunk r1_1](figure/r1_1-13.png)
[[14]]
![plot of chunk r1_1](figure/r1_1-14.png)
[[15]]
![plot of chunk r1_1](figure/r1_1-15.png)
[[16]]
![plot of chunk r1_1](figure/r1_1-16.png)
[[17]]
![plot of chunk r1_1](figure/r1_1-17.png)
[[18]]
![plot of chunk r1_1](figure/r1_1-18.png)
[[19]]
![plot of chunk r1_1](figure/r1_1-19.png)
[[20]]
![plot of chunk r1_1](figure/r1_1-20.png)
[[21]]
![plot of chunk r1_1](figure/r1_1-21.png)
[[22]]
![plot of chunk r1_1](figure/r1_1-22.png)
[[23]]
![plot of chunk r1_1](figure/r1_1-23.png)
[[24]]
![plot of chunk r1_1](figure/r1_1-24.png)
[[25]]
![plot of chunk r1_1](figure/r1_1-25.png)
[[26]]
![plot of chunk r1_1](figure/r1_1-26.png)
[[27]]
![plot of chunk r1_1](figure/r1_1-27.png)
[[28]]
![plot of chunk r1_1](figure/r1_1-28.png)
[[29]]
![plot of chunk r1_1](figure/r1_1-29.png)
[[30]]
![plot of chunk r1_1](figure/r1_1-30.png)
[[31]]
![plot of chunk r1_1](figure/r1_1-31.png)
[[32]]
![plot of chunk r1_1](figure/r1_1-32.png)
[[33]]
![plot of chunk r1_1](figure/r1_1-33.png)
[[34]]
![plot of chunk r1_1](figure/r1_1-34.png)
[[1]]
![plot of chunk r1_1](figure/r1_1-35.png)
[[2]]
![plot of chunk r1_1](figure/r1_1-36.png)
[[3]]
![plot of chunk r1_1](figure/r1_1-37.png)
[[4]]
![plot of chunk r1_1](figure/r1_1-38.png)
[[5]]
![plot of chunk r1_1](figure/r1_1-39.png)
[[6]]
![plot of chunk r1_1](figure/r1_1-40.png)
[[7]]
![plot of chunk r1_1](figure/r1_1-41.png)
[[8]]
![plot of chunk r1_1](figure/r1_1-42.png)
[[9]]
![plot of chunk r1_1](figure/r1_1-43.png)
[[10]]
![plot of chunk r1_1](figure/r1_1-44.png)
[[11]]
![plot of chunk r1_1](figure/r1_1-45.png)
[[12]]
![plot of chunk r1_1](figure/r1_1-46.png)
[[13]]
![plot of chunk r1_1](figure/r1_1-47.png)
[[14]]
![plot of chunk r1_1](figure/r1_1-48.png)
[[15]]
![plot of chunk r1_1](figure/r1_1-49.png)
[[16]]
![plot of chunk r1_1](figure/r1_1-50.png)
[[17]]
![plot of chunk r1_1](figure/r1_1-51.png)
[[18]]
![plot of chunk r1_1](figure/r1_1-52.png)
[[19]]
![plot of chunk r1_1](figure/r1_1-53.png)
[[20]]
![plot of chunk r1_1](figure/r1_1-54.png)
[[21]]
![plot of chunk r1_1](figure/r1_1-55.png)
[[22]]
![plot of chunk r1_1](figure/r1_1-56.png)
[[23]]
![plot of chunk r1_1](figure/r1_1-57.png)
[[24]]
![plot of chunk r1_1](figure/r1_1-58.png)
[[25]]
![plot of chunk r1_1](figure/r1_1-59.png)
[[26]]
![plot of chunk r1_1](figure/r1_1-60.png)
[[27]]
![plot of chunk r1_1](figure/r1_1-61.png)
[[28]]
![plot of chunk r1_1](figure/r1_1-62.png)
[[29]]
![plot of chunk r1_1](figure/r1_1-63.png)
[[30]]
![plot of chunk r1_1](figure/r1_1-64.png)
[[31]]
![plot of chunk r1_1](figure/r1_1-65.png)
[[32]]
![plot of chunk r1_1](figure/r1_1-66.png)
[[33]]
![plot of chunk r1_1](figure/r1_1-67.png)
[[34]]
![plot of chunk r1_1](figure/r1_1-68.png)
[[1]]
![plot of chunk r1_1](figure/r1_1-69.png)
[[2]]
![plot of chunk r1_1](figure/r1_1-70.png)
[[3]]
![plot of chunk r1_1](figure/r1_1-71.png)
[[4]]
![plot of chunk r1_1](figure/r1_1-72.png)
[[5]]
![plot of chunk r1_1](figure/r1_1-73.png)
[[6]]
![plot of chunk r1_1](figure/r1_1-74.png)
[[7]]
![plot of chunk r1_1](figure/r1_1-75.png)
[[8]]
![plot of chunk r1_1](figure/r1_1-76.png)
[[9]]
![plot of chunk r1_1](figure/r1_1-77.png)
[[10]]
![plot of chunk r1_1](figure/r1_1-78.png)
[[11]]
![plot of chunk r1_1](figure/r1_1-79.png)
[[12]]
![plot of chunk r1_1](figure/r1_1-80.png)
[[13]]
![plot of chunk r1_1](figure/r1_1-81.png)
[[14]]
![plot of chunk r1_1](figure/r1_1-82.png)
[[15]]
![plot of chunk r1_1](figure/r1_1-83.png)
[[16]]
![plot of chunk r1_1](figure/r1_1-84.png)
[[17]]
![plot of chunk r1_1](figure/r1_1-85.png)
[[18]]
![plot of chunk r1_1](figure/r1_1-86.png)
[[19]]
![plot of chunk r1_1](figure/r1_1-87.png)
[[20]]
![plot of chunk r1_1](figure/r1_1-88.png)
[[21]]
![plot of chunk r1_1](figure/r1_1-89.png)
[[22]]
![plot of chunk r1_1](figure/r1_1-90.png)
[[23]]
![plot of chunk r1_1](figure/r1_1-91.png)
[[24]]
![plot of chunk r1_1](figure/r1_1-92.png)
[[25]]
![plot of chunk r1_1](figure/r1_1-93.png)
[[26]]
![plot of chunk r1_1](figure/r1_1-94.png)
[[27]]
![plot of chunk r1_1](figure/r1_1-95.png)
[[28]]
![plot of chunk r1_1](figure/r1_1-96.png)
[[29]]
![plot of chunk r1_1](figure/r1_1-97.png)
[[30]]
![plot of chunk r1_1](figure/r1_1-98.png)
[[31]]
![plot of chunk r1_1](figure/r1_1-99.png)
[[32]]
![plot of chunk r1_1](figure/r1_1-100.png)
[[33]]
![plot of chunk r1_1](figure/r1_1-101.png)
[[34]]
![plot of chunk r1_1](figure/r1_1-102.png)
[[1]]
![plot of chunk r1_1](figure/r1_1-103.png)
[[2]]
![plot of chunk r1_1](figure/r1_1-104.png)
[[3]]
![plot of chunk r1_1](figure/r1_1-105.png)
[[4]]
![plot of chunk r1_1](figure/r1_1-106.png)
[[5]]
![plot of chunk r1_1](figure/r1_1-107.png)
[[6]]
![plot of chunk r1_1](figure/r1_1-108.png)
[[7]]
![plot of chunk r1_1](figure/r1_1-109.png)
[[8]]
![plot of chunk r1_1](figure/r1_1-110.png)
[[9]]
![plot of chunk r1_1](figure/r1_1-111.png)
[[10]]
![plot of chunk r1_1](figure/r1_1-112.png)
[[11]]
![plot of chunk r1_1](figure/r1_1-113.png)
[[12]]
![plot of chunk r1_1](figure/r1_1-114.png)
[[13]]
![plot of chunk r1_1](figure/r1_1-115.png)
[[14]]
![plot of chunk r1_1](figure/r1_1-116.png)
[[15]]
![plot of chunk r1_1](figure/r1_1-117.png)
[[16]]
![plot of chunk r1_1](figure/r1_1-118.png)
[[17]]
![plot of chunk r1_1](figure/r1_1-119.png)
[[18]]
![plot of chunk r1_1](figure/r1_1-120.png)
[[19]]
![plot of chunk r1_1](figure/r1_1-121.png)
[[20]]
![plot of chunk r1_1](figure/r1_1-122.png)
[[21]]
![plot of chunk r1_1](figure/r1_1-123.png)
[[22]]
![plot of chunk r1_1](figure/r1_1-124.png)
[[23]]
![plot of chunk r1_1](figure/r1_1-125.png)
[[24]]
![plot of chunk r1_1](figure/r1_1-126.png)
[[25]]
![plot of chunk r1_1](figure/r1_1-127.png)
[[26]]
![plot of chunk r1_1](figure/r1_1-128.png)
[[27]]
![plot of chunk r1_1](figure/r1_1-129.png)
[[28]]
![plot of chunk r1_1](figure/r1_1-130.png)
[[29]]
![plot of chunk r1_1](figure/r1_1-131.png)
[[30]]
![plot of chunk r1_1](figure/r1_1-132.png)
[[31]]
![plot of chunk r1_1](figure/r1_1-133.png)
[[32]]
![plot of chunk r1_1](figure/r1_1-134.png)
[[33]]
![plot of chunk r1_1](figure/r1_1-135.png)
[[34]]
![plot of chunk r1_1](figure/r1_1-136.png)
[[1]]
![plot of chunk r1_1](figure/r1_1-137.png)
[[2]]
![plot of chunk r1_1](figure/r1_1-138.png)
[[3]]
![plot of chunk r1_1](figure/r1_1-139.png)
[[4]]
![plot of chunk r1_1](figure/r1_1-140.png)
[[5]]
![plot of chunk r1_1](figure/r1_1-141.png)
[[6]]
![plot of chunk r1_1](figure/r1_1-142.png)
[[7]]
![plot of chunk r1_1](figure/r1_1-143.png)
[[8]]
![plot of chunk r1_1](figure/r1_1-144.png)
[[9]]
![plot of chunk r1_1](figure/r1_1-145.png)
[[10]]
![plot of chunk r1_1](figure/r1_1-146.png)
[[11]]
![plot of chunk r1_1](figure/r1_1-147.png)
[[12]]
![plot of chunk r1_1](figure/r1_1-148.png)
[[13]]
![plot of chunk r1_1](figure/r1_1-149.png)
[[14]]
![plot of chunk r1_1](figure/r1_1-150.png)
[[15]]
![plot of chunk r1_1](figure/r1_1-151.png)
[[16]]
![plot of chunk r1_1](figure/r1_1-152.png)
[[17]]
![plot of chunk r1_1](figure/r1_1-153.png)
[[18]]
![plot of chunk r1_1](figure/r1_1-154.png)
[[19]]
![plot of chunk r1_1](figure/r1_1-155.png)
[[20]]
![plot of chunk r1_1](figure/r1_1-156.png)
[[21]]
![plot of chunk r1_1](figure/r1_1-157.png)
[[22]]
![plot of chunk r1_1](figure/r1_1-158.png)
[[23]]
![plot of chunk r1_1](figure/r1_1-159.png)
[[24]]
![plot of chunk r1_1](figure/r1_1-160.png)
[[25]]
![plot of chunk r1_1](figure/r1_1-161.png)
[[26]]
![plot of chunk r1_1](figure/r1_1-162.png)
[[27]]
![plot of chunk r1_1](figure/r1_1-163.png)
[[28]]
![plot of chunk r1_1](figure/r1_1-164.png)
[[29]]
![plot of chunk r1_1](figure/r1_1-165.png)
[[30]]
![plot of chunk r1_1](figure/r1_1-166.png)
[[31]]
![plot of chunk r1_1](figure/r1_1-167.png)
[[32]]
![plot of chunk r1_1](figure/r1_1-168.png)
[[33]]
![plot of chunk r1_1](figure/r1_1-169.png)
[[34]]
![plot of chunk r1_1](figure/r1_1-170.png)
