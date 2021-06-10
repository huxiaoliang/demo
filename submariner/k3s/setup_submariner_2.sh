#!/bin/bash
 /usr/local/bin/k3s-uninstall.sh 
rm -rf broker-info.subm
POD_CIDR=10.44.0.0/16
SERVICE_CIDR=10.45.0.0/16

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--cluster-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --advertise-address 119.28.118.26" sh -s -

sleep 30

cp /etc/rancher/k3s/k3s.yaml kubeconfig.cluster-a
export IP="119.28.118.26"
yq -i eval \
        '.clusters[].cluster.server |= sub("127.0.0.1", env(IP)) | .contexts[].name = "cluster-a" | .current-context = "cluster-a"' \
        kubeconfig.cluster-a


cp kubeconfig.cluster-a /root/.kube/config 
 
kubectl label node vm-0-67-ubuntu  submariner.io/gateway=true 

subctl deploy-broker 

sleep 30
scp  broker-info.subm 49.51.49.223:/root
scp  broker-info.subm 150.109.11.246:/root
subctl join broker-info.subm --clusterid cluster-a --natt=true