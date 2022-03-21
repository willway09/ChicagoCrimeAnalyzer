library(sf)

getBorders = function() {
	data=read.csv("../datasources/CommunityAreaShapes.csv")

	areas = vector(length=length(data$the_geom))
	len = length(areas)

	for(i in 1:length(data$the_geom)) {
		areas[data$AREA_NUMBE[i]]  = st_as_sfc(data$the_geom[i])
	}

	from = c()
	to = c()

	for(i in 1:len) {
		for(j in 1:len) {

			if(j %% 10 == 0) {
				print(sprintf("i: %d j: %d", i, j))
			}

			fromMat = matrix(areas[i][[1]][[1]][[1]], ncol=2)
			toMat = matrix(areas[j][[1]][[1]][[1]], ncol=2)
			escape = F;

			for(fromIdx in 1:nrow(fromMat)) {
				for(toIdx in 1:nrow(toMat)) {
					if(toIdx == fromIdx) {
						next
					}
					if(fromMat[fromIdx,1] == toMat[toIdx,1] && fromMat[fromIdx,2] == toMat[toIdx,2]) {
						from = c(from, i)
						to = c(to, j)
						escape = T
						break;
					}
				}
				if(escape) break
			}
		}
	}

	borders = data.frame(from=from, to=to)

	write.csv(borders, "../datasources/Borders.csv")
}

removeSelfBorders = function() {
	data=read.csv("../datasources/Borders.csv")

	outFrom = c()
	outTo = c()

	head(data)

	for(i in 1:length(data$from)) {
		if(data$from[i] != data$to[i]) {
			outFrom = c(outFrom, data$from[i])
			outTo = c(outTo, data$to[i])
		}
	}
	write.csv(list(from=outFrom, to=outTo), "../datasources/asdf.csv")


	#data=read.csv("../datasources/Borders.csv")
}

plotAreas = function() {
	data=read.csv("../datasources/CommunityAreaShapes.csv")

	chicago = st_as_sfc(data$the_geom[1])
	for(i in 2:length(data$the_geom)) {
		chicago = st_union(chicago, st_as_sfc(data$the_geom[i]))
	}

	plot(chicago)

	#for(i in 1:length(data$the_geom)) {
		#plot(st_as_sfc(data$the_geom[i]))
	#}
}
