SELECT 
    COALESCE(invoice_totals.income_class, target_totals.income_class) AS income_class,
    CASE 
        WHEN COALESCE(target_totals.target, 0) = 0 THEN '0%'
        ELSE CONCAT(FORMAT((COALESCE(invoice_totals.invoice, 0) / COALESCE(target_totals.target, 0)) * 100, 2), '%')
    END AS invoice_achievement_percentage
FROM (
    -- Invoice Subquery
    SELECT 
        income_class,
        SUM(amount) AS invoice
    FROM 
        invoice
    WHERE 
        income_class IN ('New', 'Cross Sell', 'Renewal')
    GROUP BY 
        income_class
) AS invoice_totals

LEFT JOIN (
    -- Target Subquery
    SELECT 
        'New' AS income_class,
        SUM(`New Budget`) AS target
    FROM 
        `individual budgets`
    
    UNION ALL

    SELECT 
        'Cross Sell' AS income_class,
        SUM(`cross sell budget`) AS target
    FROM 
        `individual budgets`

    UNION ALL

    SELECT 
        'Renewal' AS income_class,
        SUM(`renewal budget`) AS target
    FROM 
        `individual budgets`
) AS target_totals ON invoice_totals.income_class = target_totals.income_class;
