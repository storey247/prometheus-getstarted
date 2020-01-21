timestamp := $(shell /bin/date "+%Y%m%d-%H%M%S")
KIND_CLUSTER_NAME ?= "hello-prometheus"
IMG ?= docker.io/hello-prometheus:1

kind-start:
ifeq (1, $(shell kind get clusters | grep ${KIND_CLUSTER_NAME} | wc -l))
	@echo "Cluster already exists"
	kubectl cluster-info --context kind-hello-prometheus
else
	@echo "Creating Cluster"	
	kind create cluster --name ${KIND_CLUSTER_NAME}
	kubectl cluster-info --context kind-hello-prometheus
endif

docker-build: 
	docker build -t ${IMG} -f Dockerfile .

kind-load-img: kind-start docker-build
	@echo "Loading image into kind"	
	kind load docker-image ${IMG} --name ${KIND_CLUSTER_NAME} --loglevel "trace"

deploy-service:
	@echo "Starting deployment"
	kubectl apply -f ./config/deployment.yaml

kind-deploy: kind-start kind-load-img deploy-service
