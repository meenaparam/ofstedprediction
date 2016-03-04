# Title: Shiny User Interface for Ofsted grade predictor 
# Author: Meenakshi Parameshwaran
# Date: 04/03/2016

library(shiny)
library(knitr)

# Set up a UI for the Ofsted predictor classifier
shinyUI(navbarPage("",
                   
            # Tab title
            tabPanel("Ofsted predictor",
                    
            # Application title
            titlePanel("Predicting Ofsted grades"),
                            
                    # Sidebar with controls for algorithm selection and values
                    sidebarLayout(
                    sidebarPanel(
                        
                        
                        selectInput(inputId = "algorithm", 
                                    label = "Which classification algorithm?", 
                                    choices = c("Classification Tree", 
                                                "SVM Radial Kernal",
                                                "Linear Discriminant Analysis", 
                                                "Naive Bayes")),
                        
                        
                        selectInput(inputId = "region", 
                                    label = "Where is the school?", 
                                    choices = c("East Midlands", "East of England",
                                                "London", "North East", "North West",
                                                "South East", "South West",
                                                "West Midlands", 
                                                "Yorkshire and the Humber")),
                        
                        selectInput(inputId = "schooltype", 
                                    label = "What type is it?", 
                                    choices = c("Academy", "Community", "Foundation",
                                                "Voluntary", "Other")),

                        sliderInput(inputId = "schoolsize",
                                    label = "How many pupils are there?",
                                    min = 50, max = 1250, value = 500, step = 100),
                        
                        radioButtons(inputId = "singlesex", 
                                     label = "What is the gender composition?",
                                     choices = list("Mixed" = 1, "Single sex" = 2),
                                     selected = 1),
                    
                        numericInput(inputId = "ks2aps",
                                 label = "What is the KS2 APS?", 
                                 min = 0, max = 40, value = 27),
                        
                        submitButton("Submit")),
                    
                                
                    # Display KNN results
                                mainPanel(h1("main panel"))
                                    

                            
                   )), 
            
        # Confusion matrix tab title               
            tabPanel("Confusion Matrix",
                     fluidRow(
                         column(10,
                                p("Confusion matrix will appear here.")
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