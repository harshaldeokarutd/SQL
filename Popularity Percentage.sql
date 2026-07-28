WITH CTE as (
    SELECT
         user1,
         user2
    FROM
        Friends 
    UNION 
      SELECT
         user2 as user1,
         user1 as user2
    FROM
        Friends 
),

CTE1 as (
    SELECT
         user1,
         COUNT(user1) as cnt
    FROM
        CTE
    GROUP BY 
         user1
)

SELECT 
    user1,
    ROUND(100*(cnt/(SELECT count(user1) from CTE1)),2) as percentage_popularity 
FROM 
    CTE1
ORDER BY user1 asc