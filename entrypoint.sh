#!/bin/sh

set -e

version="$1"
config="$2"
command="$3"
aws_iam_auth_version="$4"

if [ "$version" = "latest" ]; then
  version=$(curl -Ls https://dl.k8s.io/release/stable.txt)
fi

echo "using kubectl@$version"

curl -sLO "https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl" -o kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

curl -sLO "https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl" -o kubectl
chmod +x kubectl
mv kubectl /usr/local/bin

echo "using aws-iam-authenticator@$aws_iam_auth_version"

curl -sL -o /usr/local/bin/aws-iam-authenticator "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${aws_iam_auth_version}/aws-iam-authenticator_${aws_iam_auth_version}_linux_amd64"

chmod +x /usr/local/bin/aws-iam-authenticator

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$config" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

sh -c "kubectl $command"
