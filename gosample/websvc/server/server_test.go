package server

import (
	"io/ioutil"
	"log"
	"net/http"
	"testing"
)

func TestSimpleServer(t *testing.T) {
	cases := []struct {
		port, path, expected string
	}{
		{"9099", "/welcome", "Welcome to golang http server"},
	}

	log.Println("TestSimpleServer started")
	for _, c := range cases {
		go SimpleHTTPServer(c.port)
		resp, err := http.Get("http://localhost:" + c.port + c.path)
		if err != nil {
			log.Println("error", err)

		}
		defer resp.Body.Close()
		body, err := ioutil.ReadAll(resp.Body)
		log.Println("response body->", string(body))
		if string(body) != c.expected {
			t.Errorf("TestSimpleServer returned %q, want %q", body, c.expected)
		}
		//s.Shutdown(context.Background())
	}

}
