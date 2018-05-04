Logistic Regression
================

### Import Data

``` r
drink <- read.csv("data/drink.csv")
drink
```

    **    나이 결혼여부 자녀여부 체력 주량  직급 성별 지각여부
    ** 1    29        N        N   상   상  대리   남        N
    ** 2    31        Y        Y   하   하  과장   남        Y
    ** 3    44        Y        Y   하   하  차장   여        N
    ** 4    45        Y        Y   중   하  차장   남        Y
    ** 5    52        Y        N   중   중  실장   남        Y
    ** 6    26        N        N   상   상  대리   남        N
    ** 7    35        N        N   중   상 과장    남        N
    ** 8    46        Y        Y   하   중 차장    남        Y
    ** 9    28        N        N   상   중  대리   여        N
    ** 10   33        Y        N   하   하  과장   여        N
    ** 11   38        Y        Y   중   하  과장   여        Y
    ** 12   39        N        N   중   상  과장   남        N

### Check Data

``` r
dim(drink)
```

    ** [1] 12  8

``` r
str(drink)
```

    ** 'data.frame':    12 obs. of  8 variables:
    **  $ 나이    : int  29 31 44 45 52 26 35 46 28 33 ...
    **  $ 결혼여부: Factor w/ 2 levels "N","Y": 1 2 2 2 2 1 1 2 1 2 ...
    **  $ 자녀여부: Factor w/ 2 levels "N","Y": 1 2 2 2 1 1 1 2 1 1 ...
    **  $ 체력    : Factor w/ 3 levels "상","중","하": 1 3 3 2 2 1 2 3 1 3 ...
    **  $ 주량    : Factor w/ 3 levels "상","중","하": 1 3 3 3 2 1 1 2 2 3 ...
    **  $ 직급    : Factor w/ 6 levels "과장","과장 ",..: 3 1 5 5 4 3 2 6 3 1 ...
    **  $ 성별    : Factor w/ 2 levels "남","여": 1 1 2 1 1 1 1 1 2 2 ...
    **  $ 지각여부: Factor w/ 2 levels "N","Y": 1 2 1 2 2 1 1 2 1 1 ...

``` r
names(drink)
```

    ** [1] "나이"     "결혼여부" "자녀여부" "체력"     "주량"     "직급"    
    ** [7] "성별"     "지각여부"

### Make a model

``` r
library(class)
m <- glm(지각여부 ~ ., family=binomial(link=logit), data=drink)
summary(m)
```

    ** 
    ** Call:
    ** glm(formula = 지각여부 ~ ., family = binomial(link = logit), 
    **     data = drink)
    ** 
    ** Deviance Residuals: 
    **  [1]  0  0  0  0  0  0  0  0  0  0  0  0
    ** 
    ** Coefficients: (2 not defined because of singularities)
    **               Estimate Std. Error z value Pr(>|z|)
    ** (Intercept) -2.457e+01  1.701e+06       0        1
    ** 나이         8.063e-15  6.176e+04       0        1
    ** 결혼여부Y    2.457e+01  8.513e+05       0        1
    ** 자녀여부Y    2.457e+01  1.953e+05       0        1
    ** 체력중      -6.300e-14  7.281e+05       0        1
    ** 체력하      -2.457e+01  5.074e+05       0        1
    ** 주량중       2.457e+01  2.584e+05       0        1
    ** 주량하       2.457e+01  1.124e+06       0        1
    ** 직급과장     2.795e-14  3.088e+05       0        1
    ** 직급대리            NA         NA      NA       NA
    ** 직급실장    -1.152e-06  3.706e+05       0        1
    ** 직급차장    -2.457e+01  6.313e+05       0        1
    ** 직급차장            NA         NA      NA       NA
    ** 성별여      -2.457e+01  2.269e+05       0        1
    ** 
    ** (Dispersion parameter for binomial family taken to be 1)
    ** 
    **     Null deviance: 1.6301e+01  on 11  degrees of freedom
    ** Residual deviance: 5.1440e-10  on  0  degrees of freedom
    ** AIC: 24
    ** 
    ** Number of Fisher Scoring iterations: 23

### Predict target variable

``` r
predict(m, drink, type="response")
```

    **            1            2            3            4            5 
    ** 2.143345e-11 1.000000e+00 2.143345e-11 1.000000e+00 1.000000e+00 
    **            6            7            8            9           10 
    ** 2.143345e-11 2.143345e-11 1.000000e+00 2.143345e-11 2.143345e-11 
    **           11           12 
    ** 1.000000e+00 2.143345e-11

``` r
pred <- predict(m, drink, type="response") >= 0.5
pred
```

    **     1     2     3     4     5     6     7     8     9    10    11    12 
    ** FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE

### Evaluate the model

``` r
library(caret)
```

    ** Loading required package: lattice

    ** Loading required package: ggplot2

``` r
pred <- factor(as.integer(pred), levels=c(0,1), labels=c("Y","N"))
real <- factor(drink$지각여부, levels=c("Y","N"))
confusionMatrix(pred, real)
```

    ** Confusion Matrix and Statistics
    ** 
    **           Reference
    ** Prediction Y N
    **          Y 0 7
    **          N 5 0
    **                                      
    **                Accuracy : 0          
    **                  95% CI : (0, 0.2646)
    **     No Information Rate : 0.5833     
    **     P-Value [Acc > NIR] : 1.0000     
    **                                      
    **                   Kappa : -0.9459    
    **  Mcnemar's Test P-Value : 0.7728     
    **                                      
    **             Sensitivity : 0.0000     
    **             Specificity : 0.0000     
    **          Pos Pred Value : 0.0000     
    **          Neg Pred Value : 0.0000     
    **              Prevalence : 0.4167     
    **          Detection Rate : 0.0000     
    **    Detection Prevalence : 0.5833     
    **       Balanced Accuracy : 0.0000     
    **                                      
    **        'Positive' Class : Y          
    **
