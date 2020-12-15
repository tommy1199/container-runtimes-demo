#!/bin/sh

## Install docker

sudo apt-get update -qq
sudo apt-get upgrade -y

sudo apt-get install -qq -y curl apt-transport-https ca-certificates software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update -qq

sudo apt-get install -qq -y docker-ce

sudo gpasswd -a vagrant docker
newgrp docker

## Install podman

sudo apt-get install -qq -y software-properties-common uidmap
sudo add-apt-repository ppa:projectatomic/ppa
sudo apt-get update -qq
sudo apt-get install -qq -y podman

sudo mkdir -p /etc/containers
sudo curl https://raw.githubusercontent.com/projectatomic/registries/master/registries.fedora -o /etc/containers/registries.conf
sudo curl https://raw.githubusercontent.com/containers/skopeo/master/default-policy.json -o /etc/containers/policy.json

## Install buildah

. /etc/os-release
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/x${NAME}_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"
wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/x${NAME}_${VERSION_ID}/Release.key -O Release.key
sudo apt-key add - < Release.key
sudo apt-get update -qq
sudo apt-get install -qq -y buildah

## Install img

export IMG_SHA256="41aa98ab28be55ba3d383cb4e8f86dceac6d6e92102ee4410a6b43514f4da1fa"
sudo curl -fSL "https://github.com/genuinetools/img/releases/download/v0.5.7/img-linux-amd64" -o "/usr/local/bin/img" && echo "${IMG_SHA256}  /usr/local/bin/img" | sha256sum -c - && sudo chmod a+x "/usr/local/bin/img"

## Install kata

sudo curl -L https://github.com/kata-containers/runtime/releases/download/1.11.3/kata-static-1.11.3-x86_64.tar.xz -o /tmp/kata.tar.xz
sudo tar -xvf /tmp/kata.tar.xz -C /
sudo rm -rf /tmp/kata.tar.xz

## Install runsc

URL=https://storage.googleapis.com/gvisor/releases/nightly/latest
wget ${URL}/runsc
wget ${URL}/runsc.sha512
sha512sum -c runsc.sha512
rm -f runsc.sha512
sudo mv runsc /usr/local/bin
sudo chown root:root /usr/local/bin/runsc
sudo chmod 0755 /usr/local/bin/runsc

sudo mkdir -p /etc/docker
sudo mv /tmp/daemon.json /etc/docker/daemon.json
sudo systemctl restart docker

## Install dive

curl -L https://github.com/wagoodman/dive/releases/download/v0.9.1/dive_0.9.1_linux_amd64.deb -o /tmp/dive.deb
sudo apt-get install -qq -y /tmp/dive.deb
rm -f /tmp/dive.deb

## Install trivy

sudo apt-get install -qq -y rpm
wget https://github.com/aquasecurity/trivy/releases/download/v0.1.6/trivy_0.1.6_Linux-64bit.deb
sudo dpkg -i trivy_0.1.6_Linux-64bit.deb
sudo rm -f trivy_0.1.6_Linux-64bit.deb

## Install kubectl

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

## Install kind

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind