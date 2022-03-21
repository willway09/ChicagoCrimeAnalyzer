library(sf)
data=read.csv("../datasources/CommunityAreaShapes.csv");

#dir.create("../datasources/shapefiles")

for(i in 1:length(data$the_geom)) {
	#file = file(sprintf("../datasources/shapefiles/%d.shp", data$AREA_NUMBE[i]))
	#writeLines(data$the_geom[1], file)
	#close(file)
	str(st_as_sfc(data$the_geom[1]));
	break;
}
