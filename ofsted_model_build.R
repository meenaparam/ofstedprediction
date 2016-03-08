# Title: Building and saving Ofsted prediction models
# Author: Meenakshi Parameshwaran
# Date: 07/03/2016

library(shiny)
library(knitr)
library(caret)
library(parallel)
library(doParallel)

# Set working directory for testing
setwd("~/GitHub/Ofsted_Prediction/Ofsted_App")

# load up the ofsted data
schools <- read.csv("schools.csv")

# make an empty dataframe for the user
userdf <- schools[1,]

# set the seed at each interation, and keep them across model fits 
set.seed(13489) 
seeds <- vector(mode = "list", length = 51)
for(i in 1:50) seeds[[i]] <- sample.int(1000, 22)
#for the last model:
seeds[[51]] <- sample.int(1000, 1)

# Split the dataset into 70% training and 30% testing
set.seed(4568)
inTrain <- createDataPartition(y = schools$ofstedgrade, p = 0.7, list = FALSE)
training <- schools[inTrain, ]
testing <- schools[-inTrain, ]

# remove missings from testing
testing <- na.omit(testing)

# put the trainControl options into an object for ease - make sure allowParallel is set to true
trctrl <- trainControl(method = "cv",
                       number = 10,
                       seeds = seeds,
                       allowParallel = TRUE)

# set up parallel processing in caret before estimating models
cluster <- makeCluster(detectCores() - 1) # convention to leave 1 core for OS
registerDoParallel(cluster)

# build Classification Tree model using rpart
set.seed(13489)
modelrpart <- train(ofstedgrade ~ ., data = training, method = "rpart", trControl = trctrl)
set.seed(1234)
predrpart <- predict(modelrpart, newdata = testing)
cmrpart <- confusionMatrix(predrpart, testing$ofstedgrade)
saveRDS(object = modelrpart, file = "modelrpart.RDS")

# build Linear Discriminant Analysis model using lda
set.seed(13489)
modellda <- train(ofstedgrade ~ ., data = training, method = "lda", trControl = trctrl)
set.seed(1234)
predlda <- predict(modellda, newdata = testing)
cmlda <- confusionMatrix(predlda, testing$ofstedgrade)
saveRDS(object = modellda, file = "modellda.RDS")

# build Naive Bayes model using nb
set.seed(13489)
modelnb <- train(ofstedgrade ~ ., data = training, method = "nb", trControl = trctrl)
set.seed(1234)
prednb <- predict(modelnb, newdata = testing)
cmnb <- confusionMatrix(prednb, testing$ofstedgrade)
saveRDS(object = modelnb, file = "modelnb.RDS")

# try a gbm
set.seed(13489)
modelgbm <- train(ofstedgrade ~ ., data = training, method = "gbm", verbose = F, trControl = trctrl)
set.seed(1234)
predgbm <- predict(modelgbm, newdata = testing)
cmgbm <- confusionMatrix(predgbm, testing$ofstedgrade)
saveRDS(object = modelgbm, file = "modelgbm.RDS")

# try a random forest
set.seed(13489)
modelrf <- train(ofstedgrade ~ ., data = training, method = "rf", prox = T, trControl = trctrl)
set.seed(1234)
predrf <- predict(modelrf, newdata = testing)
cmrf <- confusionMatrix(predrf, testing$ofstedgrade)
saveRDS(object = modelgbm, file = "modelrf.RDS")

# try a knn
set.seed(13489)
modelknn <- train(ofstedgrade ~ ., data = training, method = "knn", trControl = trctrl)
set.seed(1234)
predknn <- predict(modelknn, newdata = testing)
cmknn <- confusionMatrix(predknn, testing$ofstedgrade)
saveRDS(object = modelgbm, file = "modelknn.RDS")

# try a nnet
set.seed(13489)
modelnnet <- train(ofstedgrade ~ ., data = training, method = "nnet", trControl = trctrl)
set.seed(1234)
prednnet <- predict(modelnnet, newdata = testing)
cmnnet <- confusionMatrix(prednnet, testing$ofstedgrade)
saveRDS(object = modelgbm, file = "modelnnet.RDS")

# stop the parallel processing
stopCluster(cluster)
