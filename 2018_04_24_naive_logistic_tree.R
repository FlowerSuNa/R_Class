
## Divid data by iris species
# install.packages("caret")
library(caret)

index_train <- createDataPartition(iris$Species, p=.7, list=F)
iris_train <- iris[index_train,]
iris_test <- iris[-index_train,]

table(iris$Species)
table(iris_train$Species)
table(iris_test$Species)


## Make model using Naive Bayes
# install.packages("e1071")
library(e1071)
naive <- naiveBayes(iris_train, iris_train$Species, laplace=1)

## Predict iris species from test data
naive_pred <- predict(naive, iris_test, type="class")

## Evaluate a model
table(naive_pred, iris_test$Species)
confusionMatrix(naive_pred, iris_test$Species)


## Make model using Logistic Regression
# install.packages("nnet")
library(nnet)
lr <- multinom(Species~., iris_train)

## Predict iris species from test data
lr_pred <- predict(lr, iris_test, type="class")

## Evaluate a model
table(lr_pred, iris_test$Species)
confusionMatrix(lr_pred, iris_test$Species)


## Make model using Decision Tree
# install.packages("rpart")
library(rpart)
tree <- rpart(Species~., iris_train)
tree

## Predict iris species from test data
tree_pred <- predict(tree, iris_test, type="class")

## Evaluate a model
table(tree_pred, iris_test$Species)
confusionMatrix(tree_pred, iris_test$Species)
