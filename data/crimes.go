package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strings"
)

func handleError(err error) {
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
}

type IUCRCrime struct {
	Code, PrimaryDesc, SecondaryDesc, IndexCode string
	Active                                      int
}

func main() {
	file, err := os.Open("../datasources/Crimes.csv")
	handleError(err)
	output, err := os.Create("../datasources/CrimesTransformed.csv")
	handleError(err)

	fmt.Fprintln(output, "ID,CaseNumber,CrimeDate,CrimeBlock,IUCR,LocDescription,Arrest,Domestic,Beat,District,Ward,CommunityArea,NIBRS,XCoord,YCoord,UpdatedOn,Latitude,Longitude")

	reader := csv.NewReader(file)

	readHeader := false
	//macroIterations := 0
	counter := 0
	for {
		record, err := reader.Read()
		if err != nil {
			break
		}

		if !readHeader {
			readHeader = true
			continue
		}

		//record[2] = strings.ReplaceAll(record[2], "/", "-")

		/*if record[4][0] == '0' {
			record[4] = record[4][1:len(record[4])]
		}*/

		record[7] = strings.ReplaceAll(record[7], "\"", "'\"'")

		arrest := strToBool(record[8])
		domestic:= strToBool(record[9])

		//Make 0 community area NA
		if(record[13] == "0") {
			record[13] = "";
		}

		//record[18] = strings.ReplaceAll(record[18], "/", "-")

		fmt.Fprintf(output, "%s,%s,%s,%s,%s,\"%s\",%d,%d,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n",
			record[0], record[1], record[2], record[3], record[4], record[7], arrest, domestic, record[10], record[11], record[12], record[13], record[14], record[15], record[16], record[18], record[19], record[20])

		counter++
		//if counter >= 1000 {
			//break
		//}
	}


	file.Close()
	output.Close()
}


//For insertion using SQL, old
	/*fmt.Fprintln(output, "SET DEFINE OFF;") //Allow for insertion of ampersand
	fmt.Fprintln(output, "INSERT ALL")

	reader := csv.NewReader(file)

	readHeader := false
	macroIterations := 0
	counter := 0
	for {
		record, err := reader.Read()
		if err != nil {
			break
		}

		if !readHeader {
			readHeader = true
			continue
		}

		if record[4][0] == '0' {
			record[4] = record[4][1:len(record[4])]
		}

		arrest := 0 //Assume not arrest

		if record[8] == "true" { //If arrest, update appropriately
			arrest = 1
		}

		domestic := 0 //Assume not domestic

		if record[9] == "true" { //If domestic, update appropriately
			domestic = 1
		}

		record[15] = checkNull(record[15])
		record[16] = checkNull(record[16])
		record[19] = checkNull(record[19])
		record[20] = checkNull(record[20])

		fmt.Fprintf(output, "\tINTO Crimes (ID, CaseNumber, CrimeDate, CrimeBlock, IUCR, LocDescription, Arrest, Domestic, Beat, District, Ward, CommunityArea, NIBRS, XCoord, YCoord, UpdatedOn, Latitude, Longitude) VALUES(%s, q'[%s]', TO_DATE('%s', 'mm/dd/yyyy hh12:mi:ss AM'), q'[%s]', '%s', q'[%s]', %d, %d, %s, %s, %s, %s, '%s', %s, %s, TO_DATE('%s', 'mm/dd/yyyy hh12:mi:ss AM'), %s, %s)\n",
			record[0], record[1], record[2], record[3], record[4], record[7], arrest, domestic, record[10], record[11], record[12], record[13], record[14], record[15], record[16], record[18], record[19], record[20])

		counter++
		if counter >= 1000 {
			fmt.Fprintln(output, "SELECT 1 FROM Dual;")
			fmt.Fprintln(output, "INSERT ALL")
			macroIterations++
			fmt.Println(macroIterations)
			counter = 0
		}
	}

	fmt.Fprintln(output, "SELECT 1 FROM Dual;")*/

