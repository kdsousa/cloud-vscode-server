SERVER       ?= ubuntu@seu_dominio_ou_ip
KEY          ?= ~/.ssh/sua_key.pem
PROJECT_PATH ?= $(shell basename $(shell pwd))

.PHONY: build-local rsync deploy help

help:
	@echo "Uso: make deploy [SERVER=usuario@host] [KEY=caminho/chave.pem]"

# 1. Compila a imagem na sua máquina local e exporta em .tar.gz para contornar instabilidades de rede na VM
build-local:
	docker build -t vscode-dev-image:latest .
	docker save vscode-dev-image:latest | gzip > vscode-image.tar.gz

# 2. Sincroniza o código fonte e a imagem gerada via rsync com a VM
rsync:
	rsync -azv -e "ssh -i $(KEY)" --exclude='meus-projetos' --exclude='.git' . $(SERVER):$(PROJECT_PATH)

# 3. Executa o deploy remoto: carrega a imagem no Docker da VM, cria e ajusta permissões da pasta /home/ubuntu/meus-projetos e sobe o container
deploy: build-local rsync
	ssh -i $(KEY) $(SERVER) "cd $(PROJECT_PATH) && docker load < vscode-image.tar.gz && rm -f vscode-image.tar.gz && sudo mkdir -p /home/ubuntu/meus-projetos && sudo chown -R 1000:1000 /home/ubuntu/meus-projetos && docker compose down && docker compose up -d"