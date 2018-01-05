package concurrency

import "fmt"

// Fa simple function without sychronization
func Fa() {
	fmt.Println("concurrency without sync in go")
}

//FaCh simple function with bidirection channel to sync
func FaCh(ch chan bool) {
	fmt.Println("concurrency sync with bidirection channel in go")
	ch <- true
}

//FaChReceiveFirst A receive from unbuffered channel happens before send on that channel completes.
func FaChReceiveFirst(ch chan bool) {
	fmt.Println("concurrency receive from unbuffered channel happens before send on that channel completes")
	<-ch
}

//FaChSend direction channel send
func FaChSend(ch chan<- bool) {
	fmt.Println("concurrency channel only for send")
	ch <- true
}

//FaChReceive direction channel receive
func FaChReceive(ch <-chan bool) {
	fmt.Print("concurrency channel only for receiving")
	ret := <-ch
	fmt.Printf(" %+v\n", ret)
}
