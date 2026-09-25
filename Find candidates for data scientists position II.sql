WITH CTE as (
    SELECT
        project_id,
        importance,
        skill,
        COUNT(skill) OVER (PARTITION BY project_id ) as cnt
    FROM
        Projects 
),

CTE_1 as (
    SELECT
         candidate_id,
         skill,
         proficiency,
         COUNT(skill) OVER (PARTITION BY candidate_id) as cnt
    FROM
         Candidates
),

CTE_2 as (
SELECT 
     a.project_id,
     a.importance,
     a.skill as skill1,
     a.cnt as cnt_1,
     b.candidate_id,
     b.skill as skill2,
     b.proficiency,
     b.cnt as cnt_2
FROM
     CTE a JOIN CTE_1 b
ON
    a.skill = b.skill),

CTE_3 as (
SELECT
     project_id,
     importance,
     skill1,
     cnt_1,
     candidate_id,
     skill2,
     proficiency,
     cnt_2,
     COUNT(project_id) OVER (PARTITION BY project_id, candidate_id) as cnt_3,
     100 as score
FROM
    CTE_2),

CTE_4 as (
SELECT
     project_id,
     importance,
     skill1,
     cnt_1,
     candidate_id,
     skill2,
     proficiency,
     cnt_2,
     cnt_3,
     100 + SUM(CASE WHEN proficiency > importance THEN + 10
          WHEN proficiency < importance THEN - 5
          WHEN proficiency = importance THEN 0 
          end) 
        OVER (PARTITION by project_id, candidate_id ORDER BY candidate_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 
        cumulative_sum,
    ROW_NUMBER() OVER (PARTITION BY project_id, candidate_id ORDER BY candidate_id asc) as run_cnt
FROM
    CTE_3 
WHERE
    cnt_1 = cnt_3 ),


CTE_5 as (
SELECT
     project_id,
     candidate_id,
     skill1 as skill,
     importance,
     cumulative_sum,
    ROW_NUMBER() OVER (PARTITION BY project_id ORDER BY cumulative_sum desc, candidate_id asc) as rn
FROM
    CTE_4
WHERE
    cnt_3 = run_cnt)

SELECT
     project_id,
     candidate_id,
     cumulative_sum as score
FROM
    CTE_5 
WHERE rn = 1
