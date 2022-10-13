export MAKEFILE_LIB_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifndef MAKEFILE_URL
	export MAKEFILE_URL=https://raw.githubusercontent.com/Smeagolworms4/auto-makefile/master
endif

# ROOT #
$(shell [ ! -f $(MAKEFILE_LIB_DIR)/docker.mk ] && curl -L --silent -f $(MAKEFILE_URL)/docker.mk -o $(MAKEFILE_LIB_DIR)/docker.mk) 
include $(MAKEFILE_LIB_DIR)/docker.mk

ifndef DOCKER_PATH
export DOCKER_PATH=$(PROJECT_PATH)docker/
endif

ifndef COMPOSE_PATH

# Select docker compose from env #
COMPOSE_PATH:=$(DOCKER_PATH)docker-compose.yml
ifeq ($(shell test -f $(DOCKER_PATH)docker-compose.$(ENV).yml && echo -n yes),yes)
COMPOSE_PATH:=$(DOCKER_PATH)docker-compose.$(ENV).yml
endif

endif

# Partial command #
ifndef COMPOSE
	export COMPOSE=docker-compose -f $(COMPOSE_PATH)
ifdef DOCKER_NAME
	export COMPOSE=docker-compose -f $(COMPOSE_PATH) -p $(DOCKER_NAME)	
endif
endif


ifndef FIX_SHELL
	export FIX_SHELL=COLUMNS=`tput cols` LINES=`tput lines`
endif

ifndef RULE_CMD_DOCKER_PULL
	export RULE_CMD_DOCKER_PULL=$(COMPOSE) pull
endif



ifndef RULE_CMD_DOCKER_BUILD
	export RULE_CMD_DOCKER_BUILD=$(COMPOSE) build
endif

ifndef RULE_CMD_UP
	export RULE_CMD_UP=$(COMPOSE) up -d
endif

ifndef RULE_CMD_DOWN
	export RULE_CMD_DOWN=$(COMPOSE) down
endif

ifndef RULE_CMD_LOGS
	export RULE_CMD_LOGS=$(COMPOSE) logs -f
endif

.PHONY: docker-pull

# Start Rules #

##########
# Docker #
##########

## Pull latest docker images
docker-pull: $(RULE_DEP_DOCKER_PULL)
	$(RULE_CMD_DOCKER_PULL)

## Build compose file containers
docker-build: $(RULE_DEP_DOCKER_BUILD)
	$(RULE_CMD_DOCKER_BUILD)

#################
# Up containers #
#################

## Up all containers
up: $(RULE_DEP_UP)
	$(RULE_CMD_UP)

###################
# Down containers #
###################

## Down all containers
down: $(RULE_DEP_DOWN)
	$(RULE_CMD_DOWN)

###################
# Logs containers #
###################

## Display logs all containers
logs: $(RULE_DEP_LOGS)
	$(RULE_CMD_LOGS)
