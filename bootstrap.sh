#!/bin/sh

#Bootstrap script for a ubuntu dev server.
#Dev setup: ssh server, python, pip, Java (JDK), maven 
#Cloud CLI: aws cli, azure cli, 
#Hashicorp tools: vault, terraform
#Configuration management: ansible

#Update system:
sudo apt-get update -y
sudo apt-get upgrade -y

#Basic dev setup
sudo apt-get install -y unzip python emacs vim curl git 

#Install Pip and AWSCLI
sudo apt-get install -y python-pip python-dev build-essential 
sudo pip install --upgrade pip 
sudo pip install --upgrade virtualenv 
sudo pip install boto boto3
sudo apt-get install -y awscli

#Install Ansible:
sudo apt-get install -y ansible 

#Install and enable openssh
sudo apt-get install -y openssh-server
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

#Install Azure CLI:
export AZ_REPO=$(lsb_release -cs)
sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

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
cd /opt/
sudo wget http://www-eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
sudo tar -xvzf apache-maven-3.3.9-bin.tar.gz
sudo mv apache-maven-3.3.9 maven 
sudo echo "export M2_HOME=/opt/maven" >> /etc/profile.d/mavenenv.sh
sudo echo "export PATH=${M2_HOME}/bin:${PATH}" >> /etc/profile.d/mavenenv.sh
sudo chmod +x /etc/profile.d/mavenenv.sh
sudo source /etc/profile.d/mavenenv.sh
