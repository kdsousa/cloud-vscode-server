# Cloud VS Code Server (`cloud-vscode-server`)

Ambiente de desenvolvimento web persistente baseado em **VS Code (code-server)** com suporte nativo a **Python / Jupyter Notebooks**, containerizado e integrado à infraestrutura do [cloud-traefik-gateway](https://github.com/kdsousa/cloud-traefik-gateway).

## 🚀 Funcionalidades

- **VS Code na Web**: Acesso completo ao editor de código via navegador.
- **Ambiente Data Science / Python**: Kernel do Jupyter e extensões do VS Code (`ms-python.python`, `ms-toolsai.jupyter`) pré-instaladas.
- **Persistência Host-Direct**: Todos os projetos criados ficam gravados na VM no caminho `/home/ubuntu/meus-projetos`, sobrevivendo a qualquer re-deploy do container.
- **Gateway HTTPS (Traefik)**: Roteamento de tráfego seguro integrado à rede externa `traefik`.

## 📦 Estrutura do Repositório

- `Dockerfile`: Construção da imagem base Ubuntu 22.04 com Python, Jupyter Kernel e `code-server`.
- `config.yaml`: Parâmetros de autenticação e escuta do `code-server`.
- `docker-compose.yml`: Mapeamento de redes Traefik, rotas de domínio e volumes de dados.
- `Makefile`: Script para compilação local da imagem e implantação remota automatizada.

## 🛠️ Como Utilizar

### Pré-requisitos

1. Servidor com a rede `traefik` ativa executando o container do [cloud-traefik-gateway](https://github.com/kdsousa/cloud-traefik-gateway).
2. Docker, Docker Compose e `make` instalados na máquina local.

### Passos para Deploy

1. Clone este repositório:
   ```bash
   git clone https://github.com/seu-usuario/cloud-vscode-server.git
   cd cloud-vscode-server