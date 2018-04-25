Decision Tree
================

Divid Data
----------

``` r
library(caret)
```

    Loading required package: lattice

    Loading required package: ggplot2

``` r
idx <- createDataPartition(iris$Species, p=.7, list=F)
train <- iris[idx,]
test <- iris[-idx,]
table(train$Species)
```


        setosa versicolor  virginica 
            35         35         35 

Train model
-----------

##### rpart(formula, data= , method= , control= , na.action=na.rpart)

``` r
library(rpart)
tree <- rpart(Species ~ ., train)
tree
```

    n= 105 

    node), split, n, loss, yval, (yprob)
          * denotes terminal node

    1) root 105 70 setosa (0.33333333 0.33333333 0.33333333)  
      2) Petal.Length< 2.45 35  0 setosa (1.00000000 0.00000000 0.00000000) *
      3) Petal.Length>=2.45 70 35 versicolor (0.00000000 0.50000000 0.50000000)  
        6) Petal.Width< 1.65 37  2 versicolor (0.00000000 0.94594595 0.05405405) *
        7) Petal.Width>=1.65 33  0 virginica (0.00000000 0.00000000 1.00000000) *

Explore Tree
------------

``` r
plotcp(tree)
```

<img src="2018_04_25_Decision_Tree_files/figure-markdown_github/unnamed-chunk-3-1.png" width="900" />

``` r
plot(tree, main="Classification tree for iris")
text(tree, cex=1)
```

<img src="2018_04_25_Decision_Tree_files/figure-markdown_github/unnamed-chunk-4-1.png" width="900" />

predict test data
-----------------

``` r
tree_pred <- predict(tree, test, type="class")
head(tree_pred, 20)
```

             2         11         13         14         20         21 
        setosa     setosa     setosa     setosa     setosa     setosa 
            22         23         27         29         37         39 
        setosa     setosa     setosa     setosa     setosa     setosa 
            42         43         44         55         57         59 
        setosa     setosa     setosa versicolor versicolor versicolor 
            61         63 
    versicolor versicolor 
    Levels: setosa versicolor virginica

``` r
tree_pred_prob <- predict(tree, test, type="prob")
head(tree_pred_prob, 20)
```

       setosa versicolor  virginica
    2       1  0.0000000 0.00000000
    11      1  0.0000000 0.00000000
    13      1  0.0000000 0.00000000
    14      1  0.0000000 0.00000000
    20      1  0.0000000 0.00000000
    21      1  0.0000000 0.00000000
    22      1  0.0000000 0.00000000
    23      1  0.0000000 0.00000000
    27      1  0.0000000 0.00000000
    29      1  0.0000000 0.00000000
    37      1  0.0000000 0.00000000
    39      1  0.0000000 0.00000000
    42      1  0.0000000 0.00000000
    43      1  0.0000000 0.00000000
    44      1  0.0000000 0.00000000
    55      0  0.9459459 0.05405405
    57      0  0.9459459 0.05405405
    59      0  0.9459459 0.05405405
    61      0  0.9459459 0.05405405
    63      0  0.9459459 0.05405405

Evaluate a model
----------------

``` r
confusionMatrix(tree_pred, test$Species)
```

    Confusion Matrix and Statistics

                Reference
    Prediction   setosa versicolor virginica
      setosa         15          0         0
      versicolor      0         13         2
      virginica       0          2        13

    Overall Statistics
                                              
                   Accuracy : 0.9111          
                     95% CI : (0.7878, 0.9752)
        No Information Rate : 0.3333          
        P-Value [Acc > NIR] : 8.467e-16       
                                              
                      Kappa : 0.8667          
     Mcnemar's Test P-Value : NA              

    Statistics by Class:

                         Class: setosa Class: versicolor Class: virginica
    Sensitivity                 1.0000            0.8667           0.8667
    Specificity                 1.0000            0.9333           0.9333
    Pos Pred Value              1.0000            0.8667           0.8667
    Neg Pred Value              1.0000            0.9333           0.9333
    Prevalence                  0.3333            0.3333           0.3333
    Detection Rate              0.3333            0.2889           0.2889
    Detection Prevalence        0.3333            0.3333           0.3333
    Balanced Accuracy           1.0000            0.9000           0.9000

``` r
printcp(tree)
```


    Classification tree:
    rpart(formula = Species ~ ., data = train)

    Variables actually used in tree construction:
    [1] Petal.Length Petal.Width 

    Root node error: 70/105 = 0.66667

    n= 105 

           CP nsplit rel error   xerror     xstd
    1 0.50000      0  1.000000 1.200000 0.058554
    2 0.47143      1  0.500000 0.828571 0.072790
    3 0.01000      2  0.028571 0.042857 0.024388

Control Decision Tree
---------------------

``` r
library(rpart)
tree_control <- rpart.control(xval=8, cp=-0.01, minsplit=1)
tree <- rpart(Species ~ ., train, control=tree_control)
tree
```

    n= 105 

    node), split, n, loss, yval, (yprob)
          * denotes terminal node

     1) root 105 70 setosa (0.33333333 0.33333333 0.33333333)  
       2) Petal.Length< 2.45 35  0 setosa (1.00000000 0.00000000 0.00000000) *
       3) Petal.Length>=2.45 70 35 versicolor (0.00000000 0.50000000 0.50000000)  
         6) Petal.Width< 1.65 37  2 versicolor (0.00000000 0.94594595 0.05405405)  
          12) Petal.Length< 4.95 34  0 versicolor (0.00000000 1.00000000 0.00000000) *
          13) Petal.Length>=4.95 3  1 virginica (0.00000000 0.33333333 0.66666667)  
            26) Sepal.Width>=2.65 1  0 versicolor (0.00000000 1.00000000 0.00000000) *
            27) Sepal.Width< 2.65 2  0 virginica (0.00000000 0.00000000 1.00000000) *
         7) Petal.Width>=1.65 33  0 virginica (0.00000000 0.00000000 1.00000000) *

Explore Tree
------------

``` r
plotcp(tree)
```

<img src="2018_04_25_Decision_Tree_files/figure-markdown_github/unnamed-chunk-9-1.png" width="900" />

``` r
plot(tree, main="Classification tree for iris")
text(tree, cex=1)
```

<img src="2018_04_25_Decision_Tree_files/figure-markdown_github/unnamed-chunk-10-1.png" width="900" />

Evaluate a model
----------------

``` r
confusionMatrix(tree_pred, test$Species)
```

    Confusion Matrix and Statistics

                Reference
    Prediction   setosa versicolor virginica
      setosa         15          0         0
      versicolor      0         13         2
      virginica       0          2        13

    Overall Statistics
                                              
                   Accuracy : 0.9111          
                     95% CI : (0.7878, 0.9752)
        No Information Rate : 0.3333          
        P-Value [Acc > NIR] : 8.467e-16       
                                              
                      Kappa : 0.8667          
     Mcnemar's Test P-Value : NA              

    Statistics by Class:

                         Class: setosa Class: versicolor Class: virginica
    Sensitivity                 1.0000            0.8667           0.8667
    Specificity                 1.0000            0.9333           0.9333
    Pos Pred Value              1.0000            0.8667           0.8667
    Neg Pred Value              1.0000            0.9333           0.9333
    Prevalence                  0.3333            0.3333           0.3333
    Detection Rate              0.3333            0.2889           0.2889
    Detection Prevalence        0.3333            0.3333           0.3333
    Balanced Accuracy           1.0000            0.9000           0.9000

``` r
printcp(tree)
```


    Classification tree:
    rpart(formula = Species ~ ., data = train, control = tree_control)

    Variables actually used in tree construction:
    [1] Petal.Length Petal.Width  Sepal.Width 

    Root node error: 70/105 = 0.66667

    n= 105 

             CP nsplit rel error   xerror     xstd
    1  0.500000      0  1.000000 1.142857 0.062348
    2  0.471429      1  0.500000 0.771429 0.073163
    3  0.014286      2  0.028571 0.042857 0.024388
    4 -0.010000      4  0.000000 0.042857 0.024388

Perform pruning
---------------

``` r
tree$cptable
```

               CP nsplit  rel error     xerror       xstd
    1  0.50000000      0 1.00000000 1.14285714 0.06234797
    2  0.47142857      1 0.50000000 0.77142857 0.07316262
    3  0.01428571      2 0.02857143 0.04285714 0.02438754
    4 -0.01000000      4 0.00000000 0.04285714 0.02438754

``` r
cp_xerror <- tree$cptable[,c('CP','xerror')]
cp_xerror
```

               CP     xerror
    1  0.50000000 1.14285714
    2  0.47142857 0.77142857
    3  0.01428571 0.04285714
    4 -0.01000000 0.04285714

``` r
loc <- which.min(cp_xerror[,'xerror'])

tree_pruning <- prune(tree, cp=cp_xerror[loc,"CP"])
```

Explore Tree
------------

``` r
plot(tree_pruning, main="Classification tree for iris")
text(tree_pruning)
```

<img src="2018_04_25_Decision_Tree_files/figure-markdown_github/unnamed-chunk-13-1.png" width="900" />
