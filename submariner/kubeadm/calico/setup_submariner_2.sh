#!/bin/bash

#0. clean up env
kubeadm reset -f
rm -rf broker-info.subm
rm -rf /usr/bin/kube*

#1. set http proxy
export http_proxy=http://49.51.xx.xxx:8123
export https_proxy=http://49.51.xx.xxx:8123

#2. install yq
BINARY=yq_linux_amd64
VERSION=v4.8.0 
wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&  chmod +x /usr/bin/yq


#3. install yq calicoctl
curl -o /usr/bin/calicoctl -O -L https://github.com/projectcalico/calicoctl/releases/download/v3.18.4/calicoctl &&   chmod +x /usr/bin/calicoctl


#4. install CNI plugins
CNI_VERSION="v0.8.2"
sudo mkdir -p /opt/cni/bin
wget -c  "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz" -O - | tar -C /opt/cni/bin -xz

#5. install kubeadm, kubelet, kubectl
RELEASE="v1.19.7"
curl -o /usr/bin/kubeadm https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/kubeadm && chmod +x /usr/bin/kubeadm
curl -o /usr/bin/kubelet https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/kubelet && chmod +x /usr/bin/kubelet
curl -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/kubectl && chmod +x /usr/bin/kubectl

#6. add a kubelet systemd service
RELEASE_VERSION="v0.4.0"
curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service" | sudo tee /etc/systemd/system/kubelet.service
sudo mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf" | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf


#7. enable and start kubelet
systemctl enable --now kubelet

#8. install subctl
curl -Ls https://get.submariner.io | bash
export PATH=$PATH:~/.local/bin
echo export PATH=\$PATH:~/.local/bin >> ~/.profile

#9. unset http proxy
unset http_proxy
unset https_proxy

 kubeadm reset -f

 kubeadm init --apiserver-advertise-address=172.30.0.34  --pod-network-cidr=10.144.0.0/16  --service-cidr=10.145.0.0/16 --kubernetes-version v1.19.7 

 sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config

yq -i eval \
        '.clusters[].cluster.server |= sub("172.30.0.34", "172.30.0.34") | .contexts[].name = "cluster-b" | .current-context = "cluster-b"' \
        $HOME/.kube/config

sleep 60 

kubectl label node vm-0-34-ubuntu  submariner.io/gateway=true
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

sleep 120

subctl join broker-info.subm --clusterid cluster-b --natt=true

DATASTORE_TYPE=kubernetes calicoctl create -f /root/cluster2.yaml