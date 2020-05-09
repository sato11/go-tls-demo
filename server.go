package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"path/filepath"
)

func handler(w http.ResponseWriter, r *http.Request) {
	dump, err := httputil.DumpRequest(r, true)
	if err != nil {
		http.Error(w, fmt.Sprint(err), http.StatusInternalServerError)
		return
	}
	fmt.Println(string(dump))
	fmt.Fprintf(w, "<html><body>hello</body></http>")
}

func main() {
	http.HandleFunc("/", handler)
	log.Println("start http listening :18443")
	crt := filepath.Join("/", "workspace", "server.crt")
	sec := filepath.Join("/", "workspace", "server.key")
	err := http.ListenAndServeTLS(":18443", crt, sec, nil)
	log.Println(err)
}
