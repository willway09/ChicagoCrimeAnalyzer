WITH Counts AS (
SELECT Year, COUNT(ID) as Total FROM CrimesBreakout
WHERE IUCR IN (:iucr)
OR NIBRS IN(:nibrs)
GROUP BY Year, Month
HAVING Month = :month AND Year >= :year
)
SELECT Year, Total FROM Counts
UNION
SELECT Year, 0 AS Total FROM CrimesBreakout
WHERE Year NOT IN (SELECT Year FROM Counts)
AND Year >= :year
ORDER BY Year;