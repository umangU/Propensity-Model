# System Overview

Like many other banks, the Regional Australian Bank also faces many challenges. Borrowers are assessed before granting them loans but the probability of these clients to default is not impossible. This project is created to mitigate the risk of clients failing to fulfill a loan contract. The propensity model will be integrated to RAB’s existing infrastructure to provide a tool which adds a precise and reliable addition to the bank’s existing credit management process. This tool will help to improve the relationship of RAB with clients as the goal of the bank to give clients a personalized financial solution can be achieved. 
 
The propensity model is designed as a web application, which can be used as a stand-alone application and a machine learning algorithm, which can be consolidated with the existing software of the bank. Additionally, the propensity model is compliant with the Regional Australian Bank network security protocol and policies.  
 
The propensity model comprises of two products: a web application, created using RStudio’s “shiny” library along with the machine learning model, and another which includes the same model but is deployed in SQL Machine Learning services. The web application includes the creation of machine learning algorithm in RStudio, using the shiny library, to create a simple interface which uploads a dataset and downloads predictions. The Machine Learning model created in RStudio is deployed on Microsoft SQL server in terms of Stored Procedures. This allows RAB to either integrate the Stored Procedures with their pre-existing application or to use a web application to get quick results.
