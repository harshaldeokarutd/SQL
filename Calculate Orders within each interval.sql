WITH recursive CTE as (
    SELECT
         6 as minute 
    UNION ALL
    SELECT
         minute + 6 as minute
    FROM
        CTE
    WHERE
         minute < (SELECT MAX(minute) FROM Orders)
),

CTE_1 as (
SELECT 
      a.minute as minute1,
      a.order_count,
      b.minute as minute2
FROM
     Orders a JOIN CTE b 
ON
     a.minute <= b.minute
WHERE
     b.minute - a.minute < 6
ORDER BY
      b.minute)


SELECT
     ROW_NUMBER() OVER (ORDER BY minute2 asc) as interval_no,
     total_orders
FROM (
SELECT
     minute2,
     SUM(order_count) as total_orders 
FROM
    CTE_1 
GROUP BY 
      minute2 ) temp