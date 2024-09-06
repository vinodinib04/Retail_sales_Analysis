-- Creating the database
CREATE DATABASE retailsales;
USE retailsales;

-- Creating sales table
CREATE TABLE sales
(
    transaction_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Determine the total number of records in the dataset
SELECT COUNT(*) AS total_records FROM sales;

-- Find out how many unique customers are in the dataset
SELECT COUNT(DISTINCT customer_id) AS no_of_customers FROM sales;

-- Identify all unique product categories in the dataset
SELECT DISTINCT category FROM sales;

-- Check for any null values in the dataset and delete records with missing data
SELECT * FROM sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Delete records with missing data
DELETE FROM sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Add month column
ALTER TABLE sales ADD COLUMN month VARCHAR(10);
UPDATE sales 
SET month = MONTHNAME(sale_date);

-- Add year column
ALTER TABLE sales ADD COLUMN year INT;
UPDATE sales 
SET year = YEAR(sale_date);

-- Retrieve all columns for sales made on '2022-11-05'
SELECT * FROM sales 
WHERE sale_date = '2022-11-05';

-- Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM sales
WHERE
    category = 'Clothing' AND quantity > 4
    AND month = 'November' AND year = 2022;

-- Calculate the total sales (total_sale) for each category
SELECT 
    category, SUM(total_sale) AS total_sales
FROM sales
GROUP BY category;

-- Find the average age of customers who purchased items from the 'Beauty' category
SELECT 
    ROUND(AVG(age)) AS average_age
FROM sales
WHERE category = 'Beauty';

-- Find all transactions where the total_sale is greater than 1000
SELECT * FROM sales
WHERE total_sale > 1000;

-- Find the total number of transactions (transaction_id) made by each gender in each category
SELECT category, gender, COUNT(transaction_id) AS count
FROM sales
GROUP BY category, gender
ORDER BY category;

-- Calculate the average sale for each month and find out the best selling month in each year
SELECT 
    year, month, avg_sale
FROM 
(    
    SELECT 
        year, month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY year ORDER BY AVG(total_sale) DESC) AS position
    FROM sales
    GROUP BY year, month 
) AS t1
WHERE position = 1;

-- Find the top 5 customers based on the highest total sales
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Find the number of unique customers who purchased items from each category
SELECT 
    category, COUNT(DISTINCT customer_id) AS count
FROM sales
GROUP BY category;

-- Create shifts and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(transaction_id) AS order_count
FROM sales
GROUP BY shift;
