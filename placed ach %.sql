SELECT 
    COALESCE(achieved_totals.income_class, target_totals.income_class) AS income_class,
    
    -- Calculate Placed Achievement Percentage and format as percentage
    CASE 
        WHEN COALESCE(achieved_totals.achieved, 0) = 0 THEN '0%'
        ELSE CONCAT(FORMAT((COALESCE(target_totals.target, 0) / COALESCE(achieved_totals.achieved, 0)) * 100, 2), '%')
    END AS placed_achievement_percentage

FROM (
    -- Achieved Subquery
    SELECT 
        b.income_class,
        (SUM(b.amount) + SUM(f.amount)) AS achieved
    FROM 
        brokerage b
    JOIN 
        fees f ON b.income_class = f.income_class
    WHERE 
        b.income_class IN ('New', 'Cross Sell', 'Renewal')
    GROUP BY 
        b.income_class
) AS achieved_totals

LEFT JOIN (
    -- Target Subquery
    SELECT 
        'New' AS income_class,
        SUM(`New Budget`) AS target
    FROM `individual budgets`
    
    UNION ALL
    
    SELECT 
        'Cross Sell' AS income_class,
        SUM(`cross sell budget`) AS target
    FROM `individual budgets`
    
    UNION ALL
    
    SELECT 
        'Renewal' AS income_class,
        SUM(`renewal budget`) AS target
    FROM `individual budgets`
) AS target_totals ON achieved_totals.income_class = target_totals.income_class

RIGHT JOIN (
    -- To include any income_class from the target_totals that may not exist in achieved_totals
    SELECT 
        'New' AS income_class
    UNION ALL
    SELECT 'Cross Sell'
    UNION ALL
    SELECT 'Renewal'
) AS all_income_classes ON achieved_totals.income_class = all_income_classes.income_class
   OR target_totals.income_class = all_income_classes.income_class;
