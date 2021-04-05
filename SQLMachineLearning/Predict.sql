USE loan
GO

-- Stored procedure that takes model name and new data as input parameters and predicts the default occured for the new data
DROP PROCEDURE IF EXISTS predict_defaultoccured_new;
GO
CREATE PROCEDURE predict_defaultoccured_new (@model VARCHAR(100),@q NVARCHAR(MAX))
AS
BEGIN
	-- Fetch the trained model data from table clients_loan_models
    DECLARE @c_model VARBINARY(MAX) = (SELECT model FROM clients_loan_models WHERE model_name = @model);
    
   	EXECUTE sp_execute_external_script
				@language = N'R',
				@script = N'require("e1071");
				        		
						# The InputDataSet contains the new data passed to this stored procedure
						# Use this data to make predictions
						originalDefaulters = InputDataSet;
						defaulters = originalDefaulters;

						# Scaling the input dataset
						defaulters[is.na(defaulters)] <- 0
						defaulters[,c("LoanBalance","ArrearsBalance","ArrearsDays","RepaymentAmount","LVR",
						"SecurityValuation","RelationshipBalance","SavingsBalance","SavingsBalanceOne","SavingsBalanceThree","ArrearsBalanceOne",
						"ArrearsBalanceThree","ArrearsDaysOne","ArrearsDaysThree","TransactionQuantityOne","TransactionValueOne","TransactionQuantityThree",
						"TransactionValueThree","AppUsageOne","AppUsageThree","InternetUsageOne","InternetUsageThree","BranchVisitsSix","Age")] <- scale(defaulters[,c(
						"LoanBalance","ArrearsBalance","ArrearsDays","RepaymentAmount","LVR","SecurityValuation","RelationshipBalance","SavingsBalance",
						"SavingsBalanceOne","SavingsBalanceThree","ArrearsBalanceOne","ArrearsBalanceThree","ArrearsDaysOne","ArrearsDaysThree","TransactionQuantityOne",
						"TransactionValueOne","TransactionQuantityThree","TransactionValueThree","AppUsageOne","AppUsageThree","InternetUsageOne","InternetUsageThree",
						"BranchVisitsSix","Age")])

						defaulters$JointLoan <- ifelse(defaulters$JointLoan == "Yes", 1, 0)
						defaulters$LPI <- ifelse(defaulters$LPI == "Yes", 1, 0)
						defaulters$Gender <- ifelse(defaulters$Gender == "Male", 1, 0)

						# Unserialize the model before using it
						clients_model = unserialize(c_model);
						
						
						# Call the prediction function
						client_predictions <- predict(clients_model, newdata = defaulters);
						predicted_results <- ifelse(client_predictions > 0.5, "Yes", "No")
						clients_predicts <- cbind(originalDefaulters, predicted_results)
						',
				 @input_data_1 = @q,
				 @output_data_1_name = N'clients_predicts',
				 @params = N'@c_model varbinary(max)',
				 @c_model = @c_model
				 WITH RESULT SETS ((ID INT, firstName VARCHAR(50), lastName VARCHAR(50), LoanBalance MONEY,ArrearsBalance MONEY,ArrearsDays INT,RepaymentAmount MONEY,LVR INT,JointLoan VARCHAR(50),LPI VARCHAR(50),SecurityValuation MONEY,
	   RelationshipBalance MONEY,SavingsBalance MONEY,SavingsBalanceOne INT,SavingsBalanceThree INT,ArrearsBalanceOne INT,ArrearsBalanceThree INT,ArrearsDaysOne INT,
	   ArrearsDaysThree INT,TransactionQuantityOne INT,TransactionValueOne INT,TransactionQuantityThree INT,TransactionValueThree INT,AppUsageOne INT,
	   AppUsageThree INT,InternetUsageOne INT,InternetUsageThree INT,BranchVisitsSix INT,Gender VARCHAR(50),Age INT,ResidentialPostcode VARCHAR(50), predicted_results VARCHAR(50)))
END
GO

-- Execute the predict stored procedure and pass the modelname and a query string with a set of features to be used to predict the likelihood of the clients who will default on loan
EXEC predict_defaultoccured_new @model = 'SVMpolynomial',
       @q ='SELECT [ID],[firstName],[lastName],[LoanBalance],[ArrearsBalance],[ArrearsDays],[RepaymentAmount],[LVR],[JointLoan],[LPI],[SecurityValuation],
	   [RelationshipBalance],[SavingsBalance],[SavingsBalanceOne],[SavingsBalanceThree],[ArrearsBalanceOne],[ArrearsBalanceThree],[ArrearsDaysOne],
	   [ArrearsDaysThree],[TransactionQuantityOne],[TransactionValueOne],[TransactionQuantityThree],[TransactionValueThree],[AppUsageOne],
	   [AppUsageThree],[InternetUsageOne],[InternetUsageThree],[BranchVisitsSix],[Gender],[Age],[ResidentialPostcode] FROM clients';
GO
