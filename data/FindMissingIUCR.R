convert = function(l) {
	rtn = c()
	for(i in 1:length(l)) {
		if(nchar(l[i]) == 3) {
			rtn = c(rtn, sprintf("0%s",l[i]))
		} else {
			rtn = c(rtn, l[i])
		}
	}
	return(rtn)
}

#Outside run data=read.csv("../datasources/Crimes.csv");
#Outside run iucr=read.csv("../datasources/IUCRCodes.csv");
getmissingcodes = function(data, iucr) {
	db = unique(data$IUCR)
	known = convert(unique(iucr$IUCR))
	missing = setdiff(db, known)

	addIUCR = data$IUCR[data$IUCR %in% missing]
	addPrimary = data$Primary.Type[data$IUCR %in% missing]
	addSecondary = data$Description[data$IUCR %in% missing]

	temp = data.frame(IUCR=addIUCR, PrimaryDesc=addPrimary, SecondaryDesc=addSecondary);

	outIUCR = c()
	outPrimary = c()
	outSecondary = c()

	for(i in 1:length(temp$IUCR)) {
		if(temp$IUCR[i] %in% missing) {
			outIUCR = c(outIUCR, temp$IUCR[i])
			outPrimary = c(outPrimary, temp$Primary[i])
			outSecondary = c(outSecondary, temp$Secondary[i])
			missing = setdiff(missing, temp$IUCR[i])
		}
	}

	out = data.frame(IUCR=outIUCR, PrimaryDesc=outPrimary, SecondaryDesc=outSecondary);

	write.csv(out, "../datasources/IUCRCodesMissing.csv")
}
