WITH CTE as (
      SELECT
      purchase_id,
      user_id,
      purchase_date,
      ROW_NUMBER() OVER (PARTITION BY user_id order by purchase_date asc) as rnk
FROM
     Purchases ),

CTE_1 as (
SELECT 
     purchase_id,
     user_id,
     purchase_date,
     LEAD(purchase_date) OVER (PARTITION BY user_id order by purchase_date asc) as leadp
FROM
    CTE)


SELECT 
     distinct
     user_id
FROM
 (
SELECT
     purchase_id,
     user_id,
     purchase_date,
     leadp,
     DATEDIFF(leadp, purchase_date) as temp 
FROM
    CTE_1 ) test
WHERE temp <= 7
ORDER BY user_id asc