WITH CTE as (
    SELECT 
        transaction_id,
        customer_id,
        transaction_date,
        amount,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date asc) as rn,
        DATE_SUB(transaction_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY transaction_date asc) day) as diff,
        LAG(amount) OVER (PARTITION BY customer_id ORDER BY transaction_date) as ld,
        CASE WHEN LAG(amount) OVER (PARTITION BY customer_id ORDER BY transaction_date) < amount THEN 0 else 1 end as amount_next
    FROM 
       Transactions
),

CTE_1 as (
SELECT 
     transaction_id,
     customer_id,
     transaction_date,
     amount,
     rn,
     diff,
     ld,
     amount_next,
     SUM(amount_next) OVER (PARTITION BY customer_id ORDER BY transaction_date) as sum_rnk,
     COUNT(diff) OVER (PARTITION BY customer_id, diff) as diff_cnt
FROM
    CTE)
      
SELECT 
    customer_id,
    MIN(transaction_date) as consecutive_start,
    MAX(transaction_date) as consecutive_end
FROM
   CTE_1 
GROUP BY 
    customer_id,
    diff,
    sum_rnk,
    diff_cnt
HAVING count(*) >= 3
    

