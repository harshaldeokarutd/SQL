WITH CTE AS (
    SELECT
        user_id1,
        user_id2
    FROM Friends

    UNION ALL

    SELECT
        user_id2,
        user_id1
    FROM Friends
)

SELECT
    f.user_id1,
    f.user_id2
FROM Friends f
WHERE NOT EXISTS (
    SELECT 1
    FROM CTE a
    JOIN CTE b
        ON a.user_id2 = b.user_id2
    WHERE a.user_id1 = f.user_id1
      AND b.user_id1 = f.user_id2
)
ORDER BY
    f.user_id1,
    f.user_id2;