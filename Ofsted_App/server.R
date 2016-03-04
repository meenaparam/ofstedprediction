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
    
    # for trying to show a class membership probability plot
    # output$plot1 <- renderPlot({
    #     
    #     selectedData <- df[df$Class==input$cl & df$Sex==input$se & df$Age==input$ag,5]
    #     bplt <- barplot(selectedData,
    #                     beside=TRUE, horiz=TRUE, xlim=c(0,700),
    #                     main="Titanic stats based on selected passengers's attributes",
    #                     ylab="Total",
    #                     col=c("black", "grey"),
    #                     legend = c("Deads", "Survivors")
    #     )
    #     text(x=selectedData+20,
    #          y=bplt,
    #          labels=as.character(selectedData),
    #          xpd=TRUE)
    # })
    # output$result <- renderText({ 
    #     r <- predict(mod, df[df$Class==input$cl & df$Sex==input$se & df$Age==input$ag & df$Survived=="Yes",1:3], type = c("prob"))
    #     levels(r)[r]
    
    
    # for showing a confusion matrix of model performance - maybe could just show regular confusion matrix
    # observe({
    #     set.seed(1)
    #     knn.pred <- knn(data.frame(train.X[,input$checkGroup]),
    #                     data.frame(test.X[,input$checkGroup]),
    #                     train.Y, k = input$k)
    #     
    #     
    #     output$value <- renderText({ paste("Classification Error = ",ce(test.Y,knn.pred)) })
    #     output$confusionMatrix <- renderDataTable({
    #         # modify this to show title - confusion matrix
    #         # /false positive/positive false negative/negative
    #         true.positive    <- sum(knn.pred == "positive" & test.Y == "positive")
    #         false.positive   <- sum(knn.pred == "negative" & test.Y == "positive")
    #         true.negative    <- sum(knn.pred == "negative" & test.Y == "negative")
    #         false.negative   <- sum(knn.pred == "positive" & test.Y == "negative")
    #         row.names <- c("Prediction - FALSE", "Prediction - TRUE" )
    #         col.names <- c("Reference - FALSE", "Reference - TRUE")
    #         cbind(Outcome = row.names, as.data.frame(matrix( 
    #             c(true.negative, false.negative, false.positive, true.positive) ,
    #             nrow = 2, ncol = 2, dimnames = list(row.names, col.names))))
    #     }, options = table.settings
    #     )
    #     
    # })
    
})

