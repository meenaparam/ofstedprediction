# Title: Shiny Server Logic for Ofsted grade predictor 
# Author: Meenakshi Parameshwaran
# Date: 04/03/2016

library(shiny)
library(knitr)
library(caret)
library(parallel)
library(doParallel)

# Set up the server logic for the Ofsted predictor classifier
shinyServer(function(input, output) {
})

# Split the dataset into 70% training and 30% testing
set.seed(4568)
inTrain <- createDataPartition(y = school$ofstedgrade, p = 0.7, list = FALSE)
mytraining <- training[inTrain, ]
mytesting <- training[-inTrain, ]

# set up parallel processing in caret - code taken from DSS Community site
cluster <- makeCluster(detectCores() - 1)  # convention to leave 1 core for OS
registerDoParallel(cluster)

set.seed(13489)  # set the seed at each interation, and keep them across model fits 
seeds <- vector(mode = "list", length = 26)
for (i in 1:25) seeds[[i]] <- sample.int(1000, 22)
# for the last model:
seeds[[26]] <- sample.int(1000, 1)

# put the trainControl options into an object for ease - make sure
# allowParallel is set to true
trctrl <- trainControl(method = "cv", number = 5, seeds = seeds, classProbs = TRUE, allowParallel = TRUE)

# fit the rpart model
set.seed(1567)
modFitRpart <- train(ofstedgrade ~ ., data = mytraining, method = "rpart", 
                  trControl = trctrl)
# fit the lda model
set.seed(1567)
modFitLda <- train(ofstedgrade ~ ., data = mytraining, method = "lda", 
                  trControl = trctrl)

# fit the svm radial model
set.seed(1567)
modFitSvm <- train(ofstedgrade ~ ., data = mytraining, method = "svmRadial", 
                   trControl = trctrl)

# fit the naive bayes model
set.seed(1567)
modFitNb <- train(ofstedgrade ~ ., data = mytraining, method = "nb", 
                  trControl = trctrl)

# stop the parallel processing
stopCluster(cluster)

