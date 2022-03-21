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

type IUCRCrime struct {
	Code, PrimaryDesc, SecondaryDesc, IndexCode string
	Active int
}

func main() {
	file, err := os.Open("../datasources/IUCRCodes.csv")
	handleError(err)
	output, err := os.Create("IUCR.sql");
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

		if(len(record[0]) == 3) {
			record[0] = "0" + record[0]
		}
		record[2] = prepareString(record[2])

		active := strToBool(record[4])

		fmt.Fprintf(output, "\tINTO IUCRCrimes (IUCR, PrimaryDesc, SecondaryDesc, IndexCode, Active) VALUES(q'[%s]', q'[%s]', q'[%s]', q'[%s]', %d)\n",
			record[0], record[1], record[2], record[3], active)
	}

	fmt.Fprintln(output, "SELECT 1 FROM Dual;");

	file.Close()
	output.Close();
}
