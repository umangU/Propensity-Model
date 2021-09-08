# Importing libraries to read an excel file and perform support vector machines
library(readxl)
library(e1071)

# Reading the Dataset
loan  <- read.csv("dummy.csv")

#Replacing missing values with 0 
loan[is.na(loan)]<-0

# Scaling the numerical columns to perform SVM
loan[,c("LoanBalance","ArrearsBalance","ArrearsDays","RepaymentAmount","LVR",
        "SecurityValuation","RelationshipBalance","SavingsBalance","SavingsBalanceOne","SavingsBalanceThree","ArrearsBalanceOne",
        "ArrearsBalanceThree","ArrearsDaysOne","ArrearsDaysThree","TransactionQuantityOne","TransactionValueOne","TransactionQuantityThree","TransactionValueThree","AppUsageOne",
        "AppUsageThree","InternetUsageOne","InternetUsageThree","BranchVisitsSix","Age")] <- scale(loan[,c("LoanBalance",
        "ArrearsBalance","ArrearsDays","RepaymentAmount","LVR","SecurityValuation","RelationshipBalance","SavingsBalance",
        "SavingsBalanceOne","SavingsBalanceThree","ArrearsBalanceOne","ArrearsBalanceThree","ArrearsDaysOne","ArrearsDaysThree","TransactionQuantityOne",
        "TransactionValueOne","TransactionQuantityThree","TransactionValueThree","AppUsageOne","AppUsageThree","InternetUsageOne","InternetUsageThree",
        "BranchVisitsSix","Age")])

# Factoring the character columns to Boolean
loan$JointLoan <- ifelse(loan$JointLoan == "Yes", 1, 0)
loan$LPI <- ifelse(loan$LPI == "Yes", 1, 0)
loan$Gender <- ifelse(loan$Gender == "Male", 1, 0)
loan$DefaultOccurred <- ifelse(loan$DefaultOccurred == "Yes", 1, 0)

# Removing the first name, last name and residential postcode columns
loan <- loan[,-c(1,2,30)];

# Storing the imported dataset into data frame
loan_df <- as.data.frame(loan)

# getting the number of rows from the dataset
rows <- nrow(loan)

#partitioning the dataset into training and testing
ind <- sample(2, nrow(loan_df), replace = T, prob = c(0.8,0.2))
train_data <- loan_df[ind==1, ]
test_data <- loan_df[ind==2, ]

# Performing cross-validation to find the best parameters for the SVM model having Polynomial kernel
tune.out=tune(svm, DefaultOccurred~.,data=train_data, kernel="polynomial", ranges=list(cost=c(0.1 ,1 ,10 ,100 ,1000),degree=c(1,2,3,4,5,6,7,8,9,10)))
summary(tune.out)

# Fitting the SVM with Polynomial kernel and best tuning parameter
my_model=svm(DefaultOccurred~., data=train_data, kernel="polynomial", cost=1000,degree=10)

# Saving the trained model to use in the shiny application
save(my_model, file = 'SVMpolynomial.rda')
