# Title: Shiny Server Logic for Ofsted grade predictor 
# Author: Meenakshi Parameshwaran
# Date: 04/03/2016

# Load necessary packages
library(shiny)
library(knitr)
library(caret)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(scales)

# Set working directory for testing
setwd("~/GitHub/Ofsted_Prediction/Ofsted_App")

# Load up the ofsted data
schools <- read.csv("schools.csv")

# Load model objects
modellda <- readRDS(file = "modellda.RDS")
modelnb <- readRDS(file = "modelnb.RDS")
modelrf <- readRDS(file = "modelrf.RDS")
modelknn <- readRDS(file = "modelknn.RDS")

# Set up the server logic for the Ofsted predictor classifier
shinyServer(function(input, output) {
    
        observe({

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
                    print(mypred)})

                # make and print the plot
                output$predplot <- renderPlot({
                    mypred <- reactive(predict(modelrpart, newdata = data.frame(values$df), type = "prob"))
                    # reshape the data into long format
                    mypred1 <- gather(data = mypred[1,], key = ofstedgrade, value = probability, 1:4)
                    gg <- ggplot(data = mypred1, aes(x = factor(ofstedgrade), y = probability, fill = factor(ofstedgrade))) + geom_bar(stat = "identity") + guides(fill = FALSE) + scale_x_discrete(limits = c("Outstanding", "Good", "Requires Improvement", "Inadequate")) + scale_y_continuous(labels=percent) + geom_text(aes(label = paste0(round(probability*100, 0),"%")), position = position_dodge(0.9), vjust = 2, size = 3) + xlab("") + ylab("Probability")
                    print(gg)
                
                
                })
            } else if(input$algorithm=="Linear Discriminant Analysis"){
                
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
            } else if(input$algorithm=="Naive Bayes"){
                
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
            } else if(input$algorithm=="Random Forest"){
                
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
                    mypred <- reactive(predict(modelrf, newdata = data.frame(values$df), type = "prob"))
                    finalpred <- mypred()
                    print(finalpred)
                    
                })
            } else if(input$algorithm=="K-Nearest Neighbours"){
                
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
                    mypred <- reactive(predict(modelknn, newdata = data.frame(values$df), type = "prob"))
                    finalpred <- mypred()
                    print(finalpred)
                    
                })
            }else{
                output$results <- renderPrint("Error no Algorithm selected")
        }
        
        })
        
})
