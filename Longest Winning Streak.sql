WITH CTE as (
    SELECT
         player_id,
         match_day,
         result,
         CASE WHEN result != 'Win' THEN 1 else 0 end as temp
    FROM
         Matches 
),

CTE_1 as (
SELECT 
     player_id,
     match_day,
     result,
     SUM(temp) OVER (PARTITION BY player_id ORDER BY match_day asc) as sum_temp
FROM 
    CTE),


CTE_2 as (

SELECT
    player_id,
    COUNT(sum_temp) OVER (PARTITION BY player_id, sum_temp) as cnt
FROM
    CTE_1 
WHERE
    result = 'Win'),

CTE_3 as (
    SELECT
         DISTINCT player_id 
    FROM
       Matches
)

SELECT
     player_id,
     MAX(streak) as longest_streak
FROM(
SELECT
    a.player_id,
    COALESCE(b.cnt,0) as streak
FROM
   CTE_3  a LEFT JOIN CTE_2 b 
ON 
   a.player_id = b.player_id ) temp 
GROUP BY player_id