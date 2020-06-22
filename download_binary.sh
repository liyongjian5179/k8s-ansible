#!/bin/bash
# Download

CNI_PLUGIN_VER=0.8.6
ETCD_VER=3.4.9
K8S_SERVER_VER=1.18.3
FLANNEL_VER=0.12.0
mkdir /opt/pkg && cd /opt/pkg && \
wget https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGIN_VER}/cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz && \
wget https://github.com/coreos/flannel/releases/download/v${FLANNEL_VER}/flannel-v${FLANNEL_VER}-linux-amd64.tar.gz && \
wget https://dl.k8s.io/v${K8S_SERVER_VER}/kubernetes-server-linux-amd64.tar.gz && \
wget https://github.com/etcd-io/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz



if [ -f ./cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz ];then
    mkdir -p cni/cni-${CNI_PLUGIN_VER}
    mv cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz ./cni/cni-${CNI_PLUGIN_VER}/ && \
    cd ./cni/cni-${CNI_PLUGIN_VER}/ && \
    tar xf cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz
    cd -
else
    echo "cni-plugin 二进制包不存在"
fi

if [ -f ./flannel-v${FLANNEL_VER}-linux-amd64.tar.gz ];then
    mkdir -p flannel/flannel-${FLANNEL_VER}
    mv ./flannel-v${FLANNEL_VER}-linux-amd64.tar.gz ./flannel/flannel-${FLANNEL_VER}/ && \
    cd ./flannel/flannel-${FLANNEL_VER}/ && \
    tar xf flannel-v${FLANNEL_VER}-linux-amd64.tar.gz
    cd -
else
    echo "flannel 二进制包不存在"
fi

if [ -f ./kubernetes-server-linux-amd64.tar.gz ];then
    mkdir k8s-${K8S_SERVER_VER}
    mv kubernetes-server-linux-amd64.tar.gz ./k8s-${K8S_SERVER_VER}/ && \
    cd ./k8s-${K8S_SERVER_VER}/ && \
    tar xf kubernetes-server-linux-amd64.tar.gz
    cd -
else
    echo "k8s 二进制包不存在"
fi

if [ -f etcd-v${ETCD_VER}-linux-amd64.tar.gz ];then
    mkdir -p etcd
    mv etcd-v${ETCD_VER}-linux-amd64.tar.gz ./etcd/ && \
    cd ./etcd/ && \
    tar xf etcd-v${ETCD_VER}-linux-amd64.tar.gz
    cd -
else
    echo "etcd 二进制包不存在"
fi