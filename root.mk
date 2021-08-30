# Inits params #
export PROJECT_PATH=$(shell pwd -P)/
export MAKEFILE_LIB_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifndef ENV
	ENV:=dev
endif

ifndef USER_ID
	export USER_ID=$(shell id -u)
endif

ifndef USER_GID
	export USER_GID=$(shell id -g)
endif

export ENV ## Application environment (default: dev)


ifndef RULE_CMD_UPDATE_MAKEFILE
export RULE_CMD_UPDATE_MAKEFILE=\
@rm -rfv "$(MAKEFILE_LIB_DIR)";\
$(MAKE)
endif

# Start Rules #

.DEFAULT_GOAL:=help

##########
# Others #
##########
.PHONY: update-makefile
## Update all Makefiles script
update-makefile:
	@if [ "$(RULE_DEP_UPDATE_MAKEFILE)" != "" ]; then make $(RULE_DEP_UPDATE_MAKEFILE); fi
	$(RULE_CMD_UPDATE_MAKEFILE)
	
.PHONY: help
## Help instructions
help:
	@if [ "$(RULE_DEP_HELP)" != "" ]; then make $(RULE_DEP_HELP); fi
	@echo "\033[0;33mUsage:\033[0m"
	@echo "     make [var_name=value ...] [target]\n"
	@echo "\033[0;33mAvailable variables:\033[0m"
	@echo ""
	@awk '/^export (.*) ## (.*)/ { \
		helpVar = $$2; \
		helpMessage = substr($$0, index($$0, $$3) + 3); \
		printf "     \033[0;32m%-22s\033[0m %s\n", helpVar, helpMessage; \
	} \
	{ n5line = n4line; n4line = n3line; n3line = n2line; n2line = lastLine; lastLine = $$0;}' $(MAKEFILE_LIST)
	@echo ""
	@echo "\033[0;33mAvailable targets:\033[0m"
	@echo ""
	@echo "\
		#!/bin/bash\\n\
		declare -A \RULE_GROUPS\\n\
		declare -A \RULE_GROUPS_TITLES\\n\
		\\n\
		$$(awk '/^[a-zA-Z\-_0-9\.@]+:/ {\
			returnMessage = match(n4line, /^# (.*)/); \
				if (returnMessage) { \
					\
					key = n4line; \
					gsub(/[^a-zA-Z0-9]/, "_", key);\
					printf "%s", title;\
					\
					printf "RULE_GROUPS_TITLES[%s]=\"", key;\
					printf "     %s\\n", n5line; \
					printf "     %s\\n", n4line; \
					printf "     %s", n3line; \
					printf "\";\n"; \
				} \
				helpMessage = match(lastLine, /^## (.*)/); \
				if (helpMessage) { \
					gsub(/"/, "\\\"", helpMessage);\
					helpCommand = substr($$1, 0, index($$1, ":")); \
					helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
					printf "RULE_GROUPS[%s]=\"$${RULE_GROUPS[%s]}     \033[0;32m%-22s\033[0m %s\\n\"\n", key, key, helpCommand, helpMessage; \
				} \
			} \
			{ n5line = n4line; n4line = n3line; n3line = n2line; n2line = lastLine; lastLine = $$0;}' $(MAKEFILE_LIST)\
			| sed  -e "s/\`/\\\\\`/g")\
		\n\
		for key in \`echo -e "\$${!RULE_GROUPS_TITLES[@]}"|sed -e \"s/ /\\\\n/g\"|sort\`; do\n\
			echo -e \"\$${RULE_GROUPS_TITLES[\$${key}]}\"\n\
			echo -e \"\$${RULE_GROUPS[\$${key}]}\"|sort\n\
			echo -e \"\"\n\
		done\
	" | bash
	
