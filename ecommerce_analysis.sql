--View column name and data type
PRAGMA table_info(Sales);

-- View the data
SELECT *
FROM Sales
LIMIT 10;

-- Count unique customers excluding NULL values
SELECT COUNT(DISTINCT CustomerID) AS TotalCustomers
FROM Sales
WHERE CustomerID IS NOT NULL;

-- Count records with missing CustomerID
SELECT COUNT(*) AS MissingCustomerIDs
FROM Sales
WHERE CustomerID IS NULL;

-- Total revenue generated including null CustomerID
SELECT ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
FROM Sales;

--Check Returns
SELECT 
    MIN(Quantity) AS MinQty,
    MAX(Quantity) AS MaxQty
FROM Sales;

--Clean Revenue
SELECT 
    ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
FROM Sales
WHERE Quantity > 0
  AND UnitPrice > 0;
 
-- Revenue per Product
 SELECT 
    StockCode,
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
FROM Sales
WHERE Quantity > 0
  AND UnitPrice > 0
GROUP BY StockCode, Description
ORDER BY TotalRevenue DESC;

--Top 10 Products
SELECT 
    StockCode,
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
FROM Sales
WHERE Quantity > 0
  AND UnitPrice > 0
GROUP BY StockCode, Description
ORDER BY TotalRevenue DESC
LIMIT 10;

--Number of Products
SELECT 
    COUNT(DISTINCT StockCode) AS TotalProducts
FROM Sales
WHERE Quantity > 0;

--Average revenue per product
SELECT 
    ROUND(AVG(ProductRevenue), 2) AS AvgRevenuePerProduct
FROM (
    SELECT 
        StockCode,
        SUM(Quantity * UnitPrice) AS ProductRevenue
    FROM Sales
    WHERE Quantity > 0
    GROUP BY StockCode
);

--Monthly revenue
SELECT 
    Year,
    Month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS MonthlyRevenue
FROM Sales
WHERE Quantity > 0
GROUP BY Year, Month
ORDER BY Year, Month;

--Revenue by Country
SELECT 
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
FROM Sales
WHERE Quantity > 0
GROUP BY Country
ORDER BY TotalRevenue DESC;

--Customer Revenue
SELECT 
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS TotalSpent
FROM Sales
WHERE Quantity > 0
  AND CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

--Repeat customers
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS NumPurchases
FROM Sales
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) > 1;

--Retention Rate %
WITH CustomerOrders AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS NumOrders
    FROM Sales
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)

SELECT 
    COUNT(CASE WHEN NumOrders > 1 THEN 1 END) * 100.0 / COUNT(*) AS RetentionRate
FROM CustomerOrders;

--one time vs repeat customers
SELECT 
    CustomerType,
    COUNT(*) AS NumCustomers
FROM (
    SELECT 
        CustomerID,
        CASE 
            WHEN COUNT(DISTINCT InvoiceNo) = 1 THEN 'One-time'
            ELSE 'Repeat'
        END AS CustomerType
    FROM Sales
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)
GROUP BY CustomerType;

CREATE VIEW CleanSales AS
SELECT *
FROM Sales
WHERE Quantity > 0
  AND UnitPrice > 0;