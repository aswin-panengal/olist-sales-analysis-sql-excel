 USE olist_ecommerce;
-- Total orders
Select Count(*) AS Total_orders From dbo.olist_orders;

--Total customers
Select Count(Distinct customer_Id) AS Total_customers From dbo.olist_customers;

--Total products
Select Count(Distinct product_id) AS Total_products From dbo.olist_products;

-- Number of sellers
Select Count(Distinct seller_id) AS Total_sellers From dbo.olist_sellers;

-- Business KPI Metrics 


-- Top selling Product Categories(by number of orders)
Select 
	pt.product_category_name_english AS category_name, count(oi.order_id) AS total_orders
From dbo.olist_order_items AS oi
Join dbo.olist_products AS p
	ON oi.product_id = p.product_id
Join dbo.olist_product_category as pt
	ON p.product_category_name = pt.product_category_name
Group By pt.product_category_name_english 
Order By total_orders DESC;

-- Average Payment Value per Order 

Select 
	Round(AVG(payment_value),1) AS avg_payment_per_order
From dbo.olist_payments;

--Average Delivery Time(in days)
Select	
	Round(AVG(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)),2) AS avg_delivery_days
From dbo.olist_orders
Where order_status = 'delivered';

-- Top Sellers by Average Rating 
Select --Top 50
	oi.seller_id,
	ROUND(AVG(r.review_score),2) AS avg_rating,
	COUNT(*) AS total_reviews
From dbo.olist_reviews AS r
Join dbo.olist_order_items AS oi
	ON r.order_id = oi.order_id
Group By oi.seller_id 
Having Count(*) >10
Order by avg_rating DESC, total_reviews DESC;

-- Top States by Number of Customers
Select 
    customer_state, 
    COUNT(DISTINCT customer_id) AS total_customers
From dbo.olist_customers
Group By customer_state
Order BY total_customers DESC;


-- Revenue by Product Category (Use in Excel pivot)

Select 
	pc.product_category_name_english as product_category,
	SUM(oi.price + oi.freight_value) AS total_revenue
From dbo.olist_order_items as oi
Join dbo.olist_products AS p
	ON oi.product_id = p.product_id 
join dbo.olist_product_category as pc
	ON p.product_category_name = pc.product_category_name
Group by pc.product_category_name_english
Order by total_revenue DESC;

-- Monthly order Trends 
Select 
	FORMAT(order_purchase_timestamp, 'yyyy-MM') AS order_month,
	COUNT(order_id) AS total_orders
From dbo.olist_orders
Group by FORMAT(order_purchase_timestamp, 'yyyy-MM')
Order by order_month;

