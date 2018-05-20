#!/bin/sh

#Bootstrap script for a ubuntu dev server.
#Dev setup: ssh server, python, pip, Java (JDK), maven 
#Cloud CLI: aws cli, azure cli, 
#Hypervisor: virtualbox
#Hashicorp tools: vault, terraform, vagrant
#Configuration management: ansible

#Update system:
sudo yum update -y
sudo yum upgrade -y

#Basic dev setup
sudo yum install -y unzip python emacs vim curl git 

#Install Pip AWSCLI and the requests module of pip 
sudo yum install -y python-pip python-dev build-essential 
sudo pip install --upgrade pip 
sudo pip install --upgrade virtualenv 
sudo pip install boto boto3 requests
sudo yum install -y awscli

#Install Ansible:
sudo yum install -y ansible 

#Install and enable openssh
sudo yum install -y openssh-server
sudo service ssh start
sudo systemctl enable ssh

#Install Terraform:
cd /tmp
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip?_ga=2.96085851.672140900.1524240497-986621143.1524103221 -O /tmp/terraform_0.11.7_linux_amd64.zip
unzip /tmp/terraform_0.11.7_linux_amd64.zip
sudo mv /tmp/terraform /usr/bin/terraform

#Install Vault 0.10.0:
cd /tmp
wget https://releases.hashicorp.com/vault/0.10.0/vault_0.10.0_linux_amd64.zip -O /tmp/vault_0.10.0_linux_amd64.zip
unzip /tmp/vault_0.10.0_linux_amd64.zip
sudo mv /tmp/vault /usr/bin/vault

#Install Vagrant 2.1.1:
cd /tmp
wget wget https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_linux_amd64.zip
unzip vagrant_2.1.1_linux_amd64.zip
sudo mv /tmp/vagrant /usr/bin/vagrant

#Install virtualbox
sudo yum install -y virtualbox

#Install Azure CLI:
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
sudo yum install -y azure-cli

#Install JDK 8u171:
wget http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz -O /tmp/jdk-8u171-linux-x64.tar.gz
unzip jdk-8u171-linux-x64.tar.gz	 
cd /usr/local
sudo mkdir java
cd /usr/local/java
sudo tar xzvf /tmp/jdk-8u171-linux-x64.tar.gz
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.8.0_171/jre/bin/java" 1
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk1.8.0_171/bin/javac" 1
sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/jdk1.8.0_171/jre/bin/javaws" 1
sudo update-alternatives --set java /usr/local/java/jdk1.8.0_171/jre/bin/java
sudo update-alternatives --set javac /usr/local/java/jdk1.8.0_171/jre/bin/javac
sudo update-alternatives --set javaws /usr/local/java/jdk1.8.0_171/jre/bin/javaws

#Install Maven 3.3.9:
cd /tmp
wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar xzf apache-maven-3.3.9-bin.tar.gz
sudo mkdir /usr/local/maven
sudo mv apache-maven-3.3.9/ /usr/local/maven/
sudo alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-3.3.9/bin/mvn 1
sudo alternatives --config mvn
