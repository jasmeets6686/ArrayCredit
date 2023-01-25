/*
##### Assignment 3
One of our clients provides a data dump of customers they'd like us to add to our system. 
The format is a .csv file with 1,345 lines. 

Describe your approach in validating, formatting and importing the data into your data storage. 
Detail the tools and SQL statements you'd execute.
*/


/* 

There are multiple ways of loading the data. One can use BULK INSERT command or any other tool available in the market for this 
purpose.

I'll use SSIS to import data into the table. 
Firstly, I'll edit the csv and add a column called client_id. This will relate users to a particular client.  I will 
validate the data in SSIS using script component and provide all the checks
needed in the script component.

For validation, 
---> I'll verify data type of each column to make sure data is in 
	the right format
---> I will also check NULL values for NOT NULL columns.
---> I can use additional checks to make sure data is not corrupted(e.g email with no '@').

*/




----- 



/*
##### ASSIGNMENT 5

You discover the SQL database performance is being impacted by many concurrent long running queries.

Describe your approach in how you'd diagnose, test and resolve the issue. Detail the tools and SQL statements you'd execute.



---> 

I'll use Activity Monitor to check if there are any processes/sessions which are getting blocked by another
session. From the monitor , I can also check for different parameters like processor time and waiting tasks. Recent and active 
expensive queries can also be watched from Activity Monitor. I can then kill the process which is blocking all other transactions.

If there are expensive queries that could be optimized, I'll work on optimizing them(e.g. Include/remove indexes).
*/

