#!/bin/bash
ansible -i ../invertory/hosts masters -m systemd -a 'name=kube-apiserver state=stopped enabled=no'
ansible -i ../invertory/hosts masters -m systemd -a 'name=kube-controller-manager state=stopped enabled=no'
ansible -i ../invertory/hosts masters -m systemd -a 'name=kube-scheduler state=stopped enabled=no'
ansible -i ../invertory/hosts etcd -m systemd -a 'name=etcd state=stopped enabled=no'
ansible -i ../invertory/hosts k8s -m systemd -a 'name=kubelet state=stopped enabled=no'
ansible -i ../invertory/hosts k8s -m systemd -a 'name=kube-proxy state=stopped enabled=no'
ansible -i ../invertory/hosts k8s -m systemd -a 'name=flanneld state=stopped enabled=no'
ansible -i ../invertory/hosts k8s -m systemd -a 'name=docker state=stopped enabled=no'
ansible -i ../invertory/hosts k8s -m yum -a 'name=docker state=absent'
ansible -i ../invertory/hosts k8s -m shell -a 'rm -rf /opt/kubernetes /opt/etcd /opt/cni /etc/cni /var/run/flannel /var/lib/kubelet /etc/docker /var/lib/docker'
ansible -i ../invertory/hosts k8s -m shell -a "rm -f /usr/lib/systemd/system/{docker,flanneld,kubelet,kube-proxy,kube-apiserver,kube-controller-manager,kube-scheduler}.service"
ansible -i ../invertory/hosts k8s -m shell -a 'ip link set dev cni0 down; ip line set dev docker0 down'
ansible -i ../invertory/hosts k8s -m shell -a 'ip link delete cni0; ip link delete docker0'
