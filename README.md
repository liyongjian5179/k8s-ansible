# k8s-ansible

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