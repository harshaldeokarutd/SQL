WITH RECURSIVE months as (
    SELECT 
        1 as  month_t
    UNION ALL
    SELECT
        month_t + 1 as month_t 
    FROM  
        months 
    WHERE 
         month_t < 12
),

 CTE as (
    SELECT 
         join_date,
         MONTH(join_date) as month_no,
         COUNT(join_date) OVER (ORDER BY join_date) as active_drivers 
    FROM
        Drivers 
    WHERE join_date BETWEEN '2019-01-01' AND '2020-12-31'
    ORDER BY DATE(join_date)
),

CTE_month as (
    SELECT 
         month_no,
         active_drivers
    FROM 
        CTE 
    WHERE 
       join_date BETWEEN '2020-01-01' AND '2020-12-31'
),

CTE_1 as (
    SELECT 
         month(a.requested_at) as month,
         COUNT(b.ride_id) as accepted_rides 
    FROM
        Rides a JOIN AcceptedRides b
    ON a.ride_id = b.ride_id
    WHERE a.requested_at BETWEEN '2020-01-01' AND '2020-12-31'
    GROUP BY month(a.requested_at)
),

CTE_month_2 as (
SELECT 
     a.month_t,
     b.active_drivers,
     COUNT(b.active_drivers) OVER (order by a.month_t) as cnt_t
  
FROM 
    months a LEFT JOIN CTE_month b
ON a.month_t = b.month_no ),

CTE_accepted_drivers as (
SELECT 
    a.month_t,
    COALESCE(b.accepted_rides, 0) as accepted_rides

FROM 
  months a LEFT JOIN CTE_1 b
ON a.month_t = b.month ),

CTE_active_drivers as (
SELECT DISTINCT
     month_t,
     COALESCE(MAX(active_drivers) OVER (PARTITION BY cnt_t),0) as active_drivers
FROM
    CTE_month_2 )

SELECT
      a.month_t as month,
      a.active_drivers,
      b.accepted_rides
FROM
   CTE_active_drivers a JOIN CTE_accepted_drivers b 
ON
a.month_t = b.month_t