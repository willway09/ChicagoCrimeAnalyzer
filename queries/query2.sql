WITH Counts AS (
SELECT Decade, Year, Month, COUNT(ID) AS CrimeCount, CommunityArea
FROM CrimesBreakout
GROUP BY Decade, Year, Month, CommunityArea
ORDER BY Year ASC, Month ASC
),
Densities AS (
SELECT Counts.Year AS Year, Counts.Month AS Month, CrimeCount /
(((b.Population - a.Population) / (b.Year - a.year)) * ((Counts.Year + Counts.Month / 12 - a.Year)) + a.Population) AS PopulationDensity,
a.CommunityArea AS CommunityArea
FROM Counts, CommunityAreaPopulations a, CommunityAreaPopulations b
WHERE a.NextYear = b.Year
AND a.CommunityArea = b.CommunityArea
AND Counts.CommunityArea = a.CommunityArea
AND a.Year = Counts.Decade
AND Counts.Decade < 2020

UNION

SELECT Counts.Year AS Year, Counts.Month AS Month, CrimeCount / (a.Population) AS PopulationDensity,
a.CommunityArea AS CommunityArea
FROM Counts, CommunityAreaPopulations a
WHERE Counts.CommunityArea = a.CommunityArea
AND a.Year = Counts.Decade
AND Counts.Decade = 2020
),
PassingThreshold AS (
SELECT Year, Month, COUNT(CommunityArea) AS Counts FROM Densities
WHERE PopulationDensity > :threshold
GROUP BY Year, Month
)
SELECT Year, Month, Counts FROM PassingThreshold

UNION

SELECT Year, Month, 0 FROM Densities
WHERE (Year, Month) NOT IN (SELECT Year, Month FROM PassingThreshold);