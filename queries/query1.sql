WITH Temp(Area) AS (    
    SELECT Area FROM Lake 
    ORDER BY Area DESC
    FETCH NEXT :col ROWS ONLY
), Temp2(AREA) AS (
    SELECT MIN(Area) AS Area FROM Temp
)
SELECT DISTINCT Country.Name FROM Country, Lake, geo_Lake, Temp2
    WHERE Lake.Area IN Temp2.Area 
        AND Country.Code=geo_Lake.Country
	    AND Lake.Name=geo_Lake.Lake;

