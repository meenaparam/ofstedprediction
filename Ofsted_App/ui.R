# Title: Shiny User Interface for Ofsted grade predictor 
# Author: Meenakshi Parameshwaran
# Date: 04/03/2016

library(shiny)
library(knitr)
library(plotly)


# Set up a UI for the Ofsted predictor classifier
shinyUI(navbarPage("",
                   
            # Tab title
            tabPanel("Ofsted predictor",
                    
            # Application title
            titlePanel("Predicting Ofsted grades"),
                            
                    # Fluidpage with controls for algorithm selection and values
                    fluidPage(
                        
                        h2("Results"),
                        #tableOutput("table"),
                        verbatimTextOutput("results"),
                        plotOutput("predplot"),
                        
                        
                        hr(),
                        
                        fluidRow(
                            column(3,
                               
                               selectInput(inputId = "region", 
                                           label = "Where is the school?", 
                                           choices = c("East Midlands", "East of England",
                                                       "London", "North East", "North West",
                                                       "South East", "South West",
                                                       "West Midlands", 
                                                       "Yorkshire and the Humber")),
                               
                               selectInput(inputId = "instype", 
                                           label = "What type is it?", 
                                           choices = c("Academy", "Community", "Foundation",
                                                        "Other", "Voluntary")),
                               
                               numericInput(inputId = "ks2aps",
                                            label = "What is the KS2 APS?", 
                                            min = 0, max = 40, value = 27)
                               
                                   ),
                            column(4, offset = 1,
                                   
                               radioButtons(inputId = "reldenom", 
                                            label = "What is the religious status?",
                                            choices = c("Non-religious", "Religious"),
                                            selected = "Non-religious"),
                               
                               br(),
                               br(),
                               
                               radioButtons(inputId = "egender", 
                                            label = "What is the gender composition?",
                                            choices = c("Mixed", "Single-sex"),
                                            selected = "Mixed")
                               
                                   ),
                            column(4,
                                   selectInput(inputId = "algorithm", 
                                               label = "Which classification algorithm?", 
                                               choices = c("Random Forest", 
                                                           "Linear Discriminant Analysis", 
                                                           "Naive Bayes",
                                                           "K-Nearest Neighbours")),
                                   br(),
                                   sliderInput(inputId = "totpups",
                                           label = "How many pupils are there?",
                                           min = 50, max = 1250, value = 500, step = 100)
                              
                                        )
                                   )
                        )
   
                   ), 
        
        # Features tab title               
        tabPanel("Feature Descriptions",
                            fluidRow(
                                column(10,
                                       includeMarkdown("features.Rmd")
                                )
                            )
                            
                   ),
        
        # Methods tab title             
        tabPanel("Methods",
                            fluidRow(
                                column(10,
                                       includeMarkdown("methods.Rmd")
                                )
                            )
                            
                   )
))