#!/bin/bash

set -xe

# .bash_aliases
echo "alias dc='docker compose'" >> ~/.bashrc
echo "alias ls='ls --color=auto'" >> ~/.bashrc
echo "alias ll='ls -alh'" >> ~/.bashrc
echo "alias grep='grep --color=auto'" >> ~/.bashrc

# git completion
echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc

# not sure why sandbox enabled DEBUG by default, disable it to prevent kubectl exec spamming.
echo "unset DEBUG" >> ~/.bashrc

# Get your wrapped email from https://github.com/settings/emails
git config --global user.email "168727160+AlanZheng2580@users.noreply.github.com"
git config --global user.name "AlanZheng2580"

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
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell. 
echo "alias k=kubectl" >> ~/.bashrc 
echo "complete -o default -F __start_kubectl k" >> ~/.bashrc

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
#curl -sLo go1.21.6.linux-amd64.tar.gz https://go.dev/dl/go1.21.6.linux-amd64.tar.gz \
#    && sudo rm -rf /usr/local/go \
#    && sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz \
#    && rm go1.21.6.linux-amd64.tar.gz
sudo apt-get install -y bison \
    && bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer) \
    && source /home/kasm-user/.gvm/scripts/gvm \
    && gvm install go1.4 -B
gvm use go1.4
#export GOROOT_BOOTSTRAP=$GOROOT
#gvm install go1.17.13 -B
#gvm use go1.17.13
export GOROOT_BOOTSTRAP=$GOROOT
gvm install go1.20 -B
gvm use go1.20

# insomnia
curl -sLo ./Insomnia.Core-2022.7.5.deb https://github.com/Kong/insomnia/releases/download/core%402022.7.5/Insomnia.Core-2022.7.5.deb \
    && sudo dpkg -i Insomnia.Core-2022.7.5.deb \
    && rm Insomnia.Core-2022.7.5.deb

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 20.12.2 \
  && nvm use 20.12.2 \
  && sudo npm install -g pnpm
sudo rm /usr/bin/node

# 2023/2/27: fix gke auth for k9s
sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials gpae19gke0002isb-user --region asia-east1
kubectl config set-context --current --namespace=devns6

# clone kubeconfig to root so kubefwd works
sudo cp -R ~/.kube /root/

# update docker-ce
sudo apt update \
  && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
  && sudo sed -i 's|^command=/usr/local/bin/dockerd$|command=/usr/bin/dockerd|' /etc/supervisor/conf.d/dockerd.conf \
  && sudo supervisorctl reread \
  && sudo supervisorctl update

# ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
  && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list \
  && sudo apt update \
  && sudo apt install ngrok

# sshuttle & sshfs
sudo apt install -y sshuttle sshfs
#sudo mkdir -p /mnt/droplet/ && sudo sshfs -p 2004 -o allow_other,default_permissions alan@alanz.ddns.net:/home/alan/workspace /mnt/droplet/

echo "PATH=/usr/bin:/usr/local/go/bin:$PATH" >> ~/.bashrc

# login github
gh auth login -p https -h github.com -w

echo "remember to source ~/.bashrc"
