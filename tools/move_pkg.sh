#!/bin/bash

#cni_plugins_version=0.8.6
#etcd_version=3.4.9
#kubernetes_version=1.18.3
#flannel_version=0.12.0
#calico_version=3.15.0

cni_plugins_version=$(awk '/^cni_plugins_version/ {print $2}' ./group_vars/all)
etcd_version=$(awk '/^etcd_version/ {print $2}' ./group_vars/all)
kubernetes_version=$(awk '/^kubernetes_version/ {print $2}' ./group_vars/all)
flannel_version=$(awk '/^flannel_version/ {print $2}' ./group_vars/all)
calico_version=$(awk '/^calico_version/ {print $2}' ./group_vars/all)
network_type=$(awk '/^network_type/ {print $2}' ./group_vars/all)

cd /opt/pkg/

if [ -f ./cni-plugins-linux-amd64-v${cni_plugins_version}.tgz ];then
    mkdir -p cni-plugins/${cni_plugins_version}
    mv cni-plugins-linux-amd64-v${cni_plugins_version}.tgz ./cni-plugins/${cni_plugins_version}/ && \
    cd ./cni-plugins/${cni_plugins_version}/ && \
    tar xf cni-plugins-linux-amd64-v${cni_plugins_version}.tgz
    echo "[INFO] 下载 cni-plgins 并解压完成"
    cd - &>/dev/null
fi
if [ -f ./flannel-v${flannel_version}-linux-amd64.tar.gz ];then
    mkdir -p flannel/${flannel_version}
    mv ./flannel-v${flannel_version}-linux-amd64.tar.gz ./flannel/${flannel_version}/ && \
    cd ./flannel/${flannel_version}/ && \
    tar xf flannel-v${flannel_version}-linux-amd64.tar.gz
    echo "[INFO] 下载 flannel 并解压完成"
    cd - &>/dev/null
fi
if [ -f ./calicoctl ];then
    mkdir -p calico/${calico_version}
    mv ./calicoctl ./calico/${calico_version}/ && \
    cd ./calico/${calico_version}/ && \
    echo "[INFO] 下载 calicoctl 完成"
    cd - &>/dev/null
fi
if [ -f ./kubernetes-server-linux-amd64.tar.gz ];then
    mkdir -p k8s/${kubernetes_version}
    mv kubernetes-server-linux-amd64.tar.gz ./k8s/${kubernetes_version}/ && \
    cd ./k8s/${kubernetes_version}/ && \
    tar xf kubernetes-server-linux-amd64.tar.gz
    echo "[INFO] 下载 k8s-server 并解压完成"
    cd - &>/dev/null
fi
if [ -f etcd-v${etcd_version}-linux-amd64.tar.gz ];then
    mkdir -p etcd
    mv etcd-v${etcd_version}-linux-amd64.tar.gz ./etcd/ && \
    cd ./etcd/ && \
    tar xf etcd-v${etcd_version}-linux-amd64.tar.gz
    echo "[INFO] 下载 etcd 并解压完成"
    cd - &>/dev/null
fi
if [ -f cfssl_linux-amd64 ];then
    mkdir -p cfssl
    mv cfssl_linux-amd64 ./cfssl/ && \
    mv cfssljson_linux-amd64 ./cfssl/ && \
    mv cfssl-certinfo_linux-amd64 ./cfssl/
    echo "[INFO] 下载 cfssl 相关包完成"
    cd - &>/dev/null
fi