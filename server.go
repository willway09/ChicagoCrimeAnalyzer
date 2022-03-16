package main

import (
	"fmt"
	"net/http"
)

func main() {
	db := openDatabase()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		runQuery1(db)

		w.WriteHeader(200)
		fmt.Fprint(w, "Hello world")
	})

	http.ListenAndServe(":8080", nil)

	fmt.Println("Hello world")
	db.Close()
}
