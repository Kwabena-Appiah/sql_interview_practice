--Clean and re-structure messy data.
--Convert columns to different data types.
--Tricks for manipulating NULLs.

--LEFT
--RIGHT
--LENGTH (string functions)

--In the accounts table, there is a column holding the website for each company. 
--The last three digits specify what type of web address they are using
--how many of each website type exist in the accounts table.

SELECT RIGHT(website, 3) AS web_extension, COUNT(*)
FROM accounts
GROUP BY web_extension

-- Use the accounts table to pull the first letter of each company name
-- to see the distribution of company names that begin with each letter (or number
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;

SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name, 
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;

--CONCATENATING
WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;

--COALESCE to fill null values
SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

