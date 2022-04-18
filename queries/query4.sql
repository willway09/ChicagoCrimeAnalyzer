WITH Months AS (
    SELECT DISTINCT Year, Month, MonthIdx FROM CrimesBreakout
    WHERE MonthIdx >= :begin AND MonthIdx <= :end
), 

Lon AS (
    SELECT :x FROM DUAL
),
Lat AS (
    SELECT :y FROM DUAL
),

NorthCrimes AS (
    SELECT ID, MonthIdx FROM CrimesBreakout
    WHERE Latitude > ALL (SELECT * FROM Lat)
), North AS (
    SELECT Year, Month, COUNT(ID) AS NorthTotal FROM NorthCrimes 
    RIGHT OUTER JOIN Months ON NorthCrimes.MonthIdx = Months.MonthIdx
    GROUP BY Year, Month, Months.MonthIdx
),

SouthCrimes AS (
    SELECT ID, MonthIdx FROM CrimesBreakout
    WHERE Latitude < ALL (SELECT * FROM Lat)
), South AS (
    SELECT Year, Month, COUNT(ID) AS SouthTotal FROM SouthCrimes 
    RIGHT OUTER JOIN Months ON SouthCrimes.MonthIdx = Months.MonthIdx
    GROUP BY Year, Month, Months.MonthIdx
),

EastCrimes AS (
    SELECT ID, MonthIdx FROM CrimesBreakout
    WHERE Longitude > ALL (SELECT * FROM Lon)
), East AS (
    SELECT Year, Month, COUNT(ID) AS EastTotal FROM EastCrimes 
    RIGHT OUTER JOIN Months ON EastCrimes.MonthIdx = Months.MonthIdx
    GROUP BY Year, Month, Months.MonthIdx
),

WestCrimes AS (
    SELECT ID, MonthIdx FROM CrimesBreakout
    WHERE Longitude < ALL (SELECT * FROM Lon)
), West AS (
    SELECT Year, Month, COUNT(ID) AS WestTotal FROM WestCrimes 
    RIGHT OUTER JOIN Months ON WestCrimes.MonthIdx = Months.MonthIdx
    GROUP BY Year, Month, Months.MonthIdx
)

SELECT * FROM North NATURAL JOIN South NATURAL JOIN East NATURAL JOIN West
ORDER BY Year, Month;
