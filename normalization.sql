CREATE DATABASE NormalizationDemo;
GO
USE NormalizationDemo;
GO
--1NF
IF OBJECT_ID('dbo.Order_Bad', 'U') IS NOT NULL DROP TABLE dbo.Order_Bad;
GO

CREATE TABLE dbo.Order_Bad
(
    OrderId        INT,
    OrderDate      DATE,
    CustomerName   VARCHAR(100),
    CustomerPhone  VARCHAR(20),
    CustomerCity   VARCHAR(50),
    ProductNames   VARCHAR(200),  -- ❌ multiple values in one column
    TotalAmount    DECIMAL(10,2)
);
GO

INSERT INTO dbo.Order_Bad VALUES
(101, '2026-02-01', 'Arjun Kumar', '9876543210', 'Chennai', 'Mouse, Keyboard', 2500.00),
(102, '2026-02-02', 'Arjun Kumar', '9876543210', 'Chennai', 'Laptop Bag',     1200.00),
(103, '2026-02-02', 'Meera Iyer',  '9123456780', 'Bengaluru', 'Mouse, Laptop Stand, USB Hub', 3100.00);

SELECT * FROM dbo.Order_Bad;


IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers
(
    CustomerId     INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName   VARCHAR(100) NOT NULL,
    CustomerPhone  VARCHAR(20)  NOT NULL,
    CustomerCity   VARCHAR(50)  NOT NULL
);

CREATE TABLE dbo.Orders
(
    OrderId     INT PRIMARY KEY,
    OrderDate   DATE NOT NULL,
    CustomerId  INT NOT NULL,
    CONSTRAINT FK_Orders_Customers
      FOREIGN KEY (CustomerId) REFERENCES dbo.Customers(CustomerId)
);

CREATE TABLE dbo.Products
(
    ProductId   INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    ListPrice   DECIMAL(10,2) NOT NULL
);

CREATE TABLE dbo.OrderItems
(
    OrderId   INT NOT NULL,
    ProductId INT NOT NULL,
    Qty       INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_OrderItems PRIMARY KEY (OrderId, ProductId),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId)
);

--2NF
-- Clean old tables if re-running
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

CREATE TABLE dbo.Customers
(
    CustomerId     INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName   VARCHAR(100) NOT NULL,
    CustomerPhone  VARCHAR(20)  NOT NULL,
    CustomerCity   VARCHAR(50)  NOT NULL
);

CREATE TABLE dbo.Orders
(
    OrderId     INT PRIMARY KEY,
    OrderDate   DATE NOT NULL,
    CustomerId  INT NOT NULL,
    CONSTRAINT FK_Orders_Customers
      FOREIGN KEY (CustomerId) REFERENCES dbo.Customers(CustomerId)
);

CREATE TABLE dbo.Products
(
    ProductId   INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL UNIQUE,
    ListPrice   DECIMAL(10,2) NOT NULL
);

CREATE TABLE dbo.OrderItems
(
    OrderId   INT NOT NULL,
    ProductId INT NOT NULL,
    Qty       INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_OrderItems PRIMARY KEY (OrderId, ProductId),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId)
);
GO

--3NF
IF OBJECT_ID('dbo.Cities', 'U') IS NOT NULL DROP TABLE dbo.Cities;
GO

CREATE TABLE dbo.Cities
(
    CityId   INT IDENTITY(1,1) PRIMARY KEY,
    CityName VARCHAR(50) NOT NULL UNIQUE,
    State    VARCHAR(50) NOT NULL
);

-- Add a CityId column to Customers (demo approach)
ALTER TABLE dbo.Customers
ADD CityId INT NULL;

-- Insert city master data
INSERT INTO dbo.Cities(CityName, State)
VALUES
('Chennai', 'Tamil Nadu'),
('Bengaluru', 'Karnataka');

-- Update existing customers with CityId (simple demo)
UPDATE c
SET CityId = ci.CityId
FROM dbo.Customers c
JOIN dbo.Cities ci ON ci.CityName = c.CustomerCity;

-- Now you can optionally remove CustomerCity text column (optional for demo)
-- ALTER TABLE dbo.Customers DROP COLUMN CustomerCity;

-- Add FK
ALTER TABLE dbo.Customers
ADD CONSTRAINT FK_Customers_Cities
FOREIGN KEY (CityId) REFERENCES dbo.Cities(CityId);