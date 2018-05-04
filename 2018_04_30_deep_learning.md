Deep Learning
================

### Divid Data

``` r
library(caret)
```

    ** Loading required package: lattice

    ** Loading required package: ggplot2

``` r
idx <- createDataPartition(iris$Species, p=.7, list=F)

train <- iris[idx,]
test <- iris[-idx,]
```

``` r
table(train$Species)
```

    ** 
    **     setosa versicolor  virginica 
    **         35         35         35

``` r
table(test$Species)
```

    ** 
    **     setosa versicolor  virginica 
    **         15         15         15

### Standardization

``` r
library(nnet)
train_scale <- as.data.frame(sapply(train[,-5], scale))
test_scale <- as.data.frame(sapply(test[,-5], scale))
```

``` r
train_scale$Species <- train$Species
test_scale$Species <- test$Species
```

### Train a model

``` r
net <- nnet(Species~., train_scale, size=3)
```

    ** # weights:  27
    ** initial  value 116.205759 
    ** iter  10 value 7.395183
    ** iter  20 value 4.428322
    ** iter  30 value 2.665883
    ** iter  40 value 2.290287
    ** iter  50 value 2.262213
    ** iter  60 value 2.254373
    ** iter  70 value 2.249443
    ** iter  80 value 2.249429
    ** iter  90 value 2.249361
    ** final  value 2.249358 
    ** converged

### Predict target variable

``` r
pred <- predict(net, test_scale, type='class')
```

### Evaluate the model

``` r
confusionMatrix(pred, test$Species)
```

    ** Confusion Matrix and Statistics
    ** 
    **             Reference
    ** Prediction   setosa versicolor virginica
    **   setosa         15          0         0
    **   versicolor      0         14         0
    **   virginica       0          1        15
    ** 
    ** Overall Statistics
    **                                           
    **                Accuracy : 0.9778          
    **                  95% CI : (0.8823, 0.9994)
    **     No Information Rate : 0.3333          
    **     P-Value [Acc > NIR] : < 2.2e-16       
    **                                           
    **                   Kappa : 0.9667          
    **  Mcnemar's Test P-Value : NA              
    ** 
    ** Statistics by Class:
    ** 
    **                      Class: setosa Class: versicolor Class: virginica
    ** Sensitivity                 1.0000            0.9333           1.0000
    ** Specificity                 1.0000            1.0000           0.9667
    ** Pos Pred Value              1.0000            1.0000           0.9375
    ** Neg Pred Value              1.0000            0.9677           1.0000
    ** Prevalence                  0.3333            0.3333           0.3333
    ** Detection Rate              0.3333            0.3111           0.3333
    ** Detection Prevalence        0.3333            0.3111           0.3556
    ** Balanced Accuracy           1.0000            0.9667           0.9833
