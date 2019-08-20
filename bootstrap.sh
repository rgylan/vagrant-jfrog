#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.100 services.example.com docker
EOF

# Install docker from Docker-ce repository
echo "[TASK 2] Install docker container engine"
yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
yum install -y -q docker-ce >/dev/null 2>&1

# Enable docker service
echo "[TASK 3] Enable and start docker service"
systemctl enable docker >/dev/null 2>&1
systemctl start docker

# Disable SELinux
echo "[TASK 4] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Stop and disable firewalld
echo "[TASK 5] Stop and Disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

# Enable ssh password authentication
echo "[TASK 6] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 7] Set root password"
echo "dadmin" | passwd --stdin root >/dev/null 2>&1

# Restart docker
echo "[TASK 8] Restart docker"
systemctl daemon-reload
systemctl restart docker.service

# Install JFrog Artifactory Pro
echo "[TASK 9] Install JFrog Artifactory OSS"
mkdir -p /var/opt/jfrog/artifactory
chmod 777 /var/opt/jfrog/artifactory
#docker volume create jfrog
docker pull docker.bintray.io/jfrog/artifactory-oss:latest >/dev/null 2>&1
docker run --name artifactory-oss -d -v /var/opt/jfrog/artifactory:/var/opt/jfrog/artifactory -p 9081:8081 -e EXTRA_JAVA_OPTIONS='-Xms512m -Xmx1024m -Xss256k -XX:+UseG1GC' docker.bintray.io/jfrog/artifactory-oss:latest >/dev/null 2>&1

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc