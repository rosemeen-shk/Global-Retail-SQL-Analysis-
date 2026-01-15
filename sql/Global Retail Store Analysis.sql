Use global_retail;
-- Total Revenue in USD
SELECT 
ROUND(SUM(p.`Unit price USD`*s.Quantity*e.Exchange),3) AS Revenue_in_USD
FROM sales s
JOIN products p
ON p.ProductKey = s.ProductKey
JOIN exchange_rates e
ON e.Currency = s.`Currency Code`
AND e.Date_fixed = s.OrderDate_fixed;

-- Total Revenue by year
SELECT 
ROUND(SUM(p.`Unit price USD`*s.Quantity*e.Exchange),3) AS Revenue_in_USD,
YEAR(s.Orderdate_fixed) AS order_year
FROM sales s
JOIN products p
ON p.ProductKey = s.ProductKey
JOIN exchange_rates e
ON e.Currency = s.`Currency Code`
AND e.Date_fixed = s.OrderDate_fixed
GROUP BY order_year;

-- Total Revenue by Month
SELECT
ROUND(SUM(p.`Unit price USD`*s.Quantity*e.Exchange),3) AS Revenue_in_USD,
MONTH(s.Orderdate_fixed) AS order_month
FROM sales s
JOIN products p
ON p.ProductKey = s.ProductKey
JOIN exchange_rates e
ON e.Currency = s.`Currency Code`
AND e.Date_fixed = s.OrderDate_fixed
GROUP BY order_month
ORDER BY order_month ;

-- COUNTRY WITH HIGHEST REVENUE
SELECT
ROUND(SUM(p.`Unit price USD`*s.Quantity*e.Exchange),3) AS Revenue_in_USD,
c.Country
FROM sales s
JOIN products p
ON p.ProductKey = s.ProductKey
JOIN customers c
ON c.CustomerKey = s.CustomerKey
JOIN exchange_rates e
ON e.Currency = s.`Currency Code`
AND e.Date_fixed = s.OrderDate_fixed
GROUP BY c.Country
ORDER BY c.Country DESC ;


-- STORE WITH THE HIGHEST REVENUE
SELECT
ROUND(SUM(p.`Unit price USD`*s.Quantity*e.Exchange),2) AS Revenue_in_USD,
st.StoreKey,
st.Country,
st.State
FROM sales s
JOIN products p
ON p.ProductKey = s.ProductKey
JOIN stores st
ON st.StoreKey = s.StoreKey
JOIN exchange_rates e
ON e.Currency = s.`Currency Code`
AND e.Date_fixed = s.OrderDate_fixed
GROUP BY st.StoreKey, st.Country, st.State
ORDER BY Revenue_in_USD DESC
LIMIT 1;

-- AVERAGE ORDER VALUE IN USD
SELECT 
	ROUND(AVG(REVENUE_in_USD),2) AS Average_Order_Value
FROM(
SELECT 
s.`Order Number`,
SUM(p.`Unit price USD`*s.Quantity*e.Exchange) AS REVENUE_in_USD
FROM sales s
JOIN products p
ON p.ProductKey = s.ProductKey
JOIN exchange_rates e
ON e.Currency = s.`Currency Code`
AND e.Date_fixed = s.OrderDate_fixed
GROUP BY s.`Order Number`) AS order_totals; 

-- TOP 10 BEST-SELLING PRODUCTS BY QUANTITY
SELECT
	SUM(s.Quantity) AS Total_Quantity,
    p.ProductKey,
    p.`Product Name`
FROM products p 
JOIN sales s
ON s.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.`Product Name`
ORDER BY Total_Quantity DESC
LIMIT 10;

-- PRODUCTS WITH HIGHEST REVENUE
SELECT
p.ProductKey,
p.`Product Name`,
ROUND(SUM(p.`Unit Price USD`*s.Quantity* e.Exchange),2) AS Revenue
FROM products p
JOIN sales s
	ON p.ProductKey = s.ProductKey
JOIN exchange_rates e
	ON s.OrderDate_fixed = e.Date_fixed
    AND e.Currency = s.`Currency Code`
GROUP BY p.ProductKey,p.`Product Name`
ORDER BY Revenue DESC
LIMIT 1;


-- PRODUCTS GENERATING HIGHEST PROFIT

SELECT
p.ProductKey,
p.`Product Name`,
ROUND(SUM(p.`Unit Price USD`*s.Quantity* e.Exchange) - 
	SUM(p.`Unit Cost USD`*s.Quantity* e.Exchange),2) AS PROFIT
FROM products p
JOIN sales s
	ON p.ProductKey = s.ProductKey
JOIN exchange_rates e
	ON s.OrderDate_fixed = e.Date_fixed
    AND e.Currency = s.`Currency Code`
GROUP BY p.ProductKey,p.`Product Name`
ORDER BY PROFIT DESC
LIMIT 1;


-- MOST PROFITABLE PRODUCT CATEGORIES 
SELECT
p.Category,
ROUND(SUM(p.`Unit Price USD`*s.Quantity* e.Exchange) - 
	SUM(p.`Unit Cost USD`*s.Quantity* e.Exchange),2) AS PROFIT
FROM products p
JOIN sales s
	ON p.ProductKey = s.ProductKey
JOIN exchange_rates e
	ON s.OrderDate_fixed = e.Date_fixed
    AND e.Currency = s.`Currency Code`
GROUP BY p.Category
ORDER BY PROFIT DESC
LIMIT 1; 

-- PRODUCT BEING SOLD ON LOSS
SELECT 
p.`Product Name`,
SUM(s.Quantity*p.`Unit Price USD`*e.Exchange) AS REVENUE,
SUM(s.Quantity*p.`Unit Cost USD`*e.Exchange) AS COST_PRICE
FROM products p
JOIN sales s
ON p.ProductKey=s.ProductKey
JOIN exchange_rates e
ON s.OrderDate_fixed=e.Date_fixed
AND s.`Currency Code`=e.Currency
GROUP BY p.`Product Name`
HAVING 
SUM(s.Quantity*p.`Unit Price USD`*e.Exchange)< SUM(s.Quantity*p.`Unit Cost USD`*e.Exchange);

-- TOP 10 CUSTOMERS BY TOTAL SPENDING
SELECT
c.CustomerKey,
c.Name,
ROUND(SUM(s.Quantity * p.`Unit Price USD`* e.Exchange),2) AS Total_spending_inUSD
FROM customers c
JOIN sales s
	ON c.CustomerKey = s.CustomerKey
JOIN products p
	ON s.ProductKey=p.ProductKey
JOIN exchange_rates e
	ON s.OrderDate_fixed = e.Date_fixed 
		AND s.`Currency Code` = e.Currency
GROUP BY c.CustomerKey,c.Name
ORDER BY Total_spending_inUSD DESC
LIMIT 10;


-- AVERAGE CUSTOMER LIFETIME VALUE
SELECT
ROUND(SUM(s.Quantity* p.`Unit Price USD`*e.Exchange)/ COUNT(DISTINCT c.CustomerKey),2) AS AVG_CUSTOMER_LIFETIME_VAL
FROM customers c
JOIN sales s
	ON c.CustomerKey = s.CustomerKey
JOIN products p
	ON s.ProductKey=p.ProductKey
 JOIN exchange_rates e
	ON s.`Currency Code` = e.Currency
    AND s.OrderDate_fixed = e.Date_fixed;


-- COUNTRY WITH HIGHEST VALUE CUSTOMERS
SELECT
c.Country,
ROUND(SUM(s.Quantity* p.`Unit Price USD`*e.Exchange)/ COUNT(DISTINCT c.CustomerKey),2) AS AVG_CUSTOMER_LIFETIME_VAL
FROM customers c
JOIN sales s
	ON c.CustomerKey=s.CustomerKey
JOIN products p
	ON s.ProductKey=p.ProductKey
JOIN exchange_rates e
	ON s.`Currency Code` = e.Currency
    AND s.OrderDate_fixed = e.Date_fixed
GROUP BY c.Country
ORDER BY AVG_CUSTOMER_LIFETIME_VAL DESC
LIMIT 1;

-- GENDER BASED TOTAL SPENDING
SELECT
c.Gender,
ROUND(AVG(s.Quantity* p.`Unit Price USD`*e.Exchange),2) AS TOTAL_SPENDING_AVG
FROM customers c
JOIN sales s
	ON c.CustomerKey=s.CustomerKey
JOIN products p
	ON s.ProductKey=p.ProductKey
JOIN exchange_rates e
	ON s.`Currency Code` = e.Currency
    AND s.OrderDate_fixed = e.Date_fixed
GROUP BY c.Gender
ORDER BY TOTAL_SPENDING_AVG DESC;

-- UNDERPERFORMING STORES BASED ON REVENUE PER SQUARE METER
SELECT
st.StoreKey,
st.Country,
st.State,
st.`Square Meters`,
Round(SUM(s.Quantity* p.`Unit Price USD`*e.Exchange)/st.`Square Meters`,2) AS REVENUE_PER_M2
FROM stores st 
JOIN sales s
	ON st.StoreKey=s.StoreKey
JOIN products p
	ON s.ProductKey=p.ProductKey
JOIN exchange_rates e
	ON s.`Currency Code` = e.Currency
    AND s.OrderDate_fixed = e.Date_fixed 
GROUP BY st.StoreKey,st.Country,st.State,st.`Square Meters`
ORDER BY REVENUE_PER_M2 ASC;


-- PERFORMANCE COMPARISON OF OLD STORES AND NEW STORES 
-- Convert string 'DD-MM-YYYY' into DATE type
ALTER TABLE stores 
ADD COLUMN OpenDate_converted DATE;
UPDATE stores
SET OpenDate_converted = STR_TO_DATE(`Open Date`, '%d-%m-%Y');

SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, st.OpenDate_converted, CURDATE()) >= 3 THEN 'Old Store'
        ELSE 'New Store'
    END AS Store_Category,
    ROUND(SUM(s.Quantity * p.`Unit Price USD` * e.Exchange), 2) AS TOTAL_REVENUE_USD,
    COUNT(DISTINCT st.StoreKey) AS STORE_COUNT,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, st.OpenDate_converted, CURDATE())), 1) AS AVG_STORE_AGE
FROM stores st
JOIN sales s
    ON st.StoreKey = s.StoreKey
JOIN products p
    ON s.ProductKey = p.ProductKey
JOIN exchange_rates e
    ON s.`Currency Code` = e.Currency
   AND s.OrderDate_fixed = e.Date_fixed
GROUP BY Store_Category
ORDER BY TOTAL_REVENUE_USD DESC;


-- COUNTRIES WITH MOST EFFICIENT STORES
SELECT 
st.Country,
-- st.`Square Meters`,
ROUND(SUM(s.Quantity * p.`Unit Price USD` * e.Exchange)/st.`Square Meters`,2) AS REVENUE_PER_M2
FROM sales s
JOIN stores st 
	ON s.StoreKey = st.StoreKey
JOIN products p
	ON p.ProductKey = s.ProductKey
JOIN exchange_rates e
    ON s.`Currency Code` = e.Currency
   AND s.OrderDate_fixed = e.Date_fixed
GROUP BY st.Country,st.`Square Meters`
ORDER BY REVENUE_PER_M2 DESC;
