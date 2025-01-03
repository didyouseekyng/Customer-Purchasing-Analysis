#Database Creation
CREATE DATABASE Customer_Retention_analysis;
USE Customer_Retention_analysis; 

#Data Cleaning Process

#Renaming of Columns
ALTER TABLE shopping_trends
RENAME COLUMN `Customer ID` TO `customer_id`,
RENAME COLUMN `Age` TO `age`,
RENAME COLUMN `Gender` TO `gender`,
RENAME COLUMN `Item Purchased` TO `item_purchased`,
RENAME COLUMN `Category` TO `category`,
RENAME COLUMN `Purchase Amount (USD)` TO `purchase_amount_usd`,
RENAME COLUMN `Location` TO `location`,
RENAME COLUMN `Size` TO `size`,
RENAME COLUMN `Color` TO `color`,
RENAME COLUMN `Season` TO `season`,
RENAME COLUMN `Review Rating` TO `review_rating`,
RENAME COLUMN `Subscription Status` TO `subscription_status`,
RENAME COLUMN `Payment Method` TO `payment_method`,
RENAME COLUMN `Shipping Type` TO `shipping_type`,
RENAME COLUMN `Discount Applied` TO `discount_applied`,
RENAME COLUMN `Promo Code Used` TO `promo_code_used`,
RENAME COLUMN `Previous Purchases` TO `previous_purchases`,
RENAME COLUMN `Preferred Payment Method` TO `preferred_payment_method`,
RENAME COLUMN `Frequency of Purchases` TO `purchase_frequency`;

ALTER TABLE shopping_trends
ADD CONSTRAINT pk_customer_id PRIMARY KEY (customer_id);

#Handle Missing Values

DELETE FROM shopping_trends
WHERE customer_id IS NULL OR 
item_purchased IS NULL;

#SQL Queries

#Total Revenue and Average Purchase Value
SELECT SUM(purchase_amount_usd) AS total_revenue,
AVG(purchase_amount_usd) AS average_purchase_value
FROM shopping_trends;

#Most Popular Products(Items and Categories)
SELECT 
item_purchased,
COUNT(*) AS items_sold,
SUM(purchase_amount_usd) AS total_revenue
FROM shopping_trends
GROUP BY item_purchased
ORDER BY items_sold DESC;

#Customer Segmentation

-- By Gender
SELECT 
gender,
COUNT(*) AS customers,
SUM(purchase_amount_usd) AS total_revenue
FROM shopping_trends
GROUP BY gender
ORDER BY total_revenue DESC;

-- By Age Group
SELECT
    CASE
	WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 25 THEN 'Young Adults'
    WHEN age BETWEEN 26 AND 35 THEN 'Early Career Pros'
    WHEN age BETWEEN 36 and 50 THEN 'Established Adults'
    ELSE 'Senior Customers'
    END AS age_group,
    COUNT(*) AS customers,
    SUM(purchase_amount_usd) AS total_revenue
    FROM shopping_trends
    GROUP BY age_group
    ORDER BY total_revenue DESC;
    
    WITH senior_customers AS(
    SELECT 
    item_purchased,
    SUM(purchase_amount_usd) AS total_sum
    FROM shopping_trends
    WHERE age > 50
    GROUP BY item_purchased 
    ORDER BY total_sum DESC
    )
    SELECT SUM(total_sum) AS overall_sum
    FROM senior_customers;
    
    WITH young_adults AS(
    SELECT 
    item_purchased,
    SUM(purchase_amount_usd) AS total_sum
    FROM shopping_trends
    WHERE age BETWEEN 18 and 25
    GROUP BY item_purchased 
    ORDER BY total_sum DESC
    )
    SELECT SUM(total_sum) AS overall_sum
    FROM young_adults;
    
    WITH early_career_pros AS(
    SELECT 
    item_purchased,
    SUM(purchase_amount_usd) AS total_sum
    FROM shopping_trends
    WHERE age BETWEEN 26 and 35
    GROUP BY item_purchased 
    ORDER BY total_sum DESC
    )
    SELECT SUM(total_sum) AS overall_sum
    FROM early_career_pros;
    
    WITH established_adults AS(
    SELECT 
    item_purchased,
    SUM(purchase_amount_usd) AS total_sum
    FROM shopping_trends
    WHERE age BETWEEN 36 and 50
    GROUP BY item_purchased 
    ORDER BY total_sum DESC
    )
    SELECT SUM(total_sum) AS overall_sum
    FROM established_adults;
    
    #Location Analysis
    SELECT 
    location,
    COUNT(*) AS customers,
    SUM(purchase_amount_usd) AS total_revenue
    FROM shopping_trends
    GROUP BY location
    ORDER BY total_revenue DESC;
    
    #Impact of Discounts and Promo Code Usage
    
    -- Discount
    SELECT 
    discount_applied,
    COUNT(*) AS transactions,
    SUM(purchase_amount_usd) AS total_revenue
    FROM shopping_trends
    GROUP BY discount_applied
    ORDER BY transactions DESC;
    
    -- Promo Code Usage
    SELECT 
    promo_code_used,
    COUNT(*) AS transactions,
    SUM(purchase_amount_usd) AS total_revenue,
    AVG(purchase_amount_usd) AS average_purchase_value
    FROM shopping_trends
    GROUP BY promo_code_used
    ORDER BY transactions DESC;
    
   
   #Customer Satisfaction
  
  -- Review Ratings
    SELECT 
    review_rating,
    COUNT(*) AS review_count
    FROM shopping_trends
    GROUP BY review_rating
    ORDER BY review_rating DESC;
   
   
   #Seasonal Trends
   SELECT 
   season,
   COUNT(item_purchased) AS items_sold,
   SUM(purchase_amount_usd) AS total_revenue
   FROM shopping_trends
   GROUP BY season
   ORDER BY total_revenue DESC;
   
    
    
    #Preferred Payment Methods
    SELECT
    payment_method,
    COUNT(item_purchased) AS transactions,
    SUM(purchase_amount_usd) AS total_revenue
    FROM shopping_trends
    GROUP BY payment_method
    ORDER BY total_revenue DESC;
    
    #Preferred Payment Methods by Season
    SELECT 
	season,
	payment_method,
	COUNT(*) AS usage_count
	from shopping_trends
	GROUP BY season, payment_method
	ORDER BY season, usage_count DESC;
    
    #Preferred Payment Methods by Age Group
    SELECT
    CASE
	WHEN age < 18 THEN 'Under 18'
    WHEN age BETWEEN 18 AND 25 THEN 'Young Adults'
    WHEN age BETWEEN 26 AND 35 THEN 'Early Career Pros'
    WHEN age BETWEEN 36 and 50 THEN 'Established Adults'
    ELSE 'Senior Customers'
    END AS age_group,
    payment_method,
    COUNT(*) AS usage_count
    FROM shopping_trends
    GROUP BY age_group, payment_method
    ORDER BY age_group, usage_count DESC;
    
    #Shipping Preferences
    
    SELECT
    shipping_type,
    COUNT(item_purchased) AS transactions,
    SUM(purchase_amount_usd) AS total_revenue
    FROM shopping_trends
    GROUP BY shipping_type
    ORDER BY total_revenue DESC;
    
    