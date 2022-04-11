WITH Counts AS (


SELECT Year, COUNT(ID) as Total, IUCR AS Code FROM CrimesBreakout
WHERE IUCR IN (:iucr)
GROUP BY Year, Month
HAVING Month = :month AND Year >= :year
)

OR NIBRS IN(:nibrs)




SELECT Year, Total FROM Counts
UNION
SELECT Year, 0 AS Total FROM CrimesBreakout
WHERE Year NOT IN (SELECT Year FROM Counts)
AND Year >= :year
ORDER BY Year;