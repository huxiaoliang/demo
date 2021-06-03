#!/bin/bash

rm -rf broker-info.subm
kubeadm reset -f 

kubeadm init --apiserver-advertise-address=10.0.0.80 --apiserver-cert-extra-sans=localhost,127.0.0.1,10.0.0.80,132.232.31.102 --pod-network-cidr=10.44.0.0/16 --service-cidr=10.45.0.0/16 --kubernetes-version v1.19.7

sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config

yq -i eval \
'.clusters[].cluster.server |= sub("10.0.0.80", "132.232.31.102") | .contexts[].name = "cluster-a" | .current-context = "cluster-a"' \
$HOME/.kube/config

sleep 60

kubectl label node vm-0-80-ubuntu submariner.io/gateway=true
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl create -f kube-flannel.yaml

sleep 120

subctl deploy-broker 

sleep 60

scp  broker-info.subm 139.155.48.141:/root
scp  broker-info.subm 129.226.144.251:/root
subctl join broker-info.subm --clusterid cluster-a --natt=true
