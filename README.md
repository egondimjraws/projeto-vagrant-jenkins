# 🐳 Projeto Vagrant - Jenkins + Produção Node.js

Este projeto cria duas máquinas virtuais para um ambiente de desenvolvimento com CI/CD.

## 📋 Estrutura

- **Jenkins Server** (`192.168.56.10`): Jenkins + Node.js
- **Production Server** (`192.168.56.20`): Node.js para aplicação

## 🚀 Como usar

### 1. Pré-requisitos
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

### 2. Subir as VMs
```bash
vagrant up
