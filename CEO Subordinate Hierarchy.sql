WITH RECURSIVE hierarchy AS (

    SELECT
        employee_id,
        employee_name,
        manager_id,
        salary,
        0 AS hierarchy_level,
        salary AS ceo_salary
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        h.hierarchy_level + 1,
        h.ceo_salary
    FROM Employees e
    JOIN hierarchy h
        ON e.manager_id = h.employee_id
)

SELECT 
      employee_id as subordinate_id,
      employee_name as subordinate_name,
      hierarchy_level,
      salary - ceo_salary as salary_difference 
FROM
     hierarchy
WHERE 
    hierarchy_level != 0
ORDER BY 
    hierarchy_level asc, subordinate_id asc