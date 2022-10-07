GIT_HASH ?= $(shell git log --format="%h" -n 1)
DOCKER_FOLDER := dockerfiles
APPLICATION_NAME := dev-images
DOCKER_USERNAME := ericfeunekes

# Default args
_BUILD_ARGS_TAG ?= ${GIT_HASH}
_BUILD_ARGS_RELEASE_TAG ?= latest
_BUILD_ARGS_DOCKERFILE ?= ${DOCKER_FOLDER}/Dockerfile
_DOCKER_NAME_TAG = ${DOCKER_USERNAME}/${APPLICATION_NAME}:${_BUILD_ARGS_TAG} 

# As long as the build target are formatted as name-version (with a dash as a separator)
_REMOVE_VERSION = ${word 1, ${subst -, ,$*}}
_GET_VERSION = ${word 2, ${subst -, ,$*}}

package_%:
	${MAKE} build_$*
	${MAKE} push_$*
	${MAKE} release_$*

build_%:
	${MAKE} _builder \
		-e _BUILD_ARGS_TAG="$*-${GIT_HASH}" \
		-e _BUILD_ARGS_DOCKERFILE="${DOCKER_FOLDER}/${_REMOVE_VERSION}/Dockerfile" \
		-e _VERSION=${_GET_VERSION}

push_%:
	${MAKE} _pusher \
		-e _BUILD_ARGS_TAG="$*-${GIT_HASH}" 

release_%:
	${MAKE} _releaser \
		-e _BUILD_ARGS_TAG="$*-${GIT_HASH}" \
		-e _BUILD_ARGS_RELEASE_TAG="$*-latest"

_builder: 
	docker build --tag ${_DOCKER_NAME_TAG} -f ${_BUILD_ARGS_DOCKERFILE} . --build-arg VERSION=${_VERSION}

_pusher: 
	docker push ${_DOCKER_NAME_TAG}

_releaser:
	docker pull ${_DOCKER_NAME_TAG}
	docker tag ${_DOCKER_NAME_TAG} ${DOCKER_USERNAME}/${APPLICATION_NAME}:${_BUILD_ARGS_RELEASE_TAG}
	docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:${_BUILD_ARGS_RELEASE_TAG}

