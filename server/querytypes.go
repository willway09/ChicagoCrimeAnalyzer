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
	CrimeRate float64
	BeginMonthIdx int64
	EndMonthIdx int64
}

type query2Result struct {
	Year int64
	Month int64
	Counts int64
}

type query3Parameters struct {
	IUCRs []string
	NIBRSs []string
	BeginYear int64
	EndYear int64
	MonthIUCR int64
	MonthNIBRS int64
}

type query3Result struct {
	Year int64
	Count int64
	Code string
	CodeType string
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

type query5Parameters struct {
	CommunityArea int64
	BeginMonthIdx int64
	EndMonthIdx int64
}

type query5Result struct {
	Year int64
	Month int64
	PopulationDensity float64
	NeighborPopulationDensity float64
}

type noParameters struct {

}

type communityAreasResult struct {
	ID int64
	Name string
}

type NIBRSResult struct {
	NIBRS string
	Title string
}

type IUCRResult struct {
	IUCR string
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
