WITH CTE as (
SELECT  
    employee_id,
    review_date,
    rating,
    ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY review_date desc) as rn 
FROM
    performance_reviews ),

CTE_1 as (

SELECT 
     employee_id
FROM CTE 
    WHERE 
        rn >= 3),


CTE_2 as 

(
SELECT * from CTE 
where employee_id in (SELECT employee_id from CTE_1)
AND  rn < 4),

CTE_3 as (
SELECT 
     employee_id,
     review_date,
     rating,
     LEAD(rating,1) OVER (PARTITION BY employee_id ORDER BY review_date desc) as lead1,
     LEAD(rating,2) OVER (PARTITION BY employee_id ORDER BY review_date desc) as lead2 
FROM
    CTE_2 ),


CTE_4 as (
SELECT 
    employee_id,
    improvement_score 
FROM
   (

SELECT
    employee_id,
    rating - lead2 as improvement_score,
    rating - lead1 as sc1,
    lead1 - lead2 as sc2 
FROM
    CTE_3 ) temp
WHERE
    improvement_score > 0 AND sc1 > 0 and sc2 > 0 )

SELECT
    a.employee_id,
    b.name,
    a.improvement_score 
FROM
    CTE_4 a JOIN employees b 
ON a.employee_id = b.employee_id
ORDER BY a.improvement_score desc, b.name asc;

