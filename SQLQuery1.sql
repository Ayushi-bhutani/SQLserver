--CASE 1:

SELECT 
	EmployeeName as Employee_Name, 
	EmpId as Employee_Id  
from 
	Table_Employee 

--CASE2:
SELECT * from Table_Employee t, Table_Employee t1  -- display in matrix showing 9 rows

--CASE3:
SELECT * from Table_Employee for XML AUTO


--CASE4:
SELECT * from Table_Employee for JSON AUTO

--CASE5:
--SELECT 10 + 400 RESULT from DUAL --(inside anonymous table is created )

--CASE6:
SELECT 'Valid Records' MyCol,* from Table_Employee

--CASE7:
SELECT * into Table_Employee_backup from Table_Employee  --(runs only once, Second times gives error)

--CASE8: 
SELECT * from Table_Customer 

--CASE9:
SELECT EmployeeName from Table_Employee 

--case10:
SELECT DISTINCT salary, EmployeeName from Table_Employee 

--CASE11:
SELECT * from Table_Order where order_status = 'packed'

--CASE12:
SELECT * from Table_Employee where EmpId = '1' and EmployeeName = 'Ayushi' 

--CASE13:
SELECT * 
FROM Table_Employee 
WHERE EmployeeName in ( 'Ayushi')

--CASE14:
SELECT * 
FROM Table_Customer 
WHERE Customer_id BETWEEN 1 AND 2

--CASE15:
SELECT *
FROM Table_Employee 
WHERE EmployeeName LIKE 'a%' or EmployeeName LIKE 'a%i'


--CASE16:
SELECT *
FROM Table_OrderItems
ORDER BY list_price desc

--CASE17:
 SELECT top 1 * from 

(SELECT TOP 2 *
FROM Table_Order
ORDER BY Order_id  desc ) 

TT 

order by tt.Order_id

