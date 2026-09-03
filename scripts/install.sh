#!/bin/bash
# Script para instalar dependências da aplicação na VM prod
# Execute com: vagrant ssh prod -c "sudo /vagrant/scripts/install.sh"

cd /app
npm install
echo "✅ Dependências instaladas!"
