package main

import (
	"encoding/csv"
	"fmt"
	"os"
)

func handleError(err error) {
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
}

func main() {
	file, err := os.Open("../datasources/Borders.csv")
	handleError(err)
	output, err := os.Create("borders.sql");
	handleError(err);

	fmt.Fprintln(output, "SET DEFINE OFF;"); //Allow for insertion of ampersand
	fmt.Fprintln(output, "INSERT ALL");

	reader := csv.NewReader(file)

	readHeader := false;
	for {
		record, err := reader.Read()
		if err != nil {
			break
		}

		if(!readHeader) {
			readHeader = true
			continue
		}

		fmt.Fprintf(output, "\tINTO Borders (CommunityAreaFrom, CommunityAreaTo) VALUES(%s, %s)\n",
			record[1], record[2])
	}

	fmt.Fprintln(output, "SELECT 1 FROM Dual;");

	file.Close()
	output.Close();
}
