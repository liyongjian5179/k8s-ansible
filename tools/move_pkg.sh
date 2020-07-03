#!/bin/bash

CNI_PLUGIN_VER=0.8.6
ETCD_VER=3.4.9
K8S_SERVER_VER=1.18.3
FLANNEL_VER=0.12.0
CALICO_VER=3.15.0

cd /opt/pkg/

if [ -f ./cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz ];then
    mkdir -p cni-plugins/${CNI_PLUGIN_VER}
    mv cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz ./cni-plugins/${CNI_PLUGIN_VER}/ && \
    cd ./cni-plugins/${CNI_PLUGIN_VER}/ && \
    tar xf cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz
    echo "[INFO] 下载 cni-plgins 并解压完成"
    cd - &>/dev/null
fi
if [ -f ./flannel-v${FLANNEL_VER}-linux-amd64.tar.gz ];then
    mkdir -p flannel/${FLANNEL_VER}
    mv ./flannel-v${FLANNEL_VER}-linux-amd64.tar.gz ./flannel/${FLANNEL_VER}/ && \
    cd ./flannel/${FLANNEL_VER}/ && \
    tar xf flannel-v${FLANNEL_VER}-linux-amd64.tar.gz
    echo "[INFO] 下载 flannel 并解压完成"
    cd - &>/dev/null
fi
if [ -f ./calicoctl ];then
    mkdir -p calico/${CALICO_VER}
    mv ./calicoctl ./calico/${CALICO_VER}/ && \
    cd ./calico/${CALICO_VER}/ && \
    echo "[INFO] 下载 calicoctl 完成"
    cd - &>/dev/null
fi
if [ -f ./kubernetes-server-linux-amd64.tar.gz ];then
    mkdir -p k8s/${K8S_SERVER_VER}
    mv kubernetes-server-linux-amd64.tar.gz ./k8s/${K8S_SERVER_VER}/ && \
    cd ./k8s/${K8S_SERVER_VER}/ && \
    tar xf kubernetes-server-linux-amd64.tar.gz
    echo "[INFO] 下载 k8s-server 并解压完成"
    cd - &>/dev/null
fi
if [ -f etcd-v${ETCD_VER}-linux-amd64.tar.gz ];then
    mkdir -p etcd
    mv etcd-v${ETCD_VER}-linux-amd64.tar.gz ./etcd/ && \
    cd ./etcd/ && \
    tar xf etcd-v${ETCD_VER}-linux-amd64.tar.gz
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