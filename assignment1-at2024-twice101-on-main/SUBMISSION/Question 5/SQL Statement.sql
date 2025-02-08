-- Question 5.1: List of All Customers and Their Orders
-- This query retrieves all customer details (including people that have not place order), their orders, the list of products in each order, and the total paid.
SELECT 
    C.Cemail_id AS Customer_Email,
    C.Cfirst_name || ' ' || C.Clast_name AS Customer_Name,
    O.Oorder_number AS Order_Number,
    O.Odate AS Order_Date,
    GROUP_CONCAT(P.Pshort_name, ', ') AS Product_List,
    SUM(OC.Oquantity * P.Pprice) AS Total_Paid
FROM Customer C
LEFT JOIN Orders O ON C.Cemail_id = O.Cemail_id
LEFT JOIN order_contains OC ON O.Oorder_number = OC.Oorder_number
LEFT JOIN Products P ON OC.Pproduct_number = P.Pproduct_number
GROUP BY C.Cemail_id, O.Oorder_number
ORDER BY O.Oorder_number;



-- Question 5.2: Customers with Items in Their Baskets
-- This query identifies customers with active baskets, retrieving their gift card balances and the products in their baskets.
SELECT 
    C.Cemail_id AS Customer_Email,
    C.Cfirst_name || ' ' || C.Clast_name AS Customer_Name,
    C.Cbirthdate AS Birthday,
    VG.Total_Balance AS Gift_Card_Balance,
    GROUP_CONCAT( P.Pshort_name || ' (x' || BQ.TotalQuantity || ')', ', ') AS Basket_Products
FROM Customer C
LEFT JOIN Basket B ON C.Cemail_id = B.Cemail_id
LEFT JOIN (
    SELECT 
        BC.Bbasket_id, 
        BC.Pproduct_number, 
        SUM(BC.Bquantity) AS TotalQuantity
    FROM basket_contains BC
    GROUP BY BC.Bbasket_id, BC.Pproduct_number
) BQ ON B.Bbasket_id = BQ.Bbasket_id
LEFT JOIN Products P ON BQ.Pproduct_number = P.Pproduct_number
LEFT JOIN (
    SELECT 
        PM.Cemail_id, 
        SUM(VG.Pcurrent_balance) AS Total_Balance
    FROM Payment_methods PM
    LEFT JOIN Pvouchers_gift_cards VG ON PM.Ppayment_method_id = VG.Ppayment_method_id
    GROUP BY PM.Cemail_id
) VG ON VG.Cemail_id = C.Cemail_id
WHERE BQ.Bbasket_id IS NOT NULL
GROUP BY C.Cemail_id;

-- Question 5.3: Top Two Items Sold in Each Product Category
-- This query retrieves the top two products by sales in each category to assist in stock and marketing decisions.
WITH ProductSales AS (
    SELECT 
        P.Pcategory AS Category,
        P.Pshort_name AS Product_Name,
        P.Pproduct_number AS Product_ID, -- Added Product_ID
        SUM(OC.Oquantity) AS Total_Sales,
        ROW_NUMBER() OVER (PARTITION BY P.Pcategory ORDER BY SUM(OC.Oquantity) DESC) AS Rank
    FROM Products P
    JOIN order_contains OC ON P.Pproduct_number = OC.Pproduct_number
    GROUP BY P.Pcategory, P.Pshort_name, P.Pproduct_number
)
SELECT Category, Product_Name, Product_ID, Total_Sales
FROM ProductSales
WHERE Rank <= 2;



-- Question 5.4: Month-Over-Month Sales Growth
-- This query calculates month-over-month sales growth, accounting for confirmed refunds.
-- Note: As shown in the E-R model, the Refund_Total is the derived attribute, that's why I first compute it's data base on information on quantity and price. 

WITH Refunds AS (
    SELECT 
        STRFTIME('%Y', R.Rstart_date) AS Year,
        STRFTIME('%m', R.Rstart_date) AS Month,
        SUM(OC.Oquantity * P.Pprice) AS Refund_Total
    FROM Returns R
    JOIN order_contains OC ON R.Oorder_number = OC.Oorder_number
    JOIN Products P ON OC.Pproduct_number = P.Pproduct_number
    WHERE R.Rstatus = 'Confirmed'
    GROUP BY Year, Month
),
MonthlySales AS (
    SELECT 
        STRFTIME('%Y', O.Odate) AS Year,
        STRFTIME('%m', O.Odate) AS Month,
        SUM(OC.Oquantity * P.Pprice) AS Total_Sales
    FROM Orders O
    JOIN order_contains OC ON O.Oorder_number = OC.Oorder_number
    JOIN Products P ON OC.Pproduct_number = P.Pproduct_number
    GROUP BY Year, Month
),
AdjustedSales AS (
    SELECT 
        MS.Year,
        MS.Month,
        MS.Total_Sales - COALESCE(R.Refund_Total, 0) AS Net_Sales
    FROM MonthlySales MS
    LEFT JOIN Refunds R ON MS.Year = R.Year AND MS.Month = R.Month
),
SalesGrowth AS (
    SELECT 
        Year,
        Month,
        Net_Sales AS Total_Sales,
        LAG(Net_Sales) OVER (ORDER BY Year, Month) AS Previous_Sales,
        ROUND(
            ((Net_Sales - LAG(Net_Sales) OVER (ORDER BY Year, Month)) * 100.0) /
            LAG(Net_Sales) OVER (ORDER BY Year, Month), 2
        ) AS Sales_Growth
    FROM AdjustedSales
)
SELECT Year, Month, Total_Sales, Sales_Growth
FROM SalesGrowth;
