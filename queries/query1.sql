SELECT Year, Month, CommunityArea, COUNT(CommunityArea) FROM CrimesBreakout, 
GROUP BY Year, Month, CommunityArea, 
HAVING CommunityArea=35
ORDER BY Year, Month;
