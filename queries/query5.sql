WITH AreaCounts AS (
SELECT Decade, Year, Month, COUNT(ID) AS CrimeCount, CommunityArea
FROM CrimesBreakout
GROUP BY Decade, Year, Month, CommunityArea
HAVING CommunityArea = :commarea
ORDER BY Year ASC, Month ASC
),
AreaDensity AS (
SELECT AreaCounts.Year AS Year, AreaCounts.Month AS Month, CrimeCount /
(((b.Population - a.Population) / (b.Year - a.year)) * ((AreaCounts.Year + AreaCounts.Month / 12 - a.Year)) + a.Population) AS PopulationDensity
FROM AreaCounts, CommunityAreaPopulations a, CommunityAreaPopulations b, CommunityAreas
WHERE a.NextYear = b.Year
AND a.CommunityArea = b.CommunityArea
AND AreaCounts.CommunityArea = a.CommunityArea
AND a.Year = AreaCounts.Decade
AND CommunityAreas.ID=a.CommunityArea
AND AreaCounts.Decade < 2020

UNION

SELECT AreaCounts.Year AS Year, AreaCounts.Month AS Month, CrimeCount / (a.Population) AS PopulationDensity
FROM AreaCounts, CommunityAreaPopulations a, CommunityAreas
WHERE AreaCounts.CommunityArea = a.CommunityArea
AND a.Year = AreaCounts.Decade
AND CommunityAreas.ID=a.CommunityArea
AND AreaCounts.Decade = 2020
),

Neighbors AS (
    SELECT CommunityAreaTo FROM Borders
    WHERE CommunityAreaFrom <> CommunityAreaTo
    AND CommunityAreaFrom = :commarea
),

NeighborCounts AS (
SELECT Decade, Year, Month, COUNT(ID) AS CrimeCount
FROM CrimesBreakout
WHERE CommunityArea IN (
   SELECT * FROM Neighbors
)
GROUP BY Decade, Year, Month

ORDER BY Year ASC, Month ASC
),
NeighborPopulations AS (
    SELECT Year, NextYear, SUM(Population) AS Population FROM CommunityAreas, CommunityAreaPopulations
    WHERE ID = CommunityArea 
    AND ID IN (SELECT * FROM Neighbors)
    GROUP BY Year, NextYear
),
NeighborDensity AS (
SELECT NeighborCounts.Year AS Year, NeighborCounts.Month AS Month, CrimeCount /
(((b.Population - a.Population) / (b.Year - a.year)) * ((NeighborCounts.Year + NeighborCounts.Month / 12 - a.Year)) + a.Population) AS NeighborPopulationDensity
FROM NeighborCounts, NeighborPopulations a, NeighborPopulations b, CommunityAreas
WHERE a.NextYear = b.Year
AND a.Year = NeighborCounts.Decade
AND NeighborCounts.Decade < 2020

UNION

SELECT NeighborCounts.Year AS Year, NeighborCounts.Month AS Month, CrimeCount / (a.Population) AS NeighborPopulationDensity
FROM NeighborCounts, NeighborPopulations a, CommunityAreas
WHERE a.Year = NeighborCounts.Decade
AND NeighborCounts.Decade = 2020
)

SELECT * FROM AreaDensity NATURAL JOIN NeighborDensity;
