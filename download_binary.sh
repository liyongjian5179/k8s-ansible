#!/bin/bash
# Download

CNI_PLUGIN_VER=0.8.6
ETCD_VER=3.4.9
K8S_SERVER_VER=1.18.3
FLANNEL_VER=0.12.0
CALICO_VER=3.15.0

mkdir /opt/pkg 
cd /opt/pkg 
#wget https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGIN_VER}/cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz && \
#wget https://github.com/coreos/flannel/releases/download/v${FLANNEL_VER}/flannel-v${FLANNEL_VER}-linux-amd64.tar.gz && \
#wget https://dl.k8s.io/v${K8S_SERVER_VER}/kubernetes-server-linux-amd64.tar.gz && \
#wget https://github.com/etcd-io/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz && \
#wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
#wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
#wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64  &&\
#wget https://github.com/projectcalico/calicoctl/releases/download/v{CALICO_VER}/calicoctl

if [ -f ./cni-plugins/${CNI_PLUGIN_VER}/cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz ];then
    echo "[INFO] cni-plugins 已存在"
else
    wget https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGIN_VER}/cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz 

    if [ -f ./cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz ];then
        mkdir -p cni-plugins/${CNI_PLUGIN_VER}
        mv cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz ./cni-plugins/${CNI_PLUGIN_VER}/ && \
        cd ./cni-plugins/${CNI_PLUGIN_VER}/ && \
        tar xf cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz
        echo "[INFO] 下载 cni-plgins 并解压完成"
        cd - &>/dev/null
    fi
fi

if [ -f ./flannel/${FLANNEL_VER}/flannel-v${FLANNEL_VER}-linux-amd64.tar.gz ];then
    echo "[INFO] flannel 已存在"
else
    wget https://github.com/coreos/flannel/releases/download/v${FLANNEL_VER}/flannel-v${FLANNEL_VER}-linux-amd64.tar.gz

    if [ -f ./flannel-v${FLANNEL_VER}-linux-amd64.tar.gz ];then
        mkdir -p flannel/${FLANNEL_VER}
        mv ./flannel-v${FLANNEL_VER}-linux-amd64.tar.gz ./flannel/${FLANNEL_VER}/ && \
        cd ./flannel/${FLANNEL_VER}/ && \
        tar xf flannel-v${FLANNEL_VER}-linux-amd64.tar.gz
        echo "[INFO] 下载 flannel 并解压完成"
        cd - &>/dev/null
    fi
fi

if [ -f ./calico/${CALICO_VER}/calicoctl ];then
    echo "[INFO] calicoctl 已存在"
else
    wget https://github.com/projectcalico/calicoctl/releases/download/v${CALICO_VER}/calicoctl

    if [ -f ./calicoctl ];then
        mkdir -p calico/${CALICO_VER}
        mv ./calicoctl ./calico/${CALICO_VER}/ && \
        cd ./calico/${CALICO_VER}/ && \
        echo "[INFO] 下载 calicoctl 完成"
        cd - &>/dev/null
    fi
fi

if [ -f ./k8s/${K8S_SERVER_VER}/kubernetes-server-linux-amd64.tar.gz  ];then
    echo "[INFO] k8s server 已存在"
else
    wget https://dl.k8s.io/v${K8S_SERVER_VER}/kubernetes-server-linux-amd64.tar.gz 

    if [ -f ./kubernetes-server-linux-amd64.tar.gz ];then
        mkdir -p k8s/${K8S_SERVER_VER}
        mv kubernetes-server-linux-amd64.tar.gz ./k8s/${K8S_SERVER_VER}/ && \
        cd ./k8s/${K8S_SERVER_VER}/ && \
        tar xf kubernetes-server-linux-amd64.tar.gz
        echo "[INFO] 下载 k8s-server 并解压完成"
        cd - &>/dev/null
    fi
fi

if [ -f ./etcd/etcd-v${ETCD_VER}-linux-amd64.tar.gz ];then
    echo "[INFO] etcd 已存在"
else
    wget https://github.com/etcd-io/etcd/releases/download/v${ETCD_VER}/etcd-v${ETCD_VER}-linux-amd64.tar.gz 

    if [ -f etcd-v${ETCD_VER}-linux-amd64.tar.gz ];then
        mkdir -p etcd
        mv etcd-v${ETCD_VER}-linux-amd64.tar.gz ./etcd/ && \
        cd ./etcd/ && \
        tar xf etcd-v${ETCD_VER}-linux-amd64.tar.gz
        echo "[INFO] 下载 etcd 并解压完成"
        cd - &>/dev/null
    fi
fi

if [ -f ./cfssl/cfssl_linux-amd64 ];then
    echo "[INFO] cfssl 已存在"
else
    wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 

    if [ -f cfssl_linux-amd64 ];then
        mkdir -p cfssl 
        mv cfssl_linux-amd64 ./cfssl/ && \
        mv cfssljson_linux-amd64 ./cfssl/ && \
        mv cfssl-certinfo_linux-amd64 ./cfssl/ 
        echo "[INFO] 下载 cfssl 相关包完成"
        cd - &>/dev/null
    fi 
fi