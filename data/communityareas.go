package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

func handleError(err error) {
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
}


type CommunityArea struct {
	Name string
	ID int
	Year int
	Population int
	Households string
	NextYear int
}

func main() {
	file, err := os.Open("../datasources/CommunityAreas.csv")
	handleError(err)
	areaOutput, err := os.Create("communityareas.sql");
	handleError(err);

	popOutput, err := os.Create("communityareapopulations.sql");
	handleError(err);

	fmt.Fprintln(areaOutput, "SET DEFINE OFF;"); //Allow for insertion of ampersand
	fmt.Fprintln(areaOutput, "INSERT ALL");

	fmt.Fprintln(popOutput, "SET DEFINE OFF;"); //Allow for insertion of ampersand
	fmt.Fprintln(popOutput, "INSERT ALL");

	reader := csv.NewReader(file)

	readHeader := false;

	visited := make(map[int]bool)

	for {
		record, err := reader.Read()
		if err != nil {
			break
		}

		if(!readHeader) {
			readHeader = true
			continue
		}

		var area CommunityArea

		area.Name = record[0]
		area.ID, err = strconv.Atoi(record[2])
		handleError(err)
		area.Year, err = strconv.Atoi(record[3])
		handleError(err)
		area.Population, err = strconv.Atoi(record[4])
		handleError(err)
		if(record[5] != "") {
			area.Households = record[5]
		} else {
			area.Households = "NULL"
		}

		if(area.Year == 2020) {
			area.NextYear = area.Year
		} else {
			area.NextYear = area.Year + 10
		}

		_, ok := visited[area.ID]

		if(!ok) {
			fmt.Fprintf(areaOutput, "\tINTO CommunityAreas (ID, Name) VALUES(%d, q'[%s]')\n",
				area.ID, area.Name)
			visited[area.ID] = true;
		}
		fmt.Fprintf(popOutput, "\tINTO CommunityAreaPopulations (CommunityArea, Year, Population, Households, NextYear) VALUES(%d, %d, %d, %s, %d)\n",
			area.ID, area.Year, area.Population, area.Households, area.NextYear)
	}

	fmt.Fprintln(areaOutput, "SELECT 1 FROM Dual;");
	fmt.Fprintln(popOutput, "SELECT 1 FROM Dual;");

	file.Close()
	areaOutput.Close();
	popOutput.Close();
}
