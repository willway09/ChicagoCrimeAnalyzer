DROP VIEW CrimesBreakout;
CREATE VIEW CrimesBreakout AS
SElECT
	ID,
	EXTRACT(YEAR FROM CrimeDate) AS Year,
	EXTRACT(MONTH FROM CrimeDate) - 1 AS Month,
	12 * EXTRACT(YEAR FROM CrimeDate) + (EXTRACT(MONTH FROM CrimeDate) - 1) AS MonthIdx,
	FLOOR(((EXTRACT(MONTH FROM CrimeDate) - 1)/ 3)) AS Quarter,
	FLOOR(EXTRACT(YEAR FROM CrimeDate) / 10) * 10 AS Decade,
	CommunityArea,
	IUCR,
	NIBRS,
	Latitude,
	Longitude
FROM Crimes;

DROP VIEW AllMonthIdx;
CREATE VIEW AllMonthIdx AS
    SELECT DISTINCT MonthIdx FROM CrimesBreakout;

DROP VIEW AllMonths;
CREATE VIEW AllMonths AS
    SELECT FLOOR(MonthIdx / 120) * 10 AS Decade, FLOOR(MonthIdx / 12) AS Year,
    FLOOR(MOD(MonthIdx, 12) / 3) AS Quarter, MOD(MonthIdx, 12) AS Month, MonthIdx
    FROM AllMonthIdx;


DROP VIEW CrimeDensities;
CREATE VIEW CrimeDensities AS
WITH AreaMonths AS (
    SELECT Decade, Year, Quarter, Month, MonthIdx, ID AS CommunityArea
    FROM AllMonths, CommunityAreas
),
CrimeMonths AS (
    SELECT ID, MonthIdx, CommunityArea FROM CrimesBreakout
),
CrimeCounts AS (
    SELECT Decade, Year, Month, AreaMonths.MonthIdx AS MonthIdx,
    COUNT(ID) AS CrimeCount, AreaMonths.CommunityArea AS CommunityArea
    FROM CrimeMonths RIGHT OUTER JOIN AreaMonths
    ON CrimeMonths.MonthIdx = AreaMonths.MonthIdx
    AND CrimeMonths.CommunityArea = AreaMonths.CommunityArea
    GROUP BY Decade, Year, Month, AreaMonths.MonthIdx, AreaMonths.CommunityArea
)

SELECT CrimeCounts.Year AS Year, CrimeCounts.Month AS Month, CrimeCounts.Decade AS Decade,
CrimeCounts.MonthIdx AS MonthIdx,
CrimeCount,
(((b.Population - a.Population) / (b.Year - a.year)) * ((CrimeCounts.Year + CrimeCounts.Month / 12 - a.Year)) + a.Population) AS Population,
Area,
CrimeCounts.CommunityArea AS CommunityArea
FROM CrimeCounts, CommunityAreaPopulations a, CommunityAreaPopulations b, CommunityAreas
WHERE a.NextYear = b.Year
AND a.CommunityArea = b.CommunityArea
AND CrimeCounts.CommunityArea = a.CommunityArea
AND a.Year = CrimeCounts.Decade
AND CommunityAreas.ID=a.CommunityArea;