
-- PART 1: DATA CLEANING
-- 		In this section, I removed extra spaces and duplicates from the data set.
-- 		Additionally, the data types of some columns in the sales table and the
-- 		customer_info table needed to be updated. This is because the data for these
-- 		columns had other spaces/symbols in them in the original excel file that I
-- 		imported to SQL. 




-- This code removes all spaces from the entries in the 'State' column.

UPDATE customer_info SET State = REPLACE(State, ' ', '');




-- This code puts the space between words in states that have two words.

UPDATE customer_info SET State = REPLACE(State, 'New', 'New ');
UPDATE customer_info SET State = REPLACE(State, 'North', 'North ');
UPDATE customer_info SET State = REPLACE(State, 'South', 'South ');
UPDATE customer_info SET State = REPLACE(State, 'West', 'West ');




-- This code removes all '$' from the entries in the 'revenue' column.
-- (The same technique was used for the 'profit' column.)

UPDATE sales SET revenue = REPLACE(revenue, '$', '');




-- This code converts all profits in parentheses to negative values in the 'profit' column.

UPDATE sales SET profit = REPLACE(profit, '(', '-');
UPDATE sales SET profit = REPLACE(profit, ')', '');




-- This code replaces profits listed as '-' with 0.

UPDATE sales SET profit = REPLACE(profit, '-', '0')
WHERE profit LIKE '-';




-- This code changes 'profit' to the float type.
-- A similar procedure can be used to convert the 'revenue' column to the float type.

ALTER TABLE sales
MODIFY profit FLOAT;




-- This code checks for duplicates. (I intentionally left out the State column in case a customer moved to a different state between orders.)

SELECT last_name, first_name, email, COUNT(customer_id) AS Occurrences FROM customer_info
GROUP BY last_name, first_name, email
ORDER BY Occurrences DESC;




-- Alternatively, this code checks for duplicates as well.

SELECT customer_id, last_name, first_name, email,
ROW_NUMBER() OVER (PARTITION BY customer_id) AS RowNum
FROM customer_info
ORDER BY RowNum DESC;




-- This code removes duplicates by creating a new table with distinct values, then updating the original table.

CREATE TABLE customer_info_distinct AS
SELECT DISTINCT * FROM customer_info;

TRUNCATE TABLE customer_info;

INSERT INTO customer_info
SELECT * FROM customer_info_distinct;

DROP TABLE customer_info_distinct;




-- This code changes the 'orderdate' column of the sales table to the 'date' type.

UPDATE sales
SET orderdate = STR_TO_DATE(orderdate, '%m/%d/%Y');

ALTER TABLE sales
MODIFY orderdate DATE;






-- PART 2: EXPLORING THE DATA
-- In this section, I will . . .




-- This code combines 'first_name' and 'last_name' into one column, titled 'full_name'.

SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM customer_info;




-- This code joins the 'customer_info' table and the 'sales' table.

SELECT * FROM customer_info
JOIN
sales
ON customer_info.customer_id = sales.customer_id;




-- This code counts how many orders were placed per customer_id and arranges the rows from most orders to least orders.

SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name, COUNT(order_id) AS num_of_orders FROM
(SELECT sales.customer_id AS customer_id, last_name, first_name, order_id FROM sales
JOIN
customer_info
ON sales.customer_id = customer_info.customer_id) AS Joined
GROUP BY customer_id, last_name, first_name
ORDER BY num_of_orders DESC;




-- This code counts how many orders were placed per state.

SELECT State, COUNT(order_id) AS total_orders FROM
(SELECT sales.customer_id AS ID, CONCAT(first_name, ' ', last_name) AS full_name, State, order_id, sport FROM customer_info
JOIN
sales
ON customer_info.customer_id = sales.customer_id) AS joined
GROUP BY State
ORDER BY total_orders DESC;




-- This code counts how many orders were placed per sport.

SELECT Sport, COUNT(order_id) AS total_orders FROM
(SELECT sales.customer_id AS ID, CONCAT(first_name, ' ', last_name) AS full_name, State, order_id, sport, profit FROM customer_info
JOIN
sales
ON customer_info.customer_id = sales.customer_id) AS joined
GROUP BY Sport
ORDER BY total_orders DESC;




-- This code counts how many orders were placed per sport per state.

SELECT State, Sport, COUNT(order_id) AS num_of_orders FROM
(SELECT sales.customer_id AS ID, CONCAT(first_name, ' ', last_name) AS full_name, State, order_id, sport FROM customer_info
JOIN
sales
ON customer_info.customer_id = sales.customer_id) AS joined
GROUP BY State, sport
ORDER BY State, num_of_orders DESC;




-- This code checks average profit, highest profit, and lowest profit per sport ordered by average profit.

SELECT Sport, AVG(profit) AS AvgProfit, MAX(profit) AS MaxProfit, MIN(profit) AS MinProfit, COUNT(order_id) AS total_orders FROM
(SELECT sales.customer_id AS ID, CONCAT(first_name, ' ', last_name) AS full_name, State, order_id, sport, profit FROM customer_info
JOIN
sales
ON customer_info.customer_id = sales.customer_id) AS joined
GROUP BY Sport
ORDER BY AvgProfit DESC;




-- This code checks average profit, highest profit, and lowest profit per state
-- ordered by average profit among states where at least 40 orders have been placed.

SELECT State, AVG(profit) AS AvgProfit, MAX(profit) AS MaxProfit, MIN(profit) AS MinProfit, COUNT(order_id) AS total_orders FROM
(SELECT sales.customer_id AS ID, CONCAT(first_name, ' ', last_name) AS full_name, State, order_id, sport, profit FROM customer_info
JOIN
sales
ON customer_info.customer_id = sales.customer_id) AS joined
GROUP BY State
HAVING total_orders >= 40
ORDER BY AvgProfit DESC;




-- This code calculates average profit, maximum profit, minimum profit, and total orders per month.

SELECT SUBSTRING(orderdate, 6, 2) AS 'Month', AVG(Profit), MAX(profit), MIN(Profit), COUNT(order_id) AS total_orders FROM sales
GROUP BY SUBSTRING(orderdate, 6, 2);




-- This code calculates average profit, maximum profit, minimum profit, and total number of orders per sport in June.

SELECT sport, AVG(profit), MAX(profit), MIN(profit), COUNT(order_id) AS total_orders FROM sales
WHERE SUBSTRING(orderdate, 6, 2) = 06
GROUP BY sport;




-- This code calculates average profit per month for hockey sales.

SELECT SUBSTRING(orderdate, 6, 2) AS 'Month', AVG(profit) AS Avg_Profit FROM sales
WHERE sport = 'Hockey'
GROUP BY SUBSTRING(orderdate, 6, 2);




-- This code displays a rolling total by month of the profit.

WITH Rolling_Total AS
(SELECT SUBSTRING(orderdate, 6, 2) AS `Month`, SUM(profit) AS Monthly_Profit FROM sales
GROUP BY SUBSTRING(orderdate, 6, 2))
SELECT `Month`, Monthly_Profit, SUM(Monthly_Profit) OVER(ORDER BY `Month`) AS Rolling_Total_Profit
FROM Rolling_Total;




-- This code shows the date and profit from the 'sales' table together with the name and state from the 'customer_info' table.

SELECT orderdate, full_name, State, profit FROM
(SELECT orderdate, CONCAT(first_name, ' ', last_name) AS full_name, State, profit FROM sales
JOIN customer_info
ON customer_info.customer_id = sales.customer_id) AS full_join
ORDER BY profit DESC;




-- This code gives the customer names, sports, states, and profits ranked in the top 5 highest profits per month.

WITH Profits_From_Sales AS
(SELECT SUBSTRING(orderdate, 6, 2) AS `Month`, CONCAT(first_name, ' ', last_name) AS Full_Name, Sport, State, Profit
FROM sales
JOIN customer_info
ON customer_info.customer_id = sales.customer_id),
Profits_With_Rankings AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY `Month` ORDER BY Profit DESC) AS Monthly_Ranking
FROM Profits_From_Sales)
SELECT *
FROM Profits_With_Rankings
WHERE Monthly_Ranking <= 5;