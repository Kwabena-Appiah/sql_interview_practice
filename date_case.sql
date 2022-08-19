--DATE_TRUNC allows you to truncate your date to a particular part of your date-time column 
--. It will covert datetime(2017-01-01 12:45:01) to 
--a good datetime for grouping
SELECT DATE_TRUNC('month', occurred_at)as month, SUM(standard_qty)
FROM orders
GROUP BY DATE_TRUNC('month', occurred_at)
ORDER BY DATE_TRUNC('month', occurred_at)

SELECT DATE_TRUNC('day', occurred_at)as day, SUM(standard_qty)
FROM orders
GROUP BY DATE_TRUNC('day', occurred_at)
ORDER BY DATE_TRUNC('day', occurred_at)

SELECT DATE_TRUNC('second', occurred_at)as day, SUM(standard_qty)
FROM orders
GROUP BY DATE_TRUNC('second', occurred_at)
ORDER BY DATE_TRUNC('second', occurred_at)

--'year', 'second'

--DATE_PART can be useful for pulling a specific portion of a date
SELECT DATE_PART('dow', occurred_at)as day, SUM(standard_qty)  sum_stq
FROM orders
GROUP BY DATE_PART('dow', occurred_at)
ORDER BY  sum_stq DESC

--Find the sales in terms of total dollars for all orders in each year, 
--ordered from greatest to least
SELECT DATE_PART('year', occurred_at) as years,
             SUM(total_amt_usd) total_sales 
FROM orders
GROUP BY DATE_PART('year', occurred_at)
ORDER BY total_sales DESC

--Which month did Parch & Posey have the greatest sales 
--in terms of total dollars? 
SELECT DATE_PART('month', occurred_at) as month_,
	SUM(total_amt_usd) total_sales
	
FROM orders
GROUP BY DATE_PART('month', occurred_at)
ORDER BY total_sales DESC
LIMIT 1


--Which year did Parch & Posey have the greatest sales in terms of total number of orders

SELECT DATE_PART('year', occurred_at) as years,
             SUM(total) total_qty
FROM orders
GROUP BY DATE_PART('year', occurred_at)
ORDER BY total_qty DESC
LIMIT 1

--
SELECT DATE_TRUNC('month', o.occurred_at) ord_date, SUM(o.gloss_amt_usd) tot_spent
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


--Let's say we want to compare facebook as a channel to other channels, WHEN THEN END
--Derives another column, CASE always used with select

SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;

--CASE STATEMENT WITH AGGREGATION
SELECT CASE WHEN Total > 500 THEN 'Over 500'
			WHEN Total = 500 THEN 'equal to 500'
			ELSE 'less than 500'
			END AS total_sub_class,
			COUNT(*) number_of_class
FROM orders
GROUP BY total_sub_class
ORDER BY number_of_class DESC

--Write a query to display for each order, the account ID, total amount of 
--the order, and the level of the order - ‘Large’ or ’Small’ - depending
--on if the order is $3000 or more, or smaller than $3000

SELECT account_id, total_amt_usd, 
		CASE WHEN total_amt_usd > 3000 THEN 'Large'
			WHEN total_amt_usd < 3000 THEN 'Small'
			END AS level_of_order
FROM orders o 

































