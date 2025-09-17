-- Drop table if exists (SQL Server syntax)
IF OBJECT_ID('dbo.zepto', 'U') IS NOT NULL
    DROP  dbo.zepto
create database zepto_db
use zepto
-- Create table in SQL Server
CREATE TABLE zepto(
    ----sku_id INT IDENTITY(1,1) PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INT,
    outOfStock BIT,
    quantity INT
)

------------------------------------------------
-- DATA EXPLORATION
------------------------------------------------

-- Count of rows
SELECT COUNT(*) AS total_rows FROM zepto

-- Sample data (TOP instead of LIMIT)
SELECT TOP 100 * FROM zepto

-- Null values check
SELECT * FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR availableQuantity IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL

-- Different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id) AS product_count
FROM zepto
GROUP BY outOfStock;

-- Product names present multiple times
SELECT name, COUNT(sku_id) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

------------------------------------------------
-- DATA CLEANING
------------------------------------------------

-- Products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0

-- Delete invalid rows where mrp = 0
DELETE FROM zepto
WHERE mrp = 0

-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0
    select mrp,discountedSellingPrice from zepto

------------------------------------------------
-- DATA ANALYSIS
------------------------------------------------

-- Q1. Top 10 best-value products based on discount percentage
SELECT distinct TOP 10 name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC

-- Q2. Products with High MRP but Out of Stock
SELECT distinct name, mrp
FROM zepto
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC

-- Q3. Estimated Revenue per category
SELECT distinct category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC

-- Q4. Products where MRP > 500 and discount < 10%
SELECT distinct name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC

-- Q5. Top 5 categories with highest average discount percentage
SELECT distinct TOP 5 category,
       ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC

-- Q6. Price per gram for products above 100g (best value sorting)
SELECT distinct name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice*1.0/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC

-- Q7. Categorize products by weight
SELECT distinct name, weightInGms,
       CASE 
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto

-- Q8. Total inventory weight per category
SELECT distinct category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC
--✅ Set up a messy, real-world e-commerce inventory database

---✅ Perform Exploratory Data Analysis (EDA) to explore product categories, availability, and pricing inconsistencies

---✅ Implement Data Cleaning to handle null values, remove invalid entries, and convert pricing from paise to rupees

--✅ Write business-driven SQL queries to derive insights around pricing, inventory, stock availability, revenue and more
--------------------------------
--✅ Set up and structure a real, messy e-commerce inventory database using PostgreSQL
--✅ Data exploration using SQL (missing values, duplicates, categories)
--✅ Data cleaning (zero pricing, converting paise to rupees)
--✅ Business analysis using SQL (revenue, stock analysis, product segmentation)

