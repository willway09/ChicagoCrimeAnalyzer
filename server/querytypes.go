package main

type query1Parameters struct {
	LakeOrder int64
}

type query1Result struct {
	Name string
}

type query2Parameters struct {
	MinLen float64
	NameLike string
}

type query2Result struct {
	Name string
	Lenght float64
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
	NIBRS string
	Title string
}
