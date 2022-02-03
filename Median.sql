SELECT Round(t.lat_n, 4)
FROM   (SELECT lat_n,
               Row_number()
                 OVER (
                   ORDER BY lat_n) test
        FROM   station) t
WHERE  t.test IN (SELECT CASE
                           WHEN Count(lat_n)%2 = 0 THEN Count(lat_n) / 2
                           ELSE ( Count(lat_n) + 1 ) / 2
                         END AS yt
                  FROM   station); 
