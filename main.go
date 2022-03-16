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

	var parameters query2Parameters
	parameters.MinLen = 3000
	parameters.NameLike = "M%"

	result := runQuery[query2Result](db, "queries/query2.sql", parameters)

	fmt.Println(result)

	db.Close()
}
