#######################
# EXEMPLE OF MAKEFILE #
#######################


export MAKEFILE_URL=https://raw.githubusercontent.com/Smeagolworms4/auto-makefile/master
export IMPORT_MK=docker.mk

#####################
# External resource #
#####################
$(shell [ ! -f .makefiles/index.mk ] && mkdir -p .makefiles && curl -L --silent -f $(MAKEFILE_URL)/$(IMPORT_MK) -o .makefiles/index.mk) 
include .makefiles/index.mk

##########
# Custom #
##########

## My custom rule
hello-world:
	echo Hello world

