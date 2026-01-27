--CASE1: creating and altering a stored procedure 
alter procedure MyPractice
@FirstName1 varchar(500),
@LastName1 varchar(500)
as 
BEGIN

SELECT * 
FROM Table_Customer
WHERE first_name = @FirstName1 OR last_name = @LastName1

END
GO


exec MyPractice 'Akram','Bhutani'


--CASE2: INSERTING INTO table customer 
USE [db1]
GO

INSERT INTO [dbo].[Table_Customer]
           ([Customer_id]
           ,[first_name]
           ,[last_name]
           )
     VALUES
           (4, 'anu', 'bhuvan')
           
GO

--CASE2: UPDATING INTO table customer 
USE [db1]
GO

UPDATE [dbo].[Table_Customer]
   SET phone = 123456789
      
 WHERE (phone = 981812234 )
GO
SELECT *
FROM dbo.Table_Customer


--CASE3: 
ALTER procedure Practice2
@Employee_ID int, 
@Employee_Name varchar(50)

AS
BEGIN 

UPDATE Table_Employee
SET EmployeeName = @Employee_Name
WHERE EmpId = @Employee_ID

SELECT * FROM Table_Employee
END

exec Practice2 7, 'Sachin'
