WITH CTE as (
    SELECT
        event_id,
        user_id,
        event_date,
        event_type,
        plan_name,
        monthly_amount 
    FROM
        subscription_events
    WHERE
       event_type = 'downgrade'  and user_id NOT in (
        SELECT
            user_id
        FROM
            subscription_events 
        WHERE
           event_type = 'cancel'
       )
),

CTE_1 as (
SELECT 
     user_id,
     max(monthly_amount) as max_historical_amount,
     ROUND(100*(min(monthly_amount)/max(monthly_amount)),2) as percentage_down 
FROM
    subscription_events 
GROUP BY
     user_id
HAVING percentage_down <= 50),


CTE_2 as (
SELECT 
     user_id,
     DATEDIFF(max(event_date), min(event_date)) as diff
FROM
    subscription_events
GROUP BY
     user_id 
HAVING diff >= 60),

CTE_3 as (
    SELECT
        user_id,
        plan_name,
        event_date,
        monthly_amount,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date desc) as rn 
    FROM
        subscription_events ),
    
CTE_4 as (
    SELECT
        user_id,
        plan_name as current_plan,
        monthly_amount as current_monthly_amount 
    FROM
        CTE_3 
    WHERE 
        rn = 1
)

SELECT
    DISTINCT
    d.user_id,
    c.current_plan,
    c.current_monthly_amount,
    a.max_historical_amount,
    b.diff as days_as_subscriber 
FROM
    CTE_1 a JOIN CTE_2 b  
ON a.user_id = b.user_id 
JOIN CTE_4 c 
ON a.user_id = c.user_id 
JOIN CTE d
ON 
   a.user_id = d.user_id
ORDER BY
     days_as_subscriber desc, user_id asc