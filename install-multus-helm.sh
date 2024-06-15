#!/bin/sh

# installing Multus plugin
git clone https://github.com/k8snetworkplumbingwg/multus-cni.git && cd multus-cni && kubectl apply -f ./deployments/multus-daemonset-thick-plugin.yml

# installing helm
# curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm -y
