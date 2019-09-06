export DOCKER_NAME=projectname
export BASE_URL=dev.projectdomaine.com
export MAKEFILES=nginx|mailhog|php|phpmyadmin

#####################
# External resource #
#####################
$(shell [ ! -f docker/.makefiles/root ] && mkdir -p docker/.makefiles && curl --silent -f https://raw.githubusercontent.com/Smeagolworms4/auto-makefile/master/partials/root -o docker/.makefiles/root) 
include docker/.makefiles/root
