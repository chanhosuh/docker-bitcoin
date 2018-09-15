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
	@echo "logs              Re-attach to all logging output"
	@echo "log               Re-attach to specified container log"
	@echo "bash              Bash inside a container (default=bitcoind)"
	@echo "status            Blockchain status info from bitcoind"
	@echo ""
	@echo "MAINTENANCE:"
	@echo "clean		     Delete stopped containers and dangling images"
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

.PHONY: log
log:
	@if test -z $(name); then\
	    echo "";\
	    echo "Please enter a container name as argument.";\
	    echo "";\
	    echo " e.g. 'make log name=bitcoind'";\
	    echo "";\
	    echo "or use 'make logs' to attach to all container logs.";\
	    echo "";\
	    echo "Available container names are:";\
	    echo "  bitcoind";\
	    echo "  django";\
	    echo "  db";\
	else\
	  docker-compose logs -f $(name);\
	fi

.PHONY: bash
bash:
	@echo "bash in bitcoind container:";\
	docker-compose exec bitcoind bash

.PHONY: status
status:
	@docker-compose exec bitcoind bash -c "\
	    bitcoin-cli \
	    --rpcuser=$(rpcuser) \
	    --rpcpassword=$(rpcpassword) \
	    getblockchaininfo\
	"

.PHONY: clean
clean:
	@echo "Deleting exited containers..."
	docker ps -a -q -f status=exited | xargs docker rm -v
	@echo "Deleting dangling images..."
	docker images -q -f dangling=true | xargs docker rmi
	@echo "All clean 🛀"
