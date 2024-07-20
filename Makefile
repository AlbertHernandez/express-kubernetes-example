create-kubernetes-cluster:
	cd kubernetes/utils && ./create_kubernetes_cluster.sh

delete-kubernetes-cluster:
	cd kubernetes/utils && ./delete_kubernetes_cluster.sh

deploy-app:
	cd kubernetes/utils && ./deploy_app.sh --app="express-kubernetes-example" --env="development"
