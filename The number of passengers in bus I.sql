WITH passenger_bus AS (
   SELECT
       b.passenger_id,
       min(a.arrival_time) as at_2
    FROM
      Buses a JOIN Passengers b
    On b.arrival_time <= a.arrival_time
    GROUP BY b.passenger_id
)


SELECT 
    bus_id,
    COUNT(at_2) as passengers_cnt 
FROM 
(
SELECT 
      a.bus_id,
      a.arrival_time,
      b.passenger_id,
      b.at_2 
FROM
    buses a LEFT JOIN passenger_bus  b 
ON a.arrival_time  = b.at_2 ) temp 
GROUP BY bus_id
ORDER BY bus_id asc

