WITH Customer_Recency AS (
    SELECT 
        CustomerID,
        MAX(InvoiceDate) as Last_Purchase_Date,
        -- Calculate how many days have passed between their last purchase and the end of the dataset
        JULIANDAY((SELECT MAX(InvoiceDate) FROM online_retail)) - JULIANDAY(MAX(InvoiceDate)) as Days_Since_Last_Purchase,
        SUM(Quantity * UnitPrice) as Total_Spent
    FROM online_retail
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    Last_Purchase_Date,
    Days_Since_Last_Purchase,
    Total_Spent,
    CASE 
        WHEN Days_Since_Last_Purchase > 90 THEN 'Churned'
        ELSE 'Active'
    END as Churn_Status
FROM Customer_Recency;