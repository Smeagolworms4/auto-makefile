export MAKEFILE_LIB_DIR:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifndef MAKEFILE_URL
	export MAKEFILE_URL=https://raw.githubusercontent.com/Smeagolworms4/auto-makefile/master
endif

# ROOT #
$(shell [ ! -f $(MAKEFILE_LIB_DIR)/root.mk ] && curl -L --silent -f $(MAKEFILE_URL)/root.mk -o $(MAKEFILE_LIB_DIR)/root.mk) 
include $(MAKEFILE_LIB_DIR)/root.mk

ifndef RULE_CMD_LIST
export RULE_CMD_LIST=docker ps -a
endif

ifndef RULE_CMD_KILLALL
export RULE_CMD_KILLALL=\
IDS=`docker ps -a -q`; if [ "$$IDS" != "" ]; then docker rm -f $$IDS; fi;\
docker network prune --force;\
docker volume prune --force
endif

ifndef RULE_CMD_CLEANNONE
export RULE_CMD_CLEANNONE=docker rmi -f `docker images | grep "^<none>" | awk '{print $$3}'`
endif

# Start Rules #
	
##########
# Docker #
##########
.PHONY: list
## List all containers
list: $(RULE_DEP_LIST)
	$(RULE_CMD_LIST_BEFORE)
	$(RULE_CMD_LIST)
	$(RULE_CMD_LIST_AFTER)

.PHONY: killall
## Kill all containers for all projects
killall: $(RULE_DEP_KILLALL)
	$(RULE_CMD_KILLALL_BEFORE)
	$(RULE_CMD_KILLALL)
	$(RULE_CMD_KILLALL_AFTER)

.PHONY: clean-none
## Remove unammed image
clean-none: $(RULE_DEP_CLEANNONE)
	$(RULE_CMD_CLEANNONE_BEFORE)
	$(RULE_CMD_CLEANNONE)
	$(RULE_CMD_CLEANNONE_AFTER)
