--Which channel saw the most traffic per day on average to Parch & Possy
SELECT channel,
	AVG(event_count) as avg_event_count
FROM (SELECT DATE_TRUNC('day', occurred_at) as day ,
		channel, COUNT(*) as event_count
		FROM web_events
		GROUP BY 1, 2
	  )sub
GROUP BY channel
ORDER BY avg_event_count DESC


--Pull month level information about the first order ever placed  in orders table
SELECT *
FROM orders
WHERE DATE_TRUNC('month',occurred_at)= 
			(SELECT DATE_TRUNC('month', MIN(occurred_at)) as first_order_month
				FROM orders)
ORDER BY occurred_at


--
SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);
	 
SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);
	  

--the most standard_qty paper throughout their lifetime as a customer?
--For the customer that spent the most (in total over their lifetime as 
--a customer) total_amt_usd, how many web_events did they have for each channel?
--What is the lifetime average amount spent in terms of total_amt_usd 
--for the top 10 total spending accounts?
--What is the lifetime average amount spent in terms of total_amt_usd,
--including only the companies that spent more per order, on average, 
--than the average of all orders.	  


--Provide the name of the sales_rep in each region with the largest amount
--of total_amt_usd sales.
----------------------
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;



--For the region with the largest (sum) of sales total_amt_usd, how many total 
--(count) orders were placed?

-- SELECT r.name region_name, SUM(o.total_amt_usd) total_sales
-- FROM sales_reps s JOIN region r
-- ON s.region_id = r.id 
-- JOIN accounts a ON 
-- a.sales_rep_id = s.id
-- JOIN orders o ON
-- o.account_id = a.id
-- GROUP BY 1
-- ORDER BY 2 DESC

-- SELECT MAX(total_amt)
-- FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
--              FROM sales_reps s
--              JOIN accounts a
--              ON a.sales_rep_id = s.id
--              JOIN orders o
--              ON o.account_id = a.id
--              JOIN region r
--              ON r.id = s.region_id
--              GROUP BY r.name) sub;

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);
			  
--How many accounts had more total purchases than the account name which
--has bought the most standard_qty paper throughout their lifetime as a customer?

--First let's find the account which has bought the most standard_qty paper

--Actual
SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;

--For the customer that spent the most (in total over their lifetime as a customer) 
-- total_amt_usd, how many web_events did they have for each channel?


--COMMON TABLE EXPRESSIONS (CTES)
WITH events AS (
          SELECT DATE_TRUNC('day',occurred_at) AS day, 
                        channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;



			  
			  

	  
	  
	  

	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
	  
