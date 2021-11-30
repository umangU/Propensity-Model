USE loan;

DROP TABLE IF EXISTS clients_loan_models;
GO
-- Declaring table to store trained model
CREATE TABLE clients_loan_models 
(	
	model_name VARCHAR(30) NOT NULL DEFAULT('default model') PRIMARY KEY,
    model VARBINARY(MAX) NOT NULL
);
GO

-- Stored procedure that trains and generates an R model using the clients data and support vector machines
DROP PROCEDURE IF EXISTS generate_clients_loan_model;
go
CREATE PROCEDURE generate_clients_loan_model (@trained_model varbinary(max) OUTPUT)
AS
BEGIN
	EXECUTE sp_execute_external_script
	  @language = N'R'
	, @script = N'require("e1071");

				clients_train_data[is.na(clients_train_data)] <- 0
				clients_train_data[,c("LoanBalance","ArrearsBalance","ArrearsDays","RepaymentAmount","LVR",
				"SecurityValuation","RelationshipBalance","SavingsBalance","SavingsBalanceOne","SavingsBalanceThree","ArrearsBalanceOne",
				"ArrearsBalanceThree","ArrearsDaysOne","ArrearsDaysThree","TransactionQuantityOne","TransactionValueOne","TransactionQuantityThree",
				"TransactionValueThree","AppUsageOne","AppUsageThree","InternetUsageOne","InternetUsageThree","BranchVisitsSix","Age")] <- scale(clients_train_data[,c(
				"LoanBalance","ArrearsBalance","ArrearsDays","RepaymentAmount","LVR","SecurityValuation","RelationshipBalance","SavingsBalance",
                "SavingsBalanceOne","SavingsBalanceThree","ArrearsBalanceOne","ArrearsBalanceThree","ArrearsDaysOne","ArrearsDaysThree","TransactionQuantityOne",
                "TransactionValueOne","TransactionQuantityThree","TransactionValueThree","AppUsageOne","AppUsageThree","InternetUsageOne","InternetUsageThree",
                "BranchVisitsSix","Age")])

				clients_train_data$JointLoan <- ifelse(clients_train_data$JointLoan == "Yes", 1, 0)
				clients_train_data$LPI <- ifelse(clients_train_data$LPI == "Yes", 1, 0)
				clients_train_data$Gender <- ifelse(clients_train_data$Gender == "Male", 1, 0)
				clients_train_data$DefaultOccurred <- ifelse(clients_train_data$DefaultOccurred == "Yes", 1, 0)
	

					#Create a Logistic Regression model and train it using the training data set
					model_svm <- svm(DefaultOccurred ~ LoanBalance+ArrearsBalance+ArrearsDays+RepaymentAmount+LVR+JointLoan+LPI+SecurityValuation+
					RelationshipBalance+SavingsBalance+SavingsBalanceOne+SavingsBalanceThree+ArrearsBalanceOne+ArrearsBalanceThree+ArrearsDaysOne+
				    ArrearsDaysThree+TransactionQuantityOne+TransactionValueOne+TransactionQuantityThree+TransactionValueThree+AppUsageOne+
				    AppUsageThree+InternetUsageOne+InternetUsageThree+BranchVisitsSix+Gender+Age, data=clients_train_data, kernel="polynomial", cost=10, degree=9);
					trained_model <- serialize(model_svm, NULL);'

	,@input_data_1 = N'SELECT * FROM dbo.clients TABLESAMPLE(70 PERCENT)'
	,@input_data_1_name = N'clients_train_data'
	,@params = N'@trained_model VARBINARY(MAX) OUTPUT'
	,@trained_model = @trained_model OUTPUT;
END;
GO


-- Saving model to table
TRUNCATE TABLE clients_loan_models;

-- Executing Stored Procedure to generate trained model using SVM with polynomial kernel
DECLARE @model VARBINARY(MAX);
EXEC generate_clients_loan_model @model OUTPUT;

INSERT INTO clients_loan_models (model_name, model) VALUES ('SVMpolynomial',@model);

SELECT * FROM clients_loan_models;
