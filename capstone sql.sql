CREATE TABLE sales_order_header AS
SELECT
    DATE '1899-12-30' + CAST(TRY_CAST(SalesOrderID AS DOUBLE) AS INTEGER) AS SalesOrderID,
    TRY_CAST(RevisionNumber AS INTEGER)                    AS RevisionNumber,
    DATE '1899-12-30' + CAST(TRY_CAST(OrderDate AS DOUBLE) AS INTEGER)    AS OrderDate,
    DATE '1899-12-30' + CAST(TRY_CAST(DueDate AS DOUBLE) AS INTEGER)     AS DueDate,
    DATE '1899-12-30' + CAST(TRY_CAST(ShipDate AS DOUBLE) AS INTEGER)    AS ShipDate,
    TRY_CAST(Status AS INTEGER)                            AS Status,
    TRY_CAST(OnlineOrderFlag AS INTEGER)                   AS OnlineOrderFlag,
    SalesOrderNumber,
    PurchaseOrderNumber,
    AccountNumber,
    TRY_CAST(CustomerID AS INTEGER)                        AS CustomerID,
    TRY_CAST(SalesPersonID AS INTEGER)                     AS SalesPersonID,
    TRY_CAST(TerritoryID AS INTEGER)                       AS TerritoryID,
    TRY_CAST(BillToAddressID AS INTEGER)                   AS BillToAddressID,
    TRY_CAST(ShipToAddressID AS INTEGER)                   AS ShipToAddressID,
    TRY_CAST(ShipMethodID AS INTEGER)                      AS ShipMethodID,
    TRY_CAST(CreditCardID AS INTEGER)                      AS CreditCardID,
    CreditCardApprovalCode,
    TRY_CAST(NULLIF(CurrencyRateID, 'NULL') AS INTEGER)    AS CurrencyRateID,
    TRY_CAST(SubTotal AS DOUBLE)                           AS SubTotal,
    TRY_CAST(TaxAmt AS DOUBLE)                             AS TaxAmt,
    TRY_CAST(Freight AS DOUBLE)                            AS Freight,
    TRY_CAST(TotalDue AS DOUBLE)                           AS TotalDue,
    NULLIF(Comment, 'NULL')                                AS Comment,
    rowguid,
    DATE '1899-12-30' + CAST(TRY_CAST(ModifiedDate AS DOUBLE) AS INTEGER) AS ModifiedDate
FROM read_xlsx(
    'C:\Users\Hp\Documents\Sales.SalesOrderHeader.xlsx',
    header = true,
    all_varchar = true
);


SELECT * from sales_order_header;

CREATE TABLE sales_order_detail AS
SELECT *
FROM read_xlsx(
    "C:\Users\Hp\Documents\Sales.SalesOrderDetail.xlsx",
    header = true
);

CREATE TABLE sales_customer AS
SELECT
    TRY_CAST(CustomerID AS INTEGER)                  AS CustomerID,
    TRY_CAST(NULLIF(PersonID, 'NULL') AS INTEGER)    AS PersonID,
    TRY_CAST(NULLIF(StoreID, 'NULL') AS INTEGER)     AS StoreID,
    TRY_CAST(TerritoryID AS INTEGER)                 AS TerritoryID,
    AccountNumber,
    rowguid,
    TRY_CAST(ModifiedDate AS DATE)                   AS ModifiedDate
FROM read_xlsx(
    'C:\Users\Hp\Documents\Sales.Customer.xlsx',
    header = true,
    all_varchar = true
);

CREATE TABLE sales_territory AS 
SELECT *
FROM read_xlsx(
	"C:\Users\Hp\Documents\Sales.SalesTerritory.xlsx", header = true
);

CREATE TABLE production_product AS
SELECT
    TRY_CAST(ProductID AS INTEGER)                          AS ProductID,
    Name,
    ProductNumber,
    TRY_CAST(MakeFlag AS INTEGER)                           AS MakeFlag,
    TRY_CAST(FinishedGoodsFlag AS INTEGER)                  AS FinishedGoodsFlag,
    NULLIF(Color, 'NULL')                                   AS Color,
    TRY_CAST(SafetyStockLevel AS INTEGER)                   AS SafetyStockLevel,
    TRY_CAST(ReorderPoint AS INTEGER)                       AS ReorderPoint,
    TRY_CAST(StandardCost AS DOUBLE)                        AS StandardCost,
    TRY_CAST(ListPrice AS DOUBLE)                           AS ListPrice,
    NULLIF(Size, 'NULL')                                    AS Size,
    NULLIF(SizeUnitMeasureCode, 'NULL')                     AS SizeUnitMeasureCode,
    NULLIF(WeightUnitMeasureCode, 'NULL')                   AS WeightUnitMeasureCode,
    TRY_CAST(NULLIF(Weight, 'NULL') AS DOUBLE)              AS Weight,
    TRY_CAST(DaysToManufacture AS INTEGER)                  AS DaysToManufacture,
    NULLIF(ProductLine, 'NULL')                             AS ProductLine,
    NULLIF(Class, 'NULL')                                   AS Class,
    NULLIF(Style, 'NULL')                                   AS Style,
    TRY_CAST(NULLIF(ProductSubcategoryID, 'NULL') AS INTEGER) AS ProductSubcategoryID,
    TRY_CAST(NULLIF(ProductModelID, 'NULL') AS INTEGER)     AS ProductModelID,
    TRY_CAST(SellStartDate AS DATE)                         AS SellStartDate,
    TRY_CAST(NULLIF(SellEndDate, 'NULL') AS DATE)           AS SellEndDate,
    TRY_CAST(NULLIF(DiscontinuedDate, 'NULL') AS DATE)      AS DiscontinuedDate,
    rowguid,
    TRY_CAST(ModifiedDate AS DATE)                          AS ModifiedDate
FROM read_xlsx(
    'C:\Users\Hp\Documents\Production.Product.xlsx',
    header = true,
    all_varchar = true
);


CREATE TABLE production_product_subcategory AS
SELECT *
FROM read_xlsx(
	"C:\Users\Hp\Documents\Production.ProductSubcategory.xlsx",
	header = true
);

CREATE TABLE production_product_category AS
SELECT *
FROM read_xlsx(
	"C:\Users\Hp\Documents\Production.ProductCategory.xlsx",
	header = true
);

select * from production_product_category;
select * from sales_order_header

DESCRIBE sales_order_detail;

DESCRIBE sales_order_header;

DROP TABLE sales_order_detail;

SELECT COUNT(*) AS total_orders
FROM sales_order_header;

SELECT
    MIN(OrderDate) AS first_order,
    MAX(OrderDate) AS last_order
FROM sales_order_header;

SELECT
    COUNT(*) AS total_sales_lines,
    SUM(OrderQty) AS total_quantity,
    SUM(LineTotal) AS total_revenue
FROM sales_order_detail;
   
SELECT
    ROUND(
        SUM(d.LineTotal) / COUNT(DISTINCT h.SalesOrderID),
        2
    ) AS average_order_value
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID;


SELECT
    h.SalesOrderID,
    h.OrderDate,
    d.ProductID,
    d.OrderQty,
    d.LineTotal
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID
LIMIT 10;

--total revenue
SELECT
    ROUND(SUM(LineTotal), 2) AS total_revenue
FROM sales_order_detail;

--total quantity sold
SELECT
    SUM(OrderQty) AS total_quantity_sold
FROM sales_order_detail;

--total orders
SELECT
    COUNT(DISTINCT SalesOrderID) AS total_orders
FROM sales_order_header;

--average order value
SELECT
    ROUND(
        SUM(d.LineTotal) / COUNT(DISTINCT h.SalesOrderID),
        2
    ) AS average_order_value
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID;

--sales trend
SELECT
    EXTRACT(YEAR FROM h.OrderDate) AS sales_year,
    ROUND(SUM(d.LineTotal), 2) AS revenue,
    COUNT(DISTINCT h.SalesOrderID) AS orders,
    SUM(d.OrderQty) AS quantity_sold
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID
GROUP BY sales_year
ORDER BY sales_year;

--monthly trend
SELECT
    EXTRACT(YEAR FROM h.OrderDate) AS sales_year,
    EXTRACT(MONTH FROM h.OrderDate) AS sales_month,
    ROUND(SUM(d.LineTotal), 2) AS revenue
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID
GROUP BY
    sales_year,
    sales_month
ORDER BY
    sales_year,
    sales_month;

--revenue by product category
SELECT
    pc.Name AS product_category,
    ROUND(SUM(sod.LineTotal), 2) AS revenue,
    SUM(sod.OrderQty) AS quantity_sold,
    COUNT(DISTINCT sod.SalesOrderID) AS orders
FROM sales_order_detail sod
JOIN production_product p
    ON sod.ProductID = p.ProductID
JOIN production_product_subcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN production_product_category pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY revenue DESC;

--calculating revenue by subcategory
SELECT
    pc.Name AS category,
    psc.Name AS subcategory,
    ROUND(SUM(sod.LineTotal), 2) AS revenue,
    SUM(sod.OrderQty) AS quantity_sold
FROM sales_order_detail sod
JOIN production_product p
    ON sod.ProductID = p.ProductID
JOIN production_product_subcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN production_product_category pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    pc.Name,
    psc.Name
ORDER BY revenue DESC;

--highlighting top 10 product
SELECT
    p.ProductID,
    p.Name AS product_name,
    pc.Name AS category,
    psc.Name AS subcategory,
    ROUND(SUM(sod.LineTotal), 2) AS revenue,
    SUM(sod.OrderQty) AS quantity_sold
FROM sales_order_detail sod
JOIN production_product p
    ON sod.ProductID = p.ProductID
JOIN production_product_subcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN production_product_category pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    p.ProductID,
    p.Name,
    pc.Name,
    psc.Name
ORDER BY revenue DESC
LIMIT 10;

--revenue contribution for each category
WITH category_sales AS (
    SELECT
        pc.Name AS category,
        SUM(sod.LineTotal) AS revenue
    FROM sales_order_detail sod
    JOIN production_product p
        ON sod.ProductID = p.ProductID
    JOIN production_product_subcategory psc
        ON p.ProductSubcategoryID = psc.ProductSubcategoryID
    JOIN production_product_category pc
        ON psc.ProductCategoryID = pc.ProductCategoryID
    GROUP BY pc.Name
)

SELECT
    category,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue * 100.0 / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM category_sales
ORDER BY revenue DESC;

--product price vs sales 
SELECT
    p.ProductID,
    p.Name AS product_name,
    p.ListPrice,
    ROUND(SUM(sod.LineTotal), 2) AS revenue,
    SUM(sod.OrderQty) AS quantity_sold,
    ROUND(
        SUM(sod.LineTotal) / SUM(sod.OrderQty),
        2
    ) AS average_selling_price
FROM sales_order_detail sod
JOIN production_product p
    ON sod.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.Name,
    p.ListPrice
ORDER BY revenue DESC
LIMIT 15;

--customer revenue
SELECT
    h.CustomerID,
    COUNT(DISTINCT h.SalesOrderID) AS orders,
    SUM(d.OrderQty) AS quantity_sold,
    ROUND(SUM(d.LineTotal), 2) AS revenue
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID
GROUP BY h.CustomerID
ORDER BY revenue DESC;

--our top customers
SELECT
    h.CustomerID,
    COUNT(DISTINCT h.SalesOrderID) AS orders,
    SUM(d.OrderQty) AS quantity_sold,
    ROUND(SUM(d.LineTotal), 2) AS revenue
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID
GROUP BY h.CustomerID
ORDER BY revenue DESC
LIMIT 10;

--total revenue that comes from top customers
WITH customer_sales AS (
    SELECT
        h.CustomerID,
        SUM(d.LineTotal) AS revenue
    FROM sales_order_header h
    JOIN sales_order_detail d
        ON h.SalesOrderID = d.SalesOrderID
    GROUP BY h.CustomerID
),
ranked_customers AS (
    SELECT
        CustomerID,
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue DESC) AS customer_rank
    FROM customer_sales
)
SELECT
    ROUND(SUM(revenue), 2) AS top_10_revenue,
    ROUND(
        SUM(revenue) * 100.0 /
        (SELECT SUM(revenue) FROM customer_sales),
        2
    ) AS top_10_revenue_percentage
FROM ranked_customers
WHERE customer_rank <= 10;

--Average customer value
SELECT
    ROUND(
        SUM(d.LineTotal) /
        COUNT(DISTINCT h.CustomerID),
        2
    ) AS average_revenue_per_customer
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID;

--revenue to teritory
SELECT
    t.Name AS territory,
    t.CountryRegionCode,
    t."Group" AS region_group,
    COUNT(DISTINCT h.SalesOrderID) AS orders,
    SUM(d.OrderQty) AS quantity_sold,
    ROUND(SUM(d.LineTotal), 2) AS revenue
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID
JOIN sales_territory t
    ON h.TerritoryID = t.TerritoryID
GROUP BY
    t.Name,
    t.CountryRegionCode,
    t."Group"
ORDER BY revenue DESC;

--revenue contribution by territory
WITH territory_sales AS (
    SELECT
        t.Name AS territory,
        SUM(d.LineTotal) AS revenue
    FROM sales_order_header h
    JOIN sales_order_detail d
        ON h.SalesOrderID = d.SalesOrderID
    JOIN sales_territory t
        ON h.TerritoryID = t.TerritoryID
    GROUP BY t.Name
)

SELECT
    territory,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue * 100.0 / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM territory_sales
ORDER BY revenue DESC;

--territory product category
SELECT
    t.Name AS territory,
    pc.Name AS category,
    ROUND(SUM(d.LineTotal), 2) AS revenue,
    SUM(d.OrderQty) AS quantity_sold
FROM sales_order_header h
JOIN sales_order_detail d
    ON h.SalesOrderID = d.SalesOrderID
JOIN sales_territory t
    ON h.TerritoryID = t.TerritoryID
JOIN production_product p
    ON d.ProductID = p.ProductID
JOIN production_product_subcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN production_product_category pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY
    t.Name,
    pc.Name
ORDER BY
    territory,
    revenue DESC;