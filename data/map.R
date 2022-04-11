library(sf)

plotAreas = function() {
	data=read.csv("../datasources/CommunityAreaShapes.csv")

	svg("../website/Images/map.svg")

	chicago = st_as_sfc(data$the_geom[1])
	for(i in 2:length(data$the_geom)) {
		chicago = st_union(chicago, st_as_sfc(data$the_geom[i]))
	}

	minX = min(chicago[[1]][[1]][[1]][,1])
	maxX = max(chicago[[1]][[1]][[1]][,1])
	minY = min(chicago[[1]][[1]][[1]][,2])
	maxY = max(chicago[[1]][[1]][[1]][,2])

	margin = -.013

	a = seq(from=minX,to=maxX,by=.01)

	par(mar=c(0,0,0,0), bg="#242728")
	plot(chicago, 
		xlim=c(minX-margin,maxX+margin),ylim=c(minY-margin,maxY+margin))
	#plot(chicago, xlim=c(1,2),ylim=c(1,2))
	#axis(2,at=a,labels=a)

	for(i in 1:length(data$the_geom)) {
		for(j in 1:length(data$the_geom)) {
			if(data$AREA_NUMBE[j] == i) {
				points = st_as_sfc(data$the_geom[j])[[1]][1][[1]][[1]]
				centroid = st_centroid(st_as_sfc(data$the_geom[j]))
				xavg = centroid[[1]][[1]]
				yavg = centroid[[1]][[2]]
				plot(st_as_sfc(data$the_geom[j]), add=TRUE, border=rgb((10 +  i) / 255, 50/255, (10 +  i) / 255))
					#xlim=c(minX-margin,maxX+margin),ylim=c(minY-margin,maxY+margin))
				text(xavg, yavg, sprintf("%d", i), cex=.5, col="#e8e6e3")
			}
		}
	}

	dev.off()
}
