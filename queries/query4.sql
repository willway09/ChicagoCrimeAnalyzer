WITH Months AS (
    SELECT DISTINCT Year, Month FROM CrimesBreakout
), North AS (
    SELECT Year, Month, COUNT(ID) AS NorthTotal FROM CrimesBreakout
    WHERE Latitude > :y
    GROUP BY Year, Month
), NorthComplete AS (
    SELECT Year, Month, NorthTotal FROM North
    UNION
    SELECT Year, Month, 0 AS NorthTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM North)
),

South AS (
    SELECT Year, Month, COUNT(ID) AS SouthTotal FROM CrimesBreakout
    WHERE Latitude < :y
    GROUP BY Year, Month
), SouthComplete AS (
    SELECT Year, Month, SouthTotal FROM South
    UNION
    SELECT Year, Month, 0 AS SouthTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM South)
),

East AS (
    SELECT Year, Month, COUNT(ID) AS EastTotal FROM CrimesBreakout
    WHERE Longitude > :x
    GROUP BY Year, Month
), EastComplete AS (
    SELECT Year, Month, EastTotal FROM East
    UNION
    SELECT Year, Month, 0 AS EastTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM East)
),

West AS (
    SELECT Year, Month, COUNT(ID) AS WestTotal FROM CrimesBreakout
    WHERE Longitude < :x
    GROUP BY Year, Month
), WestComplete AS (
    SELECT Year, Month, WestTotal FROM West
    UNION
    SELECT Year, Month, 0 AS WestTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM West)
)

SELECT * FROM NorthComplete NATURAL JOIN SouthComplete NATURAL JOIN EastComplete NATURAL JOIN WestComplete
ORDER BY Year, Month;
