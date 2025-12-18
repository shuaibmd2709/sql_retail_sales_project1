--SQL RETAIL SALES ANALYSIS --

-- CREATING THE TABLE --

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales ( 
			transactions_id	INT PRIMARY KEY,
			sale_date	DATE,
			sale_time	TIME,
			customer_id	INT,
			gender	VARCHAR(20),
			age	INT,
			category	VARCHAR(20),
			quantiy	INT,
			price_per_unit	FLOAT,
			cogs	FLOAT,
			total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

SELECT count(*) FROM retail_sales;

-- checking for null values -- 

SELECT * FROM retail_sales 
WHERE transactions_id is NULL
OR sale_date is NULL
OR sale_time is NULL
OR customer_id is NULL
OR gender is NULL
OR age is NULL
OR category is NULL
OR quantiy is NULL
OR price_per_unit is NULL
OR cogs is NULL
OR total_sale is NULL;

UPDATE retail_sales 
SET age = (SELECT AVG(age) FROM retail_sales) WHERE age is NULL;

SELECT * FROM retail_sales 
WHERE age is NULL;

DELETE FROM retail_sales  
WHERE transactions_id is NULL
OR sale_date is NULL
OR sale_time is NULL
OR customer_id is NULL
OR gender is NULL
OR age is NULL
OR category is NULL
OR quantiy is NULL
OR price_per_unit is NULL
OR cogs is NULL
OR total_sale is NULL;

-----------------------------------

-- DATA EXPLORATION

-- HOW MANY SALES EXISTS?

SELECT COUNT(*) as total_sales FROM retail_sales;

-- count of total customers

SELECT COUNT(DISTINCT(customer_id)) as total_customers FROM retail_sales;

-- count of total CATEGORY

SELECT COUNT(DISTINCT(category)) as total_categories FROM retail_sales;


-- query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';

--  query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022:

SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' 
and quantiy >=4;

-- query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age),2) FROM retail_sales WHERE category = 'Beauty';

-- query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales 
WHERE total_sale > 1000;

-- query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT gender , category, count(*) as total_trans   from retail_sales 
group by gender,category order by 1;

--query to calculate the average sale for each month. Find out best selling month in each year:

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- query to find the top 5 customers based on the highest total sales **:

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- query to find the number of unique customers who purchased items from each category.:

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

--  query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

--- end of project --  
