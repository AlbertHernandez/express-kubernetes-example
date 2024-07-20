create-kubernetes-cluster:
	cd kubernetes/utils && ./create_kubernetes_cluster.sh

delete-kubernetes-cluster:
	kubectl delete all --all -n default
