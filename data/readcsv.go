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

	IUCRSLines := strings.Split(iucr, "\n")

	crime.IUCRS = make([]string, len(IUCRSLines))

	for i := 0; i < len(IUCRSLines); i++ {
		crime.IUCRS[i] = strings.Split(IUCRSLines[i], " ")[0]
	}

	return crime
}

func main() {
	file, err := os.Open("../nibrscodes.csv")
	handleError(err)

	reader := csv.NewReader(file)

	var IUCRtoNIBRS map[string]string

	IUCRtoNIBRS = make(map[string]string)

	for {
		record, err := reader.Read()
		if err != nil {
			break
		}

		crime := extractNIBRSCrime(record[0], record[1])

		for i := 0; i < len(crime.IUCRS); i++ {
			_, ok := IUCRtoNIBRS[crime.IUCRS[i]]
			if ok {
				fmt.Println("Duplicate detected")
				os.Exit(-1)
			} else {
				IUCRtoNIBRS[crime.IUCRS[i]] = crime.Code
			}
		}
	}

	//fmt.Println(IUCRtoNIBRS)

	file.Close()

	file, err = os.Open("../Crimes_-_2001_to_Present.csv")
	handleError(err)

	reader = csv.NewReader(file)

	readHeader := false
	for i := 0; i < 10000; i++ {
		record, err := reader.Read()
		if err != nil {
			break
		}

		if !readHeader {
			readHeader = true
			continue
		}

		expectedCrime, ok := IUCRtoNIBRS[record[4]]

		if(!ok) {
			fmt.Printf("IUCR NOT FOUND: %s %s\n", record[4], record[14])
		} else {
			fmt.Printf("%s %s %s\n", record[4], record[14], expectedCrime)
		}
	}

	file.Close()
}
