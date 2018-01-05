Procedure for generating sample guestbook.
1, kubebuilder init --domain guestbook.io
2, kubebuilder create api --group webapp --version v1 --kind Guestbook
3, install CRD to run `make install`
   Noted: `kustomize` should be replaced with `/usr/local/kubebuilder/bin/kubectl kustomize`.
          Refer https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/ for detailed information.
4, run locally with `make run`
5, `kubectl apply -f config/samples/` to create CR
6, remove CR
7, `make uninstall` to remove CRD 

Controller should also be running on cluster like below,
`make docker-build docker-push IMG=<some-registry>/<project-name>:tag`
`make deploy IMG=<some-registry>/<project-name>:tag`
