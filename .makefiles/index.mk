export MAKEFILE_LIB_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifndef MAKEFILE_URL
	export MAKEFILE_URL=https://raw.githubusercontent.com/Smeagolworms4/auto-makefile/master
endif

# ROOT #
$(shell [ ! -f $(MAKEFILE_LIB_DIR)/root.mk ] && curl -L --silent -f $(MAKEFILE_URL)/root.mk -o $(MAKEFILE_LIB_DIR)/root.mk) 
include $(MAKEFILE_LIB_DIR)/root.mk

	
##########
# Docker #
##########

.PHONY: list
## List all containers
list: $(RULE_DEP_LIST)
	$(RULE_CMD_LIST)

.PHONY: killall
## Kill all containers for all projects
killall: $(RULE_DEP_KILLALL)
	$(RULE_CMD_KILLALL)

.PHONY: clean-none
## Remove unammed image
clean-none: $(RULE_DEP_CLEANNONE)
	$(RULE_CMD_CLEANNONE)