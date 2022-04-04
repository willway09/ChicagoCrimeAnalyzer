WITH Months AS (
    SELECT DISTINCT Year, Month FROM CrimesBreakout
), NorthEast AS (
    SELECT Year, Month, COUNT(ID) AS NorthEastTotal FROM CrimesBreakout
    WHERE Latitude > :y AND Longitude > :x
    GROUP BY Year, Month
), NorthEastComplete AS (
    SELECT Year, Month, NorthEastTotal FROM NorthEast
    UNION
    SELECT Year, Month, 0 AS NorthEastTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM NorthEast)
),

NorthWest AS (
    SELECT Year, Month, COUNT(ID) AS NorthWestTotal FROM CrimesBreakout
    WHERE Latitude > :y AND Longitude < :x
    GROUP BY Year, Month
), NorthWestComplete AS (
    SELECT Year, Month, NorthWestTotal FROM NorthWest
    UNION
    SELECT Year, Month, 0 AS NorthWestTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM NorthWest)
),

SouthEast AS (
    SELECT Year, Month, COUNT(ID) AS SouthEastTotal FROM CrimesBreakout
    WHERE Latitude < :y AND Longitude > :x
    GROUP BY Year, Month
), SouthEastComplete AS (
    SELECT Year, Month, SouthEastTotal FROM SouthEast
    UNION
    SELECT Year, Month, 0 AS SouthEastTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM SouthEast)
),

SouthWest AS (
    SELECT Year, Month, COUNT(ID) AS SouthWestTotal FROM CrimesBreakout
    WHERE Latitude < :y AND Longitude < :x
    GROUP BY Year, Month
), SouthWestComplete AS (
    SELECT Year, Month, SouthWestTotal FROM SouthWest
    UNION
    SELECT Year, Month, 0 AS SouthWestTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM SouthWest)
)

SELECT * FROM NorthEastComplete NATURAL JOIN NorthWestComplete NATURAL JOIN SouthEastComplete NATURAL JOIN SouthWestComplete;

--SELECT MIN(Latitude), MAX(Latitude), MIN(Longitude), MAX(Longitude) FROM CrimesBreakout;
