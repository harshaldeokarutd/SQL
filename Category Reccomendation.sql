WITH CTE as (
    SELECT
        a.user_id,
        a.quantity,
        b.category,
        b.price
    FROM
        ProductPurchases a JOIN ProductInfo b 
    ON
       a.product_id = b.product_id
),

CTE_2 as (
SELECT DISTINCT
      a.user_id as user_id_1,
      b.user_id as user_id_2,
      a.category as category_1,
      b.category as category_2 
FROM
     CTE a JOIN CTE b 
ON 
    a.user_id = b.user_id AND
    a.category < b.category
)

SELECT 
      category_1 as category1,
      category_2 as category2,
      COUNT(user_id_1) as customer_count
FROM
    CTE_2 
GROUP BY
     category_1, category_2
HAVING customer_count >= 3
ORDER BY customer_count desc, category1 asc, category2 asc