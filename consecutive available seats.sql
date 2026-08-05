WITH CTE as (
    SELECT
        seat_id,
        free,
        seat_id - ROW_NUMBER() OVER (ORDER BY seat_id) as diff
    FROM
        Cinema 
    WHERE
         free = 1
),

CTE_1 as (
SELECT 
     min(seat_id) as first_seat_id,
     max(seat_id) as last_seat_id,
     SUM(free) as consecutive_seats_len 
FROM
   CTE 
GROUP BY
    diff )

SELECT
      first_seat_id,
      last_seat_id,
      consecutive_seats_len
FROM
    CTE_1 
WHERE consecutive_seats_len in (SELECT MAX(consecutive_seats_len) from CTE_1)