# k8s-ansible

使用前先根据自身情况修改 `group_vars/all` 和`inventory/hosts`文件

## 使用的版本信息如下

K8S_SERVER_VER=1.18.3

ETCD_VER=3.4.9

FLANNEL_VER=0.12.0

CNI_PLUGIN_VER=0.8.6

CALICO_VER=3.15.0

DOCKER_VER=19.03.10  

## 网段信息

pod 网段：10.244.0.0/16

service 网段：10.96.0.0/12

kubernetes 内部地址：10.96.0.1

coredns 地址： 10.96.0.10


## 机器安排

| 主机名        | IP           |        角色及组件        |                         k8s 相关组件                         |
| ------------- | ------------ | :----------------------: | :----------------------------------------------------------: |
| centos7-nginx | 10.10.10.127 |   nginx 四层代理(主控机)   |                        nginx  ansible                             |
| centos7-a     | 10.10.10.128 | master,node,etcd,flannel | kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy |
| centos7-b     | 10.10.10.129 | master,node,etcd,flannel | kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy |
| centos7-c     | 10.10.10.130 | master,node,etcd,flannel | kube-apiserver kube-controller-manager kube-scheduler kubelet kube-proxy |
| centos7-d     | 10.10.10.131 |       node,flannel       |                      kubelet kube-proxy                      |
| centos7-e     | 10.10.10.132 |       node,flannel       |                      kubelet kube-proxy                      |

## 注意：
如果前端有 LB ,选用四层模式，端口 6443，同时将 site.yaml 中第 2-6 行注释。
如果没有 LB，需要自己准备 Nginx ，尽量单独找一台机器安装 Nginx。

## 提前下载安装包文件
可以通过执行 `download_binary.sh` 脚本进行包的下载
```bash
bash download_binary.sh
```
如果遇到下载问题，请先将包下载至主控机的 `/opt/pkg/`目录下
```bash
wget https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGIN_VER}/cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz && \
wget https://github.com/coreos/flannel/releases/download/v${FLANNEL_VER}/flannel-v${FLANNEL_VER}-linux-amd64.tar.gz && \
wget https://dl.k8s.io/v${K8S_SERVER_VER}/kubernetes-server-linux-amd64.tar.gz && \
wget https://github.com/etcd-io/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz && \
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 &&\
wget https://github.com/projectcalico/calicoctl/releases/download/v{CALICOCTL_VER}/calicoctl
```
然后执行`tools/move_pkg.sh` 脚本对包进行解压至对应的目录
```bash
bash tools/move_pkg.sh
```

## 修改主控机 hosts 文件

```bash
[root@centos7-nginx k8s-ansible]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.10.10.127 centos7-nginx lb.5179.top inner-lb.5179.top ng.5179.top ng-inner.5179.top
10.10.10.128 centos7-a
10.10.10.129 centos7-b
10.10.10.130 centos7-c
10.10.10.131 centos7-d
10.10.10.132 centos7-e
```

## 执行
```bash
ansible-playbook -i inventory/hosts  site.yml
```

## 给`Master`节点打上角色标签和污点
```bash
ansible-playbook -i inventory/hosts  site.yml -t make_master_labels_and_taints
```
执行完后可以看到如下
```bash
[root@centos7-nginx k8s-ansible]# kubectl get nodes
NAME           STATUS   ROLES    AGE     VERSION
10.10.10.128   Ready    master   7m48s   v1.18.3
10.10.10.129   Ready    master   7m49s   v1.18.3
10.10.10.130   Ready    master   7m49s   v1.18.3
10.10.10.131   Ready    <none>   7m49s   v1.18.3
10.10.10.132   Ready    <none>   7m49s   v1.18.3

[root@centos7-nginx k8s-ansible]# kubectl describe nodes 10.10.10.128 |grep -C 3 Taints
Annotations:        node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Thu, 25 Jun 2020 17:38:09 +0800
Taints:             node-role.kubernetes.io/master:NoSchedule
Unschedulable:      false
Lease:
  HolderIdentity:  10.10.10.128
```
也可以手动执行
```bash
# 给节点打上 master 角色
kubectl label nodes  xxx node-role.kubernetes.io/master=
# 给节点打上 node 角色
kubectl label nodes xxx node-role.kubernetes.io/node=
# 打上 master 节点不可调度后，master 节点将不会运行 pod，除非容忍这个污点
kubectl taint nodes xxx  node-role.kubernetes.io/master=:NoSchedule
# 与上条结果相反，将 master 节点当 node 节点使用
kubectl taint nodes xxx node-role.kubernetes.io/master-
```

## 重新生成证书
默认生成一次之后，如果不手动删除，是不会再生成新的证书的，

如果想重新生成可以加上`CERT_POLICY=update`,执行如下命令的同时会对旧的证书进行备份
```bash
ansible-playbook -i inventory/hosts  site.yml -t cert  -e 'CERT_POLICY=update'
```

## 增加新节点

先在`invertory/hosts`的`[new-nodes]`下增加节点地址  
然后执行
```bash
ansible-playbook -i inventory/hosts new_nodes.yml
```
## 测试集群
```
[root@centos7-nginx k8s-ansible]# kubectl apply -f tests/myapp.yaml
```
然后执行如下命令进行基础功能验证
```bash
[root@centos7-nginx k8s-ansible]# kubectl exec -it busybox -- sh
/ #
/ # nslookup kubernetes
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes
Address 1: 10.96.0.1 kubernetes.default.svc.cluster.local
/ # nslookup myapp
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      myapp
Address 1: 10.102.233.224 myapp.default.svc.cluster.local
/ #
/ # curl myapp/hostname.html
myapp-5cbd66595b-p6zlp
```

## 清理集群

```bash
bash ./tools/clean.sh
```