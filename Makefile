create-kubernetes-cluster:
	./kubernetes/use-cases/create_kubernetes_cluster.sh

delete-kubernetes-cluster:
	./kubernetes/use-cases/delete_kubernetes_cluster.sh

deploy-app:
	./kubernetes/use-cases/deploy_app.sh --app="express-kubernetes-example" --env="development"
