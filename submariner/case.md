|  k8s version   |   pod/pod connectivity across cluster | service discovery | CNI version | deployment mode | kube-proxy mode | note |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| 1.15.7 | ok | ok | flannel v0.14.0 | On-Premise | iptables | subctl v0.6.0-dev |
| 1.16.7 | ok | ok | calicoctl v3.18.4 | On-Premise | iptables | subctl v0.9.0-dev |
| 1.19.1 | ok | ok | calicoctl v3.18.4 | On-Premise | ipvs | subctl v0.9.0 |
| 1.19.1 | ok | ok | calicoctl v3.18.4 | On-Premise | iptables | subctl v0.9.0 |
| 1.18.4 | ok | ok | VPC-CNI | TKE(1) | ipvs | 独立集群部署; subctl v0.9.0; cordon other nodes; 8080 port conflict |
| 1.18.4 | ok | ok | VPC-CNI | TKE(2) | iptables | 独立集群部署; subctl v0.9.0; cordon other nodes; 8080 port conflict |
