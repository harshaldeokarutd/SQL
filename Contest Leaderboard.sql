SELECT A.hacker_id,
       B.name,
       A.max_score
FROM   (SELECT Sum(max) AS max_score,
               hacker_id
        FROM   (SELECT Max(score) AS max,
                       hacker_id,
                       challenge_id
                FROM   submissions
                GROUP  BY hacker_id,
                          challenge_id) t
        GROUP  BY t.hacker_id) A,
       (SELECT name,
               hacker_id
        FROM   hackers) B
WHERE  A.hacker_id = B.hacker_id
       AND A.max_score != 0
ORDER  BY A.max_score DESC,
          A.hacker_id ASC 
