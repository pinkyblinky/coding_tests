#!/bin/bash
set -e
curl -LO https://releases.hashicorp.com/terraform/1.12.1/terraform_1.12.1_linux_amd64.zip
unzip terraform_1.12.1_linux_amd64.zip
rm terraform_1.12.1_linux_amd64.zip
rm LICENSE.txt
sudo mv terraform /usr/local/bin/