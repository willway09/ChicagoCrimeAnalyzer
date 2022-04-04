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
