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

type NIBRSCrime struct {
	Name, Code, Against, Definition string
	IUCRS                           []string
}

func extractNIBRSCrime(str string, iucr string) NIBRSCrime {
	var crime NIBRSCrime

	strs := strings.Split(str, "\n")

	line1 := strings.Split(strings.ReplaceAll(strs[0], ")", ""), " (")

	crime.Name = line1[0]
	crime.Code = line1[1]

	temp := strings.ReplaceAll(strings.ReplaceAll(strs[1], "(", ""), ")", "")
	temp = strings.ReplaceAll(temp, "Crimes Against ", "")
	temp = strings.ReplaceAll(temp, "Crime Against ", "")

	crime.Against = temp
	crime.Definition = strings.ReplaceAll(strs[2], "Definition: ", "")
	crime.Definition = strings.ReplaceAll(strs[2], "Definition:", "")

	IUCRSLines := strings.Split(iucr, "\n")

	crime.IUCRS = make([]string, len(IUCRSLines))

	for i := 0; i < len(IUCRSLines); i++ {
		crime.IUCRS[i] = strings.Split(IUCRSLines[i], " ")[0]
	}

	return crime
}

func main() {
	file, err := os.Open("../datasources/NIBRSCodes.csv")
	handleError(err)
	output, err := os.Create("NIBRS.sql");
	handleError(err);

	fmt.Fprintln(output, "SET DEFINE OFF;"); //Allow for insertion of ampersand
	fmt.Fprintln(output, "INSERT ALL");

	reader := csv.NewReader(file)

	for {
		record, err := reader.Read()
		if err != nil {
			break
		}

		crime := extractNIBRSCrime(record[0], record[1])
		crime.Name = prepareString(crime.Name)
		crime.Against = prepareString(crime.Against)
		crime.Definition = prepareString(crime.Definition)
		fmt.Fprintf(output, "\tINTO NIBRSCrimes (NIBRS, Title, CrimeAgainst, Definition) VALUES(q'[%s]', q'[%s]', q'[%s]', q'[%s]')\n",
			crime.Code, crime.Name, crime.Against, crime.Definition)
	}

	fmt.Fprintln(output, "SELECT 1 FROM Dual;");

	file.Close()
	output.Close();
}
