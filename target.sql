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
    `individual budgets`;
