WITH RECURSIVE CTE_month as (
    SELECT 
          1 as month
    FROM
       Drivers
    UNION 
    SELECT
        month + 1 as month
    FROM
        CTE_month
    WHERE
       month < 12
),

running_count_drivers as (
    SELECT
        join_date,
        COUNT(driver_id) OVER (ORDER BY join_date asc) as cnt
    FROM
        Drivers
    ORDER BY join_date asc
),

running_count_drivers_2020_temp as (
   SELECT
       month(join_date) as join_date_month,
       cnt
    FROM
        running_count_drivers
    WHERE year(join_date) = '2020'
),

running_count_drivers_2020 as (
SELECT
      a.month,
      b.cnt,
      COUNT(b.cnt) OVER (ORDER BY a.month asc) as run_count
FROM
    CTE_month a LEFT JOIN running_count_drivers_2020_temp b
ON
    a.month = b.join_date_month ),

running_count_drivers_2020_final as (

SELECT 
     month,
     max(cnt) OVER (PARTITION BY run_count) as run_count
     
FROM
    running_count_drivers_2020 ),

CTE_rides as (
SELECT
     *
FROM
    Rides
WHERE 
    year(requested_at) = '2020'
),

CTE_accepted_rides as (
SELECT
    a.month,
    COALESCE(b.cnt, 0) as accepted_cnt
FROM
    CTE_month a LEFT JOIN (
SELECT
   month(a.requested_at) as month,
   COUNT(DISTINCT b.driver_id) as cnt
FROM
    CTE_rides a JOIN  AcceptedRides b
ON
   a.ride_id = b.ride_id
GROUP BY
    month(a.requested_at) ) b 
ON
   a.month = b.month )

SELECT DISTINCT
    a.month,
    COALESCE(ROUND(100*(b.accepted_cnt/run_count),2),0) as working_percentage 
FROM
    running_count_drivers_2020_final a JOIN CTE_accepted_rides b
ON
    a.month = b.month