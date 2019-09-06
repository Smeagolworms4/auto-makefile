export DOCKER_NAME=projectname
export BASE_URL=dev.projectdomaine.com
export MAKEFILES=nginx|mailhog|php|phpmyadmin

#####################
# External resource #
#####################
$(shell [ ! -f docker/.makefiles/root ] && mkdir -p docker/.makefiles && curl --silent -f http://127.0.0.1:8080/partials/root -o docker/.makefiles/root) 
include docker/.makefiles/root
