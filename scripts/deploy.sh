#!/bin/bash
# Script para fazer deploy da aplicação via Jenkins
# Execute na VM jenkins: ssh vagrant@192.168.56.20 'bash -s' < scripts/deploy.sh

set -e

echo ">>> Iniciando deploy da aplicação..."

cd /app

# Instala dependências se necessário
if [ ! -d "node_modules" ]; then
  echo "Instalando dependências..."
  npm install
fi

# Reinicia a aplicação (usando PM2 ou node direto)
# Exemplo com PM2 (instalar primeiro: npm install -g pm2)
# pm2 restart server.js || pm2 start server.js --name "meu-app"

# Ou reinicia simples (para testes)
pkill -f "node server.js" || true
nohup node server.js > /var/log/app.log 2>&1 &

echo "✅ Deploy concluído!"
echo "📋 Logs: /var/log/app.log"
