WITH Counts AS (
SELECT Decade, Year, Month, COUNT(ID) AS CrimeCount, CommunityArea
FROM CrimesBreakout
GROUP BY Decade, Year, Month, MonthIdx, CommunityArea
HAVING CommunityArea = :commarea
AND MonthIdx >= :begin AND MonthIdx <= :end
ORDER BY Year ASC, Month ASC
)
SELECT Counts.Year AS Year, Counts.Month AS Month, CrimeCount /
(((b.Population - a.Population) / (b.Year - a.year)) * ((Counts.Year + Counts.Month / 12 - a.Year)) + a.Population) AS PopulationDensity,
CrimeCount / Area AS GeographicDensity
FROM Counts, CommunityAreaPopulations a, CommunityAreaPopulations b, CommunityAreas
WHERE a.NextYear = b.Year
AND a.CommunityArea = b.CommunityArea
AND Counts.CommunityArea = a.CommunityArea
AND a.Year = Counts.Decade
AND CommunityAreas.ID=a.CommunityArea
AND Counts.Decade < 2020

UNION

SELECT Counts.Year AS Year, Counts.Month AS Month, CrimeCount / (a.Population) AS PopulationDensity,
CrimeCount / Area AS GeographicDensity
FROM Counts, CommunityAreaPopulations a, CommunityAreas
WHERE Counts.CommunityArea = a.CommunityArea
AND a.Year = Counts.Decade
AND CommunityAreas.ID=a.CommunityArea
AND Counts.Decade = 2020;