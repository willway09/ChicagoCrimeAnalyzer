package main

import (
	//"strings"
)

func prepareString(str string) string {
	//rtn := strings.ReplaceAll(str, "'", "''")
	//rtn := strings.ReplaceAll(str, "&", "\\&")
	//return rtn
	return str
}

func checkNull(str string) string {
	if(str == "") {
		return "NULL"
	} else {
		return str
	}
}

func strToBool(str string) int {
	if str == "true" {
		return 1
	} else {
		return 0
	}
}
