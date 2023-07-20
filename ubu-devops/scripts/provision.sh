#!/bin/bash

username=vagrant

# Network configuration
echo "Configuring network"
networkmanagerconf=$(cat <<CONF
network:
  version: 2
  renderer: NetworkManager
CONF
)
sudo touch /etc/netplan/networkmanager.yaml
echo "$networkmanagerconf" | sudo tee /etc/netplan/networkmanager.yaml > /dev/null

# Update repositories
echo "Updating repositories..."
sudo apt update

# Install basics
echo "Installing basic packages..."
sudo apt install -y git curl open-vm-tools-desktop

# Install Python 3 and pip
echo "Installing Python 3 and pip..."
sudo apt install -y python3 python3-pip

# Install oh-my-posh
echo "Installing oh-my-posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s

# Download and install Cascadia Code font
echo "Installing Cascadia Code font..."
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
unzip CascadiaCode.zip -d CascadiaCode
sudo mkdir /usr/share/fonts/cascadiacode
sudo mv CascadiaCode/*.ttf /usr/share/fonts/cascadiacode

# Update font cache
echo "Updating font cache..."
fc-cache -f -v

# Install dbus-x11 and dconf-editor
echo "Installing dbus-x11 and dconf-editor..."
sudo apt install dbus-x11 dconf-editor -y

# Configurin Gnome Terminal Profile
echo "Configuring Gnome Terminal profiles..."
sudo -u $username dbus-launch dconf reset -f /org/gnome/terminal/legacy/profiles:/
sudo -u $username dbus-launch dconf write /org/gnome/terminal/legacy/profiles:/default "''"
id=$(uuidgen)
formatted_id="${id,,}"
sudo -u $username dbus-launch dconf load -f /org/gnome/terminal/legacy/profiles:/:"${formatted_id}"/ < /vagrant/scripts/terminal-profile
sudo -u $username dbus-launch dconf write /org/gnome/terminal/legacy/profiles:/default "'${formatted_id}'"
sudo -u $username dbus-launch dconf write /org/gnome/terminal/legacy/profiles:/list "['${formatted_id}']"

# Configure oh-my-posh in bashrc
echo "Configuring oh-my-posh in bashrc..."
echo 'eval "$(oh-my-posh init bash --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/emodipt-extend.omp.json)"' >> /home/$username/.bashrc

# Remove password for the user
echo "Removing password for the user..."
sudo passwd -d $username

# Install awscli
echo "Installing awscli..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install azurecli
echo "Installing azurecli..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Google Cloud SDK
echo "Installing Google Cloud SDK..."
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl sudo
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list > /dev/null
sudo apt-get update && sudo apt-get install -y google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
sudo snap install --classic code

# Install Terraform
echo "Installing Terraform..."
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt update && sudo apt-get install terraform -y

# Install Ansible
echo "Installing Ansible..."
sudo apt install -y ansible

# Install Docker
echo "Installing Docker..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
\"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo usermod -aG docker $USER

# Install kubectl
echo "Installing kubectl..."
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update && sudo apt install kubectl

# Install ArgoCD CLI
echo "Installing ArgoCD CLI..."
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

# Install Google Chrome
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

# Install Packer
echo "Installing Packer..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt-get update && sudo apt-get install packer -y

# Install GitHub Desktop
echo "Installing GitHub Desktop..."
wget -qO - https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor | sudo tee /etc/apt/keyrings/mwt-desktop.gpg > /dev/null
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mwt-desktop.gpg] https://mirror.mwt.me/shiftkey-desktop/deb/ any main" > /etc/apt/sources.list.d/mwt-desktop.list'
sudo apt update
sudo apt install -y github-desktop

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf CascadiaCode CascadiaCode.zip

echo "Installation completed!"
echo "Restarting the machine to apply changes ;)"
