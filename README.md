# Purpose

Like many other banks, the Regional Australian Bank also faces many challenges. Borrowers are assessed before granting them loans but the probability of these clients to default is not impossible. This project is created to mitigate the risk of clients failing to fulfill a loan contract. The propensity model will be integrated to RAB’s existing infrastructure to provide a tool which adds a precise and reliable addition to the bank’s existing credit management process. This tool will help to improve the relationship of RAB with clients as the goal of the bank to give clients a personalized financial solution can be achieved. 

# System Overview

The propensity model is designed as a web application, which can be used as a stand-alone application and a machine learning algorithm, which can be consolidated with the existing software of the bank. Additionally, the propensity model is compliant with the Regional Australian Bank network security protocol and policies.  
 
The propensity model comprises of two products: a web application, created using RStudio’s “shiny” library along with the machine learning model, and another which includes the same model but is deployed in SQL Machine Learning services. The web application includes the creation of machine learning algorithm in RStudio, using the shiny library, to create a simple interface which uploads a dataset and downloads predictions. The Machine Learning model created in RStudio is deployed on Microsoft SQL server in terms of Stored Procedures. This allows RAB to either integrate the Stored Procedures with their pre-existing application or to use a web application to get quick results.

# Database

Microsoft SQL server database is used to create and make predictions on the dummy dataset. Nevertheless, the propensity model is compatible with existing RAB database, which can be linked to the model created, but requires changes on the stored procedures and the model if changes in the database occurs. The propensity tool provides user interface which allows data uploading and downloading of predictions. It also allows users to export data from software tools like MS Excel, SharePoint and database as long as the file uploaded in the application is in csv file. However, this setting can always be altered for different file extensions. 
 
The initial step in the database design was to undermine the data that would be collected and analyse via it. The database created on the local server is easy to setup on the client’s desktop environment. 
 
For the purpose of managing the data and the respective tables, every table contains one field with unique values (row numbers) and is labelled as the primary key for the table. In order to simplify the usage of the system, any guest user is given the access to the database. However, this setting can be changed as the SQL machine learning services are used on the client’s pre-existing application, so it is flexible with the setting.  
 
The propensity tool has searchable and sortable fields that can be used in reporting. For this reason, the field names are consistent with fields built in the web application, used in the algorithm and the database of the bank.

# Web Application

![image](https://user-images.githubusercontent.com/72771903/113711775-b53b9900-9728-11eb-8391-16d1e54bf43a.png)
