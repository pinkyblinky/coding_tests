#!/bin/bash
. <(gpg --decrypt secrets.sh.gpg)
echo "$KUBECONFIGCONTENT" > ~/.kube/config