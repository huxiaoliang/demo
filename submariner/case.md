
## xCase result

| broker k8s| mannaged k8s |   pod/pod connectivity | service discovery | CNI version | deployment mode | kube-proxy mode | note |
| ------------- |  ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| 1.15.7 |  1.15.7 | **ok** (cluster cidr: xx) | ok ( service cidr: xxx) | flannel v0.14.0 | On-Premise | iptables | subctl v0.6.0-dev |
| 1.16.7 |  1.15.7 | ok (cluster cidr: xx) | ok ( service cidr: xxx) | calicoctl v3.18.4 | On-Premise | iptables | subctl v0.9.0-dev |
| 1.19.1 |  1.15.7 | ok (cluster cidr: xx) | ok ( service cidr: xxx)  | calicoctl v3.18.4 | On-Premise | ipvs | subctl v0.9.0 |
| 1.19.1 |  1.15.7 | ok (cluster cidr: xx) | ok ( service cidr: xxx)  | calicoctl v3.18.4 | On-Premise | iptables | subctl v0.9.0 |
| TKE 独立集群1.18.4 |  1.15.7 | ok (cluster cidr: xx) | ok ( service cidr: xxx)  | VPC-CNI | Cloud | ipvs |  subctl v0.9.0; |
| TKE 独立集群1.18.4 |  1.15.7 | ok (cluster cidr: xx) | ok ( service cidr: xxx)  | VPC-CNI | Cloud | iptables |  subctl v0.9.0;  |
| TKE 独立集群1.18.4 |  GKE 1.15.7 | ok (cluster cidr: xx) | ok ( service cidr: xxx)  | **broker** : VPC-CNI **managed**:  | Cloud | iptables |  subctl v0.9.0 |


## Issue list

1. cordon other nodes
2. 8080 conflict on tke
3. todo
