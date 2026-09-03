#!/bin/bash
set -e

echo ">>> Provisionando Jenkins..."

# Instala Java
apt-get install -y openjdk-11-jre

# Instala Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Instala Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
apt-get update
apt-get install -y jenkins

# Inicia Jenkins
systemctl enable jenkins
systemctl start jenkins

# Aguarda iniciar
sleep 10

echo ">>> ✅ Jenkins instalado com sucesso!"
echo ">>> 🔑 Senha inicial do Jenkins:"
cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""
echo ">>> 🌐 Acesse: http://192.168.56.10:8080"
