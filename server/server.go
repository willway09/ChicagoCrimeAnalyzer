package main

import (
	"fmt"
	"net/http"
	"encoding/json"
)

func handleServerError(val error, w http.ResponseWriter) bool {
	if val != nil {
		fmt.Fprintln(w,"Error")
		w.WriteHeader(500)
		return false
	}
	return true
}

func main() {
	db := openDatabase()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		w.WriteHeader(200)
		fmt.Fprint(w, "Hello world")
	})

	http.HandleFunc("/api/communityareas", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		var parameters noParameters

		result := runQuery[communityAreasResult](db, "../queries/communityareas.sql", parameters)

		err := json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
	})

	http.HandleFunc("/api/nibrscrimes", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		var parameters noParameters

		result := runQuery[NIBRSResult](db, "../queries/nibrscrimes.sql", parameters)

		err := json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
	})

	http.HandleFunc("/api/iucrcrimes", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		var parameters noParameters

		result := runQuery[NIBRSResult](db, "../queries/iucrcrimes.sql", parameters)

		err := json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
	})

	http.ListenAndServe(":8080", nil)

	fmt.Println("Hello world")
	db.Close()
}
