# Importing libraries to use shiny package components such as dashboard and themes
library(shiny)
library(shinydashboard)
library(shinythemes)

# Dashboard page
dashboardPage(skin="black",
              # Dashboard header and sidebar along with sidebar items are declared
              dashboardHeader(title=tags$em("Loan Defaulters", style="text-align:left;color:#006600;font-size:100%"),titleWidth = 800),
              
              dashboardSidebar(tags$head(tags$style(HTML('.shiny-server-account { display: none; }'))),width = 250,
                               sidebarMenu(br(),
                                 menuItem(tags$em("Upload Data",style="font-size:120%"),icon=icon("table"),tabName="data"),
                                 menuItem(tags$em("Download Predictions",style="font-size:120%"),icon=icon("download"),tabName="download")
                               )),
              
              # Dashboard content for sidebar items
              dashboardBody(
                tabItems(
                  # Defining the pages for sidebar items
                  tabItem(tabName="data",
                          br(),
                          column(width = 12,
                                 fileInput('file1', em('Upload test data in csv format ',style="text-align:center;color:blue;font-size:150%"),multiple = FALSE,accept=c('.csv')),
                                 uiOutput("sample_input_data_heading"),div(style = 'overflow-x:scroll;',tableOutput("sample_input_data")),
                          br(),
                          br(),
                          br(),
                          br()),
                          br()),
                  
                  
                  tabItem(tabName="download",fluidRow(
                            column(width = 8)),
                            column(width = 7,uiOutput("sample_prediction_heading"),tableOutput("sample_predictions")),
                            fluidRow(column(width = 7,downloadButton("downloadData", em('Download Predictions',style="text-align:center;color:blue;font-size:150%")))               
                          ))
                )))

