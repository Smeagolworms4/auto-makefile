export MAKEFILE_LIB_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifndef MAKEFILE_URL
	export MAKEFILE_URL=http://127.0.0.1:8383
endif

# ROOT #
$(shell [ ! -f $(MAKEFILE_LIB_DIR)/root.mk ] && curl -L --silent -f http://127.0.0.1:8383/root.mk -o $(MAKEFILE_LIB_DIR)/root.mk) 
include $(MAKEFILE_LIB_DIR)/root.mk

	
##########
# Docker #
##########

## List all containers
list: $(RULE_DEP_LIST)
	$(RULE_CMD_LIST)

## Kill all containers for all projects
killall: $(RULE_DEP_KILLALL)
	$(RULE_CMD_KILLALL)

## Remove unammed image
clean-none: $(RULE_DEP_CLEANNONE)
	$(RULE_CMD_CLEANNONE)