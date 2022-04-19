WITH AllYears AS (
    SELECT DISTINCT Year FROM CrimesBreakout
    WHERE Year >= :begin AND Year <= :end
),
IUCRList AS (
    SELECT DISTINCT IUCR FROM IUCRCrimes
    WHERE IUCR IN (:iucrs)
),

IUCRNonZero AS (
    SELECT Year, IUCR, ID FROM CrimesBreakout
    WHERE Month=:monthiucr
),
IUCR AS (
    SELECT A.Year, COUNT(ID) AS Counts, A.IUCR AS Code, 'IUCR' AS CodeType FROM IUCRNonZero
    RIGHT OUTER JOIN (SELECT * FROM AllYears, IUCRList) A
    ON IUCRNonZero.Year = A.Year
    AND IUCRNonZero.IUCR = A.IUCR
    GROUP BY A.Year, A.IUCR
    ORDER BY Year
),
NIBRSList AS (
    SELECT DISTINCT NIBRS FROM NIBRSCrimes
    WHERE NIBRS IN (:nibrss)
),

NIBRSNonZero AS (
    SELECT Year, NIBRS, ID FROM CrimesBreakout
    WHERE Month=:monthnibrs
),
NIBRS AS (
    SELECT A.Year, COUNT(ID) AS Counts, A.NIBRS AS Code, 'NIBRS' AS CodeType FROM NIBRSNonZero
    RIGHT OUTER JOIN (SELECT * FROM AllYears, NIBRSList) A
    ON NIBRSNonZero.Year = A.Year
    AND NIBRSNonZero.NIBRS = A.NIBRS
    GROUP BY A.Year, A.NIBRS
    ORDER BY Year
)

SELECT * FROM IUCR

UNION

SELECT * FROM NIBRS;