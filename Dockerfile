# Imagem base oficial do Ubuntu 22.04
FROM ubuntu:22.04

# Evita interações do instalador no terminal durante o build
ENV DEBIAN_FRONTEND=noninteractive

# Instala pacotes do sistema necessários para desenvolvimento em Python, Git e utilitários
RUN apt update && apt install -y \
    curl \
    wget \
    sudo \
    gnupg \
    software-properties-common \
    python3 \
    python3-pip \
    python3-venv \
    git \
    && rm -rf /var/lib/apt/lists/*

# Cria o usuário não-root 'ubuntu' e concede permissões de sudo sem senha
RUN useradd -m -s /bin/bash ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Instala a versão estável do code-server via pacote .deb (evita erros de download do script de install)
RUN CODE_SERVER_VERSION=4.92.2 && \
    curl -fL -o /tmp/code-server.deb https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_amd64.deb && \
    dpkg -i /tmp/code-server.deb && \
    rm /tmp/code-server.deb

# Alterna para o usuário 'ubuntu' para garantir isolamento de permissões
USER ubuntu    

# Define o diretório de trabalho padrão dentro do container
WORKDIR /home/ubuntu/notebooks

# Instala o kernel do Jupyter para permitir execução de arquivos .ipynb no VS Code
RUN pip3 install --no-cache-dir ipykernel

# Instala as extensões oficiais do Python e Jupyter diretamente no code-server
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ms-toolsai.jupyter

# Copia o arquivo de configuração para a pasta do usuário ubuntu dentro do container
COPY --chown=ubuntu:ubuntu config.yaml /home/ubuntu/.config/code-server/config.yaml

# Expõe a porta 8080 usada pelo code-server
EXPOSE 8080

# Inicia o code-server apontando para o diretório de trabalho atual
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "."]