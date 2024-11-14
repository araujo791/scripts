#!/bin/bash

# This script can be used to set up the build environment for ROM building
# on Ubuntu/Linux Mint/other distributions using apt.

# Using scripts from:
# https://github.com/akhilnarang/scripts
# Thanks to Akhil Narang for his scripts, I just made it one run.

# Update package list
echo "Atualizando o repositório de pacotes..."
sudo apt-get update

# Install git if it's not already installed
echo "Instalando o Git..."
sudo apt-get install git -y

# Clone the script repository
echo "Clonando o repositório de scripts..."
git clone https://github.com/araujo791/scripts

# Change to the cloned scripts directory
cd scripts

# Run the setup script for Android build environment
echo "Configurando o ambiente de construção Android..."
bash setup/android_build_env.sh

# End of script
echo "Configuração concluída!"
