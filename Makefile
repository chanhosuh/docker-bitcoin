.DEFAULT_GOAL := help

include bitcoind/bitcoin.conf

.PHONY: help
help:
	@echo ""
	@echo "OPERATE:"
	@echo "up                Start containers"
	@echo "down              Stop containers"
	@echo "restart           Stop then start containers"
	@echo "build             Build images"
	@echo "rebuild           Stop, build, then start containers"
	@echo ""
	@echo "DEBUGGING:"
	@echo "logs              Re-attach to logging output"
	@echo "ps                List running container info"
	@echo "bash              Bash inside bitcoind container"
	@echo "status            Blockchain status info from bitcoind"
	@echo ""
	@echo "DATA:"
	@echo "nuke_blockchain   Delete blockchain data"
	@echo ""
	@echo "MAINTENANCE:"
	@echo "clean             Delete stopped containers and dangling images"
	@echo "clean_logs        Truncate Docker logs"
	@echo ""

.PHONY: build
build:
	docker-compose build
	@echo "All built 🏛"

.PHONY: up
up:
	docker-compose up -d
	@make logs

.PHONY: down
down:
	docker-compose stop

.PHONY: restart
restart:
	@echo "make down ==> make up"
	@make down
	@make up

.PHONY: rebuild
rebuild:
	@echo "make down ==> make build ==> make up"
	@make down
	@make build
	@make up

.PHONY: logs
logs:
	docker-compose logs -f 

# https://stackoverflow.com/a/51866793/1175053
.PHONY: clean_logs
clean_logs:
	docker run -it --rm --privileged --pid=host alpine:latest nsenter -t 1 -m -u -n -i -- sh -c 'truncate -s0 /var/lib/docker/containers/*/*-json.log'

.PHONY: bash
bash:
	@echo "bash in bitcoind container:";\
	docker-compose exec bitcoind bash

.PHONY: ps
ps:
	docker-compose ps

.PHONY: status
status:
	@docker-compose exec bitcoind bash -c "\
	    bitcoin-cli \
	    --rpcuser=$(rpcuser) \
	    --rpcpassword=$(rpcpassword) \
	    getblockchaininfo\
	"

.PHONY: nuke_blockchain
nuke_blockchain:
	@read -r -p "WARNING: this will delete all blockchain data (ctrl-c to exit / any other key to continue)." input
	@make down
	@docker-compose rm --force --stop -v bitcoind
	@docker volume rm docker-bitcoin_bitcoin-data
	@echo "Bitcoin blockchain deleted 💣"

.PHONY: clean
clean:
	@echo "Deleting exited containers..."
	docker ps -a -q -f status=exited | xargs docker rm -v
	@echo "Deleting dangling images..."
	docker images -q -f dangling=true | xargs docker rmi
	@echo "All clean 🛀"

.PHONY: pull
pull:
	@echo "Pulling image from Docker Hub..."
	@docker pull chanhosuh/bitcoin
	@echo "Re-tagging as docker-bitcoin_bitcoind"
	@docker tag chanhosuh/bitcoin docker-bitcoin_bitcoind
	@docker rmi chanhosuh/bitcoin

