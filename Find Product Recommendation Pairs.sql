WITH CTE as (SELECT
        p1.product_id AS product1_id,
        p2.product_id AS product2_id,
        COUNT(DISTINCT p1.user_id) AS customer_count
    FROM ProductPurchases p1
    JOIN ProductPurchases p2
        ON p1.user_id = p2.user_id
        AND p1.product_id < p2.product_id
    GROUP BY
        p1.product_id,
        p2.product_id
    HAVING COUNT(DISTINCT p1.user_id) >= 3),

CTE_2 as (
SELECT
     a.product1_id,
     a.product2_id,
     b.category,
     a.customer_count
FROM
    CTE a JOIN productInfo b 
ON
   a.product1_id = b.product_id )

SELECT
    a.product1_id,
    a.product2_id,
    a.category as product1_category,
    b.category as product2_category,
    a.customer_count
FROM
    CTE_2 a JOIN ProductInfo b
ON
    a.product2_id = b.product_id
ORDER BY 
 customer_count desc, product1_id asc, product2_id asc
    