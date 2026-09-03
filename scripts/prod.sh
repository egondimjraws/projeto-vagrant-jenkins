#!/bin/bash
set -e

echo ">>> Provisionando ambiente de produção..."

# Instala Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Cria diretório da aplicação
mkdir -p /app

echo ">>> ✅ Node.js instalado com sucesso!"
echo ">>> 📁 Pasta /app sincronizada com ./app do host"
