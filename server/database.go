package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	_ "github.com/godror/godror"
	"io/ioutil"
	"os"
	"strings"
	"errors"
	"reflect"
)

type ConnectionInfo struct {
	User, Password, ConnectString string
}

func loadConnection(filename string) (ConnectionInfo, error) {
	var connInfo ConnectionInfo

	file, err := os.Open(filename)
	if err != nil {
		return connInfo, err
	}

	err = json.NewDecoder(file).Decode(&connInfo)

	file.Close()

	return connInfo, nil
}

func getConnectionString(connInfo ConnectionInfo) string {
	return fmt.Sprintf(`user="%s" password="%s" connectString="%s"`, connInfo.User, connInfo.Password, connInfo.ConnectString)
}

func handleError(err error) {
	if err != nil {
		fmt.Println(err)
		os.Exit(-1)
	}
}

func loadQuery(filename string) string {
	content, err := ioutil.ReadFile(filename)
	handleError(err)

	query := strings.Trim(string(content), "\n"); //Clear newlines

	//Remove semicolon, gives errors for some reason...
	if query[len(query)-1] == ';' {
		query = query[0 : len(query)-1]
	}

	return query
}

//From https://stackoverflow.com/questions/21821550/sql-scan-rows-with-unknown-number-of-columns-select-from
//colTypes, _ := rows.ColumnTypes()
//colCount := len(colTypes)

func arrayToCommaList(intf interface{}) string {
	arr := reflect.ValueOf(intf)
	rtn := ""
	if arr.Len() == 0 {
		rtn = "''"
	} else {
		for i := 0; i < arr.Len(); i++ {
			if(i != arr.Len() - 1) {
				rtn += fmt.Sprintf("'%s', ", arr.Index(i))
			} else {
				rtn += fmt.Sprintf("'%s'", arr.Index(i))
			}
		}
	}
	return rtn
}

func getParametersArray(parameters interface{}, query string) ([]interface{}, string) {
	v := reflect.ValueOf(parameters)

	parametersArray := make([]interface{}, 0)

	for i := 0; i < v.NumField(); i++ {

		field := v.Field(i)

		if(field.Kind() == reflect.Array || field.Kind() == reflect.Slice) {
			name := ":" + strings.ToLower(v.Type().Field(i).Name)

			if strings.Index(query, name) == -1 {
				fmt.Printf("Cannot find parameter label %s in query\n", name);
				handleError(errors.New("Small error"))
			}

			list := arrayToCommaList(field.Interface())

			query = strings.ReplaceAll(query, name, list);
		} else {
			parametersArray = append(parametersArray, field.Interface())
		}
	}

	return parametersArray, query
}

//func readRow[T interface{}](sql.Row) T {
//}

func runQuery[T interface{}](db *sql.DB, filename string, parameters interface{}) []T {
	query := loadQuery(filename)

	arr, query := getParametersArray(parameters, query)

	stmt, err := db.Prepare(query)	
	handleError(err)

	rows, err := stmt.Query(arr...)
	handleError(err)

	columnTypes, _ := rows.ColumnTypes()
	colCount := len(columnTypes)

	result := make([]T, 0, 100)

	for rows.Next() {
		cols := make([]interface{}, colCount)
		var res T 

		v := reflect.ValueOf(&res).Elem()

		if v.NumField() != len(cols) {
			fmt.Printf("Running: %s\n", query)
			fmt.Printf("Number of Fields: %d, Length of Columns: %d\n", v.NumField(), len(cols))
			handleError(errors.New("Big error"))
		}

		colsV := reflect.ValueOf(cols)
		for i := 0; i < len(cols); i++ {
			colsV.Index(i).Set(reflect.New(v.Field(i).Type()))
		}

		rows.Scan(cols...)

		for i := 0; i < len(cols); i++ {
			if cols[i] != nil {
				v.Field(i).Set(reflect.ValueOf(cols[i]).Elem())
			}
		}

		result = append(result, res)
	}

	rows.Close()

	return result
}

func openDatabase() *sql.DB {
	connInfo, err := loadConnection("connection.json")

	db, err := sql.Open("godror", getConnectionString(connInfo))
	handleError(err)
	return db
}
