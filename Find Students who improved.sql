WITH CTE as (
    SELECT
         student_id,
         subject,
         score,
         first_value(score) OVER (PARTITION BY student_id, subject ORDER BY exam_date asc) as first_score,
         last_value(score) OVER (PARTITION BY student_id, subject ORDER BY exam_date asc) as latest_score,
         ROW_NUMBER() OVER (PARTITION BY student_id, subject ORDER BY exam_date asc) as rnk,
         exam_date 
    FROM
        Scores 
)

SELECT 
      student_id,
      subject,
      first_score,
      latest_score
FROM (
SELECT 
     student_id,
     subject,
     score,
     first_score,
     latest_score,
     rnk,
     MAX(rnk) OVER (PARTITION BY student_id, subject) as max_rnk,
     exam_date
FROM
     CTE ) temp 
WHERE
   max_rnk = rnk and first_score < latest_score