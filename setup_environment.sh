#!/bin/bash
. <(gpg --decrypt secrets.sh.gpg)
mkdir ~/.kube
touch ~/.kube/config
echo "$KUBECONFIGCONTENT" > ~/.kube/config
gpg -o terraform.tfstate --decrypt terraform.tfstate.gpg
./install_terraform.sh