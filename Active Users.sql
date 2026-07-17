
WITH CTE as (
    SELECT
        DISTINCT
        id,
        login_date

    FROM 
        Logins
),

CTE_1 as (
SELECT 
     id,
     login_date,
     ROW_NUMBER() OVER (PARTITION BY id ORDER BY login_date) as rnk 
FROM 
     CTE ),

CTE_2 as (
SELECT
    id,
    login_date,
    DATE_SUB(login_date, INTERVAL rnk DAY) as diff
FROM
    CTE_1 ),

CTE_3 as (
SELECT id from (
SELECT 
    id,
    diff,
    count(*) as cnt
FROM
    CTE_2
GROUP BY id, diff
HAVING cnt >= 5) temp)

SELECT
    id,
    name 
FROM 
    Accounts 
WHERE id in (SELECT id from CTE_3) 
ORDER BY id asc
