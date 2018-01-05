package incluster

import (
	"context"
	"fmt"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

func main() {
	// create in-cluster config
	cfg, err := rest.InClusterConfig()
	if err != nil {
		panic(err.Error())
	}

	// create kubernetes client
	clientset, err := kubernetes.NewForConfig(cfg)
	if err != nil {
		panic(err.Error())
	}
	for {
		pods, err := clientset.CoreV1().Pods("").List(context.TODO(), metav1.ListOptions{})
		if err != nil {
			panic(err.Error())
		}
		fmt.Printf("There are %d pods running in cluster\n", len(pods.Items))
		time.Sleep(10 * time.Second)
	}
}
