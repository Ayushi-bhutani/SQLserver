-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER OrderUpdation
ON dbo.Orders_Table
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Check if stock is sufficient
    IF EXISTS (
        SELECT 1
        FROM Products_Table p
        JOIN INSERTED i
        ON p.ProductID = i.ProductID
        WHERE p.StockQty < i.OrderQty
    )
    BEGIN
        PRINT 'Insufficient Stock';
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Step 2: Reduce stock
    UPDATE p
    SET p.StockQty = p.StockQty - i.OrderQty
    FROM Products_Table p
    JOIN INSERTED i
    ON p.ProductID = i.ProductID;

END
GO


