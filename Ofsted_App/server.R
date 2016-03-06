# Title: Shiny Server Logic for Ofsted grade predictor 
# Author: Meenakshi Parameshwaran
# Date: 04/03/2016

library(shiny)
library(knitr)
library(caret)

# Set working directory for testing
setwd("~/GitHub/Ofsted_Prediction/Ofsted_App")

# load up the ofsted data
schools <- read.csv("schools.csv")

# make an empty dataframe for the user
userdf <- schools[1,]

set.seed(13489) # set the seed at each interation, and keep them across model fits 
seeds <- vector(mode = "list", length = 26)
for(i in 1:25) seeds[[i]] <- sample.int(1000, 22)
#for the last model:
seeds[[26]] <- sample.int(1000, 1)

# put the trainControl options into an object for ease - make sure allowParallel is set to true
trctrl <- trainControl(method = "cv",
                       number = 5,
                       seeds = seeds,
                       allowParallel = TRUE)

# set up parallel processing in caret before estimating models
library(parallel)
library(doParallel)
cluster <- makeCluster(detectCores() - 1) # convention to leave 1 core for OS
registerDoParallel(cluster)

# build Classification Tree model using rpart
set.seed(13489)
modelrpart <- train(ofstedgrade ~ ., data = schools, method = "rpart", trControl = trctrl)

# build SVM Radial Kernal model using svmRadial
set.seed(13489)
modelsvmradial <- train(ofstedgrade ~ ., data = schools, method = "svmRadial", trControl = trctrl)

# build Linear Discriminant Analysis model using lda
set.seed(13489)
modellda <- train(ofstedgrade ~ ., data = schools, method = "lda", trControl = trctrl)

# build Naive Bayes model using nb
set.seed(13489)
modelnb <- train(ofstedgrade ~ ., data = schools, method = "nb", trControl = trctrl)

# stop the parallel processing
stopCluster(cluster)

# Set up the server logic for the Ofsted predictor classifier
shinyServer(function(input, output) {
    
        observeEvent(input$go, {

            # apply selected classification algorithm
            if(input$algorithm=="Classification Tree") {
                
                # Reactively update the prediction dataset!
                values <- reactiveValues()
                values$df <- userdf
                newEntry <- observe({
                    values$df$ks2aps <- input$ks2aps
                    values$df$totpups <- input$totpups
                    values$df$reldenom <- input$reldenom
                    values$df$egender <- input$egender
                    values$df$region <- input$region
                    values$df$instype <- input$instype
                    
                })
                
                output$table <- renderTable({data.frame(values$df)})
                
                output$results <- renderPrint({
                    mypred <- reactive(predict(modelrpart, newdata = data.frame(values$df), type = "prob"))
                    finalpred <- mypred()
                    print(finalpred)

                # # reshape the data into long format
                # library(tidyr)
                # mypred1 <- gather(data = finalpred[1,], key = ofstedgrade, value = probability, 1:4)
                # 
                # # make and print the plot
                # library(ggplot2)
                # library(scales)
                # predplot <- ggplot(data = mypred1, aes(x = factor(ofstedgrade), y = probability, fill = factor(ofstedgrade))) + geom_bar(stat = "identity") + guides(fill = FALSE) + scale_x_discrete(limits = c("Outstanding", "Good", "Requires Improvement", "Inadequate")) + scale_y_continuous(labels=percent) + geom_text(aes(label = paste0(round(probability*100, 0),"%")), position = position_dodge(0.9), vjust = 2, size = 3) + xlab("") + ylab("Probability")

                })                
            } 
            
            else if(input$algorithm=="SVM Radial Kernal"){
                
                # Reactively update the prediction dataset!
                values <- reactiveValues()
                values$df <- userdf
                newEntry <- observe({
                    values$df$ks2aps <- input$ks2aps
                    values$df$totpups <- input$totpups
                    values$df$reldenom <- input$reldenom
                    values$df$egender <- input$egender
                    values$df$region <- input$region
                    values$df$instype <- input$instype
                    
                })
                
                output$table <- renderTable({data.frame(values$df)})
                
                output$results <- renderPrint({
                    mypred <- reactive(predict(modelsvmradial, newdata = data.frame(values$df), type = "prob"))
                    finalpred <- mypred()
                    print(finalpred)
                    
                })
            }
            
            else if(input$algorithm=="Linear Discriminant Analysis"){
                
                # Reactively update the prediction dataset!
                values <- reactiveValues()
                values$df <- userdf
                newEntry <- observe({
                    values$df$ks2aps <- input$ks2aps
                    values$df$totpups <- input$totpups
                    values$df$reldenom <- input$reldenom
                    values$df$egender <- input$egender
                    values$df$region <- input$region
                    values$df$instype <- input$instype
                    
                })
                
                output$table <- renderTable({data.frame(values$df)})
                
                output$results <- renderPrint({
                    mypred <- reactive(predict(modellda, newdata = data.frame(values$df), type = "prob"))
                    finalpred <- mypred()
                    print(finalpred)
                    
                })
            }
                        
            else if(input$algorithm=="Naive Bayes"){
                
                # Reactively update the prediction dataset!
                values <- reactiveValues()
                values$df <- userdf
                newEntry <- observe({
                    values$df$ks2aps <- input$ks2aps
                    values$df$totpups <- input$totpups
                    values$df$reldenom <- input$reldenom
                    values$df$egender <- input$egender
                    values$df$region <- input$region
                    values$df$instype <- input$instype
                    
                })
                
                output$table <- renderTable({data.frame(values$df)})
                
                output$results <- renderPrint({
                    mypred <- reactive(predict(modelnb, newdata = data.frame(values$df), type = "prob"))
                    finalpred <- mypred()
                    print(finalpred)
                    
                })
            }
        
            else{
                output$results <- renderPrint("Error no Algorithm selected")
        }
        
        })
        
})
