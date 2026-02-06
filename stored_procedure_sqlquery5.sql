IF OBJECT_ID('dbo.usp_LogLowStockProducts', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_LogLowStockProducts;
GO

CREATE PROCEDURE dbo.usp_LogLowStockProducts
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductId INT;
    DECLARE @ProductName VARCHAR(100);
    DECLARE @StockQty INT;

    -- Cursor to get low stock products
    DECLARE curLowStock CURSOR FAST_FORWARD
    FOR
        SELECT ProductId, ProductName, StockQty
        FROM dbo.Products
        WHERE StockQty < 30
        ORDER BY StockQty ASC;

    OPEN curLowStock;

    FETCH NEXT FROM curLowStock 
    INTO @ProductId, @ProductName, @StockQty;

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

    CLOSE curLowStock;
    DEALLOCATE curLowStock;
END;
GO
