# k8s-ansible

# 使用的版本信息如下

CNI_PLUGIN_VER=0.8.6

ETCD_VER=3.4.9

K8S_SERVER_VER=1.18.3

FLANNEL_VER=0.12.0

DOCKER_VER=19.03.10  

如果修改版本，需要同时修改 `group_vars/all` 文件

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
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 
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
10.10.10.127 centos7-nginx lb.5179.top ng.5179.top ng-inter.5179.top
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

## 证书更新
第一次生成不用指定，如果要覆盖已存在的证书，用如下命令
```bash
ansible-playbook -i inventory/hosts  site.yml -t cert  -e 'CERT_POLICY=update'
```

## 增加新节点

先在`invertory/hosts`的`[new-nodes]`下增加节点地址  
然后执行
```bash
ansible-playbook -i inventory/hosts new_nodes.yml
```