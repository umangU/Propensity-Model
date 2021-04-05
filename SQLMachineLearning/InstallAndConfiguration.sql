/*Show all instance configurations*/
EXEC sp_configure

/*Show external scripts enabled config value*/
EXEC sp_configure 'external scripts enabled'

/*Enable external scripts (if needed)*/
EXEC sp_configure 'external scripts enabled', 1
RECONFIGURE WITH OVERRIDE

/*Verify R is enabled*/
EXEC sp_execute_external_script
	@language=N'R',
	@script=N'OutputDataSet <- InputDataSet;',
	@input_data_1=N'SELECT 1 AS R'
WITH RESULT SETS (([R] INT NOT NULL));
