library(sf)

plotAreas = function() {
	data=read.csv("../datasources/CommunityAreaShapes.csv")

	svg("../website/Images/map.svg")

	chicago = st_as_sfc(data$the_geom[1])
	for(i in 2:length(data$the_geom)) {
		chicago = st_union(chicago, st_as_sfc(data$the_geom[i]))
	}

	plot(chicago)

	for(i in 1:length(data$the_geom)) {
		for(j in 1:length(data$the_geom)) {
			if(data$AREA_NUMBE[j] == i) {
				points = st_as_sfc(data$the_geom[j])[[1]][1][[1]][[1]]
				centroid = st_centroid(st_as_sfc(data$the_geom[j]))
				xavg = centroid[[1]][[1]]
				yavg = centroid[[1]][[2]]
				plot(st_as_sfc(data$the_geom[j]), add=TRUE, border=rgb((10 +  i) / 255, (10 +  i) / 255, (10 +  i) / 255))
				text(xavg, yavg, sprintf("%d", i), cex=.5)
			}
		}
	}

	dev.off()
}
