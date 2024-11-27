create database insurance;
use insurance;

#Target
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
FROM `individual budgets`;


#No.of meetings by Account executive
SELECT `Account Executive` AS Account_Exe, count(meeting_date ) AS Total_Meetings
FROM Meeting
GROUP BY `Account Executive`;

#No.of invoice by Account Executive 
select `Account Executive`As Account_exe ,count(invoice_date) As no_of_invoices
from invoice
group by `Account Executive`;

#Stages wise by revenue amount
SELECT stage,
sum(revenue_amount)*100 AS rev_amount
FROM Opportunity
group by stage;

#top 10 products by revenue wise
SELECT product_group,
       SUM(revenue_amount) AS total_revenue
FROM Opportunity
GROUP BY product_group
ORDER BY total_revenue DESC
LIMIT 10;

#yearly meeting count;
SELECT YEAR(meeting_date) AS Year, COUNT(*) AS Total_Meetings
FROM Meeting
GROUP BY YEAR(meeting_date);

SELECT COUNT(*) FROM Meeting;