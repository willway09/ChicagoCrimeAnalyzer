 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 WITH Counts AS (



)

OR NIBRS IN(:nibrs)




SELECT Year, Total FROM Counts
UNION
SELECT Year, 0 AS Total FROM CrimesBreakout
WHERE Year NOT IN (SELECT Year FROM Counts)
AND Year >= :year
ORDER BY Year;


SELECT Year, COUNT(ID) as Total, IUCR AS Code FROM CrimesBreakout
WHERE IUCR IN (:iucr)
GROUP BY Year, Month, IUCR
--HAVING Month = :month 
--AND Year >= :begin1 AND Year <= :end1;
;

SELECT * FROM CrimesBreakout WHERE IUCR = '0110';
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 











WITH Months AS (
    SELECT DISTINCT Year, Month, MonthIdx FROM CrimesBreakout
    WHERE MonthIdx >= :begin AND MonthIdx <= :end
), North AS (
    SELECT Year, Month, COUNT(ID) AS NorthTotal FROM CrimesBreakout
    WHERE Latitude > :y
    AND Longitude > :x
    GROUP BY Year, Month, MonthIdx
    HAVING MonthIdx >= :begin AND MonthIdx <= :end
), NorthComplete AS (
    SELECT Year, Month, NorthTotal FROM North
    UNION
    SELECT Year, Month, 0 AS NorthTotal FROM Months
    WHERE (Year, Month) NOT IN (SELECT Year, Month FROM North)
)

SELECT Year, Month, NorthTotal, NorthTotal AS SouthTotal, NorthTotal AS EastTotal, NorthTotal AS WestTotal
FROM NorthComplete
ORDER BY Year, Month;

SELECT 1 FROM DUAL;

SELECT * FROM CrimesBreakout
WHERE Year >=2021
AND Latitude IS NOT NULL
ORDER BY Latitude DESC
FETCH FIRST 10 ROWS ONLY;


SELECT * FROM Temp1;

CREATE TABLE Temp2 (B VARCHAR(10), A INTEGER);

SELECT * FROM Temp1;
SELECT * FROM Temp2;

SELECT Temp1.A, COUNT(B) FROM Temp1 LEFT OUTER JOIN Temp2 ON Temp1.A = Temp2.A
GROUP BY Temp1.A;


SELECT * FROM Temp1 LEFT OUTER JOIN Temp2 ON Temp1.A = Temp2.A;

