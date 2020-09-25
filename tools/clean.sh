#!/bin/bash
ansible -i ./inventory/hosts masters -m systemd -a 'name=kube-apiserver state=stopped enabled=no'
ansible -i ./inventory/hosts masters -m systemd -a 'name=kube-controller-manager state=stopped enabled=no'
ansible -i ./inventory/hosts masters -m systemd -a 'name=kube-scheduler state=stopped enabled=no'
ansible -i ./inventory/hosts etcd -m systemd -a 'name=etcd state=stopped enabled=no'
ansible -i ./inventory/hosts k8s -m systemd -a 'name=kubelet state=stopped enabled=no'
ansible -i ./inventory/hosts k8s -m systemd -a 'name=kube-proxy state=stopped enabled=no'
ansible -i ./inventory/hosts k8s -m systemd -a 'name=flanneld state=stopped enabled=no'
ansible -i ./inventory/hosts k8s -m systemd -a 'name=docker state=stopped enabled=no'
ansible -i ./inventory/hosts k8s -m yum -a 'name=docker-ce state=absent'
ansible -i ./inventory/hosts k8s -m yum -a 'name=docker-ce-cli state=absent'
ansible -i ./inventory/hosts masters -m shell -a 'mv -f /root/.kube/config /tmp/'
# 解绑 tmpfs 的挂载点
ansible -i inventory/hosts k8s  -m raw -a "umount \$(df -HT | grep '/opt/kubelet/pods' | awk '{print \$7}')"
ansible -i ./inventory/hosts k8s -m shell -a 'rm -rf /opt/kubernetes /opt/etcd /opt/cni /etc/cni /var/run/calico /etc/calico /var/run/flannel /opt/yamls /var/lib/kubelet /etc/docker /var/lib/docker /opt/docker /var/lib/dockershim /opt/kubelet'
ansible -i ./inventory/hosts k8s -m shell -a "rm -f /usr/lib/systemd/system/{docker,etcd,flanneld,kubelet,kube-proxy,kube-apiserver,kube-controller-manager,kube-scheduler}.service"
ansible -i ./inventory/hosts k8s -m shell -a 'ip link set dev cni0 down; ip link set dev docker0 down; ip link set dev flannel.1 down'
ansible -i ./inventory/hosts k8s -m shell -a 'ip link delete cni0; ip link delete docker0; ip link delete flannel.1'
ansible -i ./inventory/hosts k8s -m shell -a 'ipvsadm -C && iptables -F'
ansible -i ./inventory/hosts k8s -m shell -a 'modprobe -r ipip'