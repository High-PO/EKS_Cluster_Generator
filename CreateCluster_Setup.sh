#!/bin/bash
echo "======Input Data ClusterConfig Files====="
read -p "Cluster Name: " CLName
read -p "VPC ID: " VPC
read -p "Public Subnet ID 1: " PuSubnet1
read -p "Public Subnet ID 2: " PuSubnet2
read -p "Private Subnet ID 1: " PrSubnet1
read -p "Private Subnet ID 2: " PrSubnet2
read -p "Node Group 1 Name: " NGName1
read -p "Node Group 2 Name: " NGName2
read -p "AWS ACCESS KEY: " ACCESS_KEY
read -p "AWS SECRET KEY: " SECRET_KEY
echo "====END Input Data ClusterConfig Files===="
echo "=============Install Packages============="
sudo yum update -y
sudo yum install -y git docker
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure set aws_access_key_id ${ACCESS_KEY}
aws configure set aws_secret_access_key ${SECRET_KEY}
aws configure set default.region ap-northeast-2
echo "=============END Install Packages========="
echo "=====Start Change ClusterConfig Files====="
sed -i 's|<CLName>|${CLName}|g' ClusterConfig.yaml
sed -i 's|<VPC>|${VPC}|g' ClusterConfig.yaml
sed -i 's|<PuSubnet1>|${PuSubnet1}|g' ClusterConfig.yaml
sed -i 's|<PuSubnet2>|${PuSubnet2}|g' ClusterConfig.yaml
sed -i 's|<PrSubnet1>|${PrSubnet1}|g' ClusterConfig.yaml
sed -i 's|<PrSubnet2>|${PrSubnet2}|g' ClusterConfig.yaml
sed -i 's|<NGName1>|${NGName1}|g' ClusterConfig.yaml
sed -i 's|<NGName2>|${NGName2}|g' ClusterConfig.yaml
echo "======End Change ClusterConfig Files======"
echo "=========================================="
echo "=========================================="
echo "==============Create EKS Cluster=========="
eksctl create cluster -f ClusterConfig
echo "============END Create EKS Cluster========"