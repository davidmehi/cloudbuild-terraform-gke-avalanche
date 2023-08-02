
# Avalanche on GKE

If you have an existing cluster, follow these steps to deploy to GKE.  If you do not have a cluster, see the terraform config to create one.

# Commands run to deploy avalanche fullnode to a new cluster

Note that config has avalanche runtime parameters hardcoded.  These can be extracted.

```
# Connect to  cluster
gcloud container clusters get-credentials arb-mainnet-nova-validator --zone us-central1-a --project gcda-arb-mainnet-validator

# Confirm cluster you are connected to
kubectl config current-context

# cd to folder with gke config
cd gke

# Create PVC
kubectl apply -f ./avalanche-fullnode-pvc.yaml
kubectl get pvc

# Deploy Avalanche fullnode
kubectl apply -f ./avalanche-fullnode.yaml
kubectl get pods

# Deploy Avalanche service to expose JSON-RPC
kubectl apply -f ./avalanche-fullnode-rpc-service.yaml
kubectl get service
```

# Troubleshooting

To find logs
```
kubectl get pods
kubectl logs <pod-name>
kubectl logs <pod-name> --tail 50
```

Describe Pods and Services
```
kubectl describe pod <pod-name>
kubectl describe service <service-name>
```


