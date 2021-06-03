#!/bin/bash

 kubeadm reset -f

 kubeadm init --apiserver-advertise-address=10.0.0.127  --pod-network-cidr=10.144.0.0/16  --service-cidr=10.145.0.0/16 --kubernetes-version v1.19.7 

 sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config

yq -i eval \
        '.clusters[].cluster.server |= sub("10.0.0.127", "10.0.0.127") | .contexts[].name = "cluster-b" | .current-context = "cluster-b"' \
        $HOME/.kube/config

sleep 60 

kubectl label node vm-0-127-ubuntu  submariner.io/gateway=true
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

sleep 120

subctl join broker-info.subm --clusterid cluster-b --natt=true

DATASTORE_TYPE=kubernetes calicoctl create -f /root/cluster2.yaml