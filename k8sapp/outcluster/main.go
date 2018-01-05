package outcluster

import (
	"context"
	"flag"
	"fmt"
	"path/filepath"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
)

func main() {
	var kubecfg *string
	if home := homedir.HomeDir(); home != "" {
		kubecfg = flag.String("kubeconfig", filepath.Join(home, ".kube", "kubeconfig"), "(optional) absolute path to the kubeconfig file")
	} else {
		kubecfg = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
	}
	flag.Parse()

	config, err := clientcmd.BuildConfigFromFlags("", *kubecfg)
	if err != nil {
		panic(err.Error())
	}

	clientset, err := kubernetes.NewForConfig(config)
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
