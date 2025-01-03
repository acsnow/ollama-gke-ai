# ollama-genai-gke

## Getting started

### Create GKE cluster 

```
gcloud container clusters create demo-genai-01 --project=tfc-sip-01 --num-nodes=3 --node-locations=us-west1-a --machine-type=n2-standard-8 --network=primary-vault-vpc --subnetwork=primary-subnet-01 --region=us-west1 --addons=GcpFilestoreCsiDriver,HttpLoadBalancing,HorizontalPodAutoscaling
```
### Add second node pool for NVIDIA gpu 
```
gcloud container node-pools create demo-genai-gpu-01  --accelerator type=nvidia-l4,count=1,gpu-driver-version=default --machine-type g2-standard-8 --num-nodes=3 --region us-west1 --cluster demo-genai-01
```
### Install Cert manager for using lets-encrypt
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.1/cert-manager.yaml
```
### CD into the tls directory and create issuer and blank secret for the helm chart to use
```
kubectl apply -f tls/production-issuer.yaml
kubectl apply -f tls/secret-tls.yaml
```
### Create storage class for filestore.  This is only needed if you are going to have multiple replicas.
```
kubectl apply -f pvc-filestore.yaml
```
### Install managed Cert
```
kubectl apply -f managed-cert.yaml
```
### Install helm for open-webui which will deploy Ollama and open-webui and create the ingress controller with temporary certs
```
helm upgrade --install open-webui open-webui/open-webui -f genai-values.yaml
```
