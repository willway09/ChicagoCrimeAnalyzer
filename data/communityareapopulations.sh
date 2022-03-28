wget "https://www.cmap.illinois.gov/documents/10180/126764/_Combined_AllCCAs.pdf/" -O - 2>/dev/null \
	| pdftotext - - \
	| grep -A 11 "General Population Characteristics, 2020" \
	| grep -v -E "(General Population|City of Chicago|CMAP Region)" \
	| sed "s/,//g" \
	| tr "\\n" "," \
	| sed "s/,\+/,/g" \
	| sed "s/--,/\$/g" \
	| tr "$" "\\n" \
	| sed "s/,$//g" \
	| tee "../datasources/CommunityAreaPopulations.csv"

	#| awk 'BEGIN {FS = ","}; { print $1,$2,$3,$4,$5 }' \
