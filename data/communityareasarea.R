data=read.csv("../datasources/CommunityAreaShapes.csv");
data=list(area_number=data$AREA_NUMBE,area=data$SHAPE_AREA);

f = file("communityareasarea.sql");

output = c()

for(i in 1:length(data$area_number)) {

	output = c(output, (sprintf(
		"UPDATE CommunityAreas SET Area=%f WHERE ID=%g;",
		data$area[i] * 9.2903e-8, data$area_number[i]
	)));
}
output = c(output, "ALTER TABLE CommunityAreas MODIFY Area REAL NOT NULL;");
writeLines(output, f);
close(f);
