SELECT River.name AS name, River.length AS length FROM River, geo_River
    WHERE River.Name=geo_River.River
    AND River.length > :a 
    AND River.Name LIKE :b
    GROUP BY River.Name, River.length
    ORDER BY River.length;
