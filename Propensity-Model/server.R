# Importing libraries to import shiny package components and perform SVM
library(shiny)
library(e1071)

# Loading the saved model
load("SVMpolynomial.rda") 

# Server function declared
shinyServer(function(input,output){
  options(shiny.maxRequestSize = 800*1024^2)
  
  # Show if the data has been uploaded
  output$sample_input_data_heading = renderUI({ 
    inFile <- input$file1
    
    if (is.null(inFile))
    {
      return(NULL)
    }
    else
    {
      tags$h4('Sample Uploaded data')
    }
  })
  
  # Displaying sample of uploaded data
  output$sample_input_data = renderTable({    
    inFile <- input$file1
    
    if (is.null(inFile))
    {
      return(NULL)
    }
    else
    {
      input_data =  readr::read_csv(input$file1$datapath, col_names = TRUE)
      
      colnames(input_data) = c("firstName", "lastName", "LoanBalance", "ArrearsBalance", 
                               "ArrearsDays", "RepaymentAmount", "LVR", "JointLoan", 
                               "LPI", "SecurityValuation", "RelationshipBalance", 
                               "SavingsBalance", "SavingsBalanceOne", "SavingsBalanceThree", 
                               "ArrearsBalanceOne", "ArrearsBalanceThree", "ArrearsDaysOne", 
                               "ArrearsDaysThree", "TransactionQuantityOne", "TransactionValueOne", 
                               "TransactionQuantityThree", "TransactionValueThree", "AppUsageOne", 
                               "AppUsageThree", "InternetUsageOne", "InternetUsageThree", 
                               "BranchVisitsSix", "Gender", "Age", "ResidentialPostcode", "DefaultOccurred")
      
      # Factoring the response variable and defining the levels
      input_data$DefaultOccurred = as.factor(input_data$DefaultOccurred )
      levels(input_data$DefaultOccurred) <- c("No", "Yes")
      
      # Render the first 11 lines of the dataset
      head(input_data, n = 11)
    }
  })
  
  # Display and download predictions
  predictions<-reactive({
    
    inFile <- input$file1
    
    if (is.null(inFile))
    {
      return(NULL)
    }
    else
    {
      withProgress(message = 'Predictions in progress. Please wait ...', {
        input_data =  readr::read_csv(input$file1$datapath, col_names = TRUE)
        
        colnames(input_data) = c("firstName", "lastName", "LoanBalance", "ArrearsBalance", 
                                 "ArrearsDays", "RepaymentAmount", "LVR", "JointLoan", 
                                 "LPI", "SecurityValuation", "RelationshipBalance", 
                                 "SavingsBalance", "SavingsBalanceOne", "SavingsBalanceThree", 
                                 "ArrearsBalanceOne", "ArrearsBalanceThree", "ArrearsDaysOne", 
                                 "ArrearsDaysThree", "TransactionQuantityOne", "TransactionValueOne", 
                                 "TransactionQuantityThree", "TransactionValueThree", "AppUsageOne", 
                                 "AppUsageThree", "InternetUsageOne", "InternetUsageThree", 
                                 "BranchVisitsSix", "Gender", "Age", "ResidentialPostcode", "DefaultOccurred")
        
        # Assigning missing values 0
        input_data[is.na(input_data)] <- 0;
        
        # Storing the input dataset into other object
        input_data_rm <- input_data;
        
        # Scaling the numerical columns to perform SVM
        input_data_rm[,c("LoanBalance","ArrearsBalance","ArrearsDays","RepaymentAmount","LVR",
                "SecurityValuation","RelationshipBalance","SavingsBalance","SavingsBalanceOne","SavingsBalanceThree","ArrearsBalanceOne",
                "ArrearsBalanceThree","ArrearsDaysOne","ArrearsDaysThree","TransactionQuantityOne","TransactionValueOne","TransactionQuantityThree","TransactionValueThree","AppUsageOne",
                "AppUsageThree","InternetUsageOne","InternetUsageThree","BranchVisitsSix","Age")] <- scale(input_data_rm[,c("LoanBalance",
                "ArrearsBalance","ArrearsDays","RepaymentAmount","LVR","SecurityValuation","RelationshipBalance","SavingsBalance",
                "SavingsBalanceOne","SavingsBalanceThree","ArrearsBalanceOne","ArrearsBalanceThree","ArrearsDaysOne","ArrearsDaysThree","TransactionQuantityOne",
                "TransactionValueOne","TransactionQuantityThree","TransactionValueThree","AppUsageOne","AppUsageThree","InternetUsageOne","InternetUsageThree",
                "BranchVisitsSix","Age")])
        
        # Factoring the character columns to boolean
        input_data_rm$JointLoan <- ifelse(input_data_rm$JointLoan == "Yes", 1, 0)
        input_data_rm$LPI <- ifelse(input_data_rm$LPI == "Yes", 1, 0)
        input_data_rm$Gender <- ifelse(input_data_rm$Gender == "Male", 1, 0)
        input_data_rm$DefaultOccurred <- ifelse(input_data_rm$DefaultOccurred == "Yes", 1, 0)
        
        # Predicting on the uploaded dataset using the imported model
        prediction = predict(my_model, input_data_rm, type="response")
        
        # Converting the predictions into classes
        DefaultPredictions = ifelse(prediction<0.5,"Yes","No")
        
        # Removing the DefaultOccured and binding the predictions to the input dataset
        input_data <- input_data[,-c(31)]
        input_data_with_prediction = cbind(input_data, DefaultPredictions )
        
        # Returning the input dataset along with the predictions
        input_data_with_prediction
        
      })
    }
  })
  
  # Displaying a sample of predicted data along with some columns from the input dataset
  output$sample_prediction_heading = renderUI({  
    inFile <- input$file1
    
    if (is.null(inFile))
    {
      return(NULL)
    }
    else
    {
      tags$h4('Sample Predicted Data')
    }
  })
  
  # Sample Predictions
  output$sample_predictions = renderTable({   # the last 6 rows to show
    pred = predictions()
    
    # Displaying the necessary columns for the ease of readability
    disp = pred[c(1,2,28,3,6,31)]
    
    # Displaying 15 rows of the predicted values
    head(disp, n=15)
    
  })
  
  # Handler to allow the user to download the dataset along with predicted values
  output$downloadData <- downloadHandler(
    filename = function() 
    {
      paste("input_data_with_predictions", ".csv", sep = "")
    },
    content = function(file) 
    {
      write.csv(predictions(), file, row.names = TRUE)
    })
})
