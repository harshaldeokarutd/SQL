WITH RECURSIVE CTE as (
    SELECT 
         num,
         frequency,
         ROW_NUMBER() OVER (PARTITION BY num) as rn
    FROM
        Numbers
    
    UNION ALL

    SELECT
         num,
         frequency,
         rn + 1 as rn
    FROM 
        CTE 
    WHERE rn < frequency
),

CTE_1 as (
SELECT 
     num,
     COUNT(num) OVER () as cnt,
     ROW_NUMBER() OVER () as rn
FROM
    CTE
ORDER BY num asc),

CTE_2 as (
SELECT 
     DISTINCT
      CASE WHEN cnt % 2 != 0 THEN (cnt + 1)/2 else cnt/2 end as med_ind
FROM
    CTE_1
UNION 
SELECT 
DISTINCT
 CASE WHEN cnt % 2 = 0 THEN (cnt/2)+1 end as med_ind 
FROM
    CTE_1)

SELECT 
    ROUND(AVG(num),1) as median
FROM 
   CTE_1 
WHERE rn in (SELECT med_ind from CTE_2)
