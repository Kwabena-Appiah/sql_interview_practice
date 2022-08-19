--100 most recent orders
select * 
	from orders
		order by occurred_at DESC 
	limit 100
	
--10 earliest  orders
select id, occurred_at, total_amt_usd
	from orders
		order by occurred_at 
	limit 10
	
--top 5 orders in terms of amount
select id, account_id, total_amt_usd
	from orders
		order by total_amt_usd DESC	
	limit 5
	
--20 lowest orders in terms of amount
select id, account_id, total_amt_usd
	from orders
		order by total_amt_usd
	limit 20

--order orders by account, and order each accounts by total amount
select account_id, total_amt_usd
	from orders
		order by account_id, total_amt_usd DESC
	limit 100
	
--100 most recent orders by account_id
select id, account_id, total_amt_usd 
	from orders
			where account_id = 4251
		order by occurred_at DESC 
	limit 100
	
--calculate unit price for each order
select id, account_id, 
	standard_amt_usd, standard_qty, 
	standard_amt_usd/ standard_qty as unit_price
from orders
limit 10

--percentage of revenue that comes from poster paper for each order.
SELECT id, account_id, 
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;

--Filtering Options:  LIKE, IN, NOT (NOT IN, NOT LIKE, ), OR, AND & BETWEEN
-- LIKE 'C%' - beginning with C
-- LIKE '%one%' - contaain 'one' in name
-- LIKE '%s' -ends with s


SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';



	
	

