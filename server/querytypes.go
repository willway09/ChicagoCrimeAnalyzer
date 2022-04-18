package main

type query1Parameters struct {
	CommunityArea int64
	BeginMonthIdx int64
	EndMonthIdx int64
}

type query1Result struct {
	Year int64
	Month int64
	PopulationDensity float64
	GeographicDensity float64
}

type query2Parameters struct {
	BeginMonthIdx int64
	EndMonthIdx int64
	CrimeRate float64
}

type query2Result struct {
	Year int64
	Month int64
	Counts int64
}

type query3Parameters struct {
	IUCRs []string
	NIBRSs []string
	Month int64
	Year int64
}

type query3Result struct {
	Year int64
	Count int64
}

type query4Parameters struct {
	BeginMonthIdx int64
	EndMonthIdx int64
	Latitude1 float64
	Latitude2 float64
	Longitude1 float64
	Longitude2 float64
}

type query4Result struct {
	Year int64
	Month int64
	NorthCounts int64
	SouthCounts int64
	EastCounts int64
	WestCounts int64
}

type noParameters struct {

}

type communityAreasResult struct {
	ID int64
	Name string
}

type NIBRSResult struct {
	IUCR string
	Title string
}

type IUCRResult struct {
	NIBRS string
	Title string
}

type bordersResult struct {
	From int64
	To int64
}

type monthrangeResult struct {
	Min int64
	Max int64
}
