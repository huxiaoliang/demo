#!/bin/bash

 kubeadm reset -f

 kubeadm init --apiserver-advertise-address=172.22.0.77  --pod-network-cidr=10.4.0.0/16  --service-cidr=10.5.0.0/16 --kubernetes-version v1.19.7 

  sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
  
  yq -i eval \
          '.clusters[].cluster.server |= sub("172.22.0.77", "172.22.0.77") | .contexts[].name = "cluster-c" | .current-context = "cluster-c"' \
          $HOME/.kube/config

sleep 60

kubectl label node vm-0-77-ubuntu  submariner.io/gateway=true
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl create -f kube-flannel.yaml
sleep 120 

subctl join broker-info.subm --clusterid cluster-c --natt=true
