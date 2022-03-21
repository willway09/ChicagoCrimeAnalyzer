DROP VIEW CrimesBreakout;
CREATE VIEW CrimesBreakout AS
SElECT 
	EXTRACT(YEAR FROM CrimeDate) AS Year,
	EXTRACT(MONTH FROM CrimeDate) - 1 AS Month,
	12 * EXTRACT(YEAR FROM CrimeDate) + (EXTRACT(MONTH FROM CrimeDate) - 1) AS MonthIdx,
	FLOOR(((EXTRACT(MONTH FROM CrimeDate) - 1)/ 3)) AS Quarter,
	CommunityArea
 FROM Crimes;
