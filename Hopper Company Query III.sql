WITH recursive cte_months as (
    SELECT
         1 as months
    UNION ALL
      SELECT
         months + 1 as months
    FROM
       cte_months 
    WHERE 
        months < 12
),

CTE as (
SELECT 
     ride_id,
     month(requested_at) as month,
     requested_at
FROM
    Rides 
WHERE 
     requested_at between '2020-01-01' and '2020-12-31'
ORDER BY month asc ),

CTE_2 as (
SELECT
     b.ride_id,
     a.month,
     b.ride_distance,
     b.ride_duration
FROM
    CTE a JOIN AcceptedRides b
ON a.ride_id = b.ride_id),

CTE_3 as (
SELECT
     a.months,
     coalesce(b.ride_distance,0) as ride_distance,
     coalesce(b.ride_duration,0) as ride_duration
FROM
    cte_months a LEFT JOIN CTE_2 b 
ON a.months = b.month),

CTE_4 as (
SELECT
     months,
     SUM(ride_distance) as tot_ride_distance,
     SUM(ride_duration) as tot_ride_duration
FROM
    CTE_3
GROUP BY 
      months)

SELECT 
   *
FROM(

SELECT 
      months as month,
      ROUND(AVG(tot_ride_distance) OVER (ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING),2) as average_ride_distance,
      ROUND(AVG(tot_ride_duration) OVER (ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING),2) as average_ride_duration
FROM
    CTE_4 
WHERE 
    months ) temp
WHERE month
between (SELECT min(months) from cte_months) and (SELECT max(months) - 2 from cte_months)