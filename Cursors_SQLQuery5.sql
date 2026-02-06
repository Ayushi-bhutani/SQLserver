--creating products table
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    DROP TABLE dbo.Products;
GO

CREATE TABLE dbo.Products
(
    ProductId     INT IDENTITY(1,1) PRIMARY KEY,
    ProductName   VARCHAR(100) NOT NULL,
    Category      VARCHAR(50)  NOT NULL,
    Price         DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    StockQty      INT NOT NULL CHECK (StockQty >= 0),
    IsActive      BIT NOT NULL DEFAULT 1,
    CreatedAt     DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

--inserting into products table
INSERT INTO dbo.Products (ProductName, Category, Price, StockQty)
VALUES
('Wireless Mouse', 'Electronics', 799.00, 50),
('Mechanical Keyboard', 'Electronics', 2499.00, 25),
('Running Shoes', 'Fashion', 1899.00, 40),
('Water Bottle', 'Fitness', 399.00, 120),
('Laptop Backpack', 'Accessories', 1499.00, 35),
('USB-C Cable', 'Electronics', 299.00, 15),
('Gym Gloves', 'Fitness', 499.00, 28);
GO

SELECT * FROM dbo.Products ORDER BY ProductId;
GO


--creating table reorderlog
IF OBJECT_ID('dbo.ReorderLog', 'U') IS NOT NULL
    DROP TABLE dbo.ReorderLog;
GO

CREATE TABLE dbo.ReorderLog
(
    LogId      INT IDENTITY(1,1) PRIMARY KEY,
    ProductId  INT NOT NULL,
    Message    VARCHAR(200) NOT NULL,
    CreatedAt  DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

--cursor declaration
DECLARE @ProductId INT;
DECLARE @ProductName VARCHAR(100);
DECLARE @Price DECIMAL(10,2);

-- 1) Declare cursor
DECLARE curProducts CURSOR FAST_FORWARD
FOR
    SELECT ProductId, ProductName, Price
    FROM dbo.Products
    ORDER BY ProductId;

-- 2) Open cursor
OPEN curProducts;

-- 3) Fetch first row
FETCH NEXT FROM curProducts INTO @ProductId, @ProductName, @Price;

-- 4) Loop until no more rows
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ProductId=' + CAST(@ProductId AS VARCHAR(10))
        + ' | Name=' + @ProductName
        + ' | Price=' + CAST(@Price AS VARCHAR(20));

    -- fetch next row
    FETCH NEXT FROM curProducts INTO @ProductId, @ProductName, @Price;
END

-- 5) Close + Deallocate
CLOSE curProducts;
DEALLOCATE curProducts;

--Print each row
TRUNCATE TABLE dbo.ReorderLog;
GO

DECLARE @ProductId INT;
DECLARE @ProductName VARCHAR(100);
DECLARE @StockQty INT;

DECLARE curLowStock CURSOR FAST_FORWARD
FOR
    SELECT ProductId, ProductName, StockQty
    FROM dbo.Products
    WHERE StockQty < 30
    ORDER BY StockQty ASC;

OPEN curLowStock;
FETCH NEXT FROM curLowStock INTO @ProductId, @ProductName, @StockQty;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO dbo.ReorderLog(ProductId, Message)
    VALUES
    (
        @ProductId,
        'Reorder needed for ' + @ProductName + ' (Stock=' + CAST(@StockQty AS VARCHAR(10)) + ')'
    );

    FETCH NEXT FROM curLowStock INTO @ProductId, @ProductName, @StockQty;
END

CLOSE curLowStock;
DEALLOCATE curLowStock;

SELECT * FROM dbo.ReorderLog ORDER BY LogId;
GO

--stored procedures 
IF OBJECT_ID('dbo.usp_ReorderLog_Cursor', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ReorderLog_Cursor;
GO

CREATE PROCEDURE dbo.usp_ReorderLog_Cursor
AS
BEGIN
    SET NOCOUNT ON;

    -- 1?? Clear old log
    TRUNCATE TABLE dbo.ReorderLog;

    -- 2?? Variable declarations
    DECLARE @ProductId INT;
    DECLARE @ProductName VARCHAR(100);
    DECLARE @StockQty INT;

    -- 3?? Cursor declaration
    DECLARE curLowStock CURSOR FAST_FORWARD
    FOR
        SELECT ProductId, ProductName, StockQty
        FROM dbo.Products
        WHERE StockQty < 30
        ORDER BY StockQty ASC;

    -- 4?? Open cursor
    OPEN curLowStock;

    FETCH NEXT FROM curLowStock 
    INTO @ProductId, @ProductName, @StockQty;

    -- 5?? Loop
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO dbo.ReorderLog (ProductId, Message)
        VALUES
        (
            @ProductId,
            'Reorder needed for ' + @ProductName +
            ' (Stock=' + CAST(@StockQty AS VARCHAR(10)) + ')'
        );

        FETCH NEXT FROM curLowStock 
        INTO @ProductId, @ProductName, @StockQty;
    END

    -- 6?? Close & Deallocate
    CLOSE curLowStock;
    DEALLOCATE curLowStock;

    -- 7?? Show result
    SELECT *
    FROM dbo.ReorderLog
    ORDER BY LogId;
END;
GO

--insert log rows 
TRUNCATE TABLE dbo.ReorderLog;
GO

DECLARE @ProductId INT;
DECLARE @ProductName VARCHAR(100);
DECLARE @StockQty INT;

DECLARE curLowStock CURSOR FAST_FORWARD
FOR
    SELECT ProductId, ProductName, StockQty
    FROM dbo.Products
    WHERE StockQty < 30
    ORDER BY StockQty ASC;

OPEN curLowStock;
FETCH NEXT FROM curLowStock INTO @ProductId, @ProductName, @StockQty;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO dbo.ReorderLog(ProductId, Message)
    VALUES
    (
        @ProductId,
        'Reorder needed for ' + @ProductName + ' (Stock=' + CAST(@StockQty AS VARCHAR(10)) + ')'
    );

    FETCH NEXT FROM curLowStock INTO @ProductId, @ProductName, @StockQty;
END

CLOSE curLowStock;
DEALLOCATE curLowStock;

SELECT * FROM dbo.ReorderLog ORDER BY LogId;
GO

--stored procedure
IF OBJECT_ID('dbo.usp_ReorderLog', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ReorderLog;
GO

CREATE PROCEDURE dbo.usp_ReorderLog
AS
BEGIN
    SET NOCOUNT ON;

    -- 1?? Clear previous logs
    TRUNCATE TABLE dbo.ReorderLog;

    -- 2?? Variable declarations
    DECLARE @ProductId INT;
    DECLARE @ProductName VARCHAR(100);
    DECLARE @StockQty INT;

    -- 3?? Cursor declaration
    DECLARE curLowStock CURSOR FAST_FORWARD
    FOR
        SELECT ProductId, ProductName, StockQty
        FROM dbo.Products
        WHERE StockQty < 30
        ORDER BY StockQty ASC;

    -- 4?? Open cursor
    OPEN curLowStock;

    FETCH NEXT FROM curLowStock 
    INTO @ProductId, @ProductName, @StockQty;

    -- 5?? Loop through rows
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO dbo.ReorderLog (ProductId, Message)
        VALUES
        (
            @ProductId,
            'Reorder needed for ' + @ProductName +
            ' (Stock=' + CAST(@StockQty AS VARCHAR(10)) + ')'
        );

        FETCH NEXT FROM curLowStock 
        INTO @ProductId, @ProductName, @StockQty;
    END

    -- 6?? Close & free cursor
    CLOSE curLowStock;
    DEALLOCATE curLowStock;

    -- 7?? Show result
    SELECT * 
    FROM dbo.ReorderLog
    ORDER BY LogId;
END;
GO
