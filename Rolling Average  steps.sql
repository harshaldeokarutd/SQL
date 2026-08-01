
WITH CTE as (
SELECT
     user_id,
     steps_count,
     steps_date,
     ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY steps_date) as rn 
FROM 
    Steps ),

CTE_1 as (
SELECT 
     user_id,
     steps_count,
     steps_date,
     DATE_SUB(steps_date, INTERVAL rn day) as difference
FROM
    CTE),

CTE_2 as (
SELECT 
      * 
FROM 
(
SELECT 
     user_id,
     steps_count,
     steps_date,
     difference,
     COUNT(difference) OVER (PARTITION BY difference, user_id) as cnt 
FROM 
    CTE_1
ORDER BY user_id) temp 
WHERE temp.cnt > 2 ),

CTE_3 as (
SELECT 
     user_id,
     steps_count,
     steps_date,
     ROUND(AVG(steps_count) OVER (PARTITION BY user_id ORDER BY steps_date ROWS BETWEEN 2 PRECEDING and CURRENT ROW),2) as avg_steps 
FROM 
     CTE_2
),

CTE_4 as (
SELECT
     user_id,
     steps_date,
     avg_steps as rolling_average,
     rnk
FROM 
    (
SELECT 
      user_id,
      steps_count,
      steps_date,
      avg_steps,
      ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY steps_date asc) as rnk 
FROM
    CTE_3 
    ) temp 
WHERE
     rnk > 2)

SELECT
     user_id,
     steps_date,
     rolling_average 
FROM
    CTE_4