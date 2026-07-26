WITH CTE as (
    SELECT
        experience,
        salary,
        SUM(salary) OVER (partition by experience order by salary, employee_id asc) as run_sal
    FROM
        Candidates
),


CTE_1 as (
    SELECT
        experience,
        salary,
        run_sal,
        COALESCE(SUM(salary),0) as sum_t,
        COALESCE(COUNT(*),0) as cnt
    FROM
        CTE
    WHERE 
        experience = 'Senior' and
        run_sal < 70000
        
),


CTE_2 as (
    SELECT
        experience,
        salary,
        run_sal,
        COUNT(*) as cnt
    FROM
        CTE
    WHERE 
        experience = 'Junior' 
    AND run_sal <= (70000 - (SELECT sum_t from CTE_1))
)


SELECT 
     'Senior' as experience,
      cnt as accepted_candidates
FROM
    CTE_1

UNION 

SELECT 
     'Junior' as experience,
      cnt as accepted_candidates
FROM
    CTE_2