WITH Customer_First_Purchase AS (
    -- Step 1: Find the first purchase month for every customer
    SELECT 
        CustomerID,
        MIN(InvoiceDate) as First_Purchase_Date,
        strftime('%Y-%m-01', MIN(InvoiceDate)) as Cohort_Month
    FROM online_retail
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
Transaction_Months AS (
    -- Step 2: Get all unique months each customer made a purchase
    SELECT DISTINCT
        CustomerID,
        strftime('%Y-%m-01', InvoiceDate) as Transaction_Month
    FROM online_retail
    WHERE CustomerID IS NOT NULL
),
Cohort_Periods AS (
    -- Step 3: Calculate the month gap between the first purchase and subsequent purchases
    SELECT 
        t.CustomerID,
        c.Cohort_Month,
        t.Transaction_Month,
        -- Calculate the difference in months
        ((strftime('%Y', t.Transaction_Month) - strftime('%Y', c.Cohort_Month)) * 12) +
        (strftime('%m', t.Transaction_Month) - strftime('%m', c.Cohort_Month)) as Month_Index
    FROM Transaction_Months t
    JOIN Customer_First_Purchase c ON t.CustomerID = c.CustomerID
)
-- Step 4: Count unique customers returning in each Month Index
SELECT 
    Cohort_Month,
    COUNT(DISTINCT CASE WHEN Month_Index = 0 THEN CustomerID END) as Month_0,
    COUNT(DISTINCT CASE WHEN Month_Index = 1 THEN CustomerID END) as Month_1,
    COUNT(DISTINCT CASE WHEN Month_Index = 2 THEN CustomerID END) as Month_2,
    COUNT(DISTINCT CASE WHEN Month_Index = 3 THEN CustomerID END) as Month_3,
    COUNT(DISTINCT CASE WHEN Month_Index = 4 THEN CustomerID END) as Month_4,
    COUNT(DISTINCT CASE WHEN Month_Index = 5 THEN CustomerID END) as Month_5,
    COUNT(DISTINCT CASE WHEN Month_Index = 6 THEN CustomerID END) as Month_6
FROM Cohort_Periods
GROUP BY Cohort_Month
ORDER BY Cohort_Month;