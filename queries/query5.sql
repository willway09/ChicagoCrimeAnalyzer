WITH AreaDensity AS (
    SELECT Year, Month, 100000 * CrimeCount / Population AS PopulationDensity
    FROM CrimeDensities
    WHERE CommunityArea = :commarea
    AND MonthIdx >= :begin AND MonthIdx <= :end
),

Neighbors AS (
    SELECT CommunityAreaTo AS CommunityArea FROM Borders
    WHERE CommunityAreaFrom <> CommunityAreaTo
    AND CommunityAreaFrom = :commarea
),

NeighborStats AS (
    SELECT * FROM CrimeDensities NATURAL JOIN Neighbors
),

NeighborDensity AS (
    SELECT Year, Month, 100000 * SUM(CrimeCount) / SUM(Population) AS NeighborPopulationDensity
    FROM NeighborStats
    GROUP BY Year, Month
)

SELECT * FROM AreaDensity NATURAL JOIN NeighborDensity
ORDER BY Year, Month;