#!/bin/bash
. <(gpg --decrypt secrets.sh.gpg)
touch ~/.kube/config
echo "$KUBECONFIGCONTENT" > ~/.kube/config
gpg -o terraform.tfstate --decrypt terraform.tfstate.gpg
./install_terraform.sh