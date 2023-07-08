#!/bin/bash
cd "$(dirname "$0")" || exit

# shellcheck disable=SC1091
source ../compose-cd

function check_multi_registry() {
	local image
	local tag

	local ghcr
	local dockerhub

	image=$1
	tag=$2

	echo -n "${image}:${tag} "

	ghcr=$(get_remote_image "ghcr.io" "${image}" "${tag}")
	dockerhub=$(get_remote_image "hub.docker.com" "${image}" "${tag}")

	if [ "$ghcr" != "$dockerhub" ]; then
		echo "error"
		echo -e "\tghcr.io: ${ghcr}"
		echo -e "\tDockerHub: ${dockerhub}"
		exit 1
	fi

	echo "OK"
}

# shellcheck disable=SC2034
PRIVATE_IMAGE=false

check_multi_registry "sksat/archbot-rs" "main"
check_multi_registry "sksat/mc.yohane.su" "main"
check_multi_registry "sksat/papermc-docker" "main"
