This is a Kubernetes admission controller example which comes from [Giant Swarm](https://docs.giantswarm.io/guides/creating-your-own-admission-controller/). Unfortunately, it is not obvious on which version it runs correctly. As a Kubernetes newbie, I have struggled several hours to get this working, so I decided to describe my working case.

## Get Kubernetes cluster
I used retired [kubeadm-dind-cluster](https://github.com/kubernetes-retired/kubeadm-dind-cluster) in version 1.13. Instruction how to get and setup it you will find in [the project's README](https://github.com/kubernetes-retired/kubeadm-dind-cluster#using-preconfigured-scripts).

## Clone the example
`git clone https://github.com/prondzyn/grumpy`

## Go to the example dir 
`cd grumpy`

## Generate certificate
`./certs/generate.sh`

## Create secret
`kubectl create secret generic grumpy -n default --from-file=key.pem=certs/grumpy-key.pem --from-file=cert.pem=certs/grumpy-crt.pem`

## Create webhook service
`kubectl apply -f webhook_config/service.yaml`

## Create webhook deployment
`kubectl apply -f webhook_config/deployment.yaml`

## Check if deployment succeed
Command

`kubectl rollout status deployment grumpy`

should return 

`deployment "grumpy" successfully rolled out`

## Create webhook configuration
`kubectl apply -f webhook_config/webhook.yaml`

## Test invalid pod deployment rejection 
Command

`kubectl apply -f examples/invalid_pod.yaml` 

should return

`Error from server: error when creating "examples/invalid_pod.yaml": admission webhook "grumpy.giantswarm.io" denied the request: Keep calm and not add more crap in the cluster!`

## Test valid pod deployment approval 

Command

`kubectl apply -f examples/valid_pod.yaml`

should return

`pod/smooth-app created`