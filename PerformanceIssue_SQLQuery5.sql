USE AdventureWorks2022;
GO

------------------------------------------------------------
-- STEP 1: DROP TABLE IF EXISTS
------------------------------------------------------------
DROP TABLE IF EXISTS dbo.SOH_Practice;
GO

------------------------------------------------------------
-- STEP 2: CREATE PRACTICE TABLE (300000 RECORDS)
------------------------------------------------------------
SELECT TOP (300000)
    SalesOrderID,
    CustomerID,
    OrderDate,
    SubTotal,
    TaxAmt,
    Freight,
    TotalDue
INTO dbo.SOH_Practice
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID;
GO

------------------------------------------------------------
-- STEP 3: ENABLE TIME & IO STATISTICS
------------------------------------------------------------
SET STATISTICS TIME ON;
SET STATISTICS IO ON;
GO

------------------------------------------------------------
-- STEP 4: SEARCH WITHOUT PRIMARY KEY / INDEX
------------------------------------------------------------
SELECT *
FROM dbo.SOH_Practice
WHERE SalesOrderID = 43659;
GO

------------------------------------------------------------
-- STEP 5: CREATE PRIMARY KEY ON SalesOrderID
-- (Automatically creates CLUSTERED INDEX)
------------------------------------------------------------
ALTER TABLE dbo.SOH_Practice
ADD CONSTRAINT PK_SOH_Practice_SalesOrderID
PRIMARY KEY CLUSTERED (SalesOrderID);
GO

------------------------------------------------------------
-- STEP 6: SEARCH WITH PRIMARY KEY
------------------------------------------------------------
SELECT *
FROM dbo.SOH_Practice
WHERE SalesOrderID = 43659;
GO

------------------------------------------------------------
-- STEP 7: SEARCH ON NON-INDEXED COLUMN
------------------------------------------------------------
SELECT *
FROM dbo.SOH_Practice
WHERE CustomerID = 11000;
GO

------------------------------------------------------------
-- STEP 8: CREATE NON-CLUSTERED INDEX ON CustomerID
------------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_SOH_Practice_CustomerID
ON dbo.SOH_Practice(CustomerID);
GO

------------------------------------------------------------
-- STEP 9: SEARCH AGAIN AFTER NON-CLUSTERED INDEX
------------------------------------------------------------
SELECT *
FROM dbo.SOH_Practice
WHERE CustomerID = 11000;
GO

------------------------------------------------------------
-- STEP 10: OPTIONAL - ORDERDATE INDEX
------------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_SOH_Practice_OrderDate
ON dbo.SOH_Practice(OrderDate);
GO

SELECT *
FROM dbo.SOH_Practice    
WHERE OrderDate >= '2013-01-01';
GO
