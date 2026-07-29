WITH recursive CTE as (
    SELECT
         customer_id,
         YEAR(MIN(order_date)) as min_year,
         YEAR(MAX(order_date)) as max_year 
    FROM
        Orders 
    GROUP BY 
        customer_id 

    UNION ALL
    
    SELECT
         customer_id,
         min_year + 1 as min_year,
         max_year
    FROM
        CTE 
    WHERE 
         min_year < max_year
),

CTE_1 as (
SELECT 
      a.customer_id,
      a.min_year,
      COALESCE(b.customer_id, a.customer_id) as customer_id_2,
      COALESCE(year(b.order_date), a.min_year) as order_year,
      COALESCE(b.price,0) as price
FROM
     CTE a LEFT JOIN Orders b 
ON  
    a.customer_id = b.customer_id  AND
    a.min_year = year(b.order_date) ),

CTE_2 as (
SELECT 

    customer_id_2,
    order_year,
    SUM(price) as price
FROM 
    CTE_1 
GROUP BY  
     customer_id_2, order_year),


CTE_3 as (

SELECT 
     customer_id_2,
     order_year,
     price,
     LAG(price) OVER (PARTITION BY customer_id_2 ORDER BY order_year) as lg,
     LEAD(price) OVER (PARTITION BY customer_id_2 ORDER BY order_year) as ld,
     ROW_NUMBER() OVER (PARTITION BY customer_id_2 ORDER BY order_year asc) as rnk,
     ROW_NUMBER() OVER (PARTITION BY customer_id_2 ORDER BY order_year desc) as rnk_2
FROM
    CTE_2
ORDER BY 
     customer_id_2, order_year asc),

CTE_4 as (

SELECT 
    customer_id_2,
    order_year,
    price,
    CASE WHEN rnk!=1 and rnk_2!= 1 and price - lg > 0 and ld - price > 0 then 1
         WHEN rnk = 1 and ld - price > 0 then 1
         WHEN rnk_2 = 1 and price - lg > 0 then 1 
         else 0 end as flag
FROM
    CTE_3 ),

CTE_5 as (

SELECT
     customer_id_2,
     COUNT(customer_id_2) as cnt,
     SUM(flag) as cnt_2 
FROM 
    CTE_4
GROUP BY
     customer_id_2)


SELECT
    customer_id_2  as customer_id
FROM
    CTE_5 
WHERE 
    cnt = cnt_2 or cnt = 1