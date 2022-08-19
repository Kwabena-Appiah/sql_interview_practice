-- select * from orders limit 5;  select * from accounts limit 5;
--customers come have many orders (Orders table is the child table containing foreign key)

-- select accounts.name, orders.occurred_at
-- from orders
-- join accounts
-- on orders.account_id = accounts.id;

--Provide a table for all web_events associated with account name of Walmart
select a.primary_poc, w.occurred_at, w.channel
from web_events w join accounts a
on w.account_id = a.id
where a.name = 'Walmart'
limit 5;


--Provide a table that provides the region for each sales_rep along with their 
--associated accounts.

select r.name region, s.name rep, a.name account
from sales_reps s join region r
on s.region_id = r.id
join accounts a 
on a.sales_rep_id = s.id
limit 5

-- Provide the name for each region for every order, as well as the account name
-- and the unit price they paid (total_amt_usd/total) for the order.
-- Your final table should have 3 columns: region name, account name, and unit price. 
-- A few accounts have 0 for total, so I
-- divided by (total + 0.01) to assure not dividing by zero.

select r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
from sales_reps s join 
region r on s.region_id = r.id
join accounts a on a.sales_rep_id = s.id
join orders o on o.account_id = a.id


--AGGREGATION & NULLS

select * from accounts where primary_poc is NOT NULL;

select * from accounts where primary_poc is  NULL;

--counts all non null data
select count(*)
from accounts;

--the total amount of poster_qty paper ordered in the orders table
--the total amount of standard_qty paper ordered in the orders table
--total amount spent on standard_amt_usd and gloss_amt_usd paper for each order
select sum(poster_qty) as Posterqty,
		sum (standard_qty) as standardqty,
		sum(total_amt_usd) as total_sales
from orders

select sum(standard_amt_usd ) as standard_amount,
	   sum(gloss_amt_usd) as gloss_amount
from orders
group by id

--When was the earliest order ever placed? 
SELECT MIN(occurred_at)
from orders;

--When was the earliest order ever placed?  without aggreagate function
SELECT occurred_at
FROM orders
ORDER BY occurred_at ASC
LIMIT 1

--When did the most recent (latest) web_event occur?
SELECT MAX(occurred_at)
FROM web_events

--When did the most recent (latest) web_event occur?Without aggregate func
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC 
LIMIT 1

--Which account (by name) placed the earliest order?
SELECT a.name,  o.occurred_at
FROM orders o JOIN
accounts a ON o.account_id = a.id
ORDER BY occurred_at ASC
LIMIT 1

--the total sales in usd for each account
SELECT a.name, SUM(total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name;


--what channel did the most recent (latest) web_event occur, 
--which account was associated with this web_event?

SELECT a.name, w.occurred_at
FROM web_events w JOIN 
accounts a ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1

--the total number of times each type of channel from the web_events was used
SELECT channel, count(channel) AS count_times
FROM web_events
GROUP BY channel

--Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc, w.occurred_at
FROM web_events w JOIN accounts a
ON w.account_id = a.id 
ORDER BY w.occurred_at ASC
LIMIT 1

--What was the smallest order placed by each account in terms of total usd
SELECT a.name, MIN(o.total_amt_usd) smallest_order
FROM Orders o JOIN accounts a
ON o.account_id = a.id
GROUP BY  a.name
ORDER BY smallest_order ASC 

--Find the number of sales reps in each region
SELECT r.name, COUNT(s.region_id) sales_reps_count
FROM sales_reps s JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY sales_reps_count DESC

--For each account, determine the average amount of each type of paper 
--they purchased across their orders

SELECT a.name, AVG(o.standard_amt_usd) avg_standard_amt,
			   AVG(o.gloss_amt_usd) avg_gloss_amt,
			   AVG(o.poster_amt_usd) poster_amt_usd
FROM orders o JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name

--For each account, determine the average amount spent per order on each paper type

SELECT a.name, AVG(o.standard_amt_usd) avg_standard_amt,
			   AVG(o.gloss_amt_usd) avg_gloss_amt,
			   AVG(o.poster_amt_usd) poster_amt_usd
FROM orders o JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name

--Determine the number of times a particular channel was used in the web_events table 
--for each sales rep.

SELECT s.name, w.channel, COUNT(w.channel) as number_of_events
FROM sales_reps s JOIN region r
ON s.region_id = r.id
JOIN accounts a ON
a.sales_rep_id = s.id
JOIN web_events w ON 
w.account_id = a.id
GROUP BY s.name, w.channel
ORDER BY number_of_events DESC

--Determine the number of times a particular channel was used in the web_events 
--table for each region

SELECT r.name region, w.channel channel, COUNT(*) as number_of_events
FROM sales_reps s JOIN region r
ON s.region_id = r.id
JOIN accounts a ON
a.sales_rep_id = s.id
JOIN web_events w ON 
w.account_id = a.id
GROUP BY r.name, w.channel
ORDER BY number_of_events DESC 

--Use DISTINCT to test if there are any accounts associated with 
--more than one region.

SELECT a.name, r.name
FROM sales_reps s JOIN region r
ON s.region_id = r.id
JOIN accounts a ON
a.sales_rep_id = s.id

--How many of the sales reps have more than 5 accounts that they manage?
SELECT s.name, COUNT(a.id) count_account
FROM sales_reps s JOIN region r
ON s.region_id = r.id
JOIN accounts a ON
a.sales_rep_id = s.id
GROUP BY s.name
HAVING COUNT(a.id) > 5
ORDER BY count_account DESC


--How many accounts have more than 20 orders?
SELECT a.name, COUNT(*) count_orders
FROM orders o JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
HAVING COUNT(*) > 20
ORDER BY count_orders DESC

--Which account has the most orders?
SELECT a.name, COUNT(*) most_orders
FROM orders o JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY most_orders DESC
LIMIT 1

--Which accounts spent more than 30,000 usd total across all orders?
SELECT a.name, SUM(o.standard_amt_usd + o.gloss_amt_usd+ o.total_amt_usd) total_amt
FROM orders o JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.standard_amt_usd + o.gloss_amt_usd+ o.total_amt_usd) > 30000
ORDER BY total_amt DESC


--Which accounts spent less than 1,000 usd total across all orders?
SELECT a.name, SUM(o.standard_amt_usd + o.gloss_amt_usd+ o.total_amt_usd) total_amt
FROM orders o JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.standard_amt_usd + o.gloss_amt_usd+ o.total_amt_usd) < 1000
ORDER BY total_amt DESC

--Which accounts used facebook as a channel to contact customers more 
--than 6 times?
SELECT a.name account_name, COUNT(*) as channel_times
FROM web_events w JOIN accounts a
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY a.name
HAVING COUNT(*) > 6
ORDER BY channel_times DESC
--OR
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel DESC;

--Which account used facebook most as a channel?
SELECT a.name, COUNT(*) as most_counts
FROM web_events w JOIN accounts a
ON w.account_id = a.id 
WHERE w.channel = 'facebook'
GROUP BY a.name
ORDER BY most_counts DESC 
LIMIT 1


--Which channel was most frequently used by most accounts?
SELECT a.id, a.name, w.channel, COUNT(a.id) account_counts
FROM web_events w JOIN accounts a
ON w.account_id = a.id
GROUP BY a.id, a.name,w.channel
ORDER BY account_counts DESC
LIMIT 10






 












