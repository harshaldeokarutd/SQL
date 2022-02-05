SELECT CASE
         WHEN ms.grade < 8 THEN NULL
         ELSE st.name
       end,
       ms.grade,
       st.marks
FROM   (SELECT name,
               marks,
               CASE
                 WHEN marks >= 0
                      AND marks < 10 THEN 1
                 WHEN marks >= 10
                      AND marks < 20 THEN 2
                 WHEN marks >= 20
                      AND marks < 30 THEN 3
                 WHEN marks >= 30
                      AND marks < 40 THEN 4
                 WHEN marks >= 40
                      AND marks < 50 THEN 5
                 WHEN marks >= 50
                      AND marks < 60 THEN 6
                 WHEN marks >= 60
                      AND marks < 70 THEN 7
                 WHEN marks >= 70
                      AND marks < 80 THEN 8
                 WHEN marks >= 80
                      AND marks < 90 THEN 9
                 ELSE 10
               end AS test
        FROM   students) st,
       (SELECT grade
        FROM   grades) ms
WHERE  st.test = ms.grade
ORDER  BY ms.grade DESC,
          st.name ASC; 
