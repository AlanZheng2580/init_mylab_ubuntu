#!/bin/bash

set -xe

# .bash_aliases
echo "alias dc='docker compose'" >> ~/.bashrc

# not sure why sandbox enabled DEBUG by default, disable it to prevent kubectl exec spamming.
echo "unset DEBUG" >> ~/.bashrc

# Get your wrapped email from https://github.com/settings/emails
git config --global user.email "a0955857152@gmail.com"
git config --global user.name "AlanZheng"

# cache git credential for 1 week.
git config --global credential.helper "cache --timeout=604800"

# github CLI
curl -sLo gh.tar.gz https://github.com/cli/cli/releases/download/v2.14.4/gh_2.14.4_linux_amd64.tar.gz \
    && tar -zxvf gh.tar.gz gh_2.14.4_linux_amd64/bin/gh \
    --strip-components 2 && sudo mv ./gh /usr/local/bin \
    && rm gh.tar.gz

# jq
curl -sLo ./jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && chmod +x ./jq \
    && sudo mv ./jq /usr/local/bin

# yq
curl -sLo ./yq.tar.gz https://github.com/mikefarah/yq/releases/download/v4.27.2/yq_linux_amd64.tar.gz \
    && tar -zxf yq.tar.gz ./yq_linux_amd64 \
    && sudo mv yq_linux_amd64 /usr/local/bin/yq \
    && rm -f yq.tar.gz

# kubectl
curl -sLO https://dl.k8s.io/release/v1.24.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && sudo mv ./kubectl /usr/local/bin/

# kind
curl -sLo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64 \
    && chmod +x ./kind \
    && sudo mv ./kind /usr/local/bin/kind

# helm 
# curl -sLo ./helm.tar.gz https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz \
#    && tar -zxvf helm.tar.gz linux-amd64/helm \
#    --strip-components 1 && sudo mv ./helm /usr/local/bin/ \
#    && rm ./helm.tar.gz

curl -sLo ./helmfile.tar.gz https://github.com/helmfile/helmfile/releases/download/v0.151.0/helmfile_0.151.0_linux_amd64.tar.gz \
    && tar -zxvf helmfile.tar.gz helmfile \
    && sudo mv ./helmfile /usr/local/bin/ \
    && rm ./helmfile.tar.gz \
    && helmfile init --force

# k9s
curl -sLo ./k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.27.3/k9s_Linux_amd64.tar.gz \
    && tar -zxvf k9s.tar.gz k9s \
    && sudo mv ./k9s /usr/local/bin/ \
    && rm ./k9s.tar.gz

# kubefwd
curl -sLo ./kubefwd_amd64.deb https://github.com/txn2/kubefwd/releases/download/1.22.4/kubefwd_amd64.deb \
    && sudo dpkg -i kubefwd_amd64.deb \
    && rm kubefwd_amd64.deb

# go
curl -sLo go1.21.6.linux-amd64.tar.gz https://go.dev/dl/go1.21.6.linux-amd64.tar.gz \
    && sudo rm -rf /usr/local/go \
    && sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz \
    && rm go1.21.6.linux-amd64.tar.gz

# insomnia
curl -sLo ./Insomnia.Core-2022.7.5.deb https://github.com/Kong/insomnia/releases/download/core%402022.7.5/Insomnia.Core-2022.7.5.deb \
    && sudo dpkg -i Insomnia.Core-2022.7.5.deb \
    && rm Insomnia.Core-2022.7.5.deb

# 2023/2/27: fix gke auth for k9s
sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials gpae19gke0002isb-user --region asia-east1
kubectl config set-context --current --namespace=devns6

# clone kubeconfig to root so kubefwd works
sudo cp -R ~/.kube /root/


# login github
gh auth login -p https -h github.com -w
