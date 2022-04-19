WITH Filtered AS (
    SELECT MonthIdx, CommunityArea FROM CrimeDensities
    WHERE 100000 * CrimeCount / Population > :threshold
)

SELECT Month, Year, COUNT(CommunityArea) AS Counts
FROM Filtered RIGHT OUTER JOIN AllMonths
ON Filtered.MonthIdx = AllMonths.MonthIdx
GROUP BY Month, Year, AllMonths.MonthIdx
HAVING AllMonths.MonthIdx >= :begin
AND AllMonths.MonthIdx <= :end
ORDER BY Year, Month;