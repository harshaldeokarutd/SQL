WITH CTE as (
    SELECT
        employee_id,
        start_time,
        end_time,
        ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY start_time) as rnk
    FROM
        EmployeeShifts 
)



SELECT 
     employee_id_1 as employee_id,
     COUNT(employee_id_1) as overlapping_shifts
FROM (
SELECT
     a.employee_id as employee_id_1,
     a.start_time as start_time_1,
     a.end_time as end_time_1,
     a.rnk as rnk_1,
     b.employee_id as employee_id_2,
     b.start_time as start_time_2,
     b.end_time as end_time_2,
     b.rnk as rnk_2
FROM
    CTE a JOIN CTE b
ON
    a.employee_id = b.employee_id
AND
    a.end_time > b.start_time 
    
    AND a.employee_id = b.employee_id
    AND a.rnk < b.rnk
WHERE
     a.start_time !=  b.start_time 
  

) temp
GROUP BY
    employee_id_1

