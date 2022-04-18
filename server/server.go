package main

import (
	"fmt"
	"net/http"
	"encoding/json"
	"io/ioutil"
	"strings"
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

	mimeTypes := getMimeTypes()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		if(r.URL.Path == "/" || r.URL.Path == "/index.html") {
			file, err := ioutil.ReadFile("../website/home.html")

			if err != nil {
				w.WriteHeader(404)
				fmt.Fprintln(w, "Page not found")
				return
			}

			w.WriteHeader(200)
			w.Write(file)
		} else {
			file, err := ioutil.ReadFile("../website/" + r.URL.Path)

			if err != nil {
				w.WriteHeader(404)
				fmt.Fprintln(w, "Page not found")
				return
			}

			parts := strings.Split(r.URL.Path, ".")

			if(len(parts) == 1) {
				w.Header().Set("Content-Type", "text/html")
			} else {
				w.Header().Set("Content-Type", mimeTypes[strings.ToLower(parts[len(parts) - 1])])
			}

			w.WriteHeader(200)
			w.Write(file)
		}

	})

	http.HandleFunc("/api/communityareas", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		var parameters noParameters

		result := runQuery[communityAreasResult](db, "../queries/communityareas.sql", parameters)

		err := json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.HandleFunc("/api/borders", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		var parameters noParameters

		result := runQuery[bordersResult](db, "../queries/borders.sql", parameters)

		err := json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.HandleFunc("/api/nibrscrimes", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		var parameters noParameters

		result := runQuery[NIBRSResult](db, "../queries/nibrscrimes.sql", parameters)

		err := json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.HandleFunc("/api/iucrcrimes", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		var parameters noParameters

		result := runQuery[NIBRSResult](db, "../queries/iucrcrimes.sql", parameters)

		err := json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.HandleFunc("/api/monthrange", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		var parameters noParameters

		result := runQuery[monthrangeResult](db, "../queries/monthrange.sql", parameters)

		err := json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.HandleFunc("/api/query1", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		dec := json.NewDecoder(r.Body)
		var parameters query1Parameters
		err := dec.Decode(&parameters)

		if err != nil {
			w.WriteHeader(412) //Precondition failed
			fmt.Fprintln(w, "Invalid JSON")
			return
		}

		fmt.Println(parameters);

		result := runQuery[query1Result](db, "../queries/query1.sql", parameters)

		err = json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.HandleFunc("/api/query2", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		dec := json.NewDecoder(r.Body)
		var parameters query2Parameters
		err := dec.Decode(&parameters)

		if err != nil {
			w.WriteHeader(412) //Precondition failed
			fmt.Fprintln(w, "Invalid JSON")
			return
		}

		fmt.Println(parameters);

		result := runQuery[query2Result](db, "../queries/query2.sql", parameters)

		err = json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.HandleFunc("/api/query3", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		dec := json.NewDecoder(r.Body)
		var parameters query3Parameters
		err := dec.Decode(&parameters)

		if err != nil {
			w.WriteHeader(412) //Precondition failed
			fmt.Fprintln(w, "Invalid JSON")
			return
		}

		fmt.Println(parameters);

		result := runQuery[query3Result](db, "../queries/query3.sql", parameters)

		err = json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.HandleFunc("/api/query4", func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		dec := json.NewDecoder(r.Body)
		var parameters query4Parameters
		err := dec.Decode(&parameters)

		fmt.Println(parameters)

		if err != nil {
			w.WriteHeader(412) //Precondition failed
			fmt.Fprintln(w, "Invalid JSON")
			return
		}

		fmt.Println(parameters);

		result := runQuery[query4Result](db, "../queries/query4.sql", parameters)

		err = json.NewEncoder(w).Encode(&result)
		if(!handleServerError(err, w)) {
			return
		}
		w.Header().Set("Content-Type", "application/json")
	})

	http.ListenAndServe(":8080", nil)

	fmt.Println("Hello world")
	db.Close()
}
