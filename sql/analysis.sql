-- Q1: Number of listings by category

SELECT
    c.category_name,
    COUNT(*) AS total_listings
FROM listings AS l
JOIN categories AS c
    ON l.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_listings DESC;

-- 1st output --

--  category_name | total_listings 
-- ---------------+----------------
--  Accessories   |             92
--  Sportswear    |             91
--  Shoes         |             86
--  Clothing      |             81
--  Bags          |             78
--  Jewelry       |             72
-- (6 rows)

-- Q2: Sales performance by category

SELECT
    c.category_name,
    COUNT(o.order_id) AS total_sales,
    SUM(l.price) AS total_sales_value
FROM orders AS o
JOIN listings AS l
    ON o.listing_id = l.listing_id
JOIN categories AS c
    ON l.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales_value DESC;

--2nd output --
--  category_name | total_sales | total_sales_value 
-- ---------------+-------------+-------------------
--  Shoes         |          44 |           3758.60
--  Accessories   |          48 |           3579.69
--  Sportswear    |          43 |           3489.35
--  Clothing      |          40 |           3197.55
--  Jewelry       |          39 |           3144.30
--  Bags          |          36 |           2893.44
-- (6 rows)

-- Q3: Sell-through rate by category

SELECT
    c.category_name,
    COUNT(l.listing_id) AS total_listings,
    COUNT(o.order_id) AS sold_listings,
    ROUND(
        COUNT(o.order_id) * 100.0 /
        COUNT(l.listing_id), 2
    ) AS sell_through_rate
FROM categories AS c
JOIN listings AS l
    ON c.category_id = l.category_id
LEFT JOIN orders AS o
    ON l.listing_id = o.listing_id
GROUP BY c.category_name
ORDER BY sell_through_rate DESC;

--3rd output --
--  category_name | total_listings | sold_listings | sell_through_rate 
-- ---------------+----------------+---------------+-------------------
--  Jewelry       |             72 |            39 |             54.17
--  Accessories   |             92 |            48 |             52.17
--  Shoes         |             86 |            44 |             51.16
--  Clothing      |             81 |            40 |             49.38
--  Sportswear    |             91 |            43 |             47.25
--  Bags          |             78 |            36 |             46.15
-- (6 rows)


-- Q4: Top sellers by transaction value

WITH seller_sales AS (
    SELECT
        l.seller_id,
        COUNT(o.order_id) AS total_sales,
        SUM(l.price) AS total_sales_value
    FROM orders AS o
    JOIN listings AS l
        ON o.listing_id = l.listing_id
    GROUP BY l.seller_id
)
SELECT
    u.username,
    s.total_sales,
    s.total_sales_value,
    RANK() OVER (
        ORDER BY s.total_sales_value DESC
    ) AS seller_rank
FROM seller_sales AS s
JOIN users AS u
    ON s.seller_id = u.user_id
ORDER BY seller_rank
LIMIT 10;

--4th output--
--  username | total_sales | total_sales_value | seller_rank 
-- ----------+-------------+-------------------+-------------
--  user_15  |           8 |            862.54 |           1
--  user_82  |           4 |            510.02 |           2
--  user_25  |           5 |            476.57 |           3
--  user_21  |           4 |            443.53 |           4
--  user_55  |           5 |            435.29 |           5
--  user_48  |           4 |            420.69 |           6
--  user_36  |           5 |            411.28 |           7
--  user_62  |           3 |            392.89 |           8
--  user_80  |           4 |            381.82 |           9
--  user_70  |           3 |            351.73 |          10
-- (10 rows)

-- Q5: Monthly marketplace transaction value

SELECT
    DATE_TRUNC('month', o.order_date)::DATE AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(l.price), 2) AS total_transaction_value
FROM orders AS o
JOIN listings AS l
    ON o.listing_id = l.listing_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY month;