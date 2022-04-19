package main

import (
	"fmt"
)

type Test struct {
	Name string
	Values []string
	Num int64
}

func main() {
	db := openDatabase()

	/*var test Test
	test.Name = "Will"
	test.Values = []string{"a","b","c"}
	test.Num = int64(55)

	fmt.Println(getParametersArray(test))*/

	/*var parameters query1Parameters
	parameters.LakeOrder = 3

	result := runQuery[query1Result](db, "queries/query1.sql", parameters)

	fmt.Println(result)*/

	var parameters query3Parameters
	parameters.IUCRs = []string{"500N", "0452"}
	parameters.NIBRSs = []string{"12"}
	parameters.MonthIUCR = 9;
	parameters.MonthNIBRS = 9;
	parameters.BeginYear = 2001;
	parameters.EndYear = 2022;

	result := runQuery[query3Result](db, "../queries/query3.sql", parameters)

	fmt.Println(result)

	db.Close()
}
