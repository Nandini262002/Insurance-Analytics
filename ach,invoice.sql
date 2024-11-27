SELECT 
    achieved_totals.income_class,
    achieved_totals.achieved,
    COALESCE(invoice_totals.invoice_total, 0) AS invoice
FROM (SELECT 'Renewal' AS income_class,(SUM(b.amount) + SUM(f.amount)) AS achieved
        FROM brokerage b
    JOIN 
        fees f ON b.income_class = f.income_class
    WHERE b.income_class = 'Renewal'
    UNION ALL
    SELECT 
        'Cross Sell' AS income_class,
        (SUM(b.amount) + SUM(f.amount)) AS achieved
         FROM brokerage b
    JOIN 
        fees f ON b.income_class = f.income_class
    WHERE b.income_class = 'Cross Sell'
    UNION ALL
    SELECT 
        'New' AS income_class,
        (SUM(b.amount) + SUM(f.amount)) AS achieved
    FROM brokerage b
    JOIN 
        fees f ON b.income_class = f.income_class
    WHERE b.income_class = 'New') AS achieved_totals
LEFT JOIN (SELECT income_class,SUM(amount) AS invoice_total
    FROM invoice
    WHERE income_class IN ('Renewal', 'Cross Sell', 'New')
    GROUP BY income_class
) AS invoice_totals ON achieved_totals.income_class = invoice_totals.income_class;
