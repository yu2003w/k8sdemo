package server

import (
	"log"
	"net/http"
	"time"
)

// handler welcome
func welcome(w http.ResponseWriter, req *http.Request) {
	log.Println("welcome is invoked")
	log.Print("request", req)
	w.Write([]byte("Welcome to golang http server"))
}

//SimpleHTTPServer setup simple http server
func SimpleHTTPServer(port string) *http.Server {
	http.HandleFunc("/welcome", welcome)
	ser := &http.Server{
		Addr:           ":" + port,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	log.Fatal(ser.ListenAndServe())

	log.Printf("simple http server started on port %v", port)
	return ser
}
