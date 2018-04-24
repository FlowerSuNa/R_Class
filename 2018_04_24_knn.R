
## Divid data
data <- iris[, c("Sepal.Length", "Sepal.Width", "Species")]

idx <- sample(x=c(1,2,3), size=nrow(data), replace=T, prob=c(3,1,1))
idx

train <- data[idx == 1,]
valid <- data[idx == 2,]
test <- data[idx == 3,]

dim(train); dim(valid); dim(test)


## Draw scatter plot
# install.packages("scales")
library(scales)
plot(formula = Sepal.Length ~ Sepal.Width,
     data = train,
     col = train$Species,
     main = "train dataset")
points(formula = Sepal.Length ~ Sepal.Width,
       data = valid,
       pch = 17,
       cex = 2,
       col = "red")


plot(formula = Sepal.Length ~ Sepal.Width,
     data = train,
     col = c("green", "blue", "purple"),
     main = "train, valid, test dataset")
points(formula = Sepal.Length ~ Sepal.Width,
       data = valid,
       pch = 17,
       cex = 2,
       col = "red")
points(formula = Sepal.Length ~ Sepal.Width,
       data = test,
       pch = 15,
       cex = 2,
       col = "orange")
legend("topright",
       c(levels(data$Species), "valid", "test"),
       pch=c(1,1,1,17,15),
       col=c("green", "blue", "purple", "red", "orange"),
       cex = 1.2)


## Make model using Knn
# install.packages("class")
library(class)

## k = 1
knn1 <- knn(train=train[,1:2], test=valid[,1:2], cl=train[,3], k=1)
knn1

plot(formula = Sepal.Length ~ Sepal.Width,
     data = train,
     col = c("purple", "blue", "green")[train$Species],
     main = "KNN (k=1)")
points(formula = Sepal.Length ~ Sepal.Width,
       data = valid,
       pch = 17,
       cex = 2,
       col = c("purple", "blue", "green")[knn1])
legend("topright",
       c( paste("train", levels(data$Species)),
          paste("valid", levels(valid$Species))),
       pch=c(rep(1,3), rep(17,3)),
       col=c("purple", "blue", "green","purple", "blue", "green"),
       cex = 1.3)
accuracy1 <- sum(knn1 == valid[,3]) / length(valid[,3])
accuracy1

## k = 21
knn21 <- knn(train=train[,1:2], test=valid[,1:2], cl=train[,3], k=21)
knn21

plot(formula = Sepal.Length ~ Sepal.Width,
     data = train,
     col = c("purple", "blue", "green")[train$Species],
     main = "KNN (k=21)")
points(formula = Sepal.Length ~ Sepal.Width,
       data = valid,
       pch = 17,
       cex = 2,
       col = c("purple", "blue", "green")[knn21])
legend("topright",
       c( paste("train", levels(data$Species)),
          paste("valid", levels(valid$Species))),
       pch=c(rep(1,3), rep(17,3)),
       col=c("purple", "blue", "green","purple", "blue", "green"),
       cex = 1.3)
accuracy21 <- sum(knn21 == valid[,3]) / length(valid[,3])
accuracy21


## Evaluate a model
accuracy_k <- NULL
for (i in c(1:nrow(train[,1:2]))) {
  set.seed(1)
  knn_k <- knn(train=train[,1:2], test=valid[,1:2], cl=train[,3], k=i)
  accuracy_k <- c(accuracy_k, sum(knn_k == valid[,3])/ length(valid[,3]))
}
accuracy_k

valid_k <- data.frame(k = c(1:nrow(train[,1:2])), accuracy=accuracy_k)
plot(formula = accuracy ~ k, 
     data = valid_k, 
     type = "o",
     pch = 20,
     main = "validation - optimal k")
with(valid_k, 
     text(accuracy~k, labels = rownames(valid_k), pos=1, cex =0.7))

min(valid_k[valid_k$accuracy %in% max(accuracy_k), "k"])


## Predict iris species from test data
knn2 <- knn(train=train[,1:2], test=test[,1:2], cl=train[,3], k=2)
knn2

table(knn2, test$Species)
confusionMatrix(knn2, test$Species)
