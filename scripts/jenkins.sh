#!/bin/bash
set -e

echo ">>> Provisionando Jenkins (Aponti - FAP - 2026)..."

# ============================================================
# 1. Instala Java 21 (obrigatório para Jenkins atual)
# ============================================================
echo ">>> [1/5] Instalando Java 21 e dependências..."
apt-get update
apt-get install -y fontconfig openjdk-21-jre

# ============================================================
# 2. Instala Node.js 18.x
# ============================================================
echo ">>> [2/5] Instalando Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# ============================================================
# 3. Adiciona repositório oficial do Jenkins (URLs atualizadas)
# ============================================================
echo ">>> [3/5] Configurando repositório do Jenkins..."

rm -f /usr/share/keyrings/jenkins-keyring.asc
rm -f /etc/apt/keyrings/jenkins-keyring.asc
rm -f /etc/apt/sources.list.d/jenkins.list

mkdir -p /etc/apt/keyrings

wget -q -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list

# ============================================================
# 4. Instala Jenkins
# ============================================================
echo ">>> [4/5] Instalando Jenkins..."
apt-get update
apt-get install -y jenkins

# ============================================================
# 5. Inicia e habilita Jenkins
# ============================================================
echo ">>> [5/5] Iniciando Jenkins..."
systemctl enable jenkins
systemctl start jenkins

sleep 15

echo ""
echo ">>> ✅ Jenkins instalado com sucesso!"
echo ""
echo ">>> 🌐 Acesse: http://192.168.56.10:8080"
echo ""
echo ">>> 🔑 Senha inicial:"
cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "Aguarde alguns segundos e execute: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
