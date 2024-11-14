#!/bin/bash

# This script sets up the build environment for ROM building on Ubuntu/Linux Mint/other distributions using apt.

# Function to check if a command was successful
check_command() {
    if [ $? -ne 0 ]; then
        echo "Erro ao executar o comando: $1"
        exit 1
    fi
}

# Update package list
echo "Atualizando o repositório de pacotes..."
sudo apt-get update
check_command "sudo apt-get update"

# Install Git if it's not already installed
echo "Instalando o Git..."
sudo apt-get install git -y
check_command "sudo apt-get install git -y"

# Clone the script repository
echo "Clonando o repositório de scripts..."
git clone https://github.com/araujo791/scripts
check_command "git clone https://github.com/araujo791/scripts"

# Change to the cloned scripts directory
cd scripts
check_command "cd scripts"

# Run the setup script for Android build environment
echo "Configurando o ambiente de construção Android..."
bash setup/android_build_env.sh
check_command "bash setup/android_build_env.sh"

# Final message
echo "Configuração concluída com sucesso!"
