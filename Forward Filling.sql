WITH CTE as (
    SELECT
       id,
       drink,
       ROW_NUMBER() OVER () as rn
    FROM
       CoffeeShop
),

CTE_1 as (
SELECT 
     id,
     drink,
     rn,
     COUNT(drink) OVER (ORDER by rn) as cnt
FROM
   CTE)

SELECT
    id,
     MAX(drink) OVER (PARTITION BY cnt) as drink
FROM
    CTE_1 
ORDER BY rn;