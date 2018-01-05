package main

import (
	"fmt"

	con "github.com/yu2003w/k8sdemo/abc/concurrency"
)

func main() {
	// normal go routine without synchronization
	go con.Fa()
	fmt.Println("Fa() will run randomly")
	var ch chan bool
	ch = make(chan bool)
	go con.FaCh(ch)
	ret := <-ch
	fmt.Printf("FaCh() completed with %+v\n", ret)

	go con.FaChReceiveFirst(ch)
	ch <- true
	fmt.Println("FaChSend() send to unbuffered channel happens after receive on that channel")

	go con.FaChSend(ch)
	<-ch
	fmt.Println("FaChSend() only send to channel")

	go con.FaChReceive(ch)
	ch <- false
	fmt.Println("FaChReceive() only receive from channel")

}
