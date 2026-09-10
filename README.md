# 🐳 APONTI Academy - FAP 2026 - Projeto Vagrant - Jenkins + Produção Node.js

> Ambiente completo de **CI/CD** (Integração Contínua / Entrega Contínua) criado com **Vagrant**, **VirtualBox**, **Jenkins** e **Node.js**.

![Vagrant](https://img.shields.io/badge/Vagrant-2.x-blue)
![VirtualBox](https://img.shields.io/badge/VirtualBox-7.x-blue)
![Jenkins](https://img.shields.io/badge/Jenkins-2.568-red)
![Node.js](https://img.shields.io/badge/Node.js-18.x-green)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange)

---

## 📋 Visão Geral

Este projeto provisiona **duas máquinas virtuais** usando **Infraestrutura como Código (IaC)**:

| VM | IP | Recursos | Serviços |
|----|-----|----------|----------|
| **jenkins** | `192.168.56.10` | 1GB RAM / 2 CPUs | Jenkins + Node.js |
| **prod** | `192.168.56.20` | 1GB RAM / 1 CPU | Node.js + Aplicação |

**Objetivo**: Demonstrar um fluxo real de **deploy automatizado**, onde o Jenkins envia a aplicação para o ambiente de produção via **SSH**.

---

## 🏗️ Arquitetura

```
┌──────────────────────────────────────────────────┐
│              HOST (máquina física)               │
│              Vagrant + VirtualBox                │
└──────────────────────────────────────────────────┘
              │                        │
              ▼                        ▼
   ┌────────────────────┐    ┌────────────────────┐
   │   VM: JENKINS      │    │   VM: PROD         │
   │   192.168.56.10    │    │   192.168.56.20    │
   │   2 vCPU / 1GB     │    │   1 vCPU / 1GB     │
   │                    │    │                    │
   │  • Ubuntu 22.04    │    │  • Ubuntu 22.04    │
   │  • OpenJDK 21      │    │  • Node.js 18      │
   │  • Node.js 18      │    │  • Aplicação       │
   │  • Jenkins 2.568   │    │    Express         │
   │                    │    │                    │
   │  /vagrant (sync)   │    │  /vagrant (sync)   │
   │                    │    │  /app (sync)       │
   └─────────┬──────────┘    └──────────▲─────────┘
             │                          │
             │      SSH sem senha       │
             └──────────────────────────┘
                  (chave RSA)
```

---

## ⚙️ Pré-requisitos

- [**Vagrant**](https://www.vagrantup.com/downloads) (2.x ou superior)
- [**VirtualBox**](https://www.virtualbox.org/wiki/Downloads) (6.1 ou superior)
- Sistema com **pelo menos 4GB de RAM** disponível
- **Internet** para baixar a box `ubuntu/jammy64`

---

## 🚀 Como Usar

### 1. Clone o repositório

```bash
git clone https://github.com/egondimjraws/projeto-vagrant-jenkins.git
cd projeto-vagrant-jenkins
```

### 2. Suba as VMs

```bash
vagrant up
```

⏱️ Aguarde ~5-10 minutos (primeira execução baixa a box e provisiona tudo).

### 3. Acesse as VMs via SSH

```bash
# VM do Jenkins
vagrant ssh jenkins

# VM de produção
vagrant ssh prod
```

### 4. Acesse o Jenkins no navegador

```
http://192.168.56.10:8080
```

Obtenha a senha inicial com:

```bash
vagrant ssh jenkins -c "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```

### 5. Acesse a aplicação em produção

```
http://192.168.56.20:3000
```

---

## 📂 Estrutura do Projeto

```
projeto-vagrant-jenkins/
├── Vagrantfile              # Configura as 2 VMs
├── README.md                # Este arquivo
├── .gitignore               # Arquivos ignorados pelo git
├── app/                     # Aplicação Node.js
│   ├── package.json
│   ├── package-lock.json
│   ├── server.js
│   ├── src/
│   └── test/
└── scripts/
    ├── jenkins.sh           # Provisiona Jenkins + Node.js
    ├── prod.sh              # Provisiona Node.js
    ├── deploy.sh            # Deploy via SSH
    └── install.sh           # Instala dependências
```

---

## 🔧 Configuração do Jenkins

Após acessar o Jenkins pela primeira vez:

### 1. Instalar plugins sugeridos

Na tela inicial, clique em **"Instalar plugins sugeridos"**.

### 2. Criar usuário admin

- **Username**: `admin`
- **Password**: (defina uma)
- **Nome**: `Administrador`

### 3. Instalar plugin "Publish Over SSH"

- **Gerenciar Jenkins** → **Plugins** → **Disponíveis**
- Buscar: `Publish Over SSH`
- Instalar e reiniciar o Jenkins

### 4. Configurar o servidor SSH

- **Gerenciar Jenkins** → **Sistema** → **Publish over SSH**
- Adicionar um servidor com:
  - **Name**: `prod-server`
  - **Hostname**: `192.168.56.20`
  - **Username**: `vagrant`
  - **Remote Directory**: `/app`
  - **Key**: colar a chave privada de `~/.ssh/id_rsa` da VM jenkins
- Clicar em **Test Configuration** → deve retornar **Success**

### 5. Criar o Job de Deploy

- **Novo Item** → Nome: `Deploy-para-Prod` → **Freestyle project**
- **Passos de construção** → **Executar shell**:

```bash
mkdir -p $WORKSPACE/app
cp -rf /vagrant/app/* $WORKSPACE/app/
ls -la $WORKSPACE/app/
```

- **Ações de pós-construção** → **Send build artifacts over SSH**:
  - **SSH Server**: `prod-server`
  - **Source files**: `app/**`
  - **Remove prefix**: `app/`
  - **Exec command**:

```bash
cd /app; pkill -f "node server.js"; sleep 1; nohup node server.js > /tmp/app.log 2>&1 &
```

### 6. Executar o build

Clique em **"Construir agora"** e verifique o **Console Output**.

---

## 🎬 Demonstração CI/CD

Faça um deploy em tempo real:

### 1. Edite o código no host

```bash
nano app/server.js
```

Modifique a mensagem no `res.send()`:

```javascript
res.send(`<h1>Deploy #${new Date().toLocaleString('pt-BR')}</h1>`);
```

### 2. No Jenkins

- Job **Deploy-para-Prod** → **Construir agora**

### 3. Teste no navegador

Recarregue `http://192.168.56.20:3000` → **nova mensagem aparece!**

🎉 **Isso é CI/CD em ação!**

---

## 🛠️ Comandos Úteis

### Gerenciamento das VMs

```bash
vagrant status              # Ver status das VMs
vagrant up                  # Subir as VMs
vagrant halt                # Desligar as VMs
vagrant reload              # Reiniciar as VMs
vagrant destroy -f          # Destruir tudo
vagrant ssh jenkins         # Acessar VM jenkins
vagrant ssh prod            # Acessar VM prod
```

### Jenkins

```bash
# Status do serviço
vagrant ssh jenkins -c "sudo systemctl status jenkins"

# Reiniciar
vagrant ssh jenkins -c "sudo systemctl restart jenkins"

# Ver logs
vagrant ssh jenkins -c "sudo journalctl -u jenkins -f"
```

### Aplicação

```bash
# Testar app localmente
vagrant ssh prod -c "curl http://localhost:3000"

# Ver logs da app
vagrant ssh prod -c "cat /tmp/app.log"

# Reiniciar app
vagrant ssh prod -c "pkill -f 'node server.js'; cd /app && nohup node server.js > /tmp/app.log 2>&1 &"
```

### SSH entre VMs

```bash
# Testar conexão da jenkins para a prod
vagrant ssh jenkins
ssh vagrant@192.168.56.20 "hostname && ls /app"
exit
```

---

## 🐛 Troubleshooting

### ❌ `vagrant: command not found`

Instale o Vagrant: https://www.vagrantup.com/downloads

### ❌ Jenkins não abre em `http://192.168.56.10:8080`

```bash
vagrant ssh jenkins -c "sudo systemctl status jenkins"
vagrant ssh jenkins -c "sudo ss -tlnp | grep 8080"
```

### ❌ Erro de GPG ao instalar Jenkins

O script `scripts/jenkins.sh` já está atualizado com a chave 2026. Se o erro persistir:

```bash
vagrant ssh jenkins
sudo rm -f /etc/apt/keyrings/jenkins-keyring.asc
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
sudo apt update
sudo apt install -y jenkins
exit
```

### ❌ `Transferred 0 file(s)` no Jenkins

O campo **Source files** precisa apontar para arquivos que **existem no workspace**. Verifique se o build step está copiando de `/vagrant/app/` para `$WORKSPACE/app/`.

### ❌ `Unsupported command` no Jenkins

Use `;` (ponto e vírgula) em vez de `&&` no **Exec command** do Publish Over SSH.

### ❌ Aplicação não abre no navegador

Testar conectividade:

```bash
ping -c 3 192.168.56.20
telnet 192.168.56.20 3000
curl http://192.168.56.20:3000
```

Se `curl` funciona mas o navegador não, tente em **aba anônima** (pode ser cache ou extensão).

### ❌ `EADDRINUSE: address already in use`

A app já está rodando. Mate o processo:

```bash
vagrant ssh prod -c "pkill -f 'node server.js'"
```

---

## 🎓 Aprendizados

Este projeto demonstra:

- ✅ **Infraestrutura como Código** com Vagrant
- ✅ **Provisionamento automatizado** com Shell scripts
- ✅ **Múltiplas VMs** com `config.vm.define`
- ✅ **Rede privada** entre VMs
- ✅ **Pastas compartilhadas** (`synced_folder`)
- ✅ **SSH sem senha** com chave RSA
- ✅ **CI/CD real** com Jenkins + Publish Over SSH
- ✅ **Deploy automatizado** de aplicação Node.js

---

## 👤 Autor

**Emanuel Gondim**
- GitHub: [@egondimjraws](https://github.com/egondimjraws)

---

## 📄 Licença

Este projeto é de uso educacional.

---

⭐ Se este projeto te ajudou, deixe uma estrela no repositório!
