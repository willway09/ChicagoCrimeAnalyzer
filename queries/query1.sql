SELECT Year, Month, 100000 * CrimeCount / Population AS PopulationDensity, CrimeCount / Area AS GeographicDensity 
FROM CrimeDensities
WHERE CommunityArea = :communityarea
AND MonthIdx >= :begin AND MonthIdx <= :end
ORDER BY MonthIdx;